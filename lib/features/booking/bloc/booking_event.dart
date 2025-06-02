part of 'booking_bloc.dart';

abstract class BookingEvent {}

class FetchBookings extends BookingEvent {
  final String userId;

  FetchBookings(this.userId);
}
