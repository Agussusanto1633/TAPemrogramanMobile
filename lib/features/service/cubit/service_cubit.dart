import 'package:flutter_bloc/flutter_bloc.dart';

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

  void setSelectedWorker(worker) {
    emit(state.copyWith(selectedWorker: worker, focusedWorker: worker));
  }

  void setFocusedWorker(worker) {
    emit(state.copyWith(focusedWorker: worker));
  }

  void resetWorker() {
    emit(state.copyWith(clearSelectedWorker: true, clearFocusedWorker: true));
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
      state.copyWith(
        clearFocusedDate: true,
        clearSelectedTime: true,
        clearSelectedWorker: true,
        clearFocusedWorker: true,
      ),
    );
  }
}
