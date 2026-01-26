import 'package:flutter/painting.dart';
import 'package:market_ui/src/in_kline_draw/price_to_y.dart';
import 'package:market_ui/src/types/bollinger_bands_result.dart';

void drawBollingerBands({
  required List<BollingerBandsResult?> bollingerBandsResults,
  required Canvas canvas,
  required double candleWidth,
  required double candleSpacing,
  required double minPrice,
  required double maxPrice,
  required double height,
}) {
  // ボリンジャーバンドのペイント設定
  final upperPaint = Paint()
    ..color = const Color(0xFF9C27B0).withValues(alpha: 0.5) // 紫色（上部バンド）
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;

  final middlePaint = Paint()
    ..color = const Color(0xFF2196F3).withValues(alpha: 0.5) // 青色（中央線）
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;

  final lowerPaint = Paint()
    ..color = const Color(0xFF9C27B0).withValues(alpha: 0.5) // 紫色（下部バンド）
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;

  // バンド間の塗りつぶし用ペイント
  final fillPaint = Paint()
    ..color = const Color(0xFF9C27B0).withValues(alpha: 0.1)
    ..style = PaintingStyle.fill;

  // バンド間の塗りつぶしパスを作成
  final fillPath = Path();
  var pathStarted = false;

  // 上部バンドのラインと塗りつぶしパスの開始
  for (var i = 0; i < bollingerBandsResults.length - 1; i++) {
    final bbResult = bollingerBandsResults[i];
    final nextBbResult = bollingerBandsResults[i + 1];

    if (bbResult == null || nextBbResult == null) {
      pathStarted = false;
      continue;
    }

    // X座標を計算
    final x = (i * (candleWidth + candleSpacing)) + (candleWidth / 2);
    final nextX = ((i + 1) * (candleWidth + candleSpacing)) + (candleWidth / 2);

    // 上部バンドを描画
    final upperY = priceToY(bbResult.upper, minPrice, maxPrice, height);
    final nextUpperY = priceToY(
      nextBbResult.upper,
      minPrice,
      maxPrice,
      height,
    );
    canvas.drawLine(Offset(x, upperY), Offset(nextX, nextUpperY), upperPaint);

    // 中央線を描画
    final middleY = priceToY(bbResult.middle, minPrice, maxPrice, height);
    final nextMiddleY = priceToY(
      nextBbResult.middle,
      minPrice,
      maxPrice,
      height,
    );
    canvas.drawLine(
      Offset(x, middleY),
      Offset(nextX, nextMiddleY),
      middlePaint,
    );

    // 下部バンドを描画
    final lowerY = priceToY(bbResult.lower, minPrice, maxPrice, height);
    final nextLowerY = priceToY(
      nextBbResult.lower,
      minPrice,
      maxPrice,
      height,
    );
    canvas.drawLine(Offset(x, lowerY), Offset(nextX, nextLowerY), lowerPaint);

    // 塗りつぶしパスの構築
    if (!pathStarted) {
      fillPath.moveTo(x, upperY);
      pathStarted = true;
    } else {
      fillPath.lineTo(x, upperY);
    }
  }

  // 塗りつぶしパスを完成させる（上部バンドから下部バンドへ）
  if (pathStarted) {
    // 最後の点を追加
    final lastIndex = bollingerBandsResults.length - 1;
    final lastBbResult = bollingerBandsResults[lastIndex];
    if (lastBbResult != null) {
      final lastX =
          (lastIndex * (candleWidth + candleSpacing)) + (candleWidth / 2);
      final lastUpperY = priceToY(
        lastBbResult.upper,
        minPrice,
        maxPrice,
        height,
      );
      fillPath.lineTo(lastX, lastUpperY);

      // 下部バンドに沿って戻る
      for (var i = lastIndex; i >= 0; i--) {
        final bbResult = bollingerBandsResults[i];
        if (bbResult == null) continue;

        final x = (i * (candleWidth + candleSpacing)) + (candleWidth / 2);
        final lowerY = priceToY(bbResult.lower, minPrice, maxPrice, height);
        fillPath.lineTo(x, lowerY);
      }

      fillPath.close();
      canvas.drawPath(fillPath, fillPaint);
    }
  }
}
