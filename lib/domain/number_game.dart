import 'dart:math';

import 'package:random_frame/domain/game.dart';
import 'package:random_frame/domain/game_result.dart';
import 'package:random_frame/domain/game_type.dart';

class NumberGame extends Game {
  final random = Random();

  NumberGame(): super(
    id: GameType.number,
    callToAction: 'Roll 1-100',
    emoji: '🔢',
    title: 'Roll 1-100',
    action: 'Roll',
    doneAction: 'rolled a number',
  );

  @override
  GameResult roll() {
    return NumberRollResult(random.nextInt(100) + 1);
  }
}
