import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/theme/color_value.dart';

class DetailBookingHeaderSection extends StatelessWidget {
  const DetailBookingHeaderSection({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Stack(
      children: [
        Container(
          color: const Color(0xff0F1828),
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(
                  bottom: 8.h,
                  top: 5.h,
                  right: 18.w,
                  left: 10.w,
                ),
                decoration: BoxDecoration(
                  color: ColorValue.primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50.r),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: SvgPicture.asset(
                        "assets/icons/arrow_back.svg",
                        color: Colors.white,
                        width: 24.w,
                        height: 24.h,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      "Detail Pemesanan",
                      style: textTheme.headlineLarge?.copyWith(
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.only(left: 23.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Layanan Potong Rumput",
                      style: textTheme.displayLarge!.copyWith(
                        color: Colors.white,
                        fontSize: 20.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Booking Code",
                      style: textTheme.displayLarge!.copyWith(
                        color: Colors.white,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width / 1.5,
                      child: Text(
                        bookingId,
                        style: textTheme.displayLarge!.copyWith(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 45.h),
            ],
          ),
        ),
        Positioned(
          bottom: -32.5.h,
          right: -32.5.w,
          child: Container(
            height: 75.h,
            width: 75.w,
            decoration: BoxDecoration(
              color: ColorValue.primaryColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
