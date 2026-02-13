import 'package:flutter/material.dart';

class ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.grey[200]!
      ..strokeWidth = 0.8;

    // Horizontal grid lines
    for (int i = 1; i < 6; i++) {
      final y = (size.height / 6) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Vertical grid lines
    for (int i = 1; i < 8; i++) {
      final x = (size.width / 7) * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    final paint = Paint()
      ..color = const Color(0xFF4F46E5)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF4F46E5).withOpacity(0.3),
          const Color(0xFF4F46E5).withOpacity(0.05),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    // Create path for the chart line
    final path = Path();
    final fillPath = Path();

    // Chart data points that match the image pattern
    final points = [
      Offset(0, size.height * 0.6),
      Offset(size.width * 0.14, size.height * 0.45),
      Offset(size.width * 0.28, size.height * 0.25),
      Offset(size.width * 0.42, size.height * 0.7),
      Offset(size.width * 0.56, size.height * 0.35),
      Offset(size.width * 0.7, size.height * 0.55),
      Offset(size.width * 0.84, size.height * 0.15),
      Offset(size.width, size.height * 0.2),
    ];

    // Create smooth curve
    path.moveTo(points[0].dx, points[0].dy);
    fillPath.moveTo(0, size.height);
    fillPath.lineTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];
      final controlPoint1 = Offset(
        current.dx + (next.dx - current.dx) * 0.4,
        current.dy,
      );
      final controlPoint2 = Offset(
        current.dx + (next.dx - current.dx) * 0.6,
        next.dy,
      );

      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        next.dx,
        next.dy,
      );

      fillPath.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        next.dx,
        next.dy,
      );
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // Draw filled area
    canvas.drawPath(fillPath, fillPaint);

    // Draw line
    canvas.drawPath(path, paint);

    // Draw points
    final pointPaint = Paint()
      ..color = const Color(0xFF4F46E5)
      ..style = PaintingStyle.fill;

    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 4, whitePaint);
      canvas.drawCircle(point, 3, pointPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
