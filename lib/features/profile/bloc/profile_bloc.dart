import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:servista/features/profile/bloc/profile_event.dart';
import 'package:servista/features/profile/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    // Load profile
    on<LoadUserProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          emit(ProfileLoaded(user));
        } else {
          emit(ProfileError("User not logged in"));
        }
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<BecomeSeller>((event, emit) async {
      emit(ProfileLoading());
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({'isSeller': true});

          emit(ProfileUpdated());
        } else {
          emit(ProfileError("User not logged in"));
        }
      } catch (e) {
        emit(ProfileError("Gagal mendaftar sebagai seller: ${e.toString()}"));
      }
    });

    on<BecomeBuyer>((event, emit) async {
      emit(ProfileLoading());
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({'isSeller': false});

          emit(ProfileUpdated());
        } else {
          emit(ProfileError("User not logged in"));
        }
      } catch (e) {
        emit(ProfileError("Gagal kembali sebagai pembeli: ${e.toString()}"));
      }
    });
  }
}
