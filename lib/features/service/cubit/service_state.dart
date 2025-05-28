part of 'service_cubit.dart';

class ServiceState {
  final DateTime? selectedDate;
  final DateTime? focusedDate;
  final String? selectedTime;
  final String? selectedWorker, focusedWorker;
  final String? paymentMethod;
  final String? selectedService;
  final int? price;
  final ServiceModel? serviceModel;

  ServiceState({
    this.selectedDate,
    this.focusedDate,
    this.selectedTime,
    this.selectedWorker,
    this.focusedWorker,
    this.paymentMethod,
    this.selectedService,
    this.price,
    this.serviceModel,
  });

  ServiceState copyWith({
    DateTime? selectedDate,
    DateTime? focusedDate,
    String? selectedTime,
    String? selectedWorker,
    String? focusedWorker,
    String? paymentMethod,
    String? selectedService,
    int? price,
    ServiceModel? serviceModel,
  }) {
    return ServiceState(
      selectedDate: selectedDate ?? this.selectedDate,
      focusedDate: focusedDate ?? this.focusedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      selectedWorker: selectedWorker ?? this.selectedWorker,
      focusedWorker: focusedWorker ?? this.focusedWorker,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      selectedService: selectedService ?? this.selectedService,
      price: price ?? this.price,
      serviceModel: serviceModel ?? this.serviceModel,
    );
  }
}
