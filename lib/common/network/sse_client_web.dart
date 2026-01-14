/// ROLE
/// - 웹 SSE 클라이언트를 제공한다
///
/// RESPONSIBILITY
/// - EventSource 기반 SSE 스트림을 제공한다
///
/// DEPENDS ON
/// - dart:async
/// - dart:html
library;

import 'dart:async';
import 'dart:html' as html;

import 'package:web_dashboard/common/network/sse_client.dart';

class WebSseClient implements SseClient {
  html.EventSource? _eventSource;
  StreamController<SseClientEvent>? _controller;

  @override
  Stream<SseClientEvent> connect({
    required Uri url,
    List<String> eventTypes = const <String>[],
    String? lastEventId,
  }) {
    close();
    final Uri resolved = _appendLastEventId(url, lastEventId);
    final html.EventSource eventSource = html.EventSource(
      resolved.toString(),
      withCredentials: true,
    );
    _eventSource = eventSource;
    final StreamController<SseClientEvent> controller =
        StreamController<SseClientEvent>.broadcast();
    _controller = controller;
    final List<String> targets =
        eventTypes.isEmpty ? <String>['message'] : eventTypes;
    for (final String type in targets) {
      eventSource.addEventListener(type, _handleEvent);
    }
    eventSource.onError.listen((_) {
      controller.addError(StateError('SSE 연결 오류'));
    });
    controller.onCancel = close;
    return controller.stream;
  }

  @override
  void close() {
    _eventSource?.close();
    _eventSource = null;
    _controller?.close();
    _controller = null;
  }

  void _handleEvent(html.Event event) {
    if (_controller == null) {
      return;
    }
    if (event is html.MessageEvent) {
      _controller?.add(
        SseClientEvent(
          type: event.type,
          data: event.data?.toString() ?? '',
          lastEventId: event.lastEventId?.isEmpty == true
              ? null
              : event.lastEventId,
        ),
      );
    }
  }

  Uri _appendLastEventId(Uri url, String? lastEventId) {
    if (lastEventId == null || lastEventId.isEmpty) {
      return url;
    }
    final Map<String, String> updated = Map<String, String>.from(
      url.queryParameters,
    );
    updated['lastEventId'] = lastEventId;
    return url.replace(queryParameters: updated);
  }
}

SseClient createSseClient() => WebSseClient();
