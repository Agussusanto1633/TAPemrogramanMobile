import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:servista/core/custom_widgets/custom_button_widget.dart';
import 'package:servista/core/theme/app_font_weight.dart';
import 'package:servista/core/theme/color_value.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/scroll/scroll_behavior.dart';
import '../widgets/financial_info_card.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
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
            children: [
              Container(
                decoration: BoxDecoration(
                  color: ColorValue.darkColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25.r),
                    bottomRight: Radius.circular(25.r),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 22.h),
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
                                image:
                                    photoUrl.isNotEmpty
                                        ? NetworkImage(photoUrl)
                                        : AssetImage(
                                          "assets/images/profile/profile.png",
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
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Spacer(),
                          SvgPicture.asset(
                            "assets/icons/notification.svg",
                            width: 24.w,
                            height: 28.w,
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'Daftarkan lapangan kamu dan dapatkan penghasilan',
                        style: textTheme.displayMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 25.h),
                      CustomButtonWidget(label: "Daftar Membership"),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.w),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Text(
                      "Riwayat Penyewaan",
                      style: textTheme.bodyLarge!.copyWith(
                        color: ColorValue.darkColor,
                        fontWeight: AppFontWeight.regular,
                        fontSize: 16.sp,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "Lihat Semua",
                      style: textTheme.bodyMedium!.copyWith(
                        color: ColorValue.darkColor,
                        fontWeight: AppFontWeight.regular,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    SvgPicture.asset("assets/icons/arrow.svg"),
                  ],
                ),
              ),
              SizedBox(height: 17.h),
              Container(
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: ColorValue.darkColor,
                ),
                child: Column(
                  children: [
                    Gap(7.h),
                    Text(
                      "CGV Sport Hall Fx",
                      style: textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    Gap(7.h),
                    Container(
                      padding: EdgeInsets.all(15.w),
                      color: ColorValue.primaryColor,
                      width: double.infinity,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/lapangan_bola.svg",
                            width: 36.85.w,
                            height: 29.11.h,
                          ),
                          Gap(10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Lapangan 2",
                                style: textTheme.bodyMedium!.copyWith(
                                  color: ColorValue.darkColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                              ),
                              Text(
                                "Sabtu, 3 Januari 2023 | 18.00",
                                style: textTheme.bodyMedium!.copyWith(
                                  color: ColorValue.darkColor,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Gap(20.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    "Ringkasan Pendapatan",
                    style: textTheme.bodyLarge!.copyWith(
                      color: ColorValue.darkColor,
                      fontWeight: AppFontWeight.regular,
                      fontSize: 16.sp,
                    ),
                  ),
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
                        child: FinancialInfoCard(
                          title: "Pendapatan bulan ini",
                          value: "7.200.000",
                          baseFontSize: 36.sp,
                        ),
                      ),
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
            ],
          ),
        ),
      ),
    );
  }
}
