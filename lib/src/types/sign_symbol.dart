import 'dart:ui';

class SignSymbol {
  SignSymbol({
    required this.symbol,
    required this.color,
    required this.isOnTop,
  });

  final SignSymbolType symbol;
  final Color color;
  final bool isOnTop; // 上にある場合はtrue、下にある場合はfalse
}

enum SignSymbolType {
  square, // 正方形
  circle, // 円
  triangle, // 三角形（上にある場合は下向き、下にある場合は上向き）
  diamond, // 菱形
  arrow, // 矢印 (上にある場合は下向き、下にある場合は上向き)
}
