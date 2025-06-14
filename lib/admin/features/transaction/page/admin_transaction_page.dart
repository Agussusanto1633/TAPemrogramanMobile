import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/theme/color_value.dart';
import '../../../../features/payment/bloc/payment_bloc.dart';
import '../../../../features/payment/bloc/payment_event.dart';
import '../../../../features/payment/cubit/payment_cubit.dart';
import '../repository/admin_payment_repository.dart';

class AdminTransactionPage extends StatefulWidget {
  const AdminTransactionPage({super.key});

  @override
  State<AdminTransactionPage> createState() => _AdminTransactionPageState();
}

class _AdminTransactionPageState extends State<AdminTransactionPage> {
  String sellerId = '';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    sellerId = prefs.getString('user_uid') ?? '';
    context.read<PaymentBloc>().add(FetchPaymentsBySeller(sellerId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transaksi Seller")),
      body: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state) {
          if (state is PaymentLoading) {
            print("Loading payments for seller: $sellerId");
            return const Center(child: CircularProgressIndicator());
          } else if (state is PaymentLoaded) {
            if (state.payments.isEmpty) {
              return const Center(child: Text("Belum ada transaksi."));
            }
            return ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: state.payments.length,
              itemBuilder: (context, index) {
                final p = state.payments[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tanggal: ${p.date}",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "Jam: ${p.startTime} - ${p.endTime}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "Harga: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(p.price)}",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: ColorValue.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Text(
                              "Status: ",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: p.status.toLowerCase() == 'selesai'
                                    ? Colors.green[100]
                                    : Colors.orange[100],
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                p.status,
                                style: TextStyle(
                                  color: p.status.toLowerCase() == 'selesai'
                                      ? Colors.green
                                      : Colors.orange,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is PaymentError) {
            return Center(child: Text("Gagal: ${state.message}"));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
