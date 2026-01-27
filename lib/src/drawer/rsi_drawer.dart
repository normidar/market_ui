import 'dart:math';

import 'package:finance_kline_core/finance_kline_core.dart';
import 'package:flutter/material.dart';
import 'package:market_ui/src/in_kline_draw/price_to_y.dart';

class RsiDrawer {
  static void drawRsi({
    required List<Rsi?> rsiData,
    required Canvas canvas,
    required Size size,
    required double barWidth,
    required double barSpacing,
    double? maxValue,
    double? minValue,
  }) {
    if (rsiData.isEmpty || size.width <= 0 || size.height <= 0) {
      return;
    }

    // RSI usually 0-100
    final currentMax = maxValue ?? 100.0;
    final currentMin = minValue ?? 0.0;

    // Reference lines
    _drawReferenceLine(
      canvas: canvas,
      size: size,
      value: 70,
      minValue: currentMin,
      maxValue: currentMax,
      color: Colors.red.withValues(alpha: 0.5),
      isDashed: true,
    );
    _drawReferenceLine(
      canvas: canvas,
      size: size,
      value: 50,
      minValue: currentMin,
      maxValue: currentMax,
      color: Colors.grey.withValues(alpha: 0.5),
      isDashed: false,
    );
    _drawReferenceLine(
      canvas: canvas,
      size: size,
      value: 30,
      minValue: currentMin,
      maxValue: currentMax,
      color: Colors.green.withValues(alpha: 0.5),
      isDashed: true,
    );

    // Draw RSI Line
    final paint = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    var isFirst = true;

    for (var i = 0; i < rsiData.length; i++) {
      final rsi = rsiData[i];
      if (rsi == null) continue;

      final x = (i * (barWidth + barSpacing)) + (barWidth / 2);
      final y = priceToY(rsi.value, currentMin, currentMax, size.height);

      if (isFirst) {
        path.moveTo(x, y);
        isFirst = false;
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  static void _drawReferenceLine({
    required Canvas canvas,
    required Size size,
    required double value,
    required double minValue,
    required double maxValue,
    required Color color,
    required bool isDashed,
  }) {
    final y = priceToY(value, minValue, maxValue, size.height);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    if (isDashed) {
      const dashWidth = 5.0;
      const dashSpace = 3.0;
      var startX = 0.0;
      while (startX < size.width) {
        canvas.drawLine(
          Offset(startX, y),
          Offset(min(startX + dashWidth, size.width), y),
          paint,
        );
        startX += dashWidth + dashSpace;
      }
    } else {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }
}
