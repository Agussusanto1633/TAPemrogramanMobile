part of 'service_cubit.dart';

class ServiceState {
  final DateTime? selectedDate;
  final DateTime? focusedDate;
  final String?  selectedTime;
  final String? selectedWorker, focusedWorker;
  final String? paymentMethod;


  ServiceState({
    this.selectedDate,
    this.focusedDate,
    this.selectedTime,
    this.selectedWorker,
    this.focusedWorker,
    this.paymentMethod,
  });

  ServiceState copyWith({
    DateTime? selectedDate,
    DateTime? focusedDate,
    String? selectedTime,
    String? selectedWorker,
    String? focusedWorker,
    String? paymentMethod,
  }) {
    return ServiceState(
      selectedDate: selectedDate ?? this.selectedDate,
      focusedDate: focusedDate ?? this.focusedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      selectedWorker: selectedWorker ?? this.selectedWorker,
      focusedWorker: focusedWorker ?? this.focusedWorker,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}
