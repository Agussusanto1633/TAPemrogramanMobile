import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:servista/core/theme/color_value.dart';
import 'package:servista/features/booking/widgets/detail_booking_card.dart';
import 'package:servista/features/booking/widgets/detail_booking_header_section.dart';
import 'package:servista/features/booking/widgets/detail_booking_overview_section.dart';
import 'package:servista/features/booking/widgets/detail_booking_service_details_section.dart';

class DetailBookingPage extends StatefulWidget {
  const DetailBookingPage({Key? key}) : super(key: key);

  @override
  State<DetailBookingPage> createState() => _DetailBookingPageState();
}

class _DetailBookingPageState extends State<DetailBookingPage> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              DetailBookingHeaderSection(),
              Container(
                padding: EdgeInsets.only(top: 23.h, left: 20.w, right: 23.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pekerja Telah menyelesaikan pesanan - Sabtu, 3 Januari 2025",
                      style: textTheme.displayLarge!.copyWith(
                        color: ColorValue.darkColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 13.h),
                    Text(
                      "Pekerjaan Potong Rumput",
                      style: textTheme.displayLarge!.copyWith(
                        color: Color(0xff777777),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 18.h),
                    Row(
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
                    SizedBox(height: 24.h),
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
                      "Pesananmu Sudah Dikerjakan!",
                      style: textTheme.displayLarge!.copyWith(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            _buildCircleProgress(),
                            Positioned(
                              left: -5.w,
                              bottom: -15.h,
                              child: Text("Booked"),
                            ),
                          ],
                        ),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            _buildCircleProgress(),
                            Positioned(
                              left: -16.w,
                              bottom: -15.h,
                              child: Text("On the way"),
                            ),
                          ],
                        ),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            _buildCircleProgress(),
                            Positioned(
                              left: -4.w,
                              bottom: -15.h,
                              child: Text("Started"),
                            ),
                          ],
                        ),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            _buildCircleProgress(isLast: true),
                            Positioned(
                              left: -15.w,
                              bottom: -15.h,
                              child: Text("Completed"),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 38.h),
                    Text(
                      "Kamu memesan jasa ini pada Jum’at 2 Januari 2025\nuntuk Sabtu 3 Januari 2025",
                      style: textTheme.displayLarge!.copyWith(
                        color: Colors.black,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // _buildCircleProgress("Booked")
                  ],
                ),
              ),
              DetailBookingCard(),
              Container(
                width: double.infinity,
                height: 6.h,
                color: const Color(0xffF3F3F3),
              ),
              DetailBookingServiceDetailsSection(),
              Gap(22.h),
              DetailBookingOverviewSection(),
              Gap(58.h),
            ],
          ),
        ),
      ),
    );
  }

  _buildCircleProgress({bool isLast = false}) {
    return Row(
      children: [
        Container(
          height: 30.h,
          width: 30.w,
          decoration: BoxDecoration(
            color: Color(0xff313131),
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
              width: 62.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: Color(0xffffffff),
                borderRadius: BorderRadius.circular(50.r),
              ),
            ),
      ],
    );
  }
}
