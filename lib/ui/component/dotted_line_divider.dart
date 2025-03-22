import 'package:flutter/material.dart';

class DottedLineDivider extends StatelessWidget {
  final double height;
  final double dotRadius;
  final Color color;
  final double spacing;

  const DottedLineDivider({
    super.key,
    this.height = 1.0,
    this.dotRadius = 1.0,
    this.color = Colors.black,
    this.spacing = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _DottedLinePainter(
          dotRadius: dotRadius,
          color: color,
          spacing: spacing,
        ),
      ),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  final double dotRadius;
  final Color color;
  final double spacing;

  _DottedLinePainter({
    required this.dotRadius,
    required this.color,
    required this.spacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawCircle(Offset(startX, size.height / 2), dotRadius, paint);
      startX += spacing + (dotRadius * 2); // Move to the next dot
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
