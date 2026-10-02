double processOrder({
  required String orderId,
  required double itemPrice,
  String? promoCode,
  double? deliveryFee,
}) {

  double delivery = deliveryFee ?? 500.0;

  double discountedPrice = itemPrice;

  if (promoCode == 'SAVE10') {
    discountedPrice = itemPrice * 0.9;
  }
  double finalTotal = discountedPrice + delivery;

  print("Order ID: $orderId");
  print("Item price: $itemPrice ₸");
  print("Promo code: $promoCode");
  print("Delivery fee: $delivery ₸");
  print("Final total: $finalTotal ₸");

  return finalTotal;
}
void main() {
  processOrder(
    orderId: "A101",
    itemPrice: 10000.0,
    promoCode: "SAVE10",
  );
}