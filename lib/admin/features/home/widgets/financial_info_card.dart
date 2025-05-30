import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/color_value.dart';
class FinancialInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final Color titleColor;
  final Color valueColor;
  final double baseFontSize;

  const FinancialInfoCard({
    super.key,
    required this.title,
    required this.value,
    this.titleColor = ColorValue.darkColor, // Warna default untuk judul
    this.valueColor = ColorValue.darkColor, // Warna default untuk nilai
    required this.baseFontSize, // Ukuran font dasar sebelum disesuaikan oleh FittedBox
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 12.w, // Ukuran font untuk judul
                color: titleColor,
              ),
            ),
            SizedBox(height: 5.h),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: baseFontSize,
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
                maxLines: 1, // Pastikan teks nilai hanya satu baris
                overflow: TextOverflow.ellipsis, // Tambahkan elipsis jika masih terlalu panjang setelah di-scale down
              ),
            ),
          ],
        ),
      ),
    );
  }
}
