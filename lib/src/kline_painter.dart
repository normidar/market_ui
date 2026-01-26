import 'package:finance_kline_core/finance_kline_core.dart';
import 'package:flutter/material.dart';
import 'package:market_ui/src/drawer/kline_drawer.dart';
import 'package:market_ui/src/types/bollinger_bands_result.dart';
import 'package:market_ui/src/types/ema_properties.dart';
import 'package:market_ui/src/types/sign_symbol.dart';

class KlinePainter extends CustomPainter {
  final List<Kline> data;
  final double candleWidth;
  final double candleSpacing;
  final Color upColor;
  final Color downColor;
  final Color wickColor;
  final List<BollingerBandsResult?>? bollingerBandsResults;
  final List<EMAProperties> emaPeriods;
  final List<List<SignSymbol>?>? signSymbols;

  KlinePainter({
    required this.data,
    this.candleWidth = 8.0,
    this.candleSpacing = 2.0,
    this.upColor = Colors.green,
    this.downColor = Colors.red,
    this.wickColor = Colors.grey,
    this.bollingerBandsResults,
    this.emaPeriods = const [],
    this.signSymbols,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    KlineDrawer.drawKline(
      klines: data,
      canvas: canvas,
      size: size,
      bollingerBandsResults: bollingerBandsResults,
      emaPeriods: emaPeriods,
      signSymbols: signSymbols,
      upColor: upColor,
      downColor: downColor,
      wickColor: wickColor,
      candleWidth: candleWidth,
      candleSpacing: candleSpacing,
    );
  }

  @override
  bool shouldRepaint(covariant KlinePainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.candleWidth != candleWidth ||
        oldDelegate.candleSpacing != candleSpacing ||
        oldDelegate.upColor != upColor ||
        oldDelegate.downColor != downColor ||
        oldDelegate.wickColor != wickColor ||
        oldDelegate.bollingerBandsResults != bollingerBandsResults ||
        oldDelegate.emaPeriods != emaPeriods ||
        oldDelegate.signSymbols != signSymbols;
  }
}
