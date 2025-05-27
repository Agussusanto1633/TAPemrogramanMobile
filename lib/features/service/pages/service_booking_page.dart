import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:servista/core/nav/nav.dart';
import 'package:servista/core/theme/app_font_weight.dart';
import 'package:servista/core/theme/color_value.dart';
import 'package:servista/core/utils/utils.dart';
import 'package:servista/features/service/widgets/bottom_sheets_widgets/bottom_sheets/calendar_bottom_sheet.dart';
import 'package:servista/features/service/widgets/bottom_sheets_widgets/bottom_sheets/payment_method_bottom_sheet.dart';

import '../../payment/page/payment_page.dart';
import '../cubit/service_cubit.dart';
import '../widgets/bottom_sheets_widgets/booking_flow.dart';

class ServiceBookingPage extends StatefulWidget {
  const ServiceBookingPage({super.key});

  @override
  State<ServiceBookingPage> createState() => _ServiceBookingPageState();
}

class _ServiceBookingPageState extends State<ServiceBookingPage> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: ColorValue.darkColor,
      body: BlocBuilder<ServiceCubit, ServiceState>(
        builder: (context, state) {
          print(state.selectedDate);
          print(state.selectedTime);
          print(state.selectedWorker);
          return SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: 10.w),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: SvgPicture.asset(
                              "assets/icons/arrow_back.svg",
                              width: 24.w,
                              height: 24.h,
                              color: ColorValue.primaryColor,
                            ),
                          ),
                          Spacer(),
                          SvgPicture.asset(
                            "assets/icons/document.svg",
                            width: 24.w,
                            height: 24.h,
                            color: ColorValue.primaryColor,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            "Pesanan Anda",
                            style: textTheme.titleLarge!.copyWith(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: AppFontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          Container(width: 24.w),
                        ],
                      ),
                    ),
                    Gap(22.w),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        clipBehavior: Clip.none,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 20.h,
                        ),
                        decoration: BoxDecoration(
                          color: ColorValue.bgFrameColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(28.r),
                            topRight: Radius.circular(28.r),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //data pesanan
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Data Pesanan",
                                  style: textTheme.titleLarge!.copyWith(
                                    color: Color(0xff3F414E),
                                    fontSize: 16.sp,
                                    fontWeight: AppFontWeight.bold,
                                  ),
                                ),
                                Gap(5.h),
                                Text(
                                  "Ringkasan pesanan layanan anda",
                                  style: textTheme.bodyLarge!.copyWith(
                                    color: Color(0xff3F414E),
                                    fontSize: 12.sp,
                                    fontWeight: AppFontWeight.regular,
                                  ),
                                ),
                                Gap(10.h),
                                Container(
                                  padding: EdgeInsets.all(10.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${state.selectedTime} | ${DateFormat("EEEE, d MMMM yyyy", 'id_ID').format(state.selectedDate!)}",
                                            style: textTheme.bodyLarge!
                                                .copyWith(
                                                  color: Color(0xff3F414E),
                                                  fontSize: 14.sp,
                                                  fontWeight:
                                                      AppFontWeight.bold,
                                                ),
                                          ),
                                          Text(
                                            state.selectedWorker == null
                                                ? "null"
                                                : state.selectedWorker!,
                                            style: textTheme.bodyLarge!
                                                .copyWith(
                                                  color: Color(0xff3F414E),
                                                  fontSize: 12.sp,
                                                  fontWeight:
                                                      AppFontWeight.regular,
                                                ),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {

                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(10.w),
                                          decoration: BoxDecoration(
                                            color: ColorValue.primaryColor,
                                            border: Border.all(
                                              color: ColorValue.grayColor,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10.r,
                                            ),
                                          ),
                                          child: Text(
                                            "Ubah",
                                            style: textTheme.bodyLarge!
                                                .copyWith(
                                                  color: ColorValue.dark2Color,
                                                  fontSize: 12.sp,
                                                  fontWeight:
                                                      AppFontWeight.bold,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Gap(30.h),
                            //pemesanan
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Pemesanan",
                                  style: textTheme.titleLarge!.copyWith(
                                    color: Color(0xff3F414E),
                                    fontSize: 16.sp,
                                    fontWeight: AppFontWeight.bold,
                                  ),
                                ),
                                Gap(5.h),
                                Text(
                                  "Kami akan mengirimkan semua e-tiket/voucher dari pesanan ini kepada kontak yang diisi di profil kamu",
                                  style: textTheme.bodyLarge!.copyWith(
                                    color: Color(0xff3F414E),
                                    fontSize: 12.sp,
                                    fontWeight: AppFontWeight.regular,
                                  ),
                                ),
                                Gap(10.h),
                                Container(
                                  padding: EdgeInsets.all(10.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Firman",
                                            style: textTheme.bodyLarge!
                                                .copyWith(
                                                  color: Color(0xff3F414E),
                                                  fontSize: 16.sp,
                                                  fontWeight:
                                                      AppFontWeight.bold,
                                                ),
                                          ),
                                          Text(
                                            "+628123456789",
                                            style: textTheme.bodyLarge!
                                                .copyWith(
                                                  color: Color(0xff3F414E),
                                                  fontSize: 12.sp,
                                                  fontWeight:
                                                      AppFontWeight.regular,
                                                ),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Container(
                                        padding: EdgeInsets.all(10.w),
                                        decoration: BoxDecoration(
                                          color: ColorValue.primaryColor,
                                          border: Border.all(
                                            color: ColorValue.grayColor,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                        ),
                                        child: Text(
                                          "Ubah",
                                          style: textTheme.bodyLarge!.copyWith(
                                            color: ColorValue.dark2Color,
                                            fontSize: 12.sp,
                                            fontWeight: AppFontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Gap(30.h),
                            //pembayaran
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Pembayaran",
                                  style: textTheme.titleLarge!.copyWith(
                                    color: Color(0xff3F414E),
                                    fontSize: 16.sp,
                                    fontWeight: AppFontWeight.bold,
                                  ),
                                ),
                                Gap(5.h),
                                Text(
                                  "Lakukan pembayaran anda dengan mudah",
                                  style: textTheme.bodyLarge!.copyWith(
                                    color: Color(0xff3F414E),
                                    fontSize: 12.sp,
                                    fontWeight: AppFontWeight.regular,
                                  ),
                                ),
                                Gap(10.h),
                                Container(
                                  padding: EdgeInsets.all(10.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Row(
                                    children: [
                                      state.paymentMethod == null
                                          ? Text(
                                            "Pilih metode pembayaran",
                                            style: textTheme.bodyLarge!
                                                .copyWith(
                                                  color: Color(0xff3F414E),
                                                  fontSize: 16.sp,
                                                  fontWeight:
                                                      AppFontWeight.bold,
                                                ),
                                          )
                                          : Row(
                                            children: [
                                              Image.asset(
                                                "assets/images/payment/${state.paymentMethod.toString().toLowerCase()}.png",
                                                width: 51.w,
                                                height: 17.h,
                                              ),
                                              Gap(11.w),
                                              Text(
                                                state.paymentMethod.toString(),
                                                style: GoogleFonts.mulish(
                                                  fontSize: 16.sp,
                                                  fontWeight:
                                                      AppFontWeight.regular,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          paymentMethodBottomSheet(context);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(10.w),
                                          decoration: BoxDecoration(
                                            color: ColorValue.primaryColor,
                                            border: Border.all(
                                              color: ColorValue.grayColor,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10.r,
                                            ),
                                          ),
                                          child: Text(
                                            "Ubah",
                                            style: textTheme.bodyLarge!
                                                .copyWith(
                                                  color: ColorValue.dark2Color,
                                                  fontSize: 12.sp,
                                                  fontWeight:
                                                      AppFontWeight.bold,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 14.h,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Harga Total",
                              style: GoogleFonts.poppins(
                                color: ColorValue.darkColor,
                                fontSize: 12.sp,
                                fontWeight: AppFontWeight.regular,
                              ),
                            ),
                            Text(
                              Utils.formatRupiah(
                                state.price,
                              ),
                              style: GoogleFonts.poppins(
                                color: ColorValue.darkColor,
                                fontSize: 16.sp,
                                fontWeight: AppFontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Gap(10.h),
                        state.paymentMethod == null ?
                        GestureDetector(
                          onTap: () {
                            //snackbar
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Pilih metode pembayaran terlebih dahulu",
                                  style: textTheme.bodyLarge!.copyWith(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: AppFontWeight.regular,
                                  ),
                                ),
                                backgroundColor: ColorValue.darkColor,
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: ColorValue.primaryColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Center(
                              child: Text(
                                " Pembayaran",
                                style: textTheme.bodyLarge!.copyWith(
                                  color: ColorValue.darkColor,
                                  fontSize: 14.sp,
                                  fontWeight: AppFontWeight.semiBold,
                                ),
                              ),
                            ),
                          ),
                        ):
                        GestureDetector(
                          onTap: () {
                            Nav.to(context, const PaymentPage());
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: ColorValue.primaryColor,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Center(
                              child: Text(
                                " Pembayaran",
                                style: textTheme.bodyLarge!.copyWith(
                                  color: ColorValue.darkColor,
                                  fontSize: 14.sp,
                                  fontWeight: AppFontWeight.semiBold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
