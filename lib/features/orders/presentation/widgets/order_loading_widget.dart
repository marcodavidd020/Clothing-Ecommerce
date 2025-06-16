import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';

class OrderLoadingWidget extends StatelessWidget {
  const OrderLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Indicador de carga personalizado
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1200),
            builder: (context, value, child) {
              return Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Círculo de progreso
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                        strokeWidth: 3,
                      ),
                    ),
                    // Icono central
                    Icon(
                      Icons.receipt_long_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ],
                ),
              );
            },
          ),
          
          const SizedBox(height: 32),
          
          // Texto de carga con animación
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Column(
                  children: [
                    Text(
                      'Cargando tus órdenes...',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      'Esto puede tomar unos segundos',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          
          const SizedBox(height: 40),
          
          // Indicadores de progreso adicionales (skeleton loading)
          _buildSkeletonCards(),
        ],
      ),
    );
  }

  Widget _buildSkeletonCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: List.generate(3, (index) {
          return TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 600 + (index * 200)),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: _buildSkeletonCard(),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header skeleton
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShimmerContainer(120, 16),
                    const SizedBox(height: 4),
                    _buildShimmerContainer(80, 12),
                  ],
                ),
                _buildShimmerContainer(80, 24, borderRadius: 12),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Content skeleton
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  _buildShimmerContainer(100, 14),
                  const Spacer(),
                  _buildShimmerContainer(60, 14),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Buttons skeleton
            Row(
              children: [
                Expanded(
                  child: _buildShimmerContainer(double.infinity, 36, borderRadius: 8),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildShimmerContainer(double.infinity, 36, borderRadius: 8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerContainer(
    double width,
    double height, {
    double borderRadius = 4,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.3, end: 0.7),
      duration: const Duration(milliseconds: 1000),
      builder: (context, value, child) {
        return AnimatedBuilder(
          animation: Tween<double>(begin: 0.3, end: 0.7).animate(
            CurvedAnimation(
              parent: AlwaysStoppedAnimation(value),
              curve: Curves.easeInOut,
            ),
          ),
          builder: (context, child) {
            return Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Colors.grey[300]?.withValues(alpha: value),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            );
          },
        );
      },
    );
  }
} 