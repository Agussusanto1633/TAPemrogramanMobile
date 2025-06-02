import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/color_value.dart';
import '../../../core/transparent_appbar/transparent_appbar.dart';
import '../../../features/booking/bloc/booking_bloc.dart';
import '../widgets/booking_tabbar_body.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  late BookingBloc bookingBloc;

  @override
  void initState() {
    super.initState();
    bookingBloc = BookingBloc(firestore: FirebaseFirestore.instance);
    bookingBloc.add(FetchBookings(FirebaseAuth.instance.currentUser!.uid));
  }

  @override
  void dispose() {
    bookingBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bookingBloc,
      child: Scaffold(
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
                      insets: EdgeInsets.symmetric(horizontal: 36.w),
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
                      BookingTabBarBody(),
                      BookingTabBarBody(upcoming: false),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
