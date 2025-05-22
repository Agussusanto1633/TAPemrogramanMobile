import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:servista/features/auth/login/bloc/auth_bloc.dart';
import 'package:servista/features/auth/login/bloc/auth_service.dart';
import 'package:servista/features/auth/login/view/page/login_otp_page.dart';
import 'package:servista/features/auth/login/view/page/login_page.dart';
import 'package:servista/features/auth/login/view/page/login_phone_page.dart';
import 'package:servista/features/booking/page/detail_booking_page.dart';
import 'package:servista/features/home/page/search_service_page.dart';
import 'package:servista/features/payment/page/payment_page.dart';
import 'package:servista/features/service/pages/detail_service_page.dart';
import 'package:servista/features/service/pages/service_booking_page.dart';
import 'package:servista/features/splash/view/page/splash_page.dart';
import 'package:servista/features/home/page/home_page.dart';
import 'package:servista/firestore/firestore_page.dart';
import 'package:servista/home_dummy.dart';

import 'core/nav_bar/nav_bar.dart';
import 'core/theme/app_style.dart';
import 'core/theme/app_theme.dart';
import 'features/profile/page/profile_page.dart';
import 'features/service/bloc/service_bloc.dart';
import 'features/service/cubit/service_cubit.dart';
import 'features/service/repositories/service_repository.dart';
import 'firebase_options.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  deviceOrientation();
  statusBarDarkStyle();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('id_ID', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
              BlocProvider(create: (context) => AuthBloc(AuthService()),)
        BlocProvider(
          create: (_) => ServiceBloc(serviceRepository: ServiceRepository()),
        ),
        BlocProvider(create: (_) => ServiceCubit()),

      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 640),
        minTextAdapt: true,
        builder: (_, child) {
          return MaterialApp(
            title: 'Servista',
            debugShowCheckedModeBanner: false,
            theme: AppThemeData.getThemeLight(),
            home: child,
          );
        },
        child: AuthenticationPage(),
      ),
    );
  }
}
