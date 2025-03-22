import 'dart:math';

import 'package:random_frame/domain/game.dart';
import 'package:random_frame/domain/game_result.dart';
import 'package:random_frame/domain/game_type.dart';

class PostNumberGame extends Game {
  final random = Random();

  PostNumberGame(): super(
    id: GameType.imageboard,
    callToAction: 'Imageboard Post Number',
    emoji: '📜',
    title: 'Post number generator',
    action: 'Roll',
    doneAction: 'rolled a post number',
  );

  @override
  GameResult roll() {
    return PostNumberRollResult(random.nextInt(999999999) + 1);
  }
}
