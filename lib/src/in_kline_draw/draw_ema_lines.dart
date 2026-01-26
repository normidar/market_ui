import 'package:finance_kline_core/finance_kline_core.dart';
import 'package:flutter/painting.dart';
import 'package:market_ui/src/in_kline_draw/price_to_y.dart';
import 'package:market_ui/src/types/ema_properties.dart';

/// EMAラインを描画する
void drawEMALines({
  required List<EMAProperties> emaPeriods,
  required Canvas canvas,
  required List<Kline> klines,
  required double candleWidth,
  required double candleSpacing,
  required double minPrice,
  required double maxPrice,
  required double height,
}) {
  for (final emaProperty in emaPeriods) {
    if (emaProperty.emaValues.length != klines.length) {
      continue; // EMA値の数がklineの数と一致しない場合はスキップ
    }

    final emaPaint = Paint()
      ..color = emaProperty.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // EMAラインを描画
    for (var i = 0; i < emaProperty.emaValues.length - 1; i++) {
      final emaValue = emaProperty.emaValues[i];
      final nextEmaValue = emaProperty.emaValues[i + 1];

      // null値またはNaN値をスキップ
      if (emaValue == null || nextEmaValue == null) {
        continue;
      }
      if (emaValue.isNaN || nextEmaValue.isNaN) {
        continue;
      }

      // X座標を計算
      final x = (i * (candleWidth + candleSpacing)) + (candleWidth / 2);
      final nextX =
          ((i + 1) * (candleWidth + candleSpacing)) + (candleWidth / 2);

      // Y座標を計算
      final y = priceToY(emaValue, minPrice, maxPrice, height);
      final nextY = priceToY(nextEmaValue, minPrice, maxPrice, height);

      // ラインを描画
      canvas.drawLine(
        Offset(x, y),
        Offset(nextX, nextY),
        emaPaint,
      );
    }
  }
}
