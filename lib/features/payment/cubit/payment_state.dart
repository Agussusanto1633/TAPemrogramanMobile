part of 'payment_cubit.dart';

@immutable
abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {}

class PaymentFailure extends PaymentState {
  final String message;
  PaymentFailure(this.message);
}




class PaymentLoaded extends PaymentState {
  final List<PaymentModel> payments;

  PaymentLoaded(this.payments);
}

class PaymentError extends PaymentState {
  final String message;

  PaymentError(this.message);
}
