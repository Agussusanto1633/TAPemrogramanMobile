import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// Sesuaikan path import ini dengan struktur proyekmu
import 'package:servista/features/service/model/service_model.dart';
import 'package:servista/core/theme/color_value.dart'; // Jika kamu punya file ini
import 'package:servista/features/service/repositories/service_repository.dart';
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
  final Function(String?) onWorkerConfirmed; // Callback saat tombol "Pilih Pekerja" ditekan

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

class __TimeSelectionInteractiveAreaState extends State<_TimeSelectionInteractiveArea> {
  String? _locallySelectedWorker; // State yang akan persisten untuk pekerja yang dipilih

  // Fungsi _buildLegendBox dipindahkan ke sini agar ter-scope dengan baik
  Widget _buildLegendBox(String label, Color bg, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
      decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: Colors.grey.shade300, width: 0.5)),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10.sp,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding( // Handle drag bottom sheet
          padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
          child: Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
        ),
        Text(
          widget.headerText,
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: ColorValue.darkColor,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 4.h, bottom: 8.h),
          child: Text(
            "Pilih pekerja",
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: ColorValue.darkColor.withOpacity(0.8),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildLegendBox("Available", ColorValue.grayColor.withOpacity(0.2), ColorValue.darkColor),
              SizedBox(width: 8.w),
              _buildLegendBox("Booked", ColorValue.dark2Color, Colors.white),
              SizedBox(width: 8.w),
              _buildLegendBox("Selected", ColorValue.primaryColor, Colors.white),
            ],
          ),
        ),
        SizedBox(height: 22.w),

        if (widget.workerNames.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Center(child: Text("Tidak ada pekerja yang terdaftar.", style: GoogleFonts.inter(fontSize: 13.sp))),
          )
        else
          Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.workerNames.map((workerName) {
              final String status = widget.workerStatusesData[workerName] ?? "Available";
              final bool isBooked = status == "Booked";
              final bool isError = status == "Error";
              final bool isSelected = _locallySelectedWorker == workerName;

              Color bgColor;
              Color textColor;
              Border border = Border.all(color: Colors.grey.shade300, width: 1);

              if (isError) {
                bgColor = Colors.orange.shade50;
                textColor = Colors.orange.shade700;
                border = Border.all(color: Colors.orange.shade300, width: 1);
              } else if (isSelected) {
                bgColor = ColorValue.primaryColor;
                textColor = Colors.white;
                border = Border.all(color: ColorValue.primaryColor, width: 1.5);
              } else if (isBooked) {
                bgColor = ColorValue.dark2Color.withOpacity(0.8);
                textColor = Colors.white.withOpacity(0.7);
                border = Border.all(color: ColorValue.dark2Color, width: 1);
              } else { // Available
                bgColor = Colors.white;
                textColor = ColorValue.darkColor;
              }

              return Padding(
                padding: EdgeInsets.only(bottom: 12.w),
                child: GestureDetector(
                  onTap: (isBooked || isError)
                      ? null
                      : () {
                    setState(() {
                      _locallySelectedWorker = workerName;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(8.r),
                      border: border,
                      boxShadow: (isSelected || (!isBooked && !isError)) ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        )
                      ] : [],
                    ),
                    child: Text(
                      workerName,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        SizedBox(height: 22.w),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              backgroundColor: _locallySelectedWorker == null
                  ? Colors.grey.shade400
                  : ColorValue.primaryColor,
              disabledBackgroundColor: Colors.grey.shade400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              elevation: _locallySelectedWorker == null ? 0 : 2,
            ),
            onPressed: _locallySelectedWorker == null
                ? null
                : () {
              widget.onWorkerConfirmed(_locallySelectedWorker);
            },
            child: Text(
              "Pilih Pekerja & Lanjut",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
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
  final String headerText = "${toBeginningOfSentenceCase(dateFormatted)} | $selectedTimeSlot";

  // Buat instance ServiceRepository.
  // Jika kamu menggunakan dependency injection, dapatkan dari sana.
  final ServiceRepository serviceRepository = ServiceRepository();

  // Future ini dibuat sekali saat fungsi showWorkerBottomSheet dipanggil.
  final Future<Map<String, String>> workerStatusesFuture =
  serviceRepository.getWorkerStatusesForSlot(
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
    builder: (modalContext) { // modalContext digunakan untuk Navigator.pop
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
                    Text("Gagal memuat data pekerja.", textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 14.sp)),
                    SizedBox(height: 8.h),
                    Text("${snapshot.error}", textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.redAccent)),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(modalContext); // Tutup saja, retry dihandle oleh pemanggil jika perlu
                      },
                      child: const Text("Tutup"),
                    )
                  ],
                ),
              ),
            );
          } else if (snapshot.hasData) {
            final Map<String, String> currentWorkerStatuses = snapshot.data!;

            mainContent = _TimeSelectionInteractiveArea(
              workerNames: workerNamesFromModel, // Nama field diubah agar lebih sesuai
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
                child: const Text("Tidak ada data atau status tidak diketahui."),
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(fbContext).viewInsets.bottom > 0
                  ? MediaQuery.of(fbContext).viewInsets.bottom
                  : 16.h, // Padding bawah default
              left: 16.w,
              right: 16.w,
              top: 0, // Padding atas untuk handle drag sudah di dalam _TimeSelectionInteractiveArea
            ),
            child: SingleChildScrollView(child: mainContent),
          );
        },
      );
    },
  );
}