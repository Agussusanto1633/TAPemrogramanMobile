import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:servista/core/nav/nav.dart';
import 'package:servista/core/theme/color_value.dart';
import 'package:servista/features/auth/login/bloc/auth_state.dart';
import 'package:servista/features/profile/bloc/profile_bloc.dart';
import 'package:servista/features/profile/widgets/profile_header.dart';
import 'package:servista/features/profile/widgets/profile_menu.dart';
import 'package:servista/firestore/firestore_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/transparent_appbar/transparent_appbar.dart';
import '../../auth/login/bloc/auth_bloc.dart';
import '../../auth/login/bloc/auth_event.dart';
import '../../auth/login/view/page/login_page.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String displayName = '';
  String email = '';
  String photoUrl = '';
  String phoneNumber = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      displayName = prefs.getString('user_displayName') ?? 'Guest';
      email = prefs.getString('user_email') ?? 'Unknown';
      photoUrl = prefs.getString('user_photoURL') ?? '';
      phoneNumber = prefs.getString('user_phoneNumber') ?? 'Unknown';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorValue.darkColor,
      appBar: transparentAppBarWidget(isDarkStyle: false),

      body: SafeArea(
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileUpdated) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder:
                    (context) => AlertDialog(
                      title: Text("Berhasil Menjadi Seller"),
                      content: Text(
                        "Selamat! Kamu sekarang terdaftar sebagai seller.\n"
                        "Silakan login kembali untuk menggunakan aplikasi seller.",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Tutup dialog
                            context.read<AuthBloc>().add(AuthSignOut());
                          },
                          child: Text("Login"),
                        ),
                      ],
                    ),
              );
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  "assets/icons/arrow_back.svg",
                  width: 24.w,
                  color: ColorValue.primaryColor,
                ),
                Gap(22.h),
                Center(
                  child: Column(
                    children: [
                      ProfileHeader(
                        userName: displayName,
                        userPhotoURL: photoUrl,
                        userEmail: email,
                        userPhoneNumber: phoneNumber,
                      ),
                      Gap(18.h),
                      GestureDetector(
                        onTap: () => Nav.to(context, FirestorePage()),
                        child: ProfileMenu(
                          title: "Ubah Profil",
                          icon: "assets/icons/profile.svg",
                        ),
                      ),
                      Gap(10.h),
                      ProfileMenu(
                        title: "Ganti Password",
                        icon: "assets/icons/unlock.svg",
                      ),
                      Gap(10.h),
                      ProfileMenu(
                        title: "Riwayat Penyewaan",
                        icon: "assets/icons/calendar.svg",
                      ),
                      Gap(10.h),
                      GestureDetector(
                        onTap: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: Text("Konfirmasi Menjadi Seller"),
                                  content: Text(
                                    "Apakah kamu yakin ingin mendaftar sebagai seller?\n"
                                    "Setelah itu, kamu tidak bisa lagi menggunakan aplikasi sebagai pembeli.",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () =>
                                              Navigator.of(context).pop(false),
                                      child: Text("Batal"),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(context).pop(true),
                                      child: Text("Ya, Lanjutkan"),
                                    ),
                                  ],
                                ),
                          );

                          if (confirmed == true) {
                            context.read<ProfileBloc>().add(BecomeSeller());
                          }
                        },
                        child: ProfileMenu(
                          title: "Daftar Menjadi Seller",
                          icon: "assets/icons/seller.svg",
                        ),
                      ),
                      Gap(38.h),
                      BlocConsumer<AuthBloc, AuthState>(
                        listener: (context, state) {
                          if (state is AuthSignedOut) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                        builder: (context, state) {
                          return GestureDetector(
                            onTap: () {
                              context.read<AuthBloc>().add(AuthSignOut());
                            },
                            child: ProfileMenu(
                              title: "Keluar",
                              icon: "assets/icons/logout.svg",
                              isArrow: false,
                            ),
                          );
                        },
                      ),
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
