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

  @override
  void initState() {
    super.initState();
    _data = _generateDummyData();
  }

  List<Kline> _generateDummyData() {
    final List<Kline> data = [];
    double currentPrice = 100.0;
    
    for (int i = 0; i < 50; i++) {
      final double open = currentPrice;
      // Random movement between -2% and +2%
      final double movement = (i % 2 == 0 ? 1 : -1) * (i % 5 + 1) * 0.5; 
      final double close = open + movement;
      
      double high = open > close ? open : close;
      double low = open < close ? open : close;
      
      high += 1.0;
      low -= 1.0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: KlineChart(
                  data: _data,
                  height: 300,
                  upColor: Colors.green,
                  downColor: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
