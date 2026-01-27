import 'package:finance_kline_core/finance_kline_core.dart';
import 'package:flutter/material.dart';
import 'package:market_ui/src/drawer/rsi_drawer.dart';

class RsiPainter extends CustomPainter {
  final List<Rsi?> data;
  final double barWidth;
  final double barSpacing;

  RsiPainter({
    required this.data,
    this.barWidth = 8.0,
    this.barSpacing = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    RsiDrawer.drawRsi(
      rsiData: data,
      canvas: canvas,
      size: size,
      barWidth: barWidth,
      barSpacing: barSpacing,
    );
  }

  @override
  bool shouldRepaint(covariant RsiPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.barWidth != barWidth ||
        oldDelegate.barSpacing != barSpacing;
  }
}
