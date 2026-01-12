import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_dashboard/common/constants/api_constants.dart';
import 'package:web_dashboard/domains/schedule/data/datasources/lecture_occurrence_remote_data_source.dart';
import 'package:web_dashboard/domains/schedule/data/dtos/occurrence_query_request.dart';

void main() {
  late Dio dio;
  late _FakeAdapter adapter;
  late LectureOccurrenceRemoteDataSourceImpl dataSource;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://example.com/api'));
    adapter = _FakeAdapter();
    dio.httpClientAdapter = adapter;
    dataSource = LectureOccurrenceRemoteDataSourceImpl(dio: dio);
  });

  test('createOccurrence posts payload', () async {
    adapter.enqueue(
      _FakeResponse(
        body: ResponseBody.fromString(
          jsonEncode(<String, Object?>{
            'id': 'occ-1',
            'lectureId': 'lec-1',
            'classroomId': 'room-1',
            'classroomName': 'room-1',
            'title': '테스트',
            'type': 'lecture',
            'status': 'scheduled',
            'isOverride': false,
            'sourceVersion': 1,
            'startAt': '2025-01-01T09:00:00Z',
            'endAt': '2025-01-01T10:00:00Z',
          }),
          201,
          headers: <String, List<String>>{'content-type': <String>['application/json']},
        ),
        onRequest: (RequestOptions options) {
          expect(options.method, 'POST');
          expect(options.path, ApiConstants.lectureOccurrences);
          expect(options.data['lectureId'], 'lec-1');
        },
      ),
    );

    final dto = await dataSource.createOccurrence(
      OccurrenceCreateRequest(
        lectureId: 'lec-1',
        classroomId: 'room-1',
        startAt: DateTime.utc(2025, 1, 1, 9),
        endAt: DateTime.utc(2025, 1, 1, 10),
      ),
    );

    expect(dto.id, 'occ-1');
  });

  test('updateOccurrence patches fields', () async {
    adapter.enqueue(
      _FakeResponse(
        body: ResponseBody.fromString(
          jsonEncode(<String, Object?>{
            'id': 'occ-1',
            'lectureId': 'lec-1',
            'classroomId': 'room-1',
            'classroomName': 'room-1',
            'title': '테스트',
            'type': 'lecture',
            'status': 'cancelled',
            'isOverride': true,
            'sourceVersion': 2,
            'startAt': '2025-01-01T09:00:00Z',
            'endAt': '2025-01-01T10:00:00Z',
          }),
          200,
          headers: <String, List<String>>{'content-type': <String>['application/json']},
        ),
        onRequest: (RequestOptions options) {
          expect(options.method, 'PATCH');
          expect(options.path, '${ApiConstants.lectureOccurrences}/occ-1');
          expect(options.data['scope'], 'following');
          expect(options.data['applyToOverrides'], isTrue);
          expect(options.data['status'], 'cancelled');
          expect(options.data['cancelReason'], '보강 예정');
          expect(options.data['title'], '수정');
        },
      ),
    );

    final dto = await dataSource.updateOccurrence(
      OccurrenceUpdateRequest(
        occurrenceId: 'occ-1',
        status: 'cancelled',
        cancelReason: '보강 예정',
        scope: 'following',
        applyToOverrides: true,
        titleOverride: '수정',
      ),
    );

    expect(dto.status, 'cancelled');
  });

  test('deleteOccurrence sends query params when needed', () async {
    adapter.enqueue(
      _FakeResponse(
        body: ResponseBody.fromString('', 204),
        onRequest: (RequestOptions options) {
          expect(options.method, 'DELETE');
          expect(options.path, '${ApiConstants.lectureOccurrences}/occ-1');
          expect(options.queryParameters['applyToFollowing'], isTrue);
          expect(options.queryParameters['applyToOverrides'], isTrue);
        },
      ),
    );

    await dataSource.deleteOccurrence(
      const OccurrenceDeleteRequest(
        occurrenceId: 'occ-1',
        applyToFollowing: true,
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
