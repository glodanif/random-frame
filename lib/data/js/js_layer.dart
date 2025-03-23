@JS()
library js_bridge;

import 'package:js/js.dart';
import 'package:random_frame/data/js/js_bridge.dart';
import 'package:random_frame/domain/js_layer_event.dart';
import 'package:random_frame/sl/get_it.dart';

final _jsBridge = getIt<JsBridge>();

@JS('notifyReady')
external void notifyReadyJs();

@JS('closeFrame')
external void closeFrameJs();

@JS('requestContext')
external void requestContextJs();

@JS('requestCaptchaToken')
external void requestCaptchaTokenJs();

@JS('openUrl')
external void openUrlJs(String url);

@JS('onContextLoaded')
external set _onContextLoaded(void Function(String?, String?) function);

@JS('onCaptchaToken')
external set _onCaptchaToken(void Function(String?) function);

void initJsBridge() {
  final eventController = _jsBridge.jsEventController;
  _onContextLoaded = allowInterop((username, location) {
    eventController.add(OnContextReady(username, location));
  });
  _onCaptchaToken = allowInterop((token) {
    eventController.add(OnCaptchaToken(token));
  });
}
