import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:servista/features/service/model/service_model.dart';

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

class LoadTimeSlotStatuses extends ServiceEvent {
  final String serviceId;
  final DateTime selectedDate;
  final ServiceModel service;

  const LoadTimeSlotStatuses({
    required this.serviceId,
    required this.selectedDate,
    required this.service,
  });

  @override
  List<Object> get props => [serviceId, selectedDate, service];
}

class LoadWorkerSlotStatuses extends ServiceEvent {
  final String serviceId;
  final DateTime selectedDate;
  final ServiceModel service;
  final String selectedTime;

  const LoadWorkerSlotStatuses({
    required this.serviceId,
    required this.selectedDate,
    required this.service,
    required this.selectedTime,
  });
}

class LoadSellerServices extends ServiceEvent {
  final String sellerId;

  const LoadSellerServices({required this.sellerId});
}

class CreateSellerServices extends ServiceEvent {
  final ServiceModel serviceModel;
  final String sellerId;
  final File mainImage;
  final List<File> additionalPhotos;

  const CreateSellerServices({
    required this.serviceModel,
    required this.sellerId,
    required this.mainImage,
    required this.additionalPhotos,
  });

  @override
  List<Object> get props => [
    serviceModel,
    sellerId,
    mainImage,
    additionalPhotos,
  ];
}

class DeleteService extends ServiceEvent {
  final String serviceId;
  final String sellerId;

  const DeleteService({required this.serviceId, required this.sellerId});
}
