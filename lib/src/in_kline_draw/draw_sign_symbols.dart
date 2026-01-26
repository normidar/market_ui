import 'package:finance_kline_core/finance_kline_core.dart';
import 'package:flutter/painting.dart';
import 'package:market_ui/src/in_kline_draw/price_to_y.dart';
import 'package:market_ui/src/types/sign_symbol.dart';

/// シンボルを描画する
void drawSignSymbols({
  required List<Kline> klines,
  required List<List<SignSymbol>?> signSymbols,
  required Canvas canvas,
  required double candleWidth,
  required double candleSpacing,
  required double minPrice,
  required double maxPrice,
  required double height,
}) {
  if (signSymbols.length != klines.length) {
    return; // リストの長さが一致しない場合は描画しない
  }

  final symbolSize = candleWidth * 1.2; // シンボルのサイズ

  for (var i = 0; i < klines.length; i++) {
    final signSymbolList = signSymbols[i];
    if (signSymbolList == null || signSymbolList.isEmpty) {
      continue; // シンボルがない場合はスキップ
    }

    final kline = klines[i];

    // X座標を計算（キャンドルの中心）
    final x = (i * (candleWidth + candleSpacing)) + (candleWidth / 2);

    // 価格を取得
    final doubleHighPrice = kline.high.toDouble();
    final doubleLowPrice = kline.low.toDouble();

    // 複数のシンボルを描画
    // 上下のシンボル数をカウントして、重ならないようにオフセットを計算
    var topCount = 0;
    var bottomCount = 0;

    for (final signSymbol in signSymbolList) {
      // Y座標を計算（上にある場合は高値の上、下にある場合は低値の下）
      // 同じ位置に複数のシンボルがある場合は、さらに離して配置
      final baseY = signSymbol.isOnTop
          ? priceToY(doubleHighPrice, minPrice, maxPrice, height)
          : priceToY(doubleLowPrice, minPrice, maxPrice, height);

      final offset = signSymbol.isOnTop
          ? symbolSize * 0.8 + (symbolSize * 1.2 * topCount)
          : symbolSize * 0.8 + (symbolSize * 1.2 * bottomCount);

      final y = signSymbol.isOnTop ? baseY - offset : baseY + offset;

      // カウントを更新
      if (signSymbol.isOnTop) {
        topCount++;
      } else {
        bottomCount++;
      }

      // ペイント設定
      final paint = Paint()
        ..color = signSymbol.color
        ..style = PaintingStyle.fill;

      // シンボルの種類に応じて描画
      switch (signSymbol.symbol) {
        case SignSymbolType.square:
          _drawSquare(canvas, x, y, symbolSize, paint);
        case SignSymbolType.circle:
          _drawCircle(canvas, x, y, symbolSize, paint);
        case SignSymbolType.triangle:
          _drawTriangle(canvas, x, y, symbolSize, paint, signSymbol.isOnTop);
        case SignSymbolType.diamond:
          _drawDiamond(canvas, x, y, symbolSize, paint);
        case SignSymbolType.arrow:
          _drawArrow(canvas, x, y, symbolSize, paint, signSymbol.isOnTop);
      }
    }
  }
}

/// 矢印を描画
void _drawArrow(
  Canvas canvas,
  double x,
  double y,
  double size,
  Paint paint,
  bool isOnTop,
) {
  final path = Path();
  final halfSize = size / 2;
  final arrowHeadSize = size * 0.4;

  if (isOnTop) {
    // 下向き矢印（上にある場合）
    // 矢印の軸
    path
      ..moveTo(x, y - halfSize)
      ..lineTo(x, y + halfSize)
      // 矢印の頭
      ..moveTo(x, y + halfSize)
      ..lineTo(x - arrowHeadSize, y + halfSize - arrowHeadSize)
      ..moveTo(x, y + halfSize)
      ..lineTo(x + arrowHeadSize, y + halfSize - arrowHeadSize);
  } else {
    // 上向き矢印（下にある場合）
    // 矢印の軸
    path
      ..moveTo(x, y + halfSize)
      ..lineTo(x, y - halfSize)
      // 矢印の頭
      ..moveTo(x, y - halfSize)
      ..lineTo(x - arrowHeadSize, y - halfSize + arrowHeadSize)
      ..moveTo(x, y - halfSize)
      ..lineTo(x + arrowHeadSize, y - halfSize + arrowHeadSize);
  }

  final strokePaint = Paint()
    ..color = paint.color
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.5
    ..strokeCap = StrokeCap.round;

  canvas.drawPath(path, strokePaint);
}

/// 円を描画
void _drawCircle(Canvas canvas, double x, double y, double size, Paint paint) {
  canvas.drawCircle(
    Offset(x, y),
    size / 2,
    paint,
  );
}

/// 菱形を描画
void _drawDiamond(Canvas canvas, double x, double y, double size, Paint paint) {
  final path = Path();
  final halfSize = size / 2;

  path
    ..moveTo(x, y - halfSize) // 上
    ..lineTo(x + halfSize, y) // 右
    ..lineTo(x, y + halfSize) // 下
    ..lineTo(x - halfSize, y) // 左
    ..close();

  canvas.drawPath(path, paint);
}

/// 正方形を描画
void _drawSquare(Canvas canvas, double x, double y, double size, Paint paint) {
  final halfSize = size / 2;
  final rect = Rect.fromLTWH(
    x - halfSize,
    y - halfSize,
    size,
    size,
  );
  canvas.drawRect(rect, paint);
}

/// 三角形を描画
void _drawTriangle(
  Canvas canvas,
  double x,
  double y,
  double size,
  Paint paint,
  bool isOnTop,
) {
  final path = Path();

  if (isOnTop) {
    // 下向き三角形（上にある場合）
    path
      ..moveTo(x, y + size / 2)
      ..lineTo(x - size / 2, y - size / 2)
      ..lineTo(x + size / 2, y - size / 2);
  } else {
    // 上向き三角形（下にある場合）
    path
      ..moveTo(x, y - size / 2)
      ..lineTo(x - size / 2, y + size / 2)
      ..lineTo(x + size / 2, y + size / 2);
  }

  path.close();
  canvas.drawPath(path, paint);
}
