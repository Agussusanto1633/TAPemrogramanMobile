import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:servista/core/theme/color_value.dart';

class ProfileMenu extends StatelessWidget {
  final String title;
  final String icon;
  //add optional bool parameter for isSelected
  final bool isArrow;

  const ProfileMenu({
    super.key,
    required this.title,
    required this.icon,
    this.isArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.5.h),
      decoration: BoxDecoration(
        color: ColorValue.dark2Color,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: 18.w,
              height: 18.h,
              color: Colors.white,
            ),
            Gap(5.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            Spacer(),
            isArrow
                ? SvgPicture.asset(
                  "assets/icons/arrow_fat.svg",
                  width: 24.w,
                  height: 24.h,
                )
                : Container(),
          ],
        ),
      ),
    );
  }
}
