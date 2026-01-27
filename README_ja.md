# market_ui

[![GitHub](https://img.shields.io/github/license/normidar/market_ui.svg)](https://github.com/normidar/market_ui/blob/main/LICENSE)
[![pub package](https://img.shields.io/pub/v/market_ui.svg)](https://pub.dartlang.org/packages/market_ui)
[![GitHub Stars](https://img.shields.io/github/stars/normidar/market_ui.svg)](https://github.com/normidar/market_ui/stargazers)
[![Twitter](https://img.shields.io/twitter/url/https/twitter.com/normidar.svg?style=social&label=Follow%20%40normidar)](https://twitter.com/normidar)
[![Github-sponsors](https://img.shields.io/badge/sponsor-30363D?logo=GitHub-Sponsors&logoColor=#EA4AAA)](https://github.com/sponsors/normidar)

`finance_kline_core` を使用して金融チャートを表示するFlutterパッケージです。

## 特徴 (Features)

- **ローソク足チャート (Candlestick Chart)**: 価格の動きを視覚化します。
- **インジケーター (Indicators)**:
  - **ボリンジャーバンド (Bollinger Bands)**: 上部・中部・下部バンドを設定可能。
  - **EMA (指数平滑移動平均線)**: 複数のEMAラインをカスタムカラーで表示可能。
- **サインシンボル (Sign Symbols)**: 売買シグナルなどを示すカスタムマーカー（矢印、丸など）をチャート上に描画します。
- **レスポンシブ (Responsive)**: 表示データに基づいて自動的にスケーリングします。
- **モジュラーアーキテクチャ (Modular Architecture)**: 新しい描画ロジックで簡単に拡張可能です。

## 使い方 (Usage)

### 1. インストール (Installation)

`pubspec.yaml` に `market_ui` と `finance_kline_core` を追加します：

```yaml
dependencies:
  market_ui: ^0.0.1
  finance_kline_core: ^0.0.4
```

### 2. 基本的な例 (Basic Example)

```dart
import 'package:finance_kline_core/finance_kline_core.dart';
import 'package:flutter/material.dart';
import 'package:market_ui/market_ui.dart';

// ... ウィジェット内で ...

KlineChart(
  data: myKlineData, // List<Kline>
  height: 400,
  upColor: Colors.green,
  downColor: Colors.red,
)
```

### 3. 高度な使い方 (Advanced Usage) - インジケーターとシンボル

```dart
KlineChart(
  data: myKlineData,
  
  // ボリンジャーバンド (Bollinger Bands)
  bollingerBandsResults: [
    BollingerBandsResult(upper: 110, middle: 100, lower: 90),
    // ...
  ],
  
  // EMAライン (EMA Lines)
  emaPeriods: [
    EMAProperties(emaValues: ema20Values, color: Colors.blue),
    EMAProperties(emaValues: ema50Values, color: Colors.orange),
  ],
  
  // サインシンボル (Sign Symbols) - マーカー
  signSymbols: [
    [SignSymbol(symbol: SignSymbolType.arrow, color: Colors.green, isOnTop: false)], // 買いシグナル
    null,
    [SignSymbol(symbol: SignSymbolType.arrow, color: Colors.red, isOnTop: true)],   // 売りシグナル
    // ... データと同じ長さが必要です
  ],
)
```
