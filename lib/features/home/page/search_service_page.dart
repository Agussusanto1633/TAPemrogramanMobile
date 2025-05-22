import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/scroll/scroll_behavior.dart';
import '../../../core/theme/color_value.dart';
import '../../service/widgets/service_card.dart';

class SearchServicePage extends StatefulWidget {
  const SearchServicePage({super.key});

  @override
  State<SearchServicePage> createState() => _SearchServicePageState();
}

class _SearchServicePageState extends State<SearchServicePage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: ColorValue.darkColor,
      appBar: AppBar(
        backgroundColor: ColorValue.darkColor,
        centerTitle: true,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 20.w),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  "assets/icons/back-button.svg",
                  width: 32.w,
                  height: 32.w,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Spacer(),
            SvgPicture.asset(
              "assets/icons/maps.svg",
              width: 24.w,
              height: 24.w,
            ),
            SizedBox(width: 5.w),
            Text(
              "Kota Malang",
              style: textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
            Spacer(),
            SizedBox(width: 32.w, height: 32.w),
            SizedBox(width: 20.w),
          ],
        ),
        leadingWidth: 24.w,
      ),
      body: ScrollConfiguration(
        behavior: NoOverScrollEffectBehavior(),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                // padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  color: ColorValue.bgFrameColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.r),
                    topRight: Radius.circular(25.r),
                  ),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    vertical: 20.w,
                    horizontal: 20.w,
                  ),
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return ServiceCard();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
