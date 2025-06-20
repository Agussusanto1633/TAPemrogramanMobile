import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:servista/core/custom_widgets/custom_button_widget.dart';
import 'package:servista/core/nav/nav.dart';
import 'package:servista/core/theme/color_value.dart';
import 'package:servista/features/service/cubit/service_cubit.dart';

import '../../../core/theme/app_font_weight.dart';

class PaymentEticketPage extends StatefulWidget {
  const PaymentEticketPage({Key? key}) : super(key: key);

  @override
  State<PaymentEticketPage> createState() => _PaymentEticketPageState();
}

class _PaymentEticketPageState extends State<PaymentEticketPage> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = TextTheme.of(context);
    return BlocBuilder<ServiceCubit, ServiceState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: ColorValue.darkColor,
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 10.w),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/ticket.svg",
                        width: 24.w,
                        height: 24.h,
                        color: ColorValue.primaryColor,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        "ETiket Anda",
                        style: textTheme.titleLarge!.copyWith(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: AppFontWeight.bold,
                        ),
                      ),
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
                      children: [
                        Stack(
                          children: [
                            Container(
                              clipBehavior: Clip.antiAlias,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: ColorValue.darkColor,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Column(
                                children: [
                                  Gap(7.h),
                                  Text(
                                    "KoneksiJasa",
                                    style: textTheme.bodySmall!.copyWith(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Gap(7.h),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.5.w,
                                      vertical: 10.h,
                                    ),
                                    color: ColorValue.primaryColor,
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/icons/potong_rumput.png",
                                          height: 45.h,
                                          width: 43.w,
                                        ),
                                        Gap(10.w),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Potong Rumput",
                                              style: textTheme.bodyMedium!
                                                  .copyWith(
                                                    color: ColorValue.darkColor,
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            Text(
                                              "${DateFormat("EEEE, d MMMM yyyy", 'id_ID').format(state.selectedDate!)} | ${state.selectedTime}",
                                              style: textTheme.bodyMedium!
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
                                    width: double.infinity,
                                    color: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 22.w,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Gap(19.h),
                                        Center(
                                          child: Text(
                                            "Koneksijasa - KoneksiJasa",
                                            style: textTheme.bodySmall!
                                                .copyWith(
                                                  fontSize: 14.sp,
                                                  fontWeight:
                                                      AppFontWeight.semiBold,
                                                  color: ColorValue.darkColor,
                                                ),
                                          ),
                                        ),

                                        Gap(14.h),

                                        Padding(
                                          padding:  EdgeInsets.symmetric(horizontal:24.w),
                                          child: Image.asset(
                                            "assets/images/payment/qris.png",
                                          ),
                                        ),
                                        Gap(24.h),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            Positioned(
                              right: 0,
                              left: 0,
                              bottom: -15.w,
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  height: 25.h,
                                  width: 40.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100.w),
                                    color: ColorValue.bgFrameColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Nav.back(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(7.r),
                              ),
                              border: Border.all(
                                color: ColorValue.darkColor,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Kembali",
                                style: textTheme.bodySmall!.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: AppFontWeight.semiBold,
                                  color: ColorValue.darkColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Gap(10.h),
                        CustomButtonWidget(label: "Unduh E-Tiket"),
                        Gap(13.h),
                      ],
                    ),
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
