import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:servista/features/service/model/service_model.dart'; // Sesuaikan path
import 'package:servista/core/theme/color_value.dart'; // Sesuaikan path
import 'package:servista/features/service/repositories/service_repository.dart'; // Sesuaikan path

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
  final List<String> times = serviceModel.availableTimeSlots; // Ini masih dibutuhkan oleh _TimeSelectionInteractiveArea
  final String serviceId = serviceModel.id;

  final dateFormatted = DateFormat(
    "EEEE, d MMMM yy",
    'id_ID',
  ).format(selectedDate);

  final ServiceRepository serviceRepository = ServiceRepository();

  final Future<Map<String, String>> statusesFuture = serviceRepository.getTimeSlotStatuses(
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
    builder: (modalContext) { // modalContext digunakan untuk Navigator.pop
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
                    Text("Gagal memuat slot waktu.", textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 14.sp)),
                    SizedBox(height: 8.h),
                    Text("${snapshot.error}", textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.redAccent)),
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
                    )
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
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(fbContext).viewInsets.bottom > 0
                  ? MediaQuery.of(fbContext).viewInsets.bottom
                  : 16.h,
              left: 16.w,
              right: 16.w,
              top: 0,
            ),
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
Widget _buildLegendBox(String label, Color bg, Color textColor) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
    decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: Colors.grey.shade300, width: 0.5)
    ),
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
class _TimeSelectionInteractiveArea extends StatefulWidget {
  final List<String> times;
  final Map<String, String> slotStatusesData;
  final String dateFormatted;
  // final Function(String) onTimeSelected; // Jika hanya ingin callback saat tap
  final Function(String?) onTimeConfirmed; // Callback saat tombol "Pilih Waktu" ditekan

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

class __TimeSelectionInteractiveAreaState extends State<_TimeSelectionInteractiveArea> {
  String? _locallySelectedTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
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
          toBeginningOfSentenceCase(widget.dateFormatted) ?? '',
          style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: ColorValue.darkColor),
        ),
        Padding(
          padding: EdgeInsets.only(top: 4.h, bottom: 8.h),
          child: Text(
            "Pilih waktu layanan",
            style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: ColorValue.darkColor.withOpacity(0.8)),
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
        SizedBox(height: 16.w),

        // Grid Waktu
        if (widget.times.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Center(child: Text("Tidak ada slot waktu yang dijadwalkan.", style: GoogleFonts.inter(fontSize: 13.sp))),
          )
        else
          Wrap(
            spacing: 12.w,
            runSpacing: 12.w,
            children: widget.times.map((time) {
              // Akses slotStatusesData dari widget props
              final String slotStatus = widget.slotStatusesData[time] ?? "Available";
              final bool isBooked = slotStatus == "Booked";
              final bool isError = slotStatus == "Error";
              // Gunakan _locallySelectedTime dari state
              final bool isSelected = _locallySelectedTime == time;

              Color bgColor;
              Color textColor;
              String displayText = time;
              Border border = Border.all(color: Colors.grey.shade300, width: 1);

              if (isError) {
                bgColor = Colors.orange.shade50;
                textColor = Colors.orange.shade700;
                displayText = "N/A";
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

              return GestureDetector(
                onTap: (isBooked || isError)
                    ? null
                    : () {
                  setState(() { // Menggunakan setState dari StatefulWidget
                    _locallySelectedTime = time;
                  });
                  // widget.onTimeSelected(time); // Panggil callback jika ada aksi langsung saat tap
                },
                child: Container(
                  width: 72.w,
                  height: 40.w,
                  alignment: Alignment.center,
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
                    displayText,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 13.sp,
                        color: textColor),
                  ),
                ),
              );
            }).toList(),
          ),
        SizedBox(height: 24.w),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              backgroundColor: _locallySelectedTime == null
                  ? Colors.grey.shade400
                  : ColorValue.primaryColor,
              disabledBackgroundColor: Colors.grey.shade400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              elevation: _locallySelectedTime == null ? 0 : 2,
            ),
            onPressed: _locallySelectedTime == null
                ? null
                : () {
              widget.onTimeConfirmed(_locallySelectedTime); // Panggil callback pop
            },
            child: Text(
              "Pilih Waktu",
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  // Pindahkan _buildLegendBox ke sini atau biarkan global jika dipakai di tempat lain
  Widget _buildLegendBox(String label, Color bg, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
      decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: Colors.grey.shade300, width: 0.5)
      ),
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
}