# market_ui

[![GitHub](https://img.shields.io/github/license/normidar/market_ui.svg)](https://github.com/normidar/market_ui/blob/main/LICENSE)
[![pub package](https://img.shields.io/pub/v/market_ui.svg)](https://pub.dartlang.org/packages/market_ui)
[![GitHub Stars](https://img.shields.io/github/stars/normidar/market_ui.svg)](https://github.com/normidar/market_ui/stargazers)
[![Twitter](https://img.shields.io/twitter/url/https/twitter.com/normidar.svg?style=social&label=Follow%20%40normidar)](https://twitter.com/normidar)
[![Github-sponsors](https://img.shields.io/badge/sponsor-30363D?logo=GitHub-Sponsors&logoColor=#EA4AAA)](https://github.com/sponsors/normidar)

A Flutter package for displaying financial charts using `finance_kline_core`.

[🇯🇵 日本語での使い方はこちら (See usage in Japanese)](README_ja.md)

## Features

- **Candlestick Chart**: Visualize price movements.
- **Indicators**:
  - **Bollinger Bands**: Configurable upper, middle, and lower bands.
  - **EMA (Exponential Moving Average)**: Multiple EMA lines with custom colors.
- **Sign Symbols**: Draw custom markers (arrows, circles, etc.) on the chart to indicate buy/sell signals.
- **Responsive**: Auto-scales based on visible data.
- **Modular Architecture**: Easy to extend with new drawing logic.

## Usage

### 1. Installation

Add `market_ui` and `finance_kline_core` to your `pubspec.yaml`:

```yaml
dependencies:
  market_ui: ^0.0.1
  finance_kline_core: ^0.0.4
```

### 2. Basic Example

```dart
import 'package:finance_kline_core/finance_kline_core.dart';
import 'package:flutter/material.dart';
import 'package:market_ui/market_ui.dart';

// ... inside your widget ...

KlineChart(
  data: myKlineData, // List<Kline>
  height: 400,
  upColor: Colors.green,
  downColor: Colors.red,
)
```

### 3. Advanced Usage (Indicators & Symbols)

```dart
KlineChart(
  data: myKlineData,
  
  // Bollinger Bands
  bollingerBandsResults: [
    BollingerBandsResult(upper: 110, middle: 100, lower: 90),
    // ...
  ],
  
  // EMA Lines
  emaPeriods: [
    EMAProperties(emaValues: ema20Values, color: Colors.blue),
    EMAProperties(emaValues: ema50Values, color: Colors.orange),
  ],
  
  // Sign Symbols (Markers)
  signSymbols: [
    [SignSymbol(symbol: SignSymbolType.arrow, color: Colors.green, isOnTop: false)], // Buy signal
    null,
    [SignSymbol(symbol: SignSymbolType.arrow, color: Colors.red, isOnTop: true)],   // Sell signal
    // ... same length as data
  ],
)
```
