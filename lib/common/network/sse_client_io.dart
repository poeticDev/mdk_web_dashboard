/// ROLE
/// - 비웹 환경의 SSE 클라이언트를 제공한다
///
/// RESPONSIBILITY
/// - 웹 전용 구현을 대체하는 안전한 폴백을 제공한다
///
/// DEPENDS ON
/// - 없음
library;

import 'package:web_dashboard/common/network/sse_client.dart';

class IoSseClient implements SseClient {
  @override
  Stream<SseClientEvent> connect({
    required Uri url,
    List<String> eventTypes = const <String>[],
    String? lastEventId,
  }) {
    return Stream<SseClientEvent>.error(
      StateError('SSE는 웹 환경에서만 지원됩니다.'),
    );
  }

  @override
  void close() {}
}

SseClient createSseClient() => IoSseClient();
