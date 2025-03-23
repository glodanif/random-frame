class JsLayerEvent {}

class OnContextReady extends JsLayerEvent {
  final String? username;
  final String? location;

  OnContextReady(this.username, this.location);
}

class OnCaptchaToken extends JsLayerEvent {
  final String? token;

  OnCaptchaToken(this.token);
}
