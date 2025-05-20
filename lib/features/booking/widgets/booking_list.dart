import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servista/core/nav/nav.dart';
import 'package:servista/core/theme/color_value.dart';
import 'package:servista/features/booking/page/detail_booking_page.dart';

class BookingList extends StatelessWidget {
  //title
  final String title;
  final String date;
  final String hour;

  const BookingList({
    Key? key,
    required this.title,
    required this.date,
    required this.hour,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 7.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: ColorValue.darkColor,
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              "Servista",
              style: GoogleFonts.mulish(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Gap(5.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.5.h),
              decoration: BoxDecoration(color: ColorValue.primaryColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "assets/icons/potong_rumput.png",
                    width: 43.w,
                    height: 48.h,
                  ),
                  SizedBox(width: 8.w), // Jarak antar item

                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.mulish(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorValue.darkColor,
                          ),
                        ),
                        Text(
                          date,
                          style: GoogleFonts.mulish(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: ColorValue.darkColor,
                          ),
                        ),
                        Text(
                          hour,
                          style: GoogleFonts.mulish(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: ColorValue.darkColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 8.w), // Jarak antar item

                  Container(
                    padding: EdgeInsets.all(10.h),
                    decoration: BoxDecoration(
                      color: ColorValue.darkColor,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Text(
                      "Chat Worker",
                      style: GoogleFonts.mulish(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Nav.to(context, DetailBookingPage());
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.r),
                    bottomRight: Radius.circular(10.r),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 10.h,
                ),
                child: Center(
                  child: Text("Lihat Detail", style:
                  GoogleFonts.mulish(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: ColorValue.blueLinkColor,
                  ),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
