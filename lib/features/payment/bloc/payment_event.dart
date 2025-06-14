abstract class PaymentEvent {}

class FetchPaymentsBySeller extends PaymentEvent {
  final String sellerId;

  FetchPaymentsBySeller(this.sellerId);
}
