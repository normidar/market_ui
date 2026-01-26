/// 価格をY座標に変換する
double priceToY(
  double price,
  double minPrice,
  double maxPrice,
  double height,
) {
  // 価格範囲を0-1に正規化し、それをY座標に変換
  // 上下反転：高い価格が小さいY座標（上）になるように
  final normalized = (price - minPrice) / (maxPrice - minPrice);
  return height * (1 - normalized);
}
