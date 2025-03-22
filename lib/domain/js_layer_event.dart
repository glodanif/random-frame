class JsLayerEvent {}

class OnContextReady extends JsLayerEvent {
  final String? username;
  final String? location;

  OnContextReady(this.username, this.location);
}
