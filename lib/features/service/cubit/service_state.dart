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
    bool clearSelectedDate = false,

    DateTime? focusedDate,
    bool clearFocusedDate = false,

    String? selectedTime,
    bool clearSelectedTime = false,

    String? selectedWorker,
    bool clearSelectedWorker = false,
    String? focusedWorker,
    bool clearFocusedWorker = false,
    String? paymentMethod,
    bool clearPaymentMethod = false,
    String? selectedService,
    bool clearSelectedService = false,
    int? price,
    bool clearPrice = false,
    ServiceModel? serviceModel,
    bool clearServiceModel = false,
  }) {
    return ServiceState(
      selectedDate:
          clearSelectedDate ? null : (selectedDate ?? this.selectedDate),
      focusedDate: clearFocusedDate ? null : (focusedDate ?? this.focusedDate),
      selectedTime:
          clearSelectedTime ? null : (selectedTime ?? this.selectedTime),
      selectedWorker:
          clearSelectedWorker ? null : (selectedWorker ?? this.selectedWorker),
      focusedWorker:
          clearFocusedWorker ? null : (focusedWorker ?? this.focusedWorker),
      paymentMethod:
          clearPaymentMethod ? null : (paymentMethod ?? this.paymentMethod),
      selectedService:
          clearSelectedService
              ? null
              : (selectedService ?? this.selectedService),
      price: clearPrice ? null : (price ?? this.price),
      serviceModel:
          clearServiceModel ? null : (serviceModel ?? this.serviceModel),
    );
  }
}
