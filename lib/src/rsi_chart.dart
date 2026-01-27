import 'package:finance_kline_core/finance_kline_core.dart';
import 'package:flutter/material.dart';
import 'package:market_ui/src/rsi_painter.dart';

class RsiChart extends StatelessWidget {
  final List<Rsi?> data;
  final double barWidth;
  final double barSpacing;
  final double height;

  const RsiChart({
    required this.data,
    super.key,
    this.barWidth = 8.0,
    this.barSpacing = 2.0,
    this.height = 150,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox();
    }

    final totalWidth = data.length * (barWidth + barSpacing);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: totalWidth < MediaQuery.of(context).size.width
            ? MediaQuery.of(context).size.width
            : totalWidth,
        height: height,
        child: CustomPaint(
          painter: RsiPainter(
            data: data,
            barWidth: barWidth,
            barSpacing: barSpacing,
          ),
          size: Size(totalWidth, height),
        ),
      ),
    );
  }
}
