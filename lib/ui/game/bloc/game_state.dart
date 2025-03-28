part of 'game_bloc.dart';

@immutable
abstract class GameState {}

class GameInitial extends GameState {}

class ThinkingState extends GameState {}

class ResultState extends GameState {
  final GameResult result;

  ResultState(this.result);
}
