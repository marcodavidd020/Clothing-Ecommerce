import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_application_ecommerce/features/home/presentation/helpers/category_ui_helper.dart';

/// Widget de esqueleto para la cuadrícula de productos con efecto shimmer
class ProductsGridSkeletonWidget extends StatelessWidget {
  /// Constructor
  const ProductsGridSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildProductsGridSkeleton(context);
  }

  /// Construye el esqueleto de la cuadrícula con efecto shimmer
  Widget _buildProductsGridSkeleton(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: CategoryUIHelper.getResponsiveGridDelegate(context),
        itemCount: 6, // Mostrar 6 placeholders
        itemBuilder: (context, index) {
          return _buildProductItemSkeleton();
        },
      ),
    );
  }

  /// Construye un item de producto skeleton con shimmer
  Widget _buildProductItemSkeleton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.transparent, blurRadius: 0)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 12,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 16,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
