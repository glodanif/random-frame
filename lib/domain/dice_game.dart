import 'dart:math';

import 'package:random_frame/domain/game.dart';
import 'package:random_frame/domain/game_result.dart';
import 'package:random_frame/domain/game_type.dart';

class DiceGame extends Game {
  final random = Random();

  DiceGame()
      : super(
          id: GameType.dice,
          callToAction: 'Roll a dice',
          emoji: '🎲',
          title: 'Dice Roll',
          action: 'Roll',
          doneAction: 'rolled a dice',
        );

  @override
  GameResult roll() {
    return DiceRollResult(
      result: random.nextInt(6) + 1,
      rotation: random.nextInt(360) + 1,
      dateTime: DateTime.now(),
    );
  }
}
