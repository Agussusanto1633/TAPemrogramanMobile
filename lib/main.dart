import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:servista/admin/features/transaction/repository/admin_payment_repository.dart';
import 'package:servista/features/auth/login/bloc/auth_bloc.dart';
import 'package:servista/features/auth/login/bloc/auth_service.dart';
import 'package:servista/features/payment/bloc/payment_bloc.dart';
import 'package:servista/features/splash/view/page/splash_page.dart';

import 'core/theme/app_style.dart';
import 'core/theme/app_theme.dart';
import 'features/booking/bloc/booking_bloc.dart';
import 'features/payment/cubit/payment_cubit.dart';
import 'features/profile/bloc/profile_bloc.dart';
import 'features/service/bloc/service_bloc.dart';
import 'features/service/cubit/service_cubit.dart';
import 'features/service/repositories/service_repository.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  deviceOrientation();
  statusBarDarkStyle();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('id_ID', null);
  await Future.delayed(const Duration(milliseconds: 1));
  FlutterNativeSplash.remove();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(AuthService())),
        BlocProvider(
          create: (_) => ServiceBloc(serviceRepository: ServiceRepository()),
        ),
        BlocProvider(create: (_) => ServiceCubit()),
        BlocProvider(create: (_) => PaymentCubit()),
        BlocProvider(
          create: (_) => BookingBloc(firestore: FirebaseFirestore.instance),
        ),
        BlocProvider(create: (context) => ProfileBloc()),
        BlocProvider(
          create: (context) => PaymentBloc(
            PaymentRepository()
          ),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 640),
        minTextAdapt: true,
        builder: (_, child) {
          return MaterialApp(
            title: 'koneksijasa',
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
