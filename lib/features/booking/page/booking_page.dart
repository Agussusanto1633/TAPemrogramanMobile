import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:servista/features/booking/page/booking_ongoing_page.dart';

import '../../../core/theme/color_value.dart';
import '../../../core/transparent_appbar/transparent_appbar.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorValue.bgFrameColor,
      appBar: transparentAppBarWidget(),
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Gap(10.h),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1, color: Colors.grey.shade300),
                    bottom: BorderSide(width: 1, color: Colors.grey.shade300),
                  ),
                ),
                child: TabBar(
                  splashFactory: NoSplash.splashFactory,

                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.amber,
                  indicatorWeight: 2,
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                      width: 2.5.w,
                      color: ColorValue.primaryColor,
                    ),
                    insets: EdgeInsets.symmetric(horizontal: 36.w, vertical: 0),
                  ),
                  tabs: [
                    Tab(text: 'Pemesanan Berlangsung'),
                    Tab(text: 'Riwayat Pemesanan'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    BookingOngoingPage(),
                    Center(child: Text('Riwayat Pemesanan Content')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
