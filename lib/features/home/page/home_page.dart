import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:servista/core/nav/nav.dart';
import 'package:servista/features/home/page/search_service_page.dart';
import 'package:servista/features/service/bloc/service_state.dart';
import 'package:servista/features/service/pages/detail_service_page.dart';
import 'package:servista/features/service/repositories/service_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/scroll/scroll_behavior.dart';
import '../../../core/theme/app_style.dart';
import '../../../core/theme/color_value.dart';
import '../../service/bloc/service_bloc.dart';
import '../../service/bloc/service_event.dart';
import '../widgets/home_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> locations = ['Malang', 'Surabaya', 'Jakarta', 'Bandung'];
  String selectedLocation = 'Malang';
  late ServiceBloc serviceBloc;
  String displayName = '';
  String email = '';
  String photoUrl = '';

  @override
  void initState() {
    super.initState();
    context.read<ServiceBloc>().add(LoadAllServices());

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
  void dispose() {
    serviceBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    statusBarLightStyle();
    final textTheme = Theme.of(context).textTheme;

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
                  padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 45.h),
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
                                image: NetworkImage(
                                  photoUrl.isNotEmpty
                                      ? photoUrl
                                      : 'https://example.com/default_profile.png',
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
                            "Halo $displayName",
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
                        'Mau cari jasa apa nih?',
                        style: textTheme.displayMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchServicePage(),
                                ),
                              );
                            },
                            child: Container(
                              height: 40.h,
                              width: 219.w,
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 15.w,
                              ),
                              decoration: BoxDecoration(
                                color: ColorValue.dark2Color,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.search,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                  SizedBox(width: 5.w),
                                  Text(
                                    "Cari lokasi di $selectedLocation",
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Container(
                            height: 40.h,
                            width: 92.w,
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            decoration: BoxDecoration(
                              color: ColorValue.dark2Color,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                borderRadius: BorderRadius.circular(10.r),
                                dropdownColor: ColorValue.dark2Color,
                                value: selectedLocation,
                                icon: Icon(
                                  Icons.arrow_drop_down_rounded,
                                  color: Colors.white,
                                ),
                                style: textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedLocation = newValue!;
                                    print(
                                      'Selected location: $selectedLocation',
                                    );
                                  });
                                },
                                items:
                                    locations.map<DropdownMenuItem<String>>((
                                      String value,
                                    ) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    padding: EdgeInsets.all(10.h),
                    decoration: BoxDecoration(
                      color: ColorValue.primaryColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      "Terdekat",
                      style: textTheme.bodyLarge?.copyWith(
                        color: ColorValue.dark2Color,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      children: [
                        Text(
                          "Rekomendasi untuk kamu",
                          style: textTheme.bodyLarge,
                        ),
                        Spacer(),
                        Text("Lihat Semua", style: textTheme.bodyMedium),
                        SizedBox(width: 5.w),
                        SvgPicture.asset("assets/icons/arrow.svg"),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),
                  BlocBuilder<ServiceBloc, ServiceState>(
                    builder: (context, state) {
                      if (state is ServiceLoading) {
                    return Container(
                            height: 285.h,
                              child: Center(child: CircularProgressIndicator()));
                      } else if (state is ServiceSuccess) {
                        print("Loading services... ${state.toString()}");
                        return SizedBox(
                          height: 285.h,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            itemCount: state.services.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            padding: EdgeInsets.only(
                              bottom: 60.h,
                              left: 20.w,
                            ),
                            itemBuilder: (context, index) {
                              return HomeCard(
                                service: state.services[index],
                                onTap: () {
                                  Nav.to(
                                    context,
                                    DetailServicePage(
                                      service: state.services[index],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        );
                      } else if (state is ServiceLoadFailure) {
                        return Center(child: Text("Error loading services"));
                      }
                      return Container();
                    },
                  ),
                  // SizedBox(
                  //   height: 285.h,
                  //   width: MediaQuery.of(context).size.width,
                  //   child: ListView.builder(
                  //     itemCount: 3,
                  //     scrollDirection: Axis.horizontal,
                  //     shrinkWrap: true,
                  //     padding: EdgeInsets.only(bottom: 60.h, left: 20.w),
                  //     itemBuilder: (context, index) {
                  //       return HomeCard();
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
