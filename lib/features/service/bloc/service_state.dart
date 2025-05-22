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

class ServiceLoadFailure extends ServiceState {
  final String message;

  const ServiceLoadFailure(this.message);

  @override
  List<Object> get props => [message];
}
