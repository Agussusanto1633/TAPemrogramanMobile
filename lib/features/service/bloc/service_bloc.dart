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

}
