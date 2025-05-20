import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:servista/features/service/pages/service_booking_page.dart';

import '../../../../../core/theme/color_value.dart';
import '../../../cubit/service_cubit.dart';

Future<String?> showWorkerBottomSheet(
  BuildContext context,
  DateTime selectedDate,
  String selectedTime,
) {
  final List<String> worker = ["Pekerja 1", "Pekerja 2", "Pekerja 3"];
  final List<String> bookedWorker = ["Pekerja 1"];

  final dateFormatted = DateFormat(
    "EEEE, d MMMM yyyy",
    'id_ID',
  ).format(selectedDate);
  final header = "${toBeginningOfSentenceCase(dateFormatted)} | $selectedTime";

  return showModalBottomSheet<String>(
    backgroundColor: Colors.white,
    context: context,
    isScrollControlled: true,
    builder: (context) {
      final cubit = context.read<ServiceCubit>();

      return BlocBuilder<ServiceCubit, ServiceState>(
        builder: (context, state) {
          final selectedWorker = state.selectedWorker;
          final focusedWorker = state.focusedWorker;

          return Padding(
            padding: MediaQuery.of(context).viewInsets + EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  header,
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

                // Legend
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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

                // List pekerja
                Column(
                  children:
                      worker.map((item) {
                        final isBooked = bookedWorker.contains(item);
                        final isSelected = focusedWorker == item;

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

                        return Padding(
                          padding: EdgeInsets.only(bottom: 13.5.w),
                          child: GestureDetector(
                            onTap:
                                isBooked
                                    ? null
                                    : () {
                                      cubit.setFocusedWorker(item);
                                    },
                            child: Container(
                              width: double.infinity,
                              height: 40.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Text(
                                item,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                ),
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
                                      builder:
                                          (context) => ServiceBookingPage(),
                                    ),
                                  )
                                  : Navigator.pop(context);
                              cubit.setSelectedWorker(focusedWorker);
                            },
                    child: Text(
                      "Pilih Pekerja",
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
