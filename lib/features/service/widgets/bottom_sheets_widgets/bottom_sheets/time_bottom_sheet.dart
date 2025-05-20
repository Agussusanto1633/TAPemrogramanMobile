import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/color_value.dart';
import '../../../cubit/service_cubit.dart';

Future<String?> showTimeBottomSheet(
  BuildContext context,
  DateTime selectedDate,
) {
  final List<String> times = [
    "10.00",
    "11.00",
    "12.00",
    "13.00",
    "14.00",
    "15.00",
    "16.00",
    "17.00",
    "18.00",
    "19.00",
    "20.00",
    "21.00",
  ];

  final List<String> bookedTimes = ["11.00", "15.00", "20.00"];

  final dateFormatted = DateFormat(
    "EEEE, d MMMM yyyy",
    'id_ID',
  ).format(selectedDate);

  return showModalBottomSheet<String>(
    backgroundColor: Colors.white,
    context: context,
    isScrollControlled: true,
    builder: (context) {
      final cubit = context.read<ServiceCubit>();

      return BlocBuilder<ServiceCubit, ServiceState>(
        builder: (context, state) {
          final selectedTime = state.selectedTime;

          return Padding(
            padding: MediaQuery.of(context).viewInsets + EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tanggal Header
                Text(
                  toBeginningOfSentenceCase(dateFormatted) ?? '',
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
                SizedBox(height: 5.w),

                // Legend
                Row(
                  children: [
                    _buildLegendBox(
                      "Available",
                      ColorValue.grayColor,
                      Colors.black,
                    ),
                    SizedBox(width: 5.w),
                    _buildLegendBox(
                      "Booked",
                      ColorValue.dark2Color,
                      Colors.white,
                    ),
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
                Wrap(
                  spacing: 16.w,
                  runSpacing: 16.w,
                  children:
                      times.map((time) {
                        final isBooked = bookedTimes.contains(time);
                        final isSelected = selectedTime == time;

                        Color bgColor;
                        Color textColor;

                        if (isSelected) {
                          bgColor = ColorValue.primaryColor;
                          textColor = Colors.black;
                        } else if (isBooked) {
                          bgColor = ColorValue.dark2Color;
                          textColor = Colors.white;
                        } else {
                          bgColor = ColorValue.grayColor;
                          textColor = Colors.black;
                        }

                        return GestureDetector(
                          onTap:
                              isBooked
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

                // Tombol Pilih
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
                              cubit.setSelectedTime(state.selectedTime!);
                              Navigator.pop(context, selectedTime);

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
            ),
          );
        },
      );
    },
  );
}

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
