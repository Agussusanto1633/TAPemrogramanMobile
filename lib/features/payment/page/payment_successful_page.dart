import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:servista/core/custom_widgets/custom_button_widget.dart';
import 'package:servista/core/nav/nav.dart';
import 'package:servista/core/nav_bar/nav_bar.dart';
import 'package:servista/features/payment/page/payment_eticket_page.dart';
import 'package:servista/features/service/cubit/service_cubit.dart';
import 'package:servista/features/splash/view/page/splash_page.dart';

import '../../../core/theme/app_font_weight.dart';
import '../../../core/theme/color_value.dart';
import '../../../core/utils/utils.dart';

class PaymentSuccessfulPage extends StatefulWidget {
  const PaymentSuccessfulPage({Key? key}) : super(key: key);

  @override
  State<PaymentSuccessfulPage> createState() => _PaymentSuccessfulPageState();
}

class _PaymentSuccessfulPageState extends State<PaymentSuccessfulPage> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return BlocBuilder<ServiceCubit, ServiceState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            context.read<ServiceCubit>().reset();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder:
                    (context) => BlocProvider.value(
                      value: context.read<ServiceCubit>(),
                      child: NavBar(),
                    ),
              ),
              (route) => false,
            );
            return false;
          },
          child: Scaffold(
            backgroundColor: ColorValue.darkColor,
            body: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 10.w),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.read<ServiceCubit>().reset();

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => BlocProvider.value(
                                      value: context.read<ServiceCubit>(),
                                      child: NavBar(),
                                    ),
                              ),
                              (route) => false,
                            );
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
                          "assets/icons/check.svg",
                          width: 24.w,
                          height: 24.h,
                          color: ColorValue.primaryColor,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          "Pembayaran Berhasil",
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
                        children: [
                          Gap(40.h),
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: double.infinity,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 18.w,
                                      ),
                                      child: Column(
                                        children: [
                                          Gap(30.h),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Penyewaan Layanan Berhasil",
                                              style: textTheme.titleLarge!
                                                  .copyWith(
                                                    color: ColorValue.darkColor,
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        AppFontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                          Gap(12.h),
                                          Text(
                                            "Data Sewa Layanan:",
                                            style: textTheme.titleLarge!
                                                .copyWith(
                                                  color: ColorValue.darkColor,
                                                  fontSize: 12.sp,
                                                  fontWeight:
                                                      AppFontWeight.regular,
                                                ),
                                          ),
                                          Gap(9.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Tanggal",
                                                style: textTheme.titleLarge!
                                                    .copyWith(
                                                      color:
                                                          ColorValue.darkColor,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          AppFontWeight.regular,
                                                    ),
                                              ),
                                              Text(
                                                state.selectedDate != null
                                                    ? DateFormat(
                                                      "EEEE, d MMMM yyyy",
                                                      'id_ID',
                                                    ).format(
                                                      state.selectedDate!,
                                                    )
                                                    : '-',
                                                style: textTheme.titleLarge!
                                                    .copyWith(
                                                      color:
                                                          ColorValue.darkColor,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          AppFontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          Gap(5.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Waktu",
                                                style: textTheme.titleLarge!
                                                    .copyWith(
                                                      color:
                                                          ColorValue.darkColor,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          AppFontWeight.regular,
                                                    ),
                                              ),
                                              Text(
                                                state.selectedTime ?? '-',
                                                style: textTheme.titleLarge!
                                                    .copyWith(
                                                      color:
                                                          ColorValue.darkColor,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          AppFontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          Gap(15.h),
                                          Divider(
                                            color: ColorValue.grayColor,
                                            thickness: 1,
                                            height: 1,
                                          ),
                                          Gap(15.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Metode Pembayaran",
                                                style: textTheme.titleLarge!
                                                    .copyWith(
                                                      color:
                                                          ColorValue.darkColor,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          AppFontWeight.regular,
                                                    ),
                                              ),
                                              Text(
                                                state.paymentMethod ?? '-',
                                                style: textTheme.titleLarge!
                                                    .copyWith(
                                                      color:
                                                          ColorValue.darkColor,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          AppFontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          Gap(31.h),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10.h,
                                        horizontal: 17.5.w,
                                      ),
                                      color: ColorValue.primaryColor
                                          .withOpacity(0.5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Total Pembayaran",
                                            style: textTheme.titleLarge!
                                                .copyWith(
                                                  color: ColorValue.darkColor,
                                                  fontSize: 16.sp,
                                                  fontWeight:
                                                      AppFontWeight.regular,
                                                ),
                                          ),
                                          Text(
                                            Utils.formatRupiah(
                                              state.price ?? 0,
                                            ),
                                            style: textTheme.titleLarge!
                                                .copyWith(
                                                  color: ColorValue.darkColor,
                                                  fontSize: 16.sp,
                                                  fontWeight:
                                                      AppFontWeight.bold,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: -23.h,
                                left: 0,
                                right: 0,
                                child: Container(
                                  width: 46.w,
                                  height: 46.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: SvgPicture.asset(
                                    "assets/icons/check_circle.svg",
                                    width: 24.w,
                                    height: 24.h,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              Nav.to(context, PaymentEticketPage());
                            },
                            child: CustomButtonWidget(label: "Lihat E-Tiket"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
