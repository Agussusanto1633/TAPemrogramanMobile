import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// Sesuaikan path import ini dengan struktur proyekmu
import 'package:servista/features/service/model/service_model.dart';
import 'package:servista/core/theme/color_value.dart'; // Jika kamu punya file ini
import 'package:servista/features/service/repositories/service_repository.dart';

import '../../../cubit/service_cubit.dart';
import '../../../pages/service_booking_page.dart';
// import 'package:servista/features/service/pages/service_booking_page.dart'; // Uncomment jika ServiceBookingPage sudah ada

// ---------------------------------------------------------------------------
// CONTOH DEFINISI ColorValue (jika belum ada di core/theme/color_value.dart)
// Hapus atau sesuaikan jika kamu sudah punya definisi sendiri.
// ---------------------------------------------------------------------------
// class ColorValue {
//   static const Color primaryColor = Color(0xFF5E72E4); // Contoh Warna Primer
//   static const Color grayColor = Color(0xFFF0F2F5);   // Contoh Warna Abu-abu
//   static const Color dark2Color = Color(0xFF32325D);  // Contoh Warna Gelap
//   static const Color darkColor = Color(0xFF212529);    // Contoh Warna Teks Gelap
// }
// ---------------------------------------------------------------------------

// Helper StatefulWidget untuk mengelola pemilihan pekerja lokal
class _TimeSelectionInteractiveArea extends StatefulWidget {
  final List<String> workerNames; // Daftar nama pekerja
  final Map<String, String> workerStatusesData; // Status untuk setiap pekerja
  final String headerText; // Teks header (Tanggal | Waktu)
  final Function(String?)
  onWorkerConfirmed; // Callback saat tombol "Pilih Pekerja" ditekan

  const _TimeSelectionInteractiveArea({
    Key? key,
    required this.workerNames,
    required this.workerStatusesData,
    required this.headerText,
    required this.onWorkerConfirmed,
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
        final focusedWorker = state.focusedWorker;
        final selectedWorker = state.selectedWorker;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.headerText,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                height: 2,
              ),
            ),
            Text(
              "Pilih pekerja",
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                height: 2,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 5.w),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
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

            if (widget.workerNames.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Center(
                  child: Text(
                    "Tidak ada pekerja yang terdaftar.",
                    style: GoogleFonts.inter(fontSize: 13.sp),
                  ),
                ),
              )
            else
              Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    widget.workerNames.map((workerName) {
                      final String status =
                          widget.workerStatusesData[workerName] ?? "Available";
                      final bool isBooked = status == "Booked";
                      final bool isError = status == "Error";
                      final isSelected = focusedWorker == workerName;

                      Color bgColor;
                      Color textColor;
                      Border border = Border.all(
                        color: Colors.grey.shade300,
                        width: 1,
                      );

                      if (isError) {
                        bgColor = Colors.orange.shade50;
                        textColor = Colors.orange.shade700;
                        border = Border.all(
                          color: Colors.orange.shade300,
                          width: 1,
                        );
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

                      return Padding(
                        padding: EdgeInsets.only(bottom: 13.5.w),
                        child: GestureDetector(
                          onTap:
                              (isBooked || isError)
                                  ? null
                                  : () {
                                    cubit.setFocusedWorker(workerName);
                                  },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 10.w,
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                workerName,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                  height: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            SizedBox(height: 20.w),

            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(110.w, 34.w),
                  backgroundColor:
                      focusedWorker == null
                          ? ColorValue.grayColor
                          : ColorValue.primaryColor,
                  disabledBackgroundColor: ColorValue.grayColor,
                ),
                onPressed:
                    focusedWorker == null
                        ? null
                        : () {
                          selectedWorker == null
                              ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ServiceBookingPage(),
                                ),
                              )
                              : Navigator.pop(context);
                          cubit.setSelectedWorker(focusedWorker);
                        },
                child: Text(
                  "Hire",
                  style: GoogleFonts.mulish(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color:
                        focusedWorker == null
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
}

// Fungsi utama untuk menampilkan bottom sheet
Future<String?> showWorkerBottomSheet(
  BuildContext context,
  DateTime selectedDate,
  String selectedTimeSlot,
  ServiceModel serviceModel,
) {
  final List<String> workerNamesFromModel = serviceModel.workerNames;
  // Pastikan ServiceModel memiliki field 'id' yang valid
  final String serviceId = serviceModel.id;

  final dateFormatted = DateFormat(
    "EEEE, d MMMM yy",
    'id_ID',
  ).format(selectedDate);
  final String headerText =
      "${toBeginningOfSentenceCase(dateFormatted)} | $selectedTimeSlot";

  // Buat instance ServiceRepository.
  // Jika kamu menggunakan dependency injection, dapatkan dari sana.
  final ServiceRepository serviceRepository = ServiceRepository();

  // Future ini dibuat sekali saat fungsi showWorkerBottomSheet dipanggil.
  final Future<Map<String, String>> workerStatusesFuture = serviceRepository
      .getWorkerStatusesForSlot(
        serviceId: serviceId,
        selectedDate: selectedDate,
        selectedTimeSlot: selectedTimeSlot,
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
      // modalContext digunakan untuk Navigator.pop
      return FutureBuilder<Map<String, String>>(
        future: workerStatusesFuture,
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
                      "Gagal memuat data pekerja.",
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
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(
                          modalContext,
                        ); // Tutup saja, retry dihandle oleh pemanggil jika perlu
                      },
                      child: const Text("Tutup"),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasData) {
            final Map<String, String> currentWorkerStatuses = snapshot.data!;

            mainContent = _TimeSelectionInteractiveArea(
              workerNames:
                  workerNamesFromModel, // Nama field diubah agar lebih sesuai
              workerStatusesData: currentWorkerStatuses,
              headerText: headerText,
              onWorkerConfirmed: (String? selectedWorkerFromChild) {
                Navigator.pop(modalContext, selectedWorkerFromChild);
              },
            );
          } else {
            mainContent = Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 60.h, horizontal: 24.w),
                child: const Text(
                  "Tidak ada data atau status tidak diketahui.",
                ),
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

// Fungsi _buildLegendBox dipindahkan ke sini agar ter-scope dengan baik
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
