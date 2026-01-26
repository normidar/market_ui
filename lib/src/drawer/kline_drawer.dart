import 'dart:math';

import 'package:finance_kline_core/finance_kline_core.dart';
import 'package:flutter/material.dart';
import 'package:market_ui/src/in_kline_draw/draw_bollinger_bands.dart';
import 'package:market_ui/src/in_kline_draw/draw_candlesticks.dart';
import 'package:market_ui/src/in_kline_draw/draw_ema_lines.dart';
import 'package:market_ui/src/in_kline_draw/draw_sign_symbols.dart';
import 'package:market_ui/src/types/bollinger_bands_result.dart';
import 'package:market_ui/src/types/ema_properties.dart';
import 'package:market_ui/src/types/sign_symbol.dart';

class KlineDrawer {
  static void drawKline({
    required List<Kline> klines,
    required Canvas canvas,
    required Size size,
    List<BollingerBandsResult?>? bollingerBandsResults,
    List<EMAProperties> emaPeriods = const [],
    List<List<SignSymbol>?>? signSymbols,
    required Color upColor,
    required Color downColor,
    required Color wickColor,
    double? maxPrice,
    double? minPrice,
    double candleWidth = 8.0,
    double candleSpacing = 2.0,
  }) {
    if (klines.isEmpty || size.width <= 0 || size.height <= 0) {
      return;
    }

    var currentMaxPrice = maxPrice;
    var currentMinPrice = minPrice;

    if (currentMaxPrice == null || currentMinPrice == null) {
      if (klines.isNotEmpty) {
        currentMaxPrice = klines.first.high.toDouble();
        currentMinPrice = klines.first.low.toDouble();
      } else {
        return;
      }
      
      for (final kline in klines) {
        currentMaxPrice = max(currentMaxPrice!, kline.high.toDouble());
        currentMinPrice = min(currentMinPrice!, kline.low.toDouble());
      }

      // Also consider Bollinger Bands for min/max
      if (bollingerBandsResults != null) {
        for (final bb in bollingerBandsResults) {
          if (bb != null) {
            currentMaxPrice = max(currentMaxPrice!, bb.upper);
            currentMinPrice = min(currentMinPrice!, bb.lower);
          }
        }
      }

      // Also consider EMA for min/max
      for (final ema in emaPeriods) {
        for (final value in ema.emaValues) {
          if (value != null && !value.isNaN) {
            currentMaxPrice = max(currentMaxPrice!, value);
            currentMinPrice = min(currentMinPrice!, value);
          }
        }
      }
      
      // Add margin
      final priceRange = currentMaxPrice! - currentMinPrice!;
      final priceMargin = priceRange * 0.1;
      currentMinPrice -= priceMargin;
      currentMaxPrice += priceMargin;
    }

    // Draw Bollinger Bands (Background)
    if (bollingerBandsResults != null && bollingerBandsResults.isNotEmpty) {
      drawBollingerBands(
        bollingerBandsResults: bollingerBandsResults,
        canvas: canvas,
        candleWidth: candleWidth,
        candleSpacing: candleSpacing,
        minPrice: currentMinPrice,
        maxPrice: currentMaxPrice,
        height: size.height,
      );
    }

    // Draw Candlesticks
    drawCandlesticks(
      klines: klines,
      canvas: canvas,
      candleWidth: candleWidth,
      candleSpacing: candleSpacing,
      minPrice: currentMinPrice!,
      maxPrice: currentMaxPrice!,
      height: size.height,
      upColor: upColor,
      downColor: downColor,
      wickColor: wickColor,
    );

    // Draw EMA Lines
    if (emaPeriods.isNotEmpty) {
      drawEMALines(
        emaPeriods: emaPeriods,
        canvas: canvas,
        klines: klines,
        candleWidth: candleWidth,
        candleSpacing: candleSpacing,
        candleSpacing: candleSpacing,
        minPrice: currentMinPrice,
        maxPrice: currentMaxPrice,
        height: size.height,
      );
    }

    // Draw Sign Symbols (Foreground)
    if (signSymbols != null && signSymbols.isNotEmpty) {
      drawSignSymbols(
        klines: klines,
        signSymbols: signSymbols,
        canvas: canvas,
        candleWidth: candleWidth,
        candleSpacing: candleSpacing,
        candleSpacing: candleSpacing,
        minPrice: currentMinPrice,
        maxPrice: currentMaxPrice,
        height: size.height,
      );
    }
  }
}
