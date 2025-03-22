abstract class GameResult {}

class CoinFlipResult extends GameResult {
  final bool result;
  final int rotation;

  CoinFlipResult({required this.result, required this.rotation});
}

class DiceRollResult extends GameResult {
  final int result;
  final int rotation;

  DiceRollResult({required this.result, required this.rotation});
}

class Magic8BallResult extends GameResult {
  final String result;
  final int rotation;

  Magic8BallResult({required this.result, required this.rotation});
}

class NumberRollResult extends GameResult {
  final int result;

  NumberRollResult(this.result);
}

class PostNumberRollResult extends GameResult {
  final int result;

  PostNumberRollResult(this.result);
}
