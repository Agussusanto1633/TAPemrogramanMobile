part of 'booking_bloc.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingLoaded extends BookingState {
  final List<BookingModel> upcoming;
  final List<BookingModel> past;

  BookingLoaded({required this.upcoming, required this.past});
}

class BookingError extends BookingState {
  final String message;

  BookingError(this.message);
}
