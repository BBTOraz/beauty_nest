import '../model/stylist.dart';

double getMinPrice(Stylist stylist) {
  if (stylist.services.isEmpty) return 0.0;
  double minPrice = stylist.services.first.price;
  for (final s in stylist.services) {
    if (s.price < minPrice) {
      minPrice = s.price;
    }
  }
  return minPrice;
}