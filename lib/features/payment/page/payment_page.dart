import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:servista/core/custom_widgets/custom_button_widget.dart';
import 'package:servista/features/service/cubit/service_cubit.dart';
import 'package:servista/features/service/widgets/bottom_sheets_widgets/bottom_sheets/payment_method_bottom_sheet.dart';

import '../../../core/theme/app_font_weight.dart';
import '../../../core/theme/color_value.dart';
import '../../../core/utils/utils.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Duration duration = const Duration(hours: 2);
  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (duration.inSeconds > 0) {
        setState(() {
          duration -= const Duration(seconds: 1);
        });
      } else {
        timer?.cancel();
      }
    });
  }

  dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget timeBox(String value) {
    return Container(
      padding: EdgeInsets.all(5.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ColorValue.darkColor,
        borderRadius: BorderRadius.circular(2.r),
      ),
      child: Text(
        value,
        style: GoogleFonts.mulish(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    TextTheme textTheme = Theme.of(context).textTheme;
    return BlocBuilder<ServiceCubit, ServiceState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: ColorValue.darkColor,
          body: SafeArea(
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
                            "Konfirmasi Pembayaran",
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
                    Gap(22.h),
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
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: ColorValue.darkColor,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Gap(7.h),
                                  Text(
                                    "Servista",
                                    style: textTheme.displayLarge!.copyWith(
                                      color: ColorValue.bgFrameColor,
                                      fontSize: 16.sp,
                                      fontWeight: AppFontWeight.bold,
                                    ),
                                  ),
                                  Gap(7.h),
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.h,
                                      horizontal: 10.w,
                                    ),
                                    color: ColorValue.primaryColor,
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/icons/potong_rumput.png",
                                          width: 43.w,
                                          height: 48.h,
                                        ),
                                        Gap(10.w),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              state.selectedService.toString(),
                                              style: textTheme.displayLarge!
                                                  .copyWith(
                                                    color: ColorValue.darkColor,
                                                    fontSize: 16.sp,
                                                    fontWeight:
                                                        AppFontWeight.bold,
                                                  ),
                                            ),
                                            Text(
                                              "${state.selectedTime} | ${DateFormat("EEEE, d MMMM yyyy", 'id_ID').format(state.selectedDate!)}",
                                              style: textTheme.displayLarge!
                                                  .copyWith(
                                                    color: ColorValue.darkColor,
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                        AppFontWeight.regular,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    color: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.h,
                                      horizontal: 10.w,
                                    ),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/payment/${state.paymentMethod!.toLowerCase()}.png",
                                          width: 51.w,
                                          height: 16.h,
                                        ),
                                        Gap(5.w),
                                        Text(
                                          state.paymentMethod.toString(),
                                          style: textTheme.displayLarge!
                                              .copyWith(
                                                color: ColorValue.darkColor,
                                                fontSize: 16.sp,
                                                fontWeight: AppFontWeight.bold,
                                              ),
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
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                            child: Text(
                                              "Ubah",
                                              style: textTheme.displayLarge!
                                                  .copyWith(
                                                    color: ColorValue.darkColor,
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
                                  Divider(
                                    height: 1,
                                    color: ColorValue.grayColor,
                                    thickness: 1,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12.5.h,
                                      horizontal: 10.w,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10.r),
                                        bottomRight: Radius.circular(10.r),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "0812345678910 a.n Servista",
                                          style: textTheme.displayLarge!
                                              .copyWith(
                                                color: ColorValue.darkColor,
                                                fontSize: 12.sp,
                                                fontWeight: AppFontWeight.bold,
                                              ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                      18.0.w,
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        QrImageView(
                                                          data:
                                                              "https://example.com",
                                                          // Ganti dengan data yang kamu mau
                                                          version:
                                                              QrVersions.auto,
                                                          size:
                                                              187.w, // Ukuran QR Code sesuai permintaan
                                                        ),
                                                        SizedBox(height: 9.h),
                                                        Text(
                                                          "Scan QR Code",
                                                          style: textTheme
                                                              .bodySmall!
                                                              .copyWith(
                                                                fontSize: 22.sp,
                                                                fontWeight:
                                                                    AppFontWeight
                                                                        .regular,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: Text(
                                            "Lihat QR Code",
                                            style: textTheme.displayLarge!
                                                .copyWith(
                                                  color:
                                                      ColorValue.blueLinkColor,
                                                  fontSize: 12.sp,
                                                  fontWeight:
                                                      AppFontWeight.regular,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 21.w,
                          vertical: 14.h,
                        ),
                        color: ColorValue.primaryColor.withOpacity(0.25),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/icons/clock.svg",
                              width: 18.w,
                              height: 18.h,
                            ),
                            Gap(5.w),
                            Text(
                              "Lakukan pembayaran dalam",
                              style: textTheme.displayLarge!.copyWith(
                                color: ColorValue.darkColor,
                                fontSize: 12.sp,
                                fontWeight: AppFontWeight.regular,
                              ),
                            ),
                            Spacer(),
                            timeBox(hours),
                            Gap(1.w),
                            timeBox(minutes),
                            Gap(1.w),
                            timeBox(seconds),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 14.h,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                  Utils.formatRupiah(state.price),
                                  style: GoogleFonts.poppins(
                                    color: ColorValue.darkColor,
                                    fontSize: 16.sp,
                                    fontWeight: AppFontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Gap(10.h),
                            CustomButtonWidget(label: "Konfirmasi Pembayaran"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
