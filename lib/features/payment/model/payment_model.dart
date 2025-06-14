class PaymentModel {
  final String date;
  final String startTime;
  final String endTime;
  final int price;
  final String serviceId;
  final String status;
  final String userId;
  final String sellerId;
  final String workerId;
  final DateTime createdAt;

  PaymentModel({
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.price,
    required this.serviceId,
    required this.status,
    required this.userId,
    required this.sellerId,
    required this.workerId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'price': price,
      'serviceId': serviceId,
      'sellerId': sellerId,
      'status': status,
      'userId': userId,
      'workerId': workerId,
      'createdAt': createdAt.toUtc().toIso8601String(),
    };
  }
}
