import 'package:flutter_bloc/flutter_bloc.dart';
import 'service_event.dart';
import 'service_state.dart';
import '../repositories/service_repository.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final ServiceRepository _serviceRepository;

  ServiceBloc({required ServiceRepository serviceRepository})
    : _serviceRepository = serviceRepository,
      super(ServiceInitial()) {
    on<LoadAllServices>(_onLoadAllServices);
    on<LoadServiceDetail>(_onLoadServiceDetail);
    on<LoadTimeSlotStatuses>(_onLoadTimeSlotStatuses);
    on<LoadWorkerSlotStatuses>(_onLoadWorkerSlotStatuses);
    on<LoadSellerServices>(_onLoadSellerServices);
    on<CreateSellerServices>(_onCreateSellerServices);

  }

  Future<void> _onLoadAllServices(
    LoadAllServices event,
    Emitter<ServiceState> emit,
  ) async {
    emit(ServiceLoading());
    try {
      final services = await _serviceRepository.getServices();
      final promoServices = await _serviceRepository.getPromoServices();
      emit(ServiceSuccess(services: services, promoServices: promoServices));
    } catch (e) {
      emit(ServiceLoadFailure(e.toString()));
    }
  }

  Future<void> _onLoadServiceDetail(
    LoadServiceDetail event,
    Emitter<ServiceState> emit,
  ) async {
    emit(ServiceLoading());
    try {
      final service = await _serviceRepository.getServiceById(event.serviceId);
      if (service != null) {
        emit(ServiceDetailLoaded(service));
      } else {
        emit(const ServiceLoadFailure('Service not found'));
      }
    } catch (e) {
      emit(ServiceLoadFailure(e.toString()));
    }
  }

  Future<void> _onLoadTimeSlotStatuses(
    LoadTimeSlotStatuses event,
    Emitter<ServiceState> emit,
  ) async {
    emit(ServiceLoading());
    try {
      final statuses = await _serviceRepository.getTimeSlotStatuses(
        serviceId: event.serviceId,
        selectedDate: event.selectedDate,
        service: event.service,
      );
      emit(TimeSlotStatusesLoaded(statuses: statuses, selectedTime: null));
    } catch (e) {
      emit(ServiceLoadFailure(e.toString()));
    }
  }

  Future<void> _onLoadWorkerSlotStatuses(
    LoadWorkerSlotStatuses event,
    Emitter<ServiceState> emit,
  ) async {
    emit(ServiceLoading());
    try {
      final statuses = await _serviceRepository.getWorkerStatusesForSlot(
        service: event.service,
        selectedDate: event.selectedDate,
        selectedTimeSlot: event.selectedTime,
        serviceId: event.serviceId,
      );
      emit(WorkerSlotStatusesLoaded(workerStatuses:statuses));
    } catch (e) {
      emit(ServiceLoadFailure(e.toString()));
    }
  }

  Future<void> _onLoadSellerServices(
      LoadSellerServices event,
      Emitter<ServiceState> emit,
      ) async {
    emit(ServiceLoading());
    try {
      final services = await _serviceRepository.getServicesBySeller(event.sellerId);
      emit(ServiceSuccess(services: services, promoServices: [])); // atau pakai SellerServiceLoaded
    } catch (e) {
      emit(ServiceLoadFailure(e.toString()));
    }
  }

  Future<void> _onCreateSellerServices(
      CreateSellerServices event,
      Emitter<ServiceState> emit,
      ) async {
    emit(CreateSellerServicesInProgress());
    try {
      await _serviceRepository.createServiceWithImages(
        name: event.serviceModel.name,
        address: event.serviceModel.address,
        price: event.serviceModel.price,
        discount: event.serviceModel.discount,
        linkMaps: event.serviceModel.linkMaps,
        facilities: event.serviceModel.facilities,
        mainImage: event.mainImage,
        additionalPhotos: event.additionalPhotos,
        sellerId: event.sellerId,
        duration: event.serviceModel.serviceDurationMinutes,
        workerNames: event.serviceModel.workerNames,

      );

      emit(CreateSellerServicesSuccess());
    } catch (e) {
      emit(CreateSellerServicesFailure(e.toString()));
    }
  }



}
