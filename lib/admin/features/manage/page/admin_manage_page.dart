import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:servista/core/theme/color_value.dart';
import 'package:servista/features/service/bloc/service_bloc.dart';
import 'package:servista/features/service/bloc/service_state.dart';
import 'package:servista/features/service/bloc/service_event.dart';

import '../../../../core/transparent_appbar/transparent_appbar.dart';
import '../widgets/card_crud.dart';
import 'admin_create_service_page.dart';
import '../../../../core/theme/app_font_weight.dart';

class AdminManagePage extends StatefulWidget {
  const AdminManagePage({Key? key}) : super(key: key);

  @override
  State<AdminManagePage> createState() => _AdminManagePageState();
}

class _AdminManagePageState extends State<AdminManagePage> {
  String sellerId = '';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      sellerId = prefs.getString('user_uid') ?? '';
    });
    context.read<ServiceBloc>().add(LoadSellerServices(sellerId: sellerId));
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: transparentAppBarWidget(isDarkStyle: true),

      backgroundColor: ColorValue.bgFrameColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Text(
                    'Layanan Kamu',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: AppFontWeight.bold,
                      color: ColorValue.darkColor,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminCreateServicePage(
                            sellerId: sellerId,
                          ),
                        ),
                      );

                      if (result == true) {
                        context
                            .read<ServiceBloc>()
                            .add(LoadSellerServices(sellerId: sellerId));
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: ColorValue.primaryColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'Tambah Service',
                        style: textTheme.bodyLarge?.copyWith(
                          fontSize: 10.sp,
                          fontWeight: AppFontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<ServiceBloc, ServiceState>(
              builder: (context, state) {
                if (state is ServiceLoading) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                } else if (state is ServiceSuccess) {
                  if (state.services.isEmpty) {
                    return Expanded(child: Center(child: Text('Tidak ada service milik Anda.')));
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.services.length,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 12.h,
                      ),
                      itemBuilder: (context, index) {
                        final service = state.services[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: YourVerticalServiceCard(
                            service: service,
                            onTapDelete: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Hapus Layanan'),
                                  content: const Text(
                                      'Apakah kamu yakin ingin menghapus layanan ini?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('Hapus'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                context.read<ServiceBloc>().add(
                                  DeleteService(
                                    serviceId: service.id,
                                    sellerId: sellerId,
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
                  );
                } else if (state is ServiceLoadFailure) {
                  return Center(
                      child: Text('Gagal load service: ${state.message}'));
                }

                return const SizedBox(); // state awal
              },
            ),
          ],
        ),
      ),
    );
  }
}
