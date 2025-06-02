class BookingModel {
  final String id;
  final String createdAt;
  final String date;
  final String endTime;
  final int price;
  final String serviceId;
  final String startTime;
  final String status;
  final String userId;
  final String workerId;

  BookingModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.startTime,
    required this.status,
    required this.workerId,
    required this.createdAt,
    required this.endTime,
    required this.price,
    required this.serviceId,
  });

  factory BookingModel.fromFirestore(String id, Map<String, dynamic> data) {
    return BookingModel(
      id: id,
      userId: data['userId'] ?? '',
      date: data['date'] ?? '',
      startTime: data['startTime'] ?? '',
      status: data['status'] ?? '',
      workerId: data['workerId'] ?? '',
      createdAt: data['createdAt'] ?? '',
      endTime: data['endTime'] ?? '',
      price: data['price'] ?? 0,
      serviceId: data['serviceId'] ?? '',
    );
  }

  DateTime get bookingDateTime {
    return DateTime.parse(
      '$date ${startTime.length == 5 ? startTime : startTime.substring(0, 5)}',
    );
  }
}
