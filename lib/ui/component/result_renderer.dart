import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:random_frame/domain/game_result.dart';

class ResultRenderer {
  Widget render(GameResult result) {
    final resultWidget = switch (result) {
      CoinFlipResult() => _imageResult(
          result.result ? "coin_heads" : "coin_tails", result.rotation, 0),
      DiceRollResult() =>
        _imageResult("dice_${result.result}", result.rotation, 12),
      Magic8BallResult() =>
        _imageWithTextResult("8ball_back", result.result, result.rotation),
      NumberRollResult() => _textResult(result.result.toString(), 24),
      PostNumberRollResult() => _textResult("№${result.result}", 16),
      _ => throw ArgumentError('Unknown result type: ${result.runtimeType}'),
    };

    return Center(child: resultWidget);
  }

  Widget _imageResult(String imageName, int rotation, double padding) {
    return SizedBox(
      width: 220.0,
      height: 220.0,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Transform.rotate(
          angle: rotation.toDouble(),
          child: FittedBox(
            child: SvgPicture.asset(
              "assets/$imageName.svg",
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  Widget _textResult(String result, double textSize) {
    return Text(
      result,
      style: TextStyle(fontSize: textSize),
    );
  }

  Widget _imageWithTextResult(String imageName, String result, int rotation) {
    return SizedBox(
      width: 220.0,
      height: 220.0,
      child: Stack(alignment: Alignment.center, children: [
        Transform.rotate(
          angle: rotation.toDouble(),
          child: FittedBox(
            child: SvgPicture.asset(
              "assets/$imageName.svg",
              fit: BoxFit.contain,
            ),
          ),
        ),
        Text(
          result,
          textAlign: TextAlign.center,
        )
      ]),
    );
  }
}
