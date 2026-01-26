import 'package:finance_kline_core/finance_kline_core.dart';
import 'package:flutter/material.dart';
import 'package:market_ui/src/kline_painter.dart';

class KlineChart extends StatefulWidget {
  final List<Kline> data;
  final double candleWidth;
  final double candleSpacing;
  final Color upColor;
  final Color downColor;
  final Color wickColor;
  final double height;

  const KlineChart({
    required this.data,
    super.key,
    this.candleWidth = 8.0,
    this.candleSpacing = 2.0,
    this.upColor = Colors.green,
    this.downColor = Colors.red,
    this.wickColor = Colors.grey,
    this.height = 300,
  });

  @override
  State<KlineChart> createState() => _KlineChartState();
}

class _KlineChartState extends State<KlineChart> {
  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const SizedBox();
    }
    
    final totalWidth =
        widget.data.length * (widget.candleWidth + widget.candleSpacing);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: totalWidth < MediaQuery.of(context).size.width
            ? MediaQuery.of(context).size.width
            : totalWidth,
        height: widget.height,
        child: CustomPaint(
          painter: KlinePainter(
            data: widget.data,
            candleWidth: widget.candleWidth,
            candleSpacing: widget.candleSpacing,
            upColor: widget.upColor,
            downColor: widget.downColor,
            wickColor: widget.wickColor,
          ),
          size: Size(totalWidth, widget.height),
        ),
      ),
    );
  }
}
