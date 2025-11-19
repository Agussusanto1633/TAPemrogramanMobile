import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/color_value.dart';
import '../../../../features/service/model/service_model.dart';

class YourVerticalServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback? onTap;
  final VoidCallback? onTapDelete;

  const YourVerticalServiceCard({
    super.key,
    required this.service,
    this.onTap,
    this.onTapDelete,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                bottomLeft: Radius.circular(16.r),
              ),
              child: Image.network(
                service.image.isNotEmpty
                    ? service.image
                    : 'https://via.placeholder.com/150',
                width: 100.w,
                height: 100.w,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            service.name,
                            style: textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: onTapDelete,
                          child: Icon(Icons.delete, color: Colors.red, size: 18.w),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      service.address,
                      style: textTheme.bodyMedium?.copyWith(
                        color: ColorValue.dark2Color,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/star.svg",
                          height: 14.w,
                          width: 14.w,
                          color: ColorValue.primaryColor,
                        ),
                        SizedBox(width: 4.w),
                        Text("${service.rating}", style: textTheme.bodyLarge),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
