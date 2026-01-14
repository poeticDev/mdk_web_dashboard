/// ROLE
/// - 웹 SSE 클라이언트를 제공한다
///
/// RESPONSIBILITY
/// - EventSource 기반 SSE 스트림을 제공한다
///
/// DEPENDS ON
/// - dart:async
/// - package:web
library;

import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'package:web_dashboard/common/network/sse_client.dart';

class WebSseClient implements SseClient {
  web.EventSource? _eventSource;
  StreamController<SseClientEvent>? _controller;
  web.EventListener? _eventListener;
  web.EventListener? _errorListener;

  @override
  Stream<SseClientEvent> connect({
    required Uri url,
    List<String> eventTypes = const <String>[],
    String? lastEventId,
  }) {
    close();
    final Uri resolved = _appendLastEventId(url, lastEventId);
    _log('SSE connect', <String, Object?>{
      'url': resolved.toString(),
      'eventTypes': eventTypes,
      'lastEventId': lastEventId,
    });
    final web.EventSource eventSource = web.EventSource(
      resolved.toString(),
      web.EventSourceInit(withCredentials: true),
    );
    _eventSource = eventSource;
    _eventListener ??= _handleEvent.toJS;
    _errorListener ??= _handleError.toJS;
    final StreamController<SseClientEvent> controller =
        StreamController<SseClientEvent>.broadcast();
    _controller = controller;
    final List<String> targets =
        eventTypes.isEmpty ? <String>['message'] : eventTypes;
    for (final String type in targets) {
      eventSource.addEventListener(type, _eventListener);
    }
    eventSource.addEventListener('error', _errorListener);
    controller.onCancel = close;
    return controller.stream;
  }

  @override
  void close() {
    _log('SSE close', null);
    _eventSource?.close();
    _eventSource = null;
    _controller?.close();
    _controller = null;
    _eventListener = null;
    _errorListener = null;
  }

  void _handleEvent(web.Event event) {
    if (_controller == null) {
      return;
    }
    final web.MessageEvent message = event as web.MessageEvent;
    _log('SSE event', <String, Object?>{
      'type': message.type,
      'lastEventId': message.lastEventId,
    });
    _controller?.add(
      SseClientEvent(
        type: message.type,
        data: message.data?.toString() ?? '',
        lastEventId: message.lastEventId.isEmpty ? null : message.lastEventId,
      ),
    );
  }

  void _handleError(web.Event event) {
    if (_controller == null) {
      return;
    }
    _log('SSE error', null);
    _controller?.addError(StateError('SSE 연결 오류'));
  }

  void _log(String message, Map<String, Object?>? payload) {
    if (payload == null) {
      print('[SSE] $message');
      return;
    }
    print('[SSE] $message: $payload');
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
