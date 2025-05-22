import 'package:equatable/equatable.dart';

abstract class ServiceEvent extends Equatable {
  const ServiceEvent();

  @override
  List<Object> get props => [];
}

class LoadAllServices extends ServiceEvent {}

class LoadServiceDetail extends ServiceEvent {
  final String serviceId;

  const LoadServiceDetail(this.serviceId);

  @override
  List<Object> get props => [serviceId];
}

class LoadPromoServices extends ServiceEvent {}
