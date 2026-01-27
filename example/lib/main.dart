import 'dart:math';

import 'package:finance_kline_core/finance_kline_core.dart';
import 'package:flutter/material.dart';
import 'package:market_ui/market_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Market Kline Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Market Kline Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Kline> _data;
  List<BollingerBandsResult?>? _bbData;
  List<EMAProperties> _emaData = [];
  List<List<SignSymbol>?>? _signSymbols;
  List<Macd?> _macdData = [];
  List<Rsi?> _rsiData = [];

  @override
  void initState() {
    super.initState();
    _data = _generateDummyData();
    _calculateIndicators();
  }

  List<Kline> _generateDummyData() {
    final List<Kline> data = [];
    double currentPrice = 10000.0;

    for (int i = 0; i < 100; i++) {
      final double open = currentPrice;
      // Random movement
      final double movement = (Random().nextDouble() - 0.5) * 200;
      final double close = open + movement;

      double high = max(open, close) + Random().nextDouble() * 50;
      double low = min(open, close) - Random().nextDouble() * 50;

      data.add(
        Kline.fromDouble(
          open: open,
          high: high,
          low: low,
          close: close,
          scale: 2,
        ),
      );

      currentPrice = close;
    }
    return data;
  }

  void _calculateIndicators() {
    // EMA
    final ema20 = _data.ema(period: 20);
    final ema50 = _data.ema(period: 50);

    // Convert List<double?> to List<double?> (mostly casting effectively)
    // The library returns List<double?>, so we can use it directly.

    _emaData = [
      EMAProperties(
        emaValues: ema20,
        color: Colors.amber,
      ),
      EMAProperties(
        emaValues: ema50,
        color: Colors.blue,
      ),
    ];

    // Bollinger Bands (Manual calculation for example)
    _bbData = _calculateBollingerBands(_data, 20, 2);

    // Sign Symbols (Random)
    _signSymbols = List.generate(_data.length, (index) {
      if (index % 10 == 0) {
        return [
          SignSymbol(
            symbol: SignSymbolType.arrow,
            color: Colors.green,
            isOnTop: false, // Buy signal below
          )
        ];
      } else if (index % 15 == 0) {
        return [
          SignSymbol(
            symbol: SignSymbolType.arrow,
            color: Colors.red,
            isOnTop: true, // Sell signal above
          )
        ];
      }
      return null;
    });

    // MACD
    _macdData = _data.macd(
      fastPeriod: 12,
      slowPeriod: 26,
      signalPeriod: 9,
    );

    // RSI
    _rsiData = _data.rsi(period: 14);
  }

  List<BollingerBandsResult?> _calculateBollingerBands(
      List<Kline> data, int period, double multiplier) {
    if (data.length < period) return List.filled(data.length, null);

    final results = <BollingerBandsResult?>[];
    // Fill initial nulls
    for (int i = 0; i < period - 1; i++) {
      results.add(null);
    }

    for (int i = period - 1; i < data.length; i++) {
      final subset = data.sublist(i - period + 1, i + 1);
      final closes = subset.map((e) => e.close.toDouble()).toList();
      final sma = closes.reduce((a, b) => a + b) / period;

      double sumSquaredDiff = 0.0;
      for (final close in closes) {
        sumSquaredDiff += pow(close - sma, 2);
      }
      final stdDev = sqrt(sumSquaredDiff / period);

      final upper = sma + (multiplier * stdDev);
      final lower = sma - (multiplier * stdDev);

      results.add(BollingerBandsResult(
        upper: upper,
        middle: sma,
        lower: lower,
      ));
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text("Kline Chart with BB, EMA, Signs"),
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: KlineChart(
                    data: _data,
                    height: 300,
                    candleWidth: 6.0,
                    candleSpacing: 2.0,
                    bollingerBandsResults: _bbData,
                    emaPeriods: _emaData,
                    signSymbols: _signSymbols,
                  ),
                ),
                const SizedBox(height: 20),
                const Text("MACD Chart"),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: MacdChart(
                    data: _macdData,
                    height: 150,
                    barWidth: 6.0,
                    barSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 20),
                const Text("RSI Chart"),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: RsiChart(
                    data: _rsiData,
                    height: 150,
                    barWidth: 6.0,
                    barSpacing: 2.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
