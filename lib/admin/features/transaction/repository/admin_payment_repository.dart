import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../features/payment/model/payment_model.dart';

class PaymentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<PaymentModel>> getPaymentsBySeller(String sellerId) async {
    print(sellerId);
    final snapshot = await _firestore
        .collection('bookings')
        .where('sellerId', isEqualTo: sellerId)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return PaymentModel(
        date: data['date'],
        startTime: data['startTime'],
        endTime: data['endTime'],
        price: data['price'],
        serviceId: data['serviceId'],
        status: data['status'],
        userId: data['userId'],
        sellerId: data['sellerId'],
        workerId: data['workerId'],
        createdAt: DateTime.parse(data['createdAt']),
      );
    }).toList();
  }
}
