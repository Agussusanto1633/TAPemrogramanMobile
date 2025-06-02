import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:servista/features/booking/model/booking_model.dart';
import 'package:servista/features/service/model/service_model.dart';

class DetailBookingServiceDetailsSection extends StatefulWidget {
  const DetailBookingServiceDetailsSection({
    super.key,
    required this.serviceModel,
    required this.bookingModel,
  });

  final ServiceModel serviceModel;
  final BookingModel bookingModel;

  @override
  State<DetailBookingServiceDetailsSection> createState() =>
      _DetailBookingServiceDetailsSectionState();
}

class _DetailBookingServiceDetailsSectionState
    extends State<DetailBookingServiceDetailsSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Service Details",
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Color(0xffE5E5E5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      height: 30.h,
                      width: 30.w,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: Image.network(
                        widget.serviceModel.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      widget.serviceModel.name,
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SvgPicture.asset(
                      "assets/icons/arrow_up.svg",
                      width: 18.w,
                      height: 18.h,
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                Divider(color: Color(0xffE5E5E5), thickness: 1),
                Gap(12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tanggal",
                            style: GoogleFonts.roboto(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff777777),
                            ),
                          ),
                          Gap(5.h),
                          Text(
                            DateFormat(
                              'EEEE, d MMMM yyyy',
                              'id_ID',
                            ).format(DateTime.parse(widget.bookingModel.date)),
                            style: GoogleFonts.roboto(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1.w,
                      height: 28.h,
                      color: Color(0xffE5E5E5),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Waktu",
                            style: GoogleFonts.roboto(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff777777),
                            ),
                          ),
                          Gap(5.h),
                          Text(
                            "${widget.bookingModel.startTime} - ${widget.bookingModel.endTime}",
                            style: GoogleFonts.roboto(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Gap(14.h),
                Divider(color: Color(0xffE5E5E5), thickness: 1),
                Gap(12.h),
                Text(
                  "Pekerjaan Tambahan",
                  style: GoogleFonts.roboto(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff777777),
                  ),
                ),
                Gap(5.h),
                Text(
                  "Tidak Ada",
                  style: GoogleFonts.roboto(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gap(15.h),
                Divider(color: Color(0xffE5E5E5), thickness: 1),
                Gap(12.h),
                Text(
                  "Pekerja",
                  style: GoogleFonts.roboto(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff777777),
                  ),
                ),
                Gap(5.h),
                Row(
                  children: [
                    Text(
                      widget.bookingModel.workerId,
                      style: GoogleFonts.roboto(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Gap(4.w),
                    SvgPicture.asset(
                      "assets/icons/seal_check.svg",
                      width: 14.w,
                      height: 14.h,
                    ),
                  ],
                ),
                Gap(15.h),
                Divider(color: Color(0xffE5E5E5), thickness: 1),
                Gap(13.h),
                Text(
                  "Luas Tanah",
                  style: GoogleFonts.roboto(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff777777),
                  ),
                ),
                Gap(5.h),
                Text(
                  "-",
                  style: GoogleFonts.roboto(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gap(13.h),
                Divider(color: Color(0xffE5E5E5), thickness: 1),
                Gap(12.h),
                Text(
                  "Alamat",
                  style: GoogleFonts.roboto(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff777777),
                  ),
                ),
                Gap(5.h),
                Text(
                  widget.serviceModel.address,
                  style: GoogleFonts.roboto(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gap(4.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
