import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/features/coupons/domain/entities/coupon_entity.dart';

/// Página simple de cupones que muestra cupones mock sin usar BLoC
class CouponsSimplePage extends StatelessWidget {
  const CouponsSimplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        titleText: 'Mis Cupones',
        showBack: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final mockCoupons = _getMockCoupons();
    
    return Padding(
      padding: const EdgeInsets.all(AppDimens.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Cupones Disponibles',
            style: AppTextStyles.heading,
          ),
          const SizedBox(height: AppDimens.vSpace8),
          Text(
            'Usa estos cupones para obtener descuentos en tus compras',
            style: AppTextStyles.body.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: AppDimens.vSpace24),
          
          // Lista de cupones
          Expanded(
            child: ListView.builder(
              itemCount: mockCoupons.length,
              itemBuilder: (context, index) {
                final coupon = mockCoupons[index];
                return _buildCouponCard(coupon);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponCard(CouponEntity coupon) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.vSpace16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.primary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header del cupón
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    coupon.code,
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                _buildStatusChip(coupon),
              ],
            ),
            
            const SizedBox(height: AppDimens.vSpace12),
            
            // Descripción
            Text(
              coupon.description,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            
            const SizedBox(height: AppDimens.vSpace8),
            
            // Detalles del descuento
            Row(
              children: [
                Icon(
                  Icons.local_offer,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  _getDiscountText(coupon),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppDimens.vSpace4),
            
                         // Mínimo de compra
             if (coupon.minimumAmount != null && coupon.minimumAmount! > 0) ...[
              Row(
                children: [
                  Icon(
                    Icons.shopping_cart,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                                     Text(
                     'Compra mínima: \$${coupon.minimumAmount!.toStringAsFixed(2)}',
                     style: AppTextStyles.caption.copyWith(
                       color: Colors.grey[600],
                     ),
                   ),
                ],
              ),
              const SizedBox(height: AppDimens.vSpace4),
            ],
            
            // Fecha de expiración
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                                 Text(
                   'Válido hasta: ${_formatDate(coupon.validUntil)}',
                   style: AppTextStyles.caption.copyWith(
                     color: Colors.grey[600],
                   ),
                 ),
              ],
            ),
            
            const SizedBox(height: AppDimens.vSpace12),
            
            // Botón de acción
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: coupon.status == CouponStatus.active
                    ? () => _copyCouponCode(coupon.code)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  coupon.status == CouponStatus.active
                      ? 'Copiar Código'
                      : _getStatusText(coupon.status),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(CouponEntity coupon) {
    Color color;
    String text;
    
    switch (coupon.status) {
      case CouponStatus.active:
        color = Colors.green;
        text = 'Activo';
        break;
      case CouponStatus.used:
        color = Colors.orange;
        text = 'Usado';
        break;
      case CouponStatus.expired:
        color = Colors.red;
        text = 'Expirado';
        break;
      case CouponStatus.inactive:
        color = Colors.grey;
        text = 'Inactivo';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

     String _getDiscountText(CouponEntity coupon) {
     if (coupon.type == CouponType.percentage) {
       return '${coupon.value.toInt()}% de descuento';
     } else {
       return '\$${coupon.value.toStringAsFixed(2)} de descuento';
     }
   }

  String _getStatusText(CouponStatus status) {
    switch (status) {
      case CouponStatus.used:
        return 'Ya Usado';
      case CouponStatus.expired:
        return 'Expirado';
      case CouponStatus.inactive:
        return 'No Disponible';
      default:
        return 'Copiar Código';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _copyCouponCode(String code) {
    // TODO: Implementar copia al portapapeles
    // Clipboard.setData(ClipboardData(text: code));
    // Mostrar snackbar de confirmación
  }

     List<CouponEntity> _getMockCoupons() {
     final now = DateTime.now();
     return [
       CouponEntity(
         id: '1',
         code: 'WELCOME20',
         name: 'Bienvenida',
         description: 'Descuento de bienvenida para nuevos usuarios',
         type: CouponType.percentage,
         value: 20.0,
         minimumAmount: 50.0,
         validFrom: now.subtract(const Duration(days: 1)),
         validUntil: now.add(const Duration(days: 30)),
         isActive: true,
         isUsed: false,
         currentUses: 0,
         maxUses: 1,
         createdAt: now,
         updatedAt: now,
       ),
       CouponEntity(
         id: '2',
         code: 'SAVE15',
         name: 'Ahorro Fijo',
         description: 'Ahorra \$15 en tu próxima compra',
         type: CouponType.fixed,
         value: 15.0,
         minimumAmount: 100.0,
         validFrom: now.subtract(const Duration(days: 1)),
         validUntil: now.add(const Duration(days: 15)),
         isActive: true,
         isUsed: false,
         currentUses: 0,
         maxUses: 1,
         createdAt: now,
         updatedAt: now,
       ),
       CouponEntity(
         id: '3',
         code: 'SUMMER25',
         name: 'Verano',
         description: 'Descuento especial de verano',
         type: CouponType.percentage,
         value: 25.0,
         minimumAmount: 75.0,
         validFrom: now.subtract(const Duration(days: 10)),
         validUntil: now.subtract(const Duration(days: 5)),
         isActive: false,
         isUsed: false,
         currentUses: 1,
         maxUses: 1,
         createdAt: now,
         updatedAt: now,
       ),
       CouponEntity(
         id: '4',
         code: 'FLASH10',
         name: 'Flash',
         description: 'Oferta flash - \$10 de descuento',
         type: CouponType.fixed,
         value: 10.0,
         minimumAmount: 30.0,
         validFrom: now.subtract(const Duration(days: 1)),
         validUntil: now.add(const Duration(days: 7)),
         isActive: true,
         isUsed: true,
         currentUses: 1,
         maxUses: 1,
         usedAt: now.subtract(const Duration(hours: 2)),
         createdAt: now,
         updatedAt: now,
       ),
     ];
   }
} 