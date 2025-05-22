import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servista/core/custom_widgets/custom_button_widget.dart';
import 'package:servista/core/nav/nav.dart';
import 'package:servista/core/nav_bar/nav_bar.dart';
import 'package:servista/core/theme/color_value.dart';
import 'package:servista/features/auth/login/bloc/auth_event.dart';
import 'package:servista/features/home/page/home_page.dart';

import '../../login/bloc/auth_bloc.dart';
import '../../login/bloc/auth_state.dart';

class RegisterEmailPage extends StatefulWidget {
  const RegisterEmailPage({Key? key}) : super(key: key);

  @override
  State<RegisterEmailPage> createState() => _RegisterEmailPageState();
}

class _RegisterEmailPageState extends State<RegisterEmailPage> {
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController noHpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              } else if (state is AuthSignedIn) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Register berhasil!")),
                );
                Nav.toRemoveUntil(context,NavBar());
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Gap(150.h),
                    Text(
                      "Servista",
                      style: GoogleFonts.onest(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.w700,
                        color: ColorValue.darkColor,
                      ),
                    ),
                    Text(
                      "Create an Account",
                      style: GoogleFonts.mulish(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff3F414E),
                      ),
                    ),
                    Gap(30.h),

                    _buildTextField(
                      controller: displayNameController,
                      label: "Nama Lengkap",
                      keyboardType: TextInputType.name,
                    ),
                    Gap(20.h),

                    _buildTextField(
                      controller: emailController,
                      label: "Email",
                      keyboardType: TextInputType.emailAddress,
                    ),
                    Gap(20.h),

                    _buildTextField(
                      controller: passwordController,
                      label: "Password",
                      isPassword: true,
                    ),
                    Gap(20.h),

                    _buildPhoneTextField(),
                    Gap(30.h),

                    state is AuthLoading
                        ? const CircularProgressIndicator()
                        : GestureDetector(
                          onTap: () {
                            final displayName =
                                displayNameController.text.trim();
                            final email = emailController.text.trim();
                            final password = passwordController.text.trim();
                            final noHp = noHpController.text.trim();
                            if (displayName.isEmpty ||
                                email.isEmpty ||
                                password.isEmpty ||
                                noHp.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Semua field wajib diisi'),
                                ),
                              );
                              return;
                            }

                            context.read<AuthBloc>().add(
                              AuthRegisterWithEmail(
                                displayName: displayName,
                                email: email,
                                password: password,
                                noHp: noHp,
                              ),
                            );
                          },

                          child: CustomButtonWidget(label: "Register"),
                        ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      style: GoogleFonts.poppins(
        fontSize: 14.sp,
        color: ColorValue.darkColor,
        fontWeight: FontWeight.w600,
      ),
      cursorColor: ColorValue.darkColor,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14.sp),
        floatingLabelStyle: GoogleFonts.poppins(
          color: ColorValue.darkColor,
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xffDFDFDF), width: 2),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xffDFDFDF), width: 2),
        ),
      ),
    );
  }

  Widget _buildPhoneTextField() {
    return TextField(
      controller: noHpController,
      keyboardType: TextInputType.phone,
      maxLength: 13,
      onChanged: (value) {
      },
      style: GoogleFonts.poppins(
        fontSize: 14.sp,
        color: ColorValue.darkColor,
        fontWeight: FontWeight.w600,
      ),
      cursorColor: ColorValue.darkColor,
      buildCounter:
          (
            context, {
            required currentLength,
            required isFocused,
            required maxLength,
          }) => null,
      decoration: InputDecoration(
        labelText: "No HP",
        labelStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14.sp),
        floatingLabelStyle: GoogleFonts.poppins(
          color: ColorValue.darkColor,
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xffDFDFDF), width: 2),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xffDFDFDF), width: 2),
        ),
      ),
    );
  }
}
