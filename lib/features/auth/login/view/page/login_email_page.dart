import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servista/core/custom_widgets/custom_button_widget.dart';
import 'package:servista/core/nav/nav.dart';
import 'package:servista/core/theme/color_value.dart';
import 'package:servista/features/auth/login/bloc/auth_bloc.dart';
import 'package:servista/features/auth/login/bloc/auth_event.dart';
import 'package:servista/features/auth/login/bloc/auth_state.dart';
import 'package:servista/features/auth/register/view/register_email_page.dart';
import '../../../../../core/nav_bar/nav_bar.dart';

class LoginEmailPage extends StatefulWidget {
  const LoginEmailPage({super.key});

  @override
  State<LoginEmailPage> createState() => _LoginEmailPageState();
}

class _LoginEmailPageState extends State<LoginEmailPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              } else if (state is AuthSignedIn) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Login berhasil!")),
                );
                Nav.toRemoveUntil(context, const NavBar());
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                      "Welcome Back",
                      style: GoogleFonts.mulish(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff3F414E),
                      ),
                    ),
                    Gap(30.h),

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
                    Gap(30.h),

                    state is AuthLoading
                        ? const CircularProgressIndicator()
                        : GestureDetector(
                      onTap: () {
                        final email = emailController.text.trim();
                        final password = passwordController.text.trim();

                        if (email.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                              Text('Semua field wajib diisi'),
                            ),
                          );
                          return;
                        }

                        context.read<AuthBloc>().add(
                          AuthSignInWithEmail(
                            email: email,
                            password: password,
                          ),
                        );
                      },
                      child: CustomButtonWidget(label: "Login"),
                    ),
                    Gap(20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Belum punya akun? ",
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Nav.to(context, const RegisterEmailPage());
                          },
                          child: Text(
                            "Daftar",
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorValue.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(30.h),
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
}
