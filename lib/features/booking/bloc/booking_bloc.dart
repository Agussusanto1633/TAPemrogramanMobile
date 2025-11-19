import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/booking_model.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final FirebaseFirestore firestore;

  BookingBloc({required this.firestore}) : super(BookingInitial()) {
    on<FetchBookings>(_onFetchBookings);
  }

  Future<void> _onFetchBookings(
    FetchBookings event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    try {
      final now = DateTime.now();

      final snapshot =
          await firestore
              .collection('bookings')
              .where('userId', isEqualTo: event.userId)
              .get();

      final allBookings =
          snapshot.docs.map((doc) {
            return BookingModel.fromFirestore(doc.id, doc.data());
          }).toList();

      final upcoming =
          allBookings.where((b) => b.bookingDateTime.isAfter(now)).toList();
      final past =
          allBookings.where((b) => b.bookingDateTime.isBefore(now)).toList();

      emit(BookingLoaded(upcoming: upcoming, past: past));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }
}
