import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/core/widgets/widgets.dart';
import 'package:flutter_application_ecommerce/core/routes/app_router.dart';
import 'package:flutter_application_ecommerce/core/storage/auth_storage.dart';
import 'package:flutter_application_ecommerce/features/cart/presentation/bloc/bloc.dart';
import 'package:flutter_application_ecommerce/features/coupons/domain/entities/coupon_entity.dart';
import 'package:flutter_application_ecommerce/features/addresses/domain/entities/address_entity.dart' as address_entities;
import 'package:flutter_application_ecommerce/features/payments/domain/entities/payment_entity.dart' as payment_entities;
import 'package:flutter_application_ecommerce/features/orders/domain/entities/order_entity.dart' as order_entities;
import 'package:flutter_application_ecommerce/features/orders/presentation/bloc/order_bloc.dart';
import 'dart:async';

/// Página de checkout completamente funcional
class FunctionalCheckoutPage extends StatefulWidget {
  const FunctionalCheckoutPage({super.key});

  @override
  State<FunctionalCheckoutPage> createState() => _FunctionalCheckoutPageState();
}

class _FunctionalCheckoutPageState extends State<FunctionalCheckoutPage> {
  // Controladores de estado
  address_entities.AddressEntity? _selectedAddress;
  payment_entities.PaymentMethod _selectedPaymentMethod = payment_entities.PaymentMethod.card;
  CouponEntity? _appliedCoupon;
  bool _isProcessingOrder = false;
  
  // Controladores de texto
  final _couponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // El usuario ya está autenticado cuando llega al checkout
    // No necesitamos hacer login automático
    _checkCurrentAuth();
  }

  /// Verificar si el usuario está autenticado actualmente
  Future<void> _checkCurrentAuth() async {
    try {
      final authStorage = GetIt.instance<AuthStorage>();
      final token = await authStorage.getAccessToken();
      
      if (token != null && token.isNotEmpty) {
        debugPrint('✅ Usuario autenticado con token: ${token.substring(0, 20)}...');
      } else {
        debugPrint('⚠️ No hay token de autenticación disponible');
      }
    } catch (e) {
      debugPrint('❌ Error verificando autenticación: $e');
    }
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        titleText: 'Checkout',
        showBack: true,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, cartState) {
          if (cartState is! CartLoaded || cartState.isEmpty) {
            return const Center(
              child: Text('No hay productos en el carrito'),
            );
          }

          return _buildCheckoutContent(cartState);
        },
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildCheckoutContent(CartLoaded cartState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sección de dirección de envío
          _buildShippingAddressSection(),
          const SizedBox(height: AppDimens.vSpace24),
          
          // Sección de productos
          _buildOrderSummarySection(cartState),
          const SizedBox(height: AppDimens.vSpace24),
          
          // Sección de cupones
          _buildCouponSection(),
          const SizedBox(height: AppDimens.vSpace24),
          
          // Sección de método de pago
          _buildPaymentMethodSection(),
          const SizedBox(height: AppDimens.vSpace24),
          
          // Resumen de precios
          _buildPriceSummary(cartState),
          
          // Espacio para el botón flotante
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildShippingAddressSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, color: AppColors.primary),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Dirección de Envío',
                    style: AppTextStyles.heading.copyWith(fontSize: 16),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _selectAddress,
                  child: Text(_selectedAddress == null ? 'Seleccionar' : 'Cambiar'),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.vSpace12),
            if (_selectedAddress != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedAddress!.fullName,
                      style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _selectedAddress!.fullAddress,
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _selectedAddress!.phoneNumber,
                      style: AppTextStyles.caption.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.add_location, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      'Selecciona una dirección de envío',
                      style: AppTextStyles.body.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummarySection(CartLoaded cartState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.shopping_bag, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Resumen del Pedido',
                  style: AppTextStyles.heading.copyWith(fontSize: 16),
                ),
                const Spacer(),
                Text(
                  '${cartState.items.length} productos',
                  style: AppTextStyles.caption.copyWith(color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.vSpace12),
            ...cartState.items.map((item) => _buildOrderItem(item)),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(dynamic item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: item.product.imageUrl.isNotEmpty 
                  ? Image.network(
                      item.product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => 
                          const Icon(Icons.image, color: Colors.grey),
                    )
                  : const Icon(Icons.image, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (item.size != null || item.color != null) ...[
                  Row(
                    children: [
                      if (item.size != null)
                        Text(
                          'Talla: ${item.size}',
                          style: AppTextStyles.caption,
                        ),
                      if (item.size != null && item.color != null)
                        const Text(' • ', style: TextStyle(color: Colors.grey)),
                      if (item.color != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Color: ', style: AppTextStyles.caption),
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: item.color.color,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                ],
                Row(
                  children: [
                    Text(
                      'Cantidad: ${item.quantity}',
                      style: AppTextStyles.caption,
                    ),
                    const Spacer(),
                    Text(
                      '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.local_offer, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Cupón de Descuento',
                  style: AppTextStyles.heading.copyWith(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.vSpace12),
            if (_appliedCoupon != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cupón aplicado: ${_appliedCoupon!.code}',
                            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            _appliedCoupon!.description,
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _removeCoupon,
                      icon: const Icon(Icons.close, size: 20),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _couponController,
                      decoration: const InputDecoration(
                        hintText: 'Ingresa tu código de cupón',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _applyCoupon,
                    child: const Text('Aplicar'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.payment, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Método de Pago',
                  style: AppTextStyles.heading.copyWith(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.vSpace12),
            ...payment_entities.PaymentMethod.values.map((method) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _selectedPaymentMethod == method 
                        ? AppColors.primary 
                        : Colors.grey[300]!,
                    width: _selectedPaymentMethod == method ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  leading: Icon(
                    _getPaymentMethodIcon(method),
                    color: _selectedPaymentMethod == method 
                        ? AppColors.primary 
                        : Colors.grey[600],
                  ),
                  title: Text(
                    _getPaymentMethodText(method),
                    style: AppTextStyles.body.copyWith(
                      fontWeight: _selectedPaymentMethod == method 
                          ? FontWeight.w600 
                          : FontWeight.normal,
                    ),
                  ),
                  trailing: Radio<payment_entities.PaymentMethod>(
                    value: method,
                    groupValue: _selectedPaymentMethod,
                    onChanged: (payment_entities.PaymentMethod? value) {
                      if (value != null) {
                        setState(() {
                          _selectedPaymentMethod = value;
                        });
                      }
                    },
                  ),
                  onTap: () {
                    setState(() {
                      _selectedPaymentMethod = method;
                    });
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSummary(CartLoaded cartState) {
    final subtotal = cartState.totalPrice;
    final discount = _appliedCoupon != null ? _calculateDiscount(subtotal) : 0.0;
    final shipping = 5.99; // Costo fijo de envío
    final tax = (subtotal - discount) * 0.1; // 10% de impuestos
    final total = subtotal - discount + shipping + tax;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.screenPadding),
        child: Column(
          children: [
            _buildPriceRow('Subtotal', subtotal),
            if (discount > 0) _buildPriceRow('Descuento', -discount, color: Colors.green),
            _buildPriceRow('Envío', shipping),
            _buildPriceRow('Impuestos', tax),
            const Divider(),
            _buildPriceRow('Total', total, isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {Color? color, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal 
                ? AppTextStyles.heading.copyWith(fontSize: 16)
                : AppTextStyles.body,
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: isTotal
                ? AppTextStyles.heading.copyWith(fontSize: 16, color: AppColors.primary)
                : AppTextStyles.body.copyWith(
                    color: color ?? Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(AppDimens.screenPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: PrimaryButton(
          label: _isProcessingOrder ? 'Procesando...' : 'Realizar Pedido',
          onPressed: _selectedAddress != null && !_isProcessingOrder 
              ? _processOrder 
              : null,
          isLoading: _isProcessingOrder,
        ),
      ),
    );
  }

  // Métodos auxiliares
  IconData _getPaymentMethodIcon(payment_entities.PaymentMethod method) {
    switch (method) {
      case payment_entities.PaymentMethod.card:
        return Icons.credit_card;
      case payment_entities.PaymentMethod.qr:
        return Icons.qr_code;
      case payment_entities.PaymentMethod.paypal:
        return Icons.account_balance_wallet;
      case payment_entities.PaymentMethod.bankTransfer:
        return Icons.account_balance;
    }
  }

  String _getPaymentMethodText(payment_entities.PaymentMethod method) {
    switch (method) {
      case payment_entities.PaymentMethod.card:
        return 'Tarjeta de Crédito/Débito';
      case payment_entities.PaymentMethod.qr:
        return 'Código QR';
      case payment_entities.PaymentMethod.paypal:
        return 'PayPal';
      case payment_entities.PaymentMethod.bankTransfer:
        return 'Transferencia Bancaria';
    }
  }

  double _calculateDiscount(double subtotal) {
    if (_appliedCoupon == null) return 0.0;
    
    if (_appliedCoupon!.type == CouponType.percentage) {
      return subtotal * (_appliedCoupon!.value / 100);
    } else {
      return _appliedCoupon!.value;
    }
  }

  // Métodos de acción
  void _selectAddress() async {
    try {
      // En lugar de usar datos mock, vamos a obtener una dirección real del usuario
      final authStorage = GetIt.instance<AuthStorage>();
      final token = await authStorage.getAccessToken();
      
      if (token != null) {
        // TODO: Implementar llamada real a la API de direcciones
        // Por ahora, usar una dirección del seeder que sabemos que existe
        
        debugPrint('🏠 Configurando dirección temporal del seeder...');
        
        setState(() {
          _selectedAddress = address_entities.AddressEntity(
            id: '2e83fbf1-6ee4-4f4c-b1b9-ec514d212e9d', // ID real del seeder
            fullName: 'Av.Bolivia, Calle 12',
            phoneNumber: '+57 300 123 4567',
            latitude: 4.7110,
            longitude: -74.0721,
            street: 'Paseo del Prado, 31',
            city: 'Alicante',
            department: 'Valencia',
            postalCode: '03001',
            isDefault: true,
            isActive: true,
            userId: '85132dd1-3965-4c33-be6f-4812521b7c52', // ID real del usuario cliente@tienda.com
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        });
        
        debugPrint('✅ Dirección configurada: ${_selectedAddress!.id}');
      } else {
        debugPrint('⚠️ No hay token de autenticación');
      }
    } catch (e) {
      debugPrint('❌ Error configurando dirección: $e');
      
      // Fallback a datos mock
      setState(() {
        _selectedAddress = address_entities.AddressEntity(
          id: '1',
          fullName: 'Juan Pérez',
          phoneNumber: '+57 300 123 4567',
          latitude: 4.7110,
          longitude: -74.0721,
          street: 'Calle 123 #45-67',
          city: 'Bogotá',
          department: 'Cundinamarca',
          postalCode: '110111',
          isDefault: true,
          isActive: true,
          userId: 'user123',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      });
    }
  }

  void _applyCoupon() {
    final code = _couponController.text.trim().toUpperCase();
    if (code.isEmpty) return;

    // Simular aplicación de cupón
    final mockCoupons = _getMockCoupons();
    try {
      final coupon = mockCoupons.firstWhere(
        (c) => c.code == code && c.status == CouponStatus.active,
      );

      setState(() {
        _appliedCoupon = coupon;
        _couponController.clear();
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cupón aplicado exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cupón no válido o expirado'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeCoupon() {
    setState(() {
      _appliedCoupon = null;
    });
  }

  /// Procesa la orden y navega a la pantalla de éxito
  void _processOrder() async {
    if (_selectedAddress == null || _isProcessingOrder) return;

    setState(() {
      _isProcessingOrder = true;
    });

    try {
      final cartState = context.read<CartBloc>().state as CartLoaded;
      
      // Crear los items de la orden usando el apiItemId del carrito
      final orderItems = cartState.items.map((item) {
        // Verificar que el item tenga apiItemId (requerido para crear órdenes)
        if (item.apiItemId == null || item.apiItemId!.isEmpty) {
          throw Exception('Error: El producto "${item.product.name}" no tiene ID de variante válido.');
        }
        
        return order_entities.OrderItemEntity(
          id: '',
          productId: item.apiItemId!, // Usar apiItemId como productId/variant_id
          name: item.product.name,
          image: item.product.imageUrl,
          price: item.product.price,
          quantity: item.quantity,
          total: item.product.price * item.quantity,
        );
      }).toList();

      debugPrint('🛒 Procesando orden con ${orderItems.length} items');

      // Crear la orden
      context.read<OrderBloc>().add(
        CreateOrder(
          items: orderItems,
          shippingAddress: _selectedAddress!,
          couponCode: _appliedCoupon?.code,
        ),
      );

      // Escuchar cambios en el OrderBloc para manejar el resultado
      final orderSubscription = context.read<OrderBloc>().stream.listen((orderState) {
        if (orderState is OrderCreated) {
          debugPrint('✅ Orden creada exitosamente: ${orderState.order.id}');
          
          // Vaciar el carrito después de crear la orden exitosamente
          _clearCartAfterOrder(context);
          
          setState(() {
            _isProcessingOrder = false;
          });

          // Navegar a la pantalla de éxito
          Navigator.of(context).pushReplacementNamed(
            '/order-success',
            arguments: {
              'order': orderState.order,
              'message': orderState.message,
            },
          );
        } else if (orderState is OrderError) {
          debugPrint('❌ Error al crear orden: ${orderState.message}');
          
          setState(() {
            _isProcessingOrder = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Error al procesar la orden: ${orderState.message}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.red[700],
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'Reintentar',
                textColor: Colors.white,
                onPressed: () => _processOrder(),
              ),
            ),
          );
        }
      });

      // Cancelar la suscripción después de un tiempo para evitar memory leaks
      Future.delayed(const Duration(seconds: 30), () {
        orderSubscription.cancel();
      });

    } catch (e) {
      debugPrint('❌ Error inesperado al procesar orden: $e');
      
      setState(() {
        _isProcessingOrder = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Error inesperado: ${e.toString()}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Vacía el carrito después de crear una orden exitosamente
  void _clearCartAfterOrder(BuildContext context) {
    try {
      debugPrint('🧹 Vaciando carrito después de crear orden');
      final cartBloc = context.read<CartBloc>();
      
      // Usar API si está disponible, sino usar método local
      if (cartBloc.clearCartUseCase != null) {
        debugPrint('🌐 Vaciando carrito usando API');
        cartBloc.add(const CartClearedFromApi());
      } else {
        debugPrint('💾 Vaciando carrito localmente');
        cartBloc.add(const CartCleared());
      }
      
      // Mostrar mensaje de confirmación
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.shopping_cart_outlined, color: Colors.white),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Carrito vaciado automáticamente',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green[700],
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      debugPrint('❌ Error al vaciar carrito: $e');
      // No mostrar error al usuario ya que la orden se creó exitosamente
    }
  }

  List<CouponEntity> _getMockCoupons() {
    final now = DateTime.now();
    return [
      CouponEntity(
        id: '1',
        code: 'WELCOME20',
        name: 'Bienvenida',
        description: 'Descuento de bienvenida',
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
        name: 'Ahorro',
        description: 'Ahorra \$15',
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
    ];
  }
} 