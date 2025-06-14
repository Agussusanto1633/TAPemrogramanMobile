import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servista/core/theme/color_value.dart';
import 'package:servista/features/profile/bloc/profile_bloc.dart';
import 'package:servista/features/profile/bloc/profile_state.dart';

class ProfileHeader extends StatelessWidget {
  final String userName;
  final String userPhotoURL;
  final String userEmail;
  final String userPhoneNumber;

  const ProfileHeader({
    Key? key,
    required this.userName,
    required this.userPhotoURL,
    required this.userEmail,
    required this.userPhoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 150.w,
              height: 150.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: ColorValue.primaryColor, width: 5.w),
              ),
              child: ClipOval(
                child:
                    userPhotoURL.isEmpty
                        ? Image.asset(
                          "assets/images/profile/profile.png",
                          fit: BoxFit.cover,
                        )
                        : Image.network(userPhotoURL, fit: BoxFit.cover),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: 48.h,
                width: 48.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: SvgPicture.asset("assets/icons/camera.svg"),
                ),
              ),
            ),
          ],
        ),
        Gap(18.h),
        Text(
          userName,
          style: GoogleFonts.mulish(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Gap(5.h),
        Text(
          userPhoneNumber,
          style: GoogleFonts.mulish(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
