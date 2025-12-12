import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_dashboard/common/constants/api_constants.dart';
import 'package:web_dashboard/core/timetable/data/datasources/lecture_remote_data_source.dart';
import 'package:web_dashboard/core/timetable/data/dtos/lecture_request_dtos.dart';

void main() {
  late Dio dio;
  late _FakeAdapter adapter;
  late LectureRemoteDataSourceImpl dataSource;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://example.com/api'));
    adapter = _FakeAdapter();
    dio.httpClientAdapter = adapter;
    dataSource = LectureRemoteDataSourceImpl(dio: dio);
  });

  test('fetchLectures hits GET /lectures with query params', () async {
    adapter.enqueue(
      _FakeResponse(
        body: ResponseBody.fromString(
          jsonEncode(<Map<String, Object?>>[
            <String, Object?>{
              'id': '1',
              'title': '캘린더 테스트',
              'type': 'LECTURE',
              'status': 'ACTIVE',
              'classroomId': 'room-1',
              'classroomName': '공학관 101',
              'startTime': '2025-01-01T09:00:00Z',
              'endTime': '2025-01-01T10:00:00Z',
            },
          ]),
          200,
          headers: <String, List<String>>{'content-type': <String>['application/json']},
        ),
        onRequest: (RequestOptions options) {
          expect(options.method, 'GET');
          expect(options.path, ApiConstants.lectures);
          expect(options.queryParameters['classroomId'], 'room-1');
        },
      ),
    );

    final result = await dataSource.fetchLectures(
      LectureQueryRequest(
        from: DateTime.utc(2025, 1, 1),
        to: DateTime.utc(2025, 1, 7),
        classroomId: 'room-1',
      ),
    );

    expect(result.length, 1);
    expect(result.first.title, '캘린더 테스트');
  });

  test('createLecture sends POST body', () async {
    adapter.enqueue(
      _FakeResponse(
        body: ResponseBody.fromString(
          jsonEncode(<String, Object?>{
            'id': '1',
            'title': '신규 일정',
            'type': 'EVENT',
            'status': 'ACTIVE',
            'classroomId': 'room-1',
            'classroomName': '공학관 101',
            'startTime': '2025-01-01T09:00:00Z',
            'endTime': '2025-01-01T10:00:00Z',
          }),
          201,
          headers: <String, List<String>>{'content-type': <String>['application/json']},
        ),
        onRequest: (RequestOptions options) {
          expect(options.method, 'POST');
          expect(options.data['title'], '신규 일정');
        },
      ),
    );

    final dto = await dataSource.createLecture(
      LecturePayloadDto(
        title: '신규 일정',
        type: 'EVENT',
        status: 'ACTIVE',
        classroomId: 'room-1',
        startTime: DateTime.utc(2025, 1, 1, 9),
        endTime: DateTime.utc(2025, 1, 1, 10),
      ),
    );

    expect(dto.type, 'EVENT');
  });

  test('updateLecture hits PUT /lectures/:id with query flag', () async {
    adapter.enqueue(
      _FakeResponse(
        body: ResponseBody.fromString(
          jsonEncode(<String, Object?>{
            'id': '1',
            'title': '수정된 일정',
            'type': 'LECTURE',
            'status': 'ACTIVE',
            'classroomId': 'room-1',
            'classroomName': '공학관 101',
            'startTime': '2025-01-01T09:00:00Z',
            'endTime': '2025-01-01T10:00:00Z',
          }),
          200,
          headers: <String, List<String>>{'content-type': <String>['application/json']},
        ),
        onRequest: (RequestOptions options) {
          expect(options.method, 'PUT');
          expect(options.path, '${ApiConstants.lectures}/1');
          expect(options.queryParameters['applyToSeries'], true);
        },
      ),
    );

    final dto = await dataSource.updateLecture(
      UpdateLectureRequest(
        lectureId: '1',
        applyToSeries: true,
        payload: LecturePayloadDto(
          title: '수정된 일정',
          type: 'LECTURE',
          status: 'ACTIVE',
          classroomId: 'room-1',
          startTime: DateTime.utc(2025, 1, 1, 9),
          endTime: DateTime.utc(2025, 1, 1, 10),
        ),
      ),
    );

    expect(dto.title, '수정된 일정');
  });

  test('deleteLecture sends DELETE /lectures/:id', () async {
    adapter.enqueue(
      _FakeResponse(
        body: ResponseBody.fromString(
          '',
          204,
          headers: <String, List<String>>{},
        ),
        onRequest: (RequestOptions options) {
          expect(options.method, 'DELETE');
          expect(options.path, '${ApiConstants.lectures}/99');
          expect(options.queryParameters['deleteSeries'], true);
        },
      ),
    );

    await dataSource.deleteLecture(
      DeleteLectureRequest(
        lectureId: '99',
        deleteSeries: true,
      ),
    );
  });
}

class _FakeAdapter implements HttpClientAdapter {
  final List<_FakeResponse> _queue = <_FakeResponse>[];

  void enqueue(_FakeResponse response) {
    _queue.add(response);
  }

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (_queue.isEmpty) {
      throw StateError('No queued response');
    }
    final _FakeResponse response = _queue.removeAt(0);
    response.onRequest?.call(options);
    return response.body;
  }
}

class _FakeResponse {
  _FakeResponse({
    required this.body,
    this.onRequest,
  });

  final ResponseBody body;
  final void Function(RequestOptions options)? onRequest;
}
