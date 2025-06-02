import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:servista/core/theme/color_value.dart';
import 'package:servista/features/booking/widgets/detail_booking_card.dart';
import 'package:servista/features/booking/widgets/detail_booking_header_section.dart';
import 'package:servista/features/booking/widgets/detail_booking_overview_section.dart';
import 'package:servista/features/booking/widgets/detail_booking_service_details_section.dart';

import '../../service/model/service_model.dart';
import '../model/booking_model.dart';

class DetailBookingPage extends StatefulWidget {
  const DetailBookingPage({
    super.key,
    required this.serviceModel,
    required this.bookingModel,
    required this.upcoming,
  });
  final ServiceModel serviceModel;
  final BookingModel bookingModel;

  final bool upcoming;

  @override
  State<DetailBookingPage> createState() => _DetailBookingPageState();
}

class _DetailBookingPageState extends State<DetailBookingPage> {
  late final String status;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    status = determineBookingStatus(
      widget.bookingModel.date,
      widget.bookingModel.startTime,
      widget.bookingModel.endTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              DetailBookingHeaderSection(bookingId: widget.bookingModel.id),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: 23.h,
                  left: 20.w,
                  right: 23.w,
                  bottom: 23.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.upcoming
                          ? "Kamu Memesan Layanan Ini Untuk : \n${formatToHariTanggal(widget.bookingModel.date)} "
                          : "Pekerja Telah menyelesaikan pesanan - ${formatToHariTanggal(widget.bookingModel.date)}",
                      style: textTheme.displayLarge!.copyWith(
                        color: ColorValue.darkColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 13.h),
                    Text(
                      widget.serviceModel.name,
                      style: textTheme.displayLarge!.copyWith(
                        color: Color(0xff777777),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: widget.upcoming ? 0 : 18.h),
                    widget.upcoming
                        ? SizedBox()
                        : Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 11.r,
                                horizontal: 17.r,
                              ),
                              decoration: BoxDecoration(
                                color: ColorValue.primaryColor,
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                              child: Text(
                                "Penilaian Servis",
                                style: textTheme.displayLarge!.copyWith(
                                  color: ColorValue.darkColor,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(width: 50.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 11.r,
                                horizontal: 17.r,
                              ),
                              decoration: BoxDecoration(
                                color: ColorValue.primaryColor,
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                              child: Text(
                                "Pesan Ulang",
                                style: textTheme.displayLarge!.copyWith(
                                  color: ColorValue.darkColor,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 6.h,
                color: const Color(0xffF3F3F3),
              ),
              Container(
                width: double.infinity,
                color: const Color(0xffADB5BD),
                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.upcoming
                          ? "Pesananmu Sudah Terjadwal!"
                          : "Pesananmu Sudah Dikerjakan!",
                      style: textTheme.displayLarge!.copyWith(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    _buildProgressIndicator(status),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "  Booked",
                          style: textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "On the way",
                          style: textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Started",
                          style: textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Completed",
                          style: textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 23.h),
                    Text(
                      "Kamu memesan jasa ini pada ${DateFormat("EEEE, d MMMM yyyy", "id_ID").format(DateTime.parse(widget.bookingModel.createdAt).toLocal())}\nuntuk ${formatToHariTanggal(widget.bookingModel.date)}",
                      style: textTheme.displayLarge!.copyWith(
                        color: Colors.black,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              DetailBookingCard(
                serviceModel: widget.serviceModel,
                worker: widget.bookingModel.workerId,
              ),
              Container(
                width: double.infinity,
                height: 6.h,
                color: const Color(0xffF3F3F3),
              ),
              DetailBookingServiceDetailsSection(
                serviceModel: widget.serviceModel,
                bookingModel: widget.bookingModel,
              ),
              Gap(22.h),
              DetailBookingOverviewSection(price: widget.serviceModel.price),
              Gap(58.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(String currentStatus) {
    final statusOrder = ["booked", "onworking", "started", "completed"];
    final currentIndex = statusOrder.indexOf(currentStatus);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(statusOrder.length, (index) {
        bool isActive = index <= currentIndex;
        bool isLast = index == statusOrder.length - 1;
        return Column(
          children: [
            isLast
                ? buildCircleProgress(isLast: true, isActive: isActive)
                : buildCircleProgress(isActive: isActive),
          ],
        );
      }),
    );
  }

  Widget buildCircleProgress({bool isLast = false, required bool isActive}) {
    return Row(
      children: [
        Container(
          height: 30.h,
          width: 30.w,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xff313131) : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Color(0xffffffff), width: 2.w),
          ),
          child: Center(
            child: SvgPicture.asset(
              "assets/icons/check_fat.svg",
              color: Colors.white,
              width: 15.w,
              height: 15.h,
            ),
          ),
        ),
        isLast
            ? SizedBox()
            : Container(
              width: 57.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: isActive ? const Color(0xff313131) : Colors.white,
                borderRadius: BorderRadius.circular(50.r),
              ),
            ),
      ],
    );
  }
}

String formatToHariTanggal(String date) {
  final parsed = DateTime.parse(date);
  return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(parsed);
}

String determineBookingStatus(String date, String startTime, String endTime) {
  final now = DateTime.now();

  // Format: date = "2025-06-10", time = "09:00"
  DateTime startDateTime = DateTime.parse(
    '$date ${startTime.padLeft(5, '0')}:00',
  );
  DateTime endDateTime = DateTime.parse('$date ${endTime.padLeft(5, '0')}:00');

  if (now.isBefore(startDateTime)) {
    return "booked";
  } else if (now.isAfter(endDateTime)) {
    return "completed";
  } else {
    return "onworking";
  }
}
