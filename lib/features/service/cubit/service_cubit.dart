import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../model/service_model.dart';

part 'service_state.dart';

class ServiceCubit extends Cubit<ServiceState> {
  ServiceCubit() : super(ServiceState());

  void setSelectedDate(DateTime date) {
    emit(state.copyWith(selectedDate: date, focusedDate: date));
  }

  void setFocusedDate(DateTime date) {
    emit(state.copyWith(focusedDate: date));
  }

  void setSelectedTime(String time) {
    emit(state.copyWith(selectedTime: time));
  }

  void setSelectedWorker(String worker) {
    emit(state.copyWith(selectedWorker: worker, focusedWorker: worker));
  }

  void setFocusedWorker(String worker) {
    emit(state.copyWith(focusedWorker: worker));
  }

  void setPaymentMethod(String method) {
    emit(state.copyWith(paymentMethod: method));
  }

  void setSelectedService(String service) {
    emit(state.copyWith(selectedService: service));
  }

  void setPrice(int price) {
    emit(state.copyWith(price: price));
  }

  void setServiceModel(ServiceModel serviceModel) {
    emit(state.copyWith(serviceModel: serviceModel));
  }

  void reset() {
    emit(
      ServiceState(
        selectedDate: null,
        selectedTime: null,
        selectedWorker: null,
        paymentMethod: null,
        price: null,
        focusedDate: null,
        focusedWorker: null,
        selectedService: null,
        serviceModel: null,
      ),
    );
  }
}
