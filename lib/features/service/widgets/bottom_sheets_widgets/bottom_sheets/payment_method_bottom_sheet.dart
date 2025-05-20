import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servista/core/theme/app_font_weight.dart';

import '../../../../../core/theme/color_value.dart';
import '../../../cubit/service_cubit.dart';

Future<String?> paymentMethodBottomSheet(BuildContext context) {
  final List<String> bank = ["BCA", "BRI", "Mandiri"];
  final List<String> eWallet = ["OVO", "DANA", "GOPAY", "LINKAJA"];

  String? selectedMethod;

  return showModalBottomSheet<String>(
    backgroundColor: Colors.white,
    context: context,
    isScrollControlled: true,
    builder: (context) {
      final cubit = context.read<ServiceCubit>();

      return BlocBuilder<ServiceCubit, ServiceState>(
        builder: (context, state) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(22.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Text(
                    "Pilih Metode Pembayaran",
                    style: GoogleFonts.mulish(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff3F414E),
                    ),
                  ),
                ),
                Gap(14.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Transfer Bank",
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: AppFontWeight.regular,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5.w),

                // Grid list of banks
                Column(
                  children:
                      bank.map((item) {
                        final isSelected = state.paymentMethod == item;

                        Color selectedColor, textColor, bgcolor;

                        if (isSelected) {
                          selectedColor = ColorValue.primaryColor;
                          textColor = Colors.black;
                          bgcolor = Colors.black.withOpacity(0.1);
                        } else {
                          selectedColor = Colors.white;
                          textColor = Colors.black;
                          bgcolor = Colors.white;
                        }

                        return Padding(
                          padding: EdgeInsets.only(bottom: 5.w),
                          child: GestureDetector(
                            onTap: () {
                              // setState(() {
                              //   selectedMethod = item;
                              // });
                              cubit.setPaymentMethod(item);
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                vertical: 10.w,
                                horizontal: 25.w,
                              ),
                              color: bgcolor,
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/payment/${item.toLowerCase()}.png",
                                    width: 51.w,
                                    height: 17.h,
                                  ),
                                  Gap(11.w),
                                  Text(
                                    item,
                                    style: GoogleFonts.mulish(
                                      fontSize: 16.sp,
                                      fontWeight: AppFontWeight.regular,
                                      color: textColor,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    padding: EdgeInsets.all(3.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: ColorValue.primaryColor,
                                        width: 1.w,
                                      ),
                                    ),
                                    child: Container(
                                      height: 6.h,
                                      width: 6.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: selectedColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
                Divider(height: 1.w, color: Colors.black.withOpacity(0.1)),

                SizedBox(height: 18.w),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Transfer E-Wallet  ",
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: AppFontWeight.regular,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.w),

                // Grid list of banks
                Column(
                  children:
                      eWallet.map((item) {
                        final isSelected = state.paymentMethod == item;

                        Color selectedColor, textColor, bgcolor;

                        if (isSelected) {
                          selectedColor = ColorValue.primaryColor;
                          textColor = Colors.black;
                          bgcolor = Colors.black.withOpacity(0.1);
                        } else {
                          selectedColor = Colors.white;
                          textColor = Colors.black;
                          bgcolor = Colors.white;
                        }

                        return Padding(
                          padding: EdgeInsets.only(bottom: 5.w),
                          child: GestureDetector(
                            onTap: () {
                              // setState(() {
                              //   selectedMethod = item;
                              // });
                              cubit.setPaymentMethod(item);
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                vertical: 10.w,
                                horizontal: 25.w,
                              ),
                              color: bgcolor,

                              alignment: Alignment.center,

                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/payment/${item.toLowerCase()}.png",
                                    width: 51.w,
                                    height: 17.h,
                                  ),
                                  Gap(11.w),
                                  Text(
                                    item,
                                    style: GoogleFonts.mulish(
                                      fontSize: 16.sp,
                                      fontWeight: AppFontWeight.regular,
                                      color: textColor,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    padding: EdgeInsets.all(3.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: ColorValue.primaryColor,
                                        width: 1.w,
                                      ),
                                    ),
                                    child: Container(
                                      height: 6.h,
                                      width: 6.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: selectedColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
                Padding(
                  padding: EdgeInsets.all(20.w),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 41.w),
                      backgroundColor:
                          state.paymentMethod == null
                              ? ColorValue.grayColor
                              : ColorValue.primaryColor,
                      disabledBackgroundColor: ColorValue.grayColor,
                    ),
                    onPressed:
                        state.paymentMethod == null
                            ? null
                            : () async {
                              Navigator.pop(context, selectedMethod);
                              await Future.delayed(Duration(milliseconds: 300));
                            },
                    child: Text(
                      "Pilih",
                      style: GoogleFonts.mulish(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color:
                            state.paymentMethod == null
                                ? ColorValue.darkColor.withOpacity(0.5)
                                : ColorValue.darkColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
