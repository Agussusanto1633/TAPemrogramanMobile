import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servista/core/custom_widgets/custom_button_widget.dart';
import 'package:servista/core/nav/nav.dart';
import 'package:servista/core/theme/app_font_weight.dart';
import 'package:servista/core/theme/color_value.dart';
import 'package:servista/core/transparent_appbar/transparent_appbar.dart';
import 'package:servista/features/auth/login/bloc/auth_bloc.dart';
import 'package:servista/features/auth/login/bloc/auth_service.dart';
import 'package:servista/features/auth/login/bloc/auth_state.dart';
import 'package:servista/features/auth/login/view/page/login_email_page.dart';
import 'package:servista/home_dummy.dart';

import '../../../../../core/nav_bar/admin_nav_bar.dart';
import '../../../../../core/nav_bar/nav_bar.dart';
import '../../bloc/auth_event.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: transparentAppBarWidget(isDarkStyle: true),
      body: BlocProvider(
        create: (context) => AuthBloc(AuthService()),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gap(150.h),
              Text(
                "KoneksiJasa",
                style: GoogleFonts.onest(
                  fontSize: 40.sp,
                  fontWeight: FontWeight.w700,
                  color: ColorValue.darkColor,
                ),
              ),
              Text(
                "Welcome to KoneksiJasa",
                style: GoogleFonts.mulish(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff3F414E),
                ),
              ),
              Spacer(),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) async {
                  if (state is AuthSignedIn) {
                    final uid = state.user.uid;
                    if (uid != null) {
                      final doc =
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(uid)
                              .get();
                      final isSeller = doc.data()?['isSeller'] ?? false;

                      if (isSeller == true) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AdminNavBar(),
                          ),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NavBar(),
                          ),
                        );
                      }
                    } else {
                      // Gagal ambil UID
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Login gagal: tidak dapat mengambil data pengguna.",
                          ),
                        ),
                      );
                    }
                  } else if (state is AuthError) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.error)));
                  }
                },

                builder: (context, state) {
                  if (state is AuthLoading) {
                    // Tampilkan indikator loading
                    return CircularProgressIndicator();
                  }

                  return InkWell(
                    onTap: () async {
                      BlocProvider.of<AuthBloc>(
                        context,
                      ).add(AuthSignInWithGoogle());
                    },

                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      padding: EdgeInsets.all(10.w),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xffE9E9E9),
                        borderRadius: BorderRadius.circular(7.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/auth/google.png",
                            height: 24.h,
                            width: 24.w,
                          ),
                          Gap(10.w),
                          Text(
                            "Login dengan Google",
                            style: GoogleFonts.poppins(
                              color: Color(0xff474747),
                              fontSize: 14.w,
                              fontWeight: AppFontWeight.semiBold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Gap(16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: GestureDetector(
                  onTap: () {
                    Nav.to(context, LoginEmailPage());
                  },
                  child: CustomButtonWidget(
                    label: "Login dengan Email",
                    backgroundColor: ColorValue.darkColor,
                    labelColor: Colors.white,
                  ),
                ),
              ),
              Gap(19.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Divider(color: Colors.black, height: 1, thickness: 2),
              ),
              Gap(109.h),
            ],
          ),
        ),
      ),
    );
  }
}
