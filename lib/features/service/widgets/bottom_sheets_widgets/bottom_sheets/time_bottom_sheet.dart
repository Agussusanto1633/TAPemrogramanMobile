import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:servista/features/service/model/service_model.dart'; // Sesuaikan path
import 'package:servista/core/theme/color_value.dart'; // Sesuaikan path
import 'package:servista/features/service/repositories/service_repository.dart';

import '../../../cubit/service_cubit.dart'; // Sesuaikan path

// Asumsi ServiceModel punya field 'id'
// class ServiceModel {
//   final String id;
//   final List<String> availableTimeSlots;
//   final List<String> workerNames;
//   // ... properti lainnya
//   ServiceModel({required this.id, required this.availableTimeSlots, required this.workerNames, /* ... */});
// }

// Contoh definisi ColorValue jika belum ada di file ini
// class ColorValue {
//   static const Color primaryColor = Colors.blue;
//   static const Color grayColor = Colors.grey;
//   static const Color dark2Color = Colors.black54;
//   static const Color darkColor = Colors.black;
// }

Future<String?> showTimeBottomSheet(
  BuildContext context,
  DateTime selectedDate,
  ServiceModel serviceModel,
) {
  final List<String> times =
      serviceModel
          .availableTimeSlots; // Ini masih dibutuhkan oleh _TimeSelectionInteractiveArea
  final String serviceId = serviceModel.id;

  final dateFormatted = DateFormat(
    "EEEE, d MMMM yyyy",
    'id_ID',
  ).format(selectedDate);

  final ServiceRepository serviceRepository = ServiceRepository();

  final Future<Map<String, String>> statusesFuture = serviceRepository
      .getTimeSlotStatuses(
        serviceId: serviceId,
        selectedDate: selectedDate,
        service: serviceModel,
      );

  return showModalBottomSheet<String>(
    backgroundColor: Colors.white,
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (modalContext) {
      final cubit = context.read<ServiceCubit>();

      // modalContext digunakan untuk Navigator.pop
      return FutureBuilder<Map<String, String>>(
        future: statusesFuture,
        builder: (fbContext, snapshot) {
          Widget mainContent;

          if (snapshot.connectionState == ConnectionState.waiting) {
            mainContent = Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 60.h, horizontal: 24.w),
                child: const CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            mainContent = Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 60.h, horizontal: 24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Gagal memuat slot waktu.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(fontSize: 14.sp),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "${snapshot.error}",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: Colors.redAccent,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Pertimbangkan menambahkan tombol retry yang memanggil ulang pemanggilan showTimeBottomSheet
                    // atau menggunakan mekanisme state management yang lebih canggih untuk retry.
                    ElevatedButton(
                      onPressed: () {
                        // Cara sederhana untuk retry: tutup dan buka lagi,
                        // atau jika ada provider, trigger refresh.
                        // Untuk saat ini, tombol ini hanya contoh.
                        Navigator.pop(modalContext); // Tutup dulu
                        // Mungkin panggil showTimeBottomSheet lagi dari parent
                        // dengan memanggil ulang method yang menampilkannya.
                        // Ini di luar scope modifikasi langsung di sini.
                      },
                      child: const Text("Tutup & Coba Lagi Manual"),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasData) {
            final Map<String, String> slotStatusesData = snapshot.data!;

            mainContent = _TimeSelectionInteractiveArea(
              times: times, // Dari ServiceModel
              slotStatusesData: slotStatusesData, // Dari FutureBuilder
              dateFormatted: dateFormatted,
              onTimeConfirmed: (String? selectedTimeFromChild) {
                Navigator.pop(modalContext, selectedTimeFromChild);
              },
            );
          } else {
            mainContent = Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 60.h, horizontal: 24.w),
                child: const Text("Tidak ada data slot waktu."),
              ),
            );
          }

          return Padding(
            padding: MediaQuery.of(context).viewInsets + EdgeInsets.all(24.w),
            child: SingleChildScrollView(child: mainContent),
          );
        },
      );
    },
  );
}

// _buildLegendBox bisa tetap global jika tidak dimasukkan ke dalam state class
// atau kamu bisa membuatnya menjadi static method di dalam _TimeSelectionInteractiveAreaState
// atau helper function biasa.

class _TimeSelectionInteractiveArea extends StatefulWidget {
  final List<String> times;
  final Map<String, String> slotStatusesData;
  final String dateFormatted;
  // final Function(String) onTimeSelected; // Jika hanya ingin callback saat tap
  final Function(String?)
  onTimeConfirmed; // Callback saat tombol "Pilih Waktu" ditekan

  const _TimeSelectionInteractiveArea({
    Key? key,
    required this.times,
    required this.slotStatusesData,
    required this.dateFormatted,
    // required this.onTimeSelected,
    required this.onTimeConfirmed,
  }) : super(key: key);

  @override
  __TimeSelectionInteractiveAreaState createState() =>
      __TimeSelectionInteractiveAreaState();
}

class __TimeSelectionInteractiveAreaState
    extends State<_TimeSelectionInteractiveArea> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ServiceCubit>();

    return BlocBuilder<ServiceCubit, ServiceState>(
      builder: (context, state) {
        final selectedTime = state.selectedTime;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              toBeginningOfSentenceCase(widget.dateFormatted) ?? '',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                height: 2,
              ),
            ),
            Text(
              "Pilih waktu layanan",
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                height: 2,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 10.w),

            Row(
              children: [
                _buildLegendBox(
                  "Available",
                  ColorValue.grayColor,
                  Colors.black,
                ),
                SizedBox(width: 5.w),
                _buildLegendBox("Booked", ColorValue.dark2Color, Colors.white),
                SizedBox(width: 5.w),
                _buildLegendBox(
                  "Selected",
                  ColorValue.primaryColor,
                  Colors.black,
                ),
              ],
            ),
            SizedBox(height: 22.w),

            // Grid Waktu
            if (widget.times.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Center(
                  child: Text(
                    "Tidak ada slot waktu yang dijadwalkan.",
                    style: GoogleFonts.inter(fontSize: 13.sp),
                  ),
                ),
              )
            else
              Wrap(
                spacing: 16.w,
                runSpacing: 16.w,
                children:
                    widget.times.map((time) {
                      // Akses slotStatusesData dari widget props
                      final String slotStatus =
                          widget.slotStatusesData[time] ?? "Available";
                      final bool isBooked = slotStatus == "Booked";
                      final bool isError = slotStatus == "Error";
                      // Gunakan _locallySelectedTime dari state
                      final bool isSelected = selectedTime == time;

                      Color bgColor;
                      Color textColor;
                      String displayText = time;

                      if (isError) {
                        bgColor = Colors.orange.shade50;
                        textColor = Colors.orange.shade700;
                        displayText = "N/A";
                        // border = Border.all(
                        //   color: Colors.orange.shade300,
                        //   width: 1,
                        // );
                      } else if (isSelected) {
                        bgColor = ColorValue.primaryColor;
                        textColor = Colors.black;
                      } else if (isBooked) {
                        bgColor = ColorValue.dark2Color;
                        textColor = Colors.white;
                      } else {
                        // Available
                        bgColor = ColorValue.grayColor;
                        textColor = Colors.black;
                      }

                      return GestureDetector(
                        onTap:
                            (isBooked || isError)
                                ? null
                                : () {
                                  cubit.setSelectedTime(time);
                                },
                        child: Container(
                          width: 64.w,
                          height: 40.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: Text(
                            time,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              color: textColor,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            SizedBox(height: 22.w),

            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(110.w, 34.w),

                  backgroundColor:
                      selectedTime == null
                          ? ColorValue.grayColor
                          : ColorValue.primaryColor,
                  disabledBackgroundColor: ColorValue.grayColor,
                ),
                onPressed:
                    selectedTime == null
                        ? null
                        : () {
                          widget.onTimeConfirmed(
                            selectedTime,
                          ); // Panggil callback pop
                          cubit.setSelectedTime(state.selectedTime!);
                        },
                child: Text(
                  "Pilih Waktu",
                  style: GoogleFonts.mulish(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color:
                        selectedTime == null
                            ? ColorValue.darkColor.withOpacity(0.5)
                            : ColorValue.darkColor,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Pindahkan _buildLegendBox ke sini atau biarkan global jika dipakai di tempat lain

  Widget _buildLegendBox(String label, Color bg, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.w),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10.sp,
          color: textColor,
          height: 2,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
