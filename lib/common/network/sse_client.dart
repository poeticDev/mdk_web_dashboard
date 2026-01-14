/// ROLE
/// - SSE 클라이언트를 제공한다
///
/// RESPONSIBILITY
/// - 플랫폼별 SSE 연결 구현을 추상화한다
///
/// DEPENDS ON
/// - 없음
library;

import 'sse_client_io.dart' if (dart.library.html) 'sse_client_web.dart'
    as sse_impl;

SseClient createSseClient() => sse_impl.createSseClient();

abstract class SseClient {
  Stream<SseClientEvent> connect({
    required Uri url,
    List<String> eventTypes,
    String? lastEventId,
  });

  void close();
}

class SseClientEvent {
  const SseClientEvent({
    required this.type,
    required this.data,
    this.lastEventId,
  });

  final String type;
  final String data;
  final String? lastEventId;
}
