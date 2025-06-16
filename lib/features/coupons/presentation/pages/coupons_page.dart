import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_ecommerce/core/widgets/custom_app_bar.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import '../bloc/coupon_bloc.dart';
import '../widgets/widgets.dart';
import '../../core/constants/coupon_strings.dart';

class CouponsPage extends StatefulWidget {
  const CouponsPage({super.key});

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  @override
  void initState() {
    super.initState();
    // Cargar cupones al inicializar
    context.read<CouponBloc>().add(LoadMyCoupons());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: CustomAppBar(
        titleText: CouponStrings.appBarTitle,
        showBack: true,
      ),
      body: BlocListener<CouponBloc, CouponState>(
        listener: (context, state) {
          if (state is CouponApplied) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.primary,
              ),
            );
            // Volver al carrito o página anterior
            Navigator.of(context).pop(state.appliedCoupon);
          } else if (state is CouponError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state is CouponRemoved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.primary,
              ),
            );
          }
        },
        child: Column(
          children: [
            // Widget para aplicar cupón manualmente
            const CouponApplyWidget(),
            
            // Filtros de cupones
            const CouponFilterWidget(),
            
            // Lista de cupones
            const Expanded(
              child: CouponListWidget(),
            ),
          ],
        ),
      ),
    );
  }
} 