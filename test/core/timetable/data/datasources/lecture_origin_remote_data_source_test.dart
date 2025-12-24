import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_dashboard/common/constants/api_constants.dart';
import 'package:web_dashboard/core/timetable/data/datasources/lecture_origin_remote_data_source.dart';
import 'package:web_dashboard/core/timetable/data/dtos/lecture_request_dtos.dart';

void main() {
  late Dio dio;
  late _FakeAdapter adapter;
  late LectureOriginRemoteDataSourceImpl dataSource;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://example.com/api'));
    adapter = _FakeAdapter();
    dio.httpClientAdapter = adapter;
    dataSource = LectureOriginRemoteDataSourceImpl(dio: dio);
  });

  test('fetchLectures hits GET timetable endpoint with query params', () async {
    adapter.enqueue(
      _FakeResponse(
        body: ResponseBody.fromString(
          jsonEncode(<String, Object?>{
            'roomId': 'room-1',
            'range': <String, Object?>{
              'from': '2025-01-01T00:00:00Z',
              'to': '2025-01-07T23:59:59Z',
            },
            'tz': 'Asia/Seoul',
            'lectures': <Map<String, Object?>>[
              <String, Object?>{
                'lectureId': '1',
                'title': '캘린더 테스트',
                'type': 'lecture',
                'status': 'scheduled',
                'classroomId': 'room-1',
                'startTime': '2025-01-01T09:00:00Z',
                'endTime': '2025-01-01T10:00:00Z',
                'version': 1,
                'createdAt': '2025-01-01T08:00:00Z',
                'updatedAt': '2025-01-01T08:00:00Z',
              },
            ],
          }),
          200,
          headers: <String, List<String>>{'content-type': <String>['application/json']},
        ),
        onRequest: (RequestOptions options) {
          expect(options.method, 'GET');
          expect(
            options.path,
            ApiConstants.classroomTimetablePath('room-1'),
          );
          expect(options.queryParameters['tz'], 'Asia/Seoul');
        },
      ),
    );

    final result = await dataSource.fetchLectures(
      LectureOriginQueryRequest(
        from: DateTime.utc(2025, 1, 1),
        to: DateTime.utc(2025, 1, 7),
        classroomId: 'room-1',
        timezone: 'Asia/Seoul',
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
            'lectureId': '1',
            'title': '신규 일정',
            'type': 'event',
            'status': 'scheduled',
            'classroomId': 'room-1',
            'startTime': '2025-01-01T09:00:00Z',
            'endTime': '2025-01-01T10:00:00Z',
            'version': 1,
            'createdAt': '2025-01-01T08:00:00Z',
            'updatedAt': '2025-01-01T08:00:00Z',
          }),
          201,
          headers: <String, List<String>>{'content-type': <String>['application/json']},
        ),
        onRequest: (RequestOptions options) {
          expect(options.method, 'POST');
          expect(options.data['title'], '신규 일정');
          expect(options.data['status'], isNull);
        },
      ),
    );

    final dto = await dataSource.createLecture(
      LecturePayloadDto(
        title: '신규 일정',
        type: 'event',
        classroomId: 'room-1',
        startTime: DateTime.utc(2025, 1, 1, 9),
        endTime: DateTime.utc(2025, 1, 1, 10),
      ),
    );

    expect(dto.type, 'event');
  });

  test('updateLecture hits PATCH /lectures/:id with version header', () async {
    adapter.enqueue(
      _FakeResponse(
        body: ResponseBody.fromString(
          jsonEncode(<String, Object?>{
            'lectureId': '1',
            'title': '수정된 일정',
            'type': 'lecture',
            'status': 'scheduled',
            'classroomId': 'room-1',
            'startTime': '2025-01-01T09:00:00Z',
            'endTime': '2025-01-01T10:00:00Z',
            'version': 2,
            'createdAt': '2025-01-01T08:00:00Z',
            'updatedAt': '2025-01-01T09:00:00Z',
          }),
          200,
          headers: <String, List<String>>{'content-type': <String>['application/json']},
        ),
        onRequest: (RequestOptions options) {
          expect(options.method, 'PATCH');
          expect(options.path, '${ApiConstants.lectures}/1');
          expect(
            options.headers[ApiConstants.expectedVersionHeader],
            1,
          );
          expect(options.data['patch']['title'], '수정된 일정');
          expect(options.data['expectedVersion'], 1);
          expect(options.data['applyToFollowing'], isFalse);
          expect(options.data['applyToOverrides'], isFalse);
        },
      ),
    );

    final dto = await dataSource.updateLecture(
      UpdateLectureRequest(
        lectureId: '1',
        expectedVersion: 1,
        payload: LecturePayloadDto(
          title: '수정된 일정',
          type: 'lecture',
          classroomId: 'room-1',
          startTime: DateTime.utc(2025, 1, 1, 9),
          endTime: DateTime.utc(2025, 1, 1, 10),
        ),
      ),
    );

    expect(dto.title, '수정된 일정');
  });

  test('deleteLecture sends DELETE with version header', () async {
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
          expect(
            options.headers[ApiConstants.expectedVersionHeader],
            3,
          );
          expect(options.queryParameters['applyToFollowing'], isNull);
          expect(options.queryParameters['applyToOverrides'], isTrue);
        },
      ),
    );

    await dataSource.deleteLecture(
      DeleteLectureRequest(
        lectureId: '99',
        expectedVersion: 3,
        applyToOverrides: true,
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
