import 'dart:math';

import 'package:finance_kline_core/finance_kline_core.dart';
import 'package:flutter/material.dart';
import 'package:market_ui/src/in_kline_draw/price_to_y.dart';

class MacdDrawer {
  static void drawMacd({
    required List<Macd?> macdData,
    required Canvas canvas,
    required Size size,
    required double barWidth,
    required double barSpacing,
    double? maxValue,
    double? minValue,
  }) {
    if (macdData.isEmpty || size.width <= 0 || size.height <= 0) {
      return;
    }

    // Filter valid data to determine min/max
    final validData = macdData.whereType<Macd>().toList();
    if (validData.isEmpty) return;

    var currentMax = maxValue;
    var currentMin = minValue;

    if (currentMax == null || currentMin == null) {
      currentMax = validData.first.macdLine;
      currentMin = validData.first.macdLine;

      for (final macd in validData) {
        currentMax = max(currentMax!, macd.macdLine);
        currentMax = max(currentMax, macd.signalLine);
        currentMax = max(currentMax, macd.histogram);

        currentMin = min(currentMin!, macd.macdLine);
        currentMin = min(currentMin, macd.signalLine);
        currentMin = min(currentMin, macd.histogram);
      }

      // Add margin
      final range = currentMax! - currentMin!;
      final margin = range * 0.1;
      currentMax += margin;
      currentMin -= margin;
    }

    // Draw Zero Line
    _drawZeroLine(
      canvas: canvas,
      size: size,
      minValue: currentMin,
      maxValue: currentMax,
    );

    // Draw Histogram
    _drawHistogram(
      macdData: macdData,
      canvas: canvas,
      size: size,
      barWidth: barWidth,
      barSpacing: barSpacing,
      minValue: currentMin,
      maxValue: currentMax,
    );

    // Draw MACD Line
    _drawLine(
      data: macdData,
      getValue: (m) => m.macdLine,
      canvas: canvas,
      size: size,
      barWidth: barWidth,
      barSpacing: barSpacing,
      minValue: currentMin,
      maxValue: currentMax,
      color: Colors.blue,
    );

    // Draw Signal Line
    _drawLine(
      data: macdData,
      getValue: (m) => m.signalLine,
      canvas: canvas,
      size: size,
      barWidth: barWidth,
      barSpacing: barSpacing,
      minValue: currentMin,
      maxValue: currentMax,
      color: Colors.orange,
    );
  }

  static void _drawZeroLine({
    required Canvas canvas,
    required Size size,
    required double minValue,
    required double maxValue,
  }) {
    final zeroY = priceToY(0, minValue, maxValue, size.height);
    final paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawLine(Offset(0, zeroY), Offset(size.width, zeroY), paint);
  }

  static void _drawHistogram({
    required List<Macd?> macdData,
    required Canvas canvas,
    required Size size,
    required double barWidth,
    required double barSpacing,
    required double minValue,
    required double maxValue,
  }) {
    final upPaint = Paint()
      ..color = Colors.green.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    final downPaint = Paint()
      ..color = Colors.red.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    final zeroY = priceToY(0, minValue, maxValue, size.height);

    for (var i = 0; i < macdData.length; i++) {
      final macd = macdData[i];
      if (macd == null) continue;

      final isPositive = macd.histogram >= 0;
      final x = (i * (barWidth + barSpacing)) + (barWidth / 2);
      final histogramY =
          priceToY(macd.histogram, minValue, maxValue, size.height);

      final barHeight = (histogramY - zeroY).abs();
      // Avoid 0 height rect
      final height = barHeight < 1 ? 1.0 : barHeight;
      
      final rect = Rect.fromLTWH(
        x - barWidth / 2,
        isPositive ? histogramY : zeroY,
        barWidth,
        height,
      );

      canvas.drawRect(rect, isPositive ? upPaint : downPaint);
    }
  }

  static void _drawLine({
    required List<Macd?> data,
    required double Function(Macd) getValue,
    required Canvas canvas,
    required Size size,
    required double barWidth,
    required double barSpacing,
    required double minValue,
    required double maxValue,
    required Color color,
  }) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    var isFirst = true;

    for (var i = 0; i < data.length; i++) {
      final macd = data[i];
      if (macd == null) continue;

      final value = getValue(macd);
      final x = (i * (barWidth + barSpacing)) + (barWidth / 2);
      final y = priceToY(value, minValue, maxValue, size.height);

      if (isFirst) {
        path.moveTo(x, y);
        isFirst = false;
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }
}
