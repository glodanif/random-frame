import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:random_frame/data/js/js_layer.dart';
import 'package:random_frame/domain/context.dart';
import 'package:random_frame/domain/js_layer_event.dart';
import 'package:random_frame/log/logger.dart';

class JsBridge {
  final jsEventController = StreamController<JsLayerEvent>.broadcast();

  JsBridge() {
    jsEventController.stream.listen((event) {
      Logger.event("JS Event: ${event.toString()}");
    });
  }

  void notifyReady() {
    notifyReadyJs();
  }

  void closeFrame() {
    closeFrameJs();
  }

  void openUrl(String url) {
    openUrlJs(url);
  }

  Future<Context> requestContext() {
    final completer = Completer<Context>();
    StreamSubscription? subscription;
    subscription = jsEventController.stream.listen((event) {
      if (event is OnContextReady) {
        completer.complete(Context(event.username, event.location));
        subscription?.cancel();
      }
    });
    requestContextJs();
    return completer.future;
  }

  Future<String?> requestCaptchaToken() {
    final completer = Completer<String?>();
    StreamSubscription? subscription;
    subscription = jsEventController.stream.listen((event) {
      if (event is OnCaptchaToken) {
        completer.complete(event.token);
        subscription?.cancel();
      }
    });
    requestCaptchaTokenJs();
    return completer.future;
  }
}
