import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:servista/core/theme/color_value.dart';
import 'package:servista/features/booking/bloc/booking_bloc.dart';
import 'package:servista/features/service/bloc/service_bloc.dart';
import 'package:servista/features/booking/widgets/booking_list.dart';
import 'package:intl/intl.dart';

import '../../service/bloc/service_state.dart';
import '../../service/model/service_model.dart';

class BookingTabBarBody extends StatelessWidget {
  const BookingTabBarBody({super.key, this.upcoming = true});

  final bool upcoming;

  @override
  Widget build(BuildContext context) {
    final serviceState = context.watch<ServiceBloc>().state;

    return Scaffold(
      backgroundColor: ColorValue.bgFrameColor,
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state is BookingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BookingLoaded) {
            if (state.upcoming.isEmpty || state.upcoming.isEmpty) {
              return Center(child: Text("Belum ada pemesanan."));
            }

            if (serviceState is! ServiceSuccess) {
              return Center(child: Text("Layanan belum tersedia."));
            }

            return ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              itemCount: upcoming ? state.upcoming.length : state.past.length,
              separatorBuilder: (_, __) => Gap(16.h),
              itemBuilder: (context, index) {
                final booking =
                    upcoming ? state.upcoming[index] : state.past[index];
                final service =
                    serviceState.services
                        .where((s) => s.id == booking.serviceId)
                        .cast<ServiceModel?>()
                        .firstOrNull;
                if (service == null) {
                  return BookingList(
                    serviceModel: service,
                    bookingModel: booking,
                    upcoming: upcoming,
                  );
                }
                return BookingList(
                  upcoming: upcoming,
                  serviceModel: service,
                  bookingModel: booking,
                );
              },
            );
          } else if (state is BookingError) {
            return Center(child: Text("Terjadi kesalahan: ${state.message}"));
          }
          return const Center(child: Text("Tidak ada data."));
        },
      ),
    );
  }
}
