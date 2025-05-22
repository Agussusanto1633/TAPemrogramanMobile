import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:servista/features/service/bloc/service_state.dart';

import '../../../core/scroll/scroll_behavior.dart';
import '../../../core/theme/color_value.dart';
import '../model/service_model.dart';
import '../widgets/service_card.dart';
import '../bloc/service_bloc.dart';
import '../bloc/service_event.dart';
import '../repositories/service_repository.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  @override
  void initState() {
    super.initState();
    context.read<ServiceBloc>().add(LoadAllServices());
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: ColorValue.bgFrameColor,
      body: ScrollConfiguration(
        behavior: NoOverScrollEffectBehavior(),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Sedang promo nih", style: textTheme.titleMedium),
                  BlocBuilder<ServiceBloc, ServiceState>(
                    builder: (context, state) {
                      if (state is ServiceLoading) {
                       return Container(
                            height: 134.h,
                              child: Center(child: CircularProgressIndicator()));
                      } else if (state is ServiceSuccess) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.only(top: 15.w),
                          itemCount: state.promoServices.length,
                          itemBuilder: (context, index) {
                            return ServiceCard(
                              service: state.promoServices[index],
                            );
                          },
                        );
                      } else if (state is ServiceLoadFailure) {
                        return Center(child: Text(state.message));
                      } else {
                        return Center(child: Text("No data available"));
                      }
                    },
                  ),
                  SizedBox(height: 10.w),
                  Text("Lapangan terdekat", style: textTheme.titleMedium),
                  BlocBuilder<ServiceBloc, ServiceState>(
                    builder: (context, state) {
                      if (state is ServiceLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is ServiceSuccess) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.only(top: 15.w),
                          itemCount: state.services.length,
                          itemBuilder: (context, index) {
                            return ServiceCard(service: state.services[index]);
                          },
                        );
                      } else if (state is ServiceLoadFailure) {
                        return Center(child: Text(state.message));
                      } else {
                        return Center(child: Text("No data available"));
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
