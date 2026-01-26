import 'dart:math';

import 'package:finance_kline_core/finance_kline_core.dart';
import 'package:flutter/painting.dart';
import 'package:market_ui/src/in_kline_draw/price_to_y.dart';

/// キャンドルスティックを描画する
void drawCandlesticks({
  required List<Kline> klines,
  required Canvas canvas,
  required double candleWidth,
  required double candleSpacing,
  required double minPrice,
  required double maxPrice,
  required double height,
  required Color upColor,
  required Color downColor,
  required Color wickColor,
}) {
  // ペイント設定
  final upPaint = Paint()
    ..color = upColor
    ..style = PaintingStyle.fill;

  final downPaint = Paint()
    ..color = downColor
    ..style = PaintingStyle.fill;

  final wickPaint = Paint()
    ..color = wickColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = max(1, candleWidth * 0.1);

  // 各キャンドルを描画
  for (var i = 0; i < klines.length; i++) {
    final kline = klines[i];

    final doubleClosePrice = kline.close.toDouble();
    final doubleOpenPrice = kline.open.toDouble();
    final doubleHighPrice = kline.high.toDouble();
    final doubleLowPrice = kline.low.toDouble();

    final isUp = doubleClosePrice >= doubleOpenPrice;

    // X座標を計算（左端から開始）
    final x = (i * (candleWidth + candleSpacing)) + (candleWidth / 2);

    // Y座標を計算
    final highY = priceToY(doubleHighPrice, minPrice, maxPrice, height);
    final lowY = priceToY(doubleLowPrice, minPrice, maxPrice, height);
    final openY = priceToY(
      doubleOpenPrice,
      minPrice,
      maxPrice,
      height,
    );
    final closeY = priceToY(
      doubleClosePrice,
      minPrice,
      maxPrice,
      height,
    );

    // ウィック（高値-低値の線）を描画
    // wickPaint.color = isUp ? upPaint.color : downPaint.color; // Using separate wick color as per original design, or stick to reference? 
    // Reference uses colored wicks. MarketUI originally used grey wicks.
    // Let's use the passed wickColor for now to match original MarketUI, but can update if needed.
    // Actually, reference code does: `wickPaint.color = isUp ? upPaint.color : downPaint.color;`
    // I will stick to the parameters passed (wickColor) to keep flexibility, allowing user to set it to same as candles if they want.
    
    canvas.drawLine(
      Offset(x, highY),
      Offset(x, lowY),
      wickPaint,
    );

    // ボディ（始値-終値の矩形）を描画
    final bodyTop = min(openY, closeY);
    final bodyBottom = max(openY, closeY);
    final bodyHeight = bodyBottom - bodyTop;

    // ボディの高さが0の場合は最小の線を描画
    if (bodyHeight < 1) {
      canvas.drawLine(
        Offset(x - candleWidth / 2, openY),
        Offset(x + candleWidth / 2, openY),
        wickPaint,
      );
    } else {
      final rect = Rect.fromLTWH(
        x - candleWidth / 2,
        bodyTop,
        candleWidth,
        bodyHeight,
      );
      canvas.drawRect(rect, isUp ? upPaint : downPaint);
    }
  }
}
