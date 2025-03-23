import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_frame/data/js/js_bridge.dart';

part 'home_state.dart';

class HomeBloc extends Cubit<HomeState> {
  final JsBridge _jsBridge;
  int _dice = 1;
  double _rotation = 0.0;

  HomeBloc(
    this._jsBridge,
  ) : super(HomeInitial()) {
    final random = Random();
    _dice = random.nextInt(6) + 1;
    _rotation = random.nextDouble() * 360;
  }

  void notifyReady() {
    _jsBridge.notifyReady();
  }

  Future<void> loadContext() async {
    final context = await _jsBridge.requestContext();
    if (context.location != null || !kReleaseMode) {
      emit(
        LoadedState(
          username: context.username ?? "guest",
          randomDice: _dice,
          randomRotation: _rotation,
        ),
      );
    } else {
      emit(InvalidLocationState());
    }
  }

  void closeFrame() {
    _jsBridge.closeFrame();
  }
}
