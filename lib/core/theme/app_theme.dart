import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color_value.dart';

class AppThemeData {
  static ThemeData getThemeLight() {

    Color primaryColor = ColorValue.primaryColor;
    final Map<int, Color> primaryColorMap = {
      50: primaryColor,
      100: primaryColor,
      200: primaryColor,
      300: primaryColor,
      400: primaryColor,
      500: primaryColor,
      600: primaryColor,
      700: primaryColor,
      800: primaryColor,
      900: primaryColor,
    };
    final MaterialColor primaryMaterialColor = MaterialColor(
      primaryColor.value,
      primaryColorMap,
    );
    return ThemeData(
      fontFamily: GoogleFonts.mulish().fontFamily,
      primaryColor: primaryColor,
      primarySwatch: primaryMaterialColor,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        toolbarHeight: 56.h,
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: GoogleFonts.mulish(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: ColorValue.darkColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10.r)),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: ColorValue.primaryColor.withOpacity(0.4),
          disabledForegroundColor: Colors.white,
          foregroundColor: Colors.white,
          backgroundColor: ColorValue.primaryColor,
          minimumSize: Size(double.infinity, 50.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          textStyle: GoogleFonts.mulish(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),


      tabBarTheme: TabBarTheme(
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return ColorValue.primaryColor.withOpacity(0); // efek splash
            }
            return null;
          },
        ),
        splashFactory: InkRipple.splashFactory,
        labelColor: ColorValue.darkColor,
        unselectedLabelColor: ColorValue.darkColor.withOpacity(0.5),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            width: 2,
            color: ColorValue.primaryColor,
          ),
        ),
      ),

      textTheme: TextTheme(
        /// Display Text Style
        // Regular 28
        displayLarge: GoogleFonts.mulish(
          fontSize: 28.sp,
          fontWeight: FontWeight.w400,
          color: ColorValue.darkColor,
        ),
        // Bold 24
        displayMedium: GoogleFonts.mulish(
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          color: ColorValue.darkColor,
        ),
        // Bold 20
        displaySmall: GoogleFonts.mulish(
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          color: ColorValue.darkColor,
        ),
        /// Title Text Style
        // Bold 18
        titleLarge: GoogleFonts.mulish(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: ColorValue.darkColor,
        ),
        // Bold 16
        titleMedium: GoogleFonts.mulish(
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
          color: ColorValue.darkColor,
        ),
        // Bold 14
        titleSmall: GoogleFonts.mulish(
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          color: ColorValue.darkColor,
        ),
        /// Body Text Style
        // Bold 12
        bodyLarge: GoogleFonts.mulish(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: ColorValue.darkColor,
        ),
        // Regular 12
        bodyMedium: GoogleFonts.mulish(
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          color: ColorValue.darkColor,
        ),
        // Regular 10
        bodySmall: GoogleFonts.mulish(
          fontSize: 10.sp,
          fontWeight: FontWeight.w400,
          color: ColorValue.darkColor,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorValue.primaryColor),
          borderRadius: BorderRadius.circular(8.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorValue.primaryColor),
          borderRadius: BorderRadius.circular(8.r),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorValue.primaryColor),
          borderRadius: BorderRadius.circular(8.r),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: ColorValue.primaryColor),
          borderRadius: BorderRadius.circular(8.r),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorValue.primaryColor),
          borderRadius: BorderRadius.circular(8.r),
        ),
        activeIndicatorBorder: BorderSide(color: ColorValue.primaryColor),
        outlineBorder: BorderSide(color: ColorValue.primaryColor),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorValue.primaryColor),
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}
