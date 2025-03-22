@JS()
library js_bridge;

import 'package:flutter/foundation.dart';
import 'package:js/js.dart';
import 'package:random_frame/data/js/js_bridge.dart';
import 'package:random_frame/domain/js_layer_event.dart';
import 'package:random_frame/sl/get_it.dart';

final _jsBridge = getIt<JsBridge>();

@JS('notifyReady')
external void notifyReadyJs();

@JS('requestContext')
external void requestContextJs();

@JS('downloadImageFromBytes')
external void downloadImageFromBytesJs(Uint8List bytes, String fileName);

@JS('openUrl')
external void openUrlJs(String url);

@JS('onContextLoaded')
external set _onContextLoaded(void Function(String?, String?) function);

void initJsBridge() {
  final eventController = _jsBridge.jsEventController;
  _onContextLoaded = allowInterop((username, location) {
    eventController.add(OnContextReady(username, location));
  });
}
