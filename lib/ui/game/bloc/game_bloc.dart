import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_frame/domain/game.dart';
import 'package:random_frame/domain/game_result.dart';

part 'game_state.dart';

class GameBloc extends Cubit<GameState> {
  late Game _game;

  GameBloc() : super(GameInitial());

  void initGame(Game game) {
    _game = game;
  }

  void play() async {
    emit(ThinkingState());
    await Future.delayed(const Duration(seconds: 1));
    final result = _game.roll();
    emit(ResultState(result));
  }
}
