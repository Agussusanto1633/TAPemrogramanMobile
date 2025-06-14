import 'package:bloc/bloc.dart';
import 'package:servista/admin/features/transaction/repository/admin_payment_repository.dart';
import 'package:servista/features/payment/bloc/payment_event.dart';

import '../cubit/payment_cubit.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository paymentRepository;

  PaymentBloc(this.paymentRepository) : super(PaymentInitial()) {
    on<FetchPaymentsBySeller>((event, emit) async {
      emit(PaymentLoading());
      try {
        final payments = await paymentRepository.getPaymentsBySeller(event.sellerId);
        emit(PaymentLoaded(payments));
      } catch (e) {
        emit(PaymentError(e.toString()));
      }
    });
  }
}
