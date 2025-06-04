import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/scroll/scroll_behavior.dart';
import '../../../../core/theme/app_font_weight.dart';
import '../../../../core/theme/color_value.dart';
import '../../home/widgets/financial_info_card.dart';

class AdminIncomePage extends StatefulWidget {
  const AdminIncomePage({super.key});

  @override
  State<AdminIncomePage> createState() => _AdminIncomePageState();
}

class _AdminIncomePageState extends State<AdminIncomePage> {
  String displayName = '';
  String email = '';
  String photoUrl = '';

  @override
  void initState() {
    super.initState();

    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      displayName = prefs.getString('user_displayName') ?? 'Guest';
      email = prefs.getString('user_email') ?? 'Unknown';
      photoUrl = prefs.getString('user_photoURL') ?? '';
    });
  }



  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: ColorValue.bgFrameColor,
      body: ScrollConfiguration(
        behavior: NoOverScrollEffectBehavior(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Container(
                          width: 36.h,
                          height: 36.h,
                          decoration: ShapeDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                photoUrl.isNotEmpty
                                    ? photoUrl
                                    : 'https://example.com/default_profile.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          "Halo, $displayName",
                          style: textTheme.titleMedium?.copyWith(
                            color: ColorValue.dark2Color,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Spacer(),
                        SvgPicture.asset(
                          "assets/icons/notification.svg",
                          width: 24.w,
                          height: 28.w,
                          color: ColorValue.dark2Color,
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),
                    Text(
                      "Pendapatan anda",
                      style: textTheme.displayMedium?.copyWith(
                        color: ColorValue.dark2Color,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.w),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text("Ringkasan Pendapatan", style: textTheme.bodyLarge!.copyWith(
                    color: ColorValue.darkColor,
                    fontWeight: AppFontWeight.regular,
                    fontSize: 16.sp,
                  )),
                ),
              ),
              Gap(16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                          flex: 10,
                          child: FinancialInfoCard(title: "Pendapatan bulan ini", value: "7.200.000", baseFontSize: 36.sp,)),
                      SizedBox(width: 10.w),
                      Expanded(
                        flex: 8,
                        child: FinancialInfoCard(
                          title: "Transaksi Berhasil",
                          value: "10",
                          baseFontSize: 36.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gap(31.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text("Ringkasan Pendapatan", style: textTheme.bodyLarge!.copyWith(
                  color: ColorValue.darkColor,
                  fontWeight: AppFontWeight.regular,
                  fontSize: 16.sp,
                )),
              ),
              Gap(31.h),
              Align(
                alignment: Alignment.center,
                child: Text("Tidak ada data sebelumnya", style: textTheme.bodyLarge!.copyWith(
                  color: Colors.black,
                  fontWeight: AppFontWeight.regular,
                  fontSize: 12.sp,
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
