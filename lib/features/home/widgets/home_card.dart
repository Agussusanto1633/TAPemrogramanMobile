import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/theme/color_value.dart';
import '../../service/model/service_model.dart';

class HomeCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onTap;

  const HomeCard({
    Key? key,
    required this.service,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 221.w,
        margin: EdgeInsets.only(right: 16.w),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 0,
              offset: Offset(0, 0),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 13.r,
              offset: Offset(-1, 6),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 31.r,
              offset: Offset(-6, 51),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x02000000),
              blurRadius: 37.r,
              offset: Offset(-11, 91),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x00000000),
              blurRadius: 40.r,
              offset: Offset(-18, 142),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 200.w,
              height: 150.w,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    service.image.isNotEmpty
                        ? service.image
                        : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR9WYzQWEjZck6kOZi8VIec_mK2Der3rh-6Mw&s",
                  ),
                  fit: BoxFit.cover,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
            ),
            SizedBox(height: 11.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    service.address,
                    style: textTheme.bodyMedium?.copyWith(
                      color: ColorValue.dark2Color,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 12.w),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/star.svg",
                        height: 14.w,
                        width: 15.w,
                        color: ColorValue.primaryColor,
                      ),
                      SizedBox(width: 4.w),
                      Text("${service.rating}", style: textTheme.bodyLarge),
                      SizedBox(width: 2.w),
                      Text("(40)", style: textTheme.bodyMedium),
                      Spacer(),
                      Text("${service.range} km", style: textTheme.bodyMedium),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}