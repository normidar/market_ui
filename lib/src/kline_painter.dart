import 'package:finance_kline_core/finance_kline_core.dart';
import 'package:flutter/material.dart';

class KlinePainter extends CustomPainter {
  final List<Kline> data;
  final double candleWidth;
  final double candleSpacing;
  final Color upColor;
  final Color downColor;
  final Color wickColor;

  KlinePainter({
    required this.data,
    this.candleWidth = 8.0,
    this.candleSpacing = 2.0,
    this.upColor = Colors.green,
    this.downColor = Colors.red,
    this.wickColor = Colors.grey,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxPrice = data
        .map((e) => e.high.toDouble())
        .reduce((a, b) => a > b ? a : b);
    final minPrice = data
        .map((e) => e.low.toDouble())
        .reduce((a, b) => a < b ? a : b);
    final priceRange = maxPrice - minPrice;
    
    // Avoid division by zero
    final range = priceRange == 0 ? 1.0 : priceRange;

    final height = size.height;
    
    // Helper to convert price to y-coordinate
    double priceToY(double price) {
      return height - ((price - minPrice) / range * height);
    }

    final paint = Paint()
      ..style = PaintingStyle.fill;

    final wickPaint = Paint()
      ..color = wickColor
      ..strokeWidth = 1.0;

    for (var i = 0; i < data.length; i++) {
      final kline = data[i];
      final open = kline.open.toDouble();
      final close = kline.close.toDouble();
      final high = kline.high.toDouble();
      final low = kline.low.toDouble();

      final isUp = close >= open;
      final color = isUp ? upColor : downColor;
      paint.color = color;

      final x = i * (candleWidth + candleSpacing);
      
      // Draw wick
      final highY = priceToY(high);
      final lowY = priceToY(low);
      final centerX = x + candleWidth / 2;
      
      canvas.drawLine(
        Offset(centerX, highY),
        Offset(centerX, lowY),
        wickPaint,
      );

      // Draw body
      final openY = priceToY(open);
      final closeY = priceToY(close);
      
      // Ensure body has at least some height
      var bodyTop = isUp ? closeY : openY;
      var bodyBottom = isUp ? openY : closeY;
      
      if ((bodyBottom - bodyTop).abs() < 0.5) {
        bodyBottom += 0.5;
        bodyTop -= 0.5;
      }

      final bodyRect = Rect.fromLTRB(
        x,
        bodyTop,
        x + candleWidth,
        bodyBottom,
      );
      canvas.drawRect(bodyRect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant KlinePainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.candleWidth != candleWidth ||
        oldDelegate.candleSpacing != candleSpacing ||
        oldDelegate.upColor != upColor ||
        oldDelegate.downColor != downColor ||
        oldDelegate.wickColor != wickColor;
  }
}
