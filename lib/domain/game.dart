import 'package:random_frame/domain/coin_game.dart';
import 'package:random_frame/domain/post_number_game.dart';

import 'dice_game.dart';
import 'game_result.dart';
import 'game_type.dart';
import 'magic_ball_game.dart';
import 'number_game.dart';

abstract class Game {
  final GameType id;
  final String callToAction;
  final String emoji;
  final String title;
  final String action;
  final String doneAction;

  Game({
    required this.id,
    required this.callToAction,
    required this.emoji,
    required this.title,
    required this.action,
    required this.doneAction,
  });

  GameResult roll();

  static final _games = [
    CoinGame(),
    DiceGame(),
    MagicBallGame(),
    NumberGame(),
    PostNumberGame(),
  ];

  static List<Game> getAllGames() {
    return _games;
  }

  static Game getGameById(GameType id) {
    return _games.firstWhere(
      (element) => element.id == id,
      orElse: () => throw ArgumentError("Game is not supported yet"),
    );
  }
}
