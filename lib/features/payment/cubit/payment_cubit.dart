import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../model/payment_model.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());

  Future<void> createPayment(PaymentModel payment) async {
    emit(PaymentLoading());
    try {
      final customId =
          '${payment.serviceId}-${payment.date.replaceAll('-', '')}-${DateTime.now().millisecondsSinceEpoch}';

      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(customId)
          .set(payment.toMap());

      emit(PaymentSuccess());
      print("succes bree");
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }
}
