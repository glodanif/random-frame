import 'package:equatable/equatable.dart';

abstract class GameResult extends Equatable {}

class CoinFlipResult extends GameResult {
  final bool result;
  final int rotation;
  final DateTime dateTime;

  CoinFlipResult({
    required this.result,
    required this.rotation,
    required this.dateTime,
  });

  @override
  List<Object> get props => [result, rotation, dateTime.millisecond];

  @override
  bool get stringify => true;
}

class DiceRollResult extends GameResult {
  final int result;
  final int rotation;
  final DateTime dateTime;

  DiceRollResult({
    required this.result,
    required this.rotation,
    required this.dateTime,
  });

  @override
  List<Object> get props => [result, rotation, dateTime.millisecond];

  @override
  bool get stringify => true;
}

class Magic8BallResult extends GameResult {
  final String result;
  final int rotation;
  final DateTime dateTime;

  Magic8BallResult({
    required this.result,
    required this.rotation,
    required this.dateTime,
  });

  @override
  List<Object> get props => [result, rotation, dateTime.millisecond];

  @override
  bool get stringify => true;
}

class NumberRollResult extends GameResult {
  final int result;
  final DateTime dateTime;

  NumberRollResult({
    required this.result,
    required this.dateTime,
  });

  @override
  List<Object> get props => [result, dateTime.millisecond];

  @override
  bool get stringify => true;
}

class PostNumberRollResult extends GameResult {
  final int result;
  final DateTime dateTime;

  PostNumberRollResult({
    required this.result,
    required this.dateTime,
  });

  @override
  List<Object> get props => [result, dateTime.millisecond];

  @override
  bool get stringify => true;
}
