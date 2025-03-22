import 'dart:math';

import 'package:random_frame/domain/game.dart';
import 'package:random_frame/domain/game_result.dart';
import 'package:random_frame/domain/game_type.dart';

class CoinGame extends Game {
  final random = Random();

  CoinGame()
      : super(
          id: GameType.coin,
          callToAction: 'Flip a coin',
          emoji: '🪙',
          title: 'Coin Flip',
          action: 'Flip',
          doneAction: 'flipped a coin',
        );

  @override
  GameResult roll() {
    return CoinFlipResult(
      result: random.nextBool(),
      rotation: random.nextInt(360) + 1,
    );
  }
}
