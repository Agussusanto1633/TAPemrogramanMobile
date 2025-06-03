import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../core/theme/color_value.dart';
import '../../../cubit/service_cubit.dart';

Future<DateTime?> showCalendarBottomSheet(BuildContext context) {
  return showModalBottomSheet<DateTime>(
    backgroundColor: Colors.white,
    context: context,
    isScrollControlled: true,
    builder: (context) {
      final cubit = context.read<ServiceCubit>();

      return BlocBuilder<ServiceCubit, ServiceState>(
        builder: (context, state) {
          final selectedDate = state.selectedDate ?? DateTime.now();
          final focusedDate = state.focusedDate ?? selectedDate;

          return Padding(
            padding: MediaQuery.of(context).viewInsets + EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header tanggal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        toBeginningOfSentenceCase(
                              DateFormat(
                                "MMMM yyyy",
                                'id_ID',
                              ).format(focusedDate),
                            ) ??
                            '',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          height: 2,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed:
                              focusedDate.isAfter(DateTime.now())
                                  ? () => cubit.setFocusedDate(
                                    DateTime(
                                      focusedDate.year,
                                      focusedDate.month - 1,
                                    ),
                                  )
                                  : null,
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed:
                              () => cubit.setFocusedDate(
                                DateTime(
                                  focusedDate.year,
                                  focusedDate.month + 1,
                                ),
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  "Pilih tanggal layanan",
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                    height: 2,
                  ),
                ),
                SizedBox(height: 16.w),

                // Kalender
                TableCalendar(
                  locale: 'id_ID',
                  firstDay: DateTime(2000),
                  lastDay: DateTime(2100),
                  focusedDay: focusedDate,
                  selectedDayPredicate: (day) => isSameDay(selectedDate, day),
                  enabledDayPredicate: (day) {
                    final today = DateTime.now();
                    final check = DateTime(day.year, day.month, day.day);
                    return !check.isBefore(
                      DateTime(today.year, today.month, today.day),
                    );
                  },
                  onDaySelected: (selectedDay, focusDay) {
                    final today = DateTime.now();
                    if (selectedDay.isBefore(
                      DateTime(today.year, today.month, today.day),
                    )) {
                      return;
                    }
                    cubit.setSelectedDate(selectedDay);
                    cubit.setFocusedDate(focusDay);
                  },
                  onPageChanged: (focusedDay) {
                    cubit.setFocusedDate(focusedDay);
                  },
                  headerVisible: false,
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: GoogleFonts.inter(
                      color: ColorValue.darkColor.withOpacity(0.5),
                    ),
                    weekendTextStyle: GoogleFonts.inter(
                      color: const Color(0xFFF36A6A),
                    ),
                    selectedDecoration: const BoxDecoration(),
                    todayDecoration: const BoxDecoration(),
                    disabledTextStyle: GoogleFonts.inter(
                      color: ColorValue.darkColor.withOpacity(0.2),
                    ),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      color: ColorValue.darkColor.withOpacity(0.5),
                      fontSize: 12.sp,
                    ),
                    weekendStyle: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFF36A6A),
                      fontSize: 12.sp,
                    ),
                  ),
                  calendarBuilders: CalendarBuilders(
                    selectedBuilder:
                        (context, date, _) => Container(
                          margin: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: ColorValue.primaryColor,
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${date.day}',
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    todayBuilder:
                        (context, date, _) => Container(
                          margin: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${date.day}',
                            style: GoogleFonts.inter(
                              color: ColorValue.darkColor.withOpacity(0.5),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                  ),
                ),

                SizedBox(height: 20.w),

                // Tombol Pilih
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context, selectedDate);
                      cubit.setSelectedDate(selectedDate);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: ColorValue.primaryColor,
                          borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        "Pilih Tanggal",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          color: ColorValue.darkColor,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.w),
              ],
            ),
          );
        },
      );
    },
  );
}
