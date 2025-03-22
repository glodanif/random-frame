import 'dart:math';

import 'package:random_frame/domain/game.dart';
import 'package:random_frame/domain/game_result.dart';
import 'package:random_frame/domain/game_type.dart';

class MagicBallGame extends Game {
  final random = Random();

  final _possibleResults = [
    "It is certain",
    "It is decidedly so",
    "Without a doubt",
    "Yes - definitely",
    "You may rely on it",
    "As I see it, yes",
    "Most likely",
    "Outlook good",
    "Yes",
    "Signs point to yes",
    "Reply hazy, try again",
    "Ask again later",
    "Better not tell you now",
    "Cannot predict now",
    "Concentrate and ask again",
    "Don't count on it",
    "My reply is no",
    "My sources say no",
    "Outlook not so good",
    "Very doubtful",
  ];

  MagicBallGame()
      : super(
          id: GameType.magicBall,
          callToAction: 'Magic 8 Ball',
          emoji: '🎱',
          title: '8 Ball',
          action: 'Shake',
          doneAction: 'shook the 8 Ball',
        );

  @override
  GameResult roll() {
    return Magic8BallResult(
      result: _possibleResults[random.nextInt(_possibleResults.length)],
      rotation: random.nextInt(360) + 1,
    );
  }
}
