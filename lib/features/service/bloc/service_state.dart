import 'package:equatable/equatable.dart';
import '../model/service_model.dart';

abstract class ServiceState extends Equatable {
  const ServiceState();

  @override
  List<Object?> get props => [];
}

class ServiceInitial extends ServiceState {}

class ServiceLoading extends ServiceState {}

class ServiceSuccess extends ServiceState {
  final List<ServiceModel> services;
  final List<ServiceModel> promoServices;

  const ServiceSuccess({
    required this.services,
    required this.promoServices,
  });

  @override
  List<Object> get props => [services, promoServices];
}

class ServiceDetailLoaded extends ServiceState {
  final ServiceModel service;

  const ServiceDetailLoaded(this.service);

  @override
  List<Object> get props => [service];
}

class ServicePromoLoaded extends ServiceState {
  final List<ServiceModel> services;

  const ServicePromoLoaded(this.services);

  @override
  List<Object> get props => [services];
}

// Di service_state.dart
class TimeSlotStatusesLoaded extends ServiceState {
  final Map<String, String> statuses; // SUDAH BENAR Map<String, String>
  final String? selectedTime;       // TAMBAHAN untuk UI bottom sheet

  const TimeSlotStatusesLoaded({required this.statuses, this.selectedTime});

  @override
  List<Object?> get props => [statuses, selectedTime];

  // Opsional: copyWith untuk memudahkan update state di Cubit
  TimeSlotStatusesLoaded copyWith({
    Map<String, String>? statuses,
    String? selectedTime,
  }) {
    return TimeSlotStatusesLoaded(
      statuses: statuses ?? this.statuses,
      selectedTime: selectedTime ?? this.selectedTime,
    );
  }
}

class WorkerSlotStatusesLoaded extends ServiceState {
  // Menyimpan status untuk setiap pekerja.
  // Key: nama pekerja (String), Value: statusnya ("Available", "Booked", "Error")
  final Map<String, String> workerStatuses;

  // Menyimpan nama pekerja yang sedang dipilih oleh pengguna di UI.
  // Bisa null jika belum ada pekerja yang dipilih.
  final String? selectedWorker;

  const WorkerSlotStatusesLoaded({
    required this.workerStatuses,
    this.selectedWorker,
  });

  @override
  List<Object?> get props => [workerStatuses, selectedWorker];

  // Method copyWith untuk memudahkan update state di Cubit,
  // misalnya saat pengguna memilih pekerja lain.
  WorkerSlotStatusesLoaded copyWith({
    Map<String, String>? workerStatuses,
    String? selectedWorker,
    bool forceNullSelectedWorker = false, // Flag untuk memaksa selectedWorker menjadi null
  }) {
    return WorkerSlotStatusesLoaded(
      workerStatuses: workerStatuses ?? this.workerStatuses, // Jika param null, gunakan nilai lama
      selectedWorker: forceNullSelectedWorker
          ? null // Jika diminta null secara paksa
          : (selectedWorker ?? this.selectedWorker), // Jika param null, gunakan nilai lama
    );
  }
}


class ServiceLoadFailure extends ServiceState {
  final String message;

  const ServiceLoadFailure(this.message);

  @override
  List<Object> get props => [message];
}

class SellerServiceLoaded extends ServiceState {
  final List<ServiceModel> services;

  const SellerServiceLoaded(this.services);
}


class CreateSellerServicesInProgress extends ServiceState {}

class CreateSellerServicesSuccess extends ServiceState {}

class CreateSellerServicesFailure extends ServiceState {
  final String error;
  const CreateSellerServicesFailure(this.error);

  @override
  List<Object> get props => [error];
}

class UpdateSellerServiceInProgress extends ServiceState {}

class UpdateSellerServiceSuccess extends ServiceState {}

class UpdateSellerServiceFailure extends ServiceState {
  final String error;

  const UpdateSellerServiceFailure(this.error);

  @override
  List<Object> get props => [error];
}

