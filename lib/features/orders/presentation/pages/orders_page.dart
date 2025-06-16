import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import '../bloc/order_bloc.dart';
import '../widgets/order_card_widget.dart';
import '../widgets/order_empty_state_widget.dart';
import '../widgets/order_loading_widget.dart';
import '../widgets/order_error_widget.dart';
import '../pages/order_details_page.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<OrderBloc>()..add(const LoadMyOrders()),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.receipt_long_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text('Mis Órdenes'),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {
                context.read<OrderBloc>().add(const LoadMyOrders());
              },
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Actualizar',
            ),
          ],
        ),
        body: BlocConsumer<OrderBloc, OrderState>(
          listener: (context, state) {
            if (state is OrderError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _getErrorMessage(state.message),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.orange[700],
                  behavior: SnackBarBehavior.floating,
                  action: SnackBarAction(
                    label: 'Reintentar',
                    textColor: Colors.white,
                    onPressed: () {
                      context.read<OrderBloc>().add(const LoadMyOrders());
                    },
                  ),
                ),
              );
            } else if (state is OrderCreated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.green[700],
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is OrderLoading) {
              return const OrderLoadingWidget();
            }

            if (state is OrderError) {
              return OrderErrorWidget(
                message: state.message,
                onRetry: () {
                  context.read<OrderBloc>().add(const LoadMyOrders());
                },
              );
            }

            if (state is OrderLoaded) {
              if (state.orders.isEmpty) {
                return const OrderEmptyStateWidget();
              }

              return _buildOrdersList(context, state.orders);
            }

            return const OrderLoadingWidget();
          },
        ),
      ),
    );
  }

  Widget _buildOrdersList(BuildContext context, List<dynamic> orders) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<OrderBloc>().add(const LoadMyOrders());
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${orders.length} orden${orders.length != 1 ? 'es' : ''} encontrada${orders.length != 1 ? 's' : ''}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: OrderCardWidget(
                      order: orders[index],
                      onViewDetails: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => OrderDetailsPage(order: orders[index]),
                          ),
                        );
                      },
                      onCancel: orders[index].canBeCancelled
                          ? () => _cancelOrder(context, orders[index].id)
                          : null,
                    ),
                  );
                },
                childCount: orders.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 32),
          ),
        ],
      ),
    );
  }

  String _getErrorMessage(String originalError) {
    if (originalError.toLowerCase().contains('403')) {
      return 'No tienes permisos para ver las órdenes.\nVerifica que hayas iniciado sesión correctamente.';
    } else if (originalError.toLowerCase().contains('connection') || 
               originalError.toLowerCase().contains('conexión')) {
      return 'Verifica tu conexión a internet\ne intenta nuevamente.';
    } else if (originalError.toLowerCase().contains('timeout')) {
      return 'La conexión tardó demasiado.\nIntenta nuevamente en unos momentos.';
    } else {
      return 'Ocurrió un problema inesperado.\nIntenta nuevamente más tarde.';
    }
  }

  void _showOrderDetails(BuildContext context, dynamic order) {
    Navigator.of(context).pushNamed(
      '/order-details',
      arguments: order,
    );
  }

  void _cancelOrder(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.cancel_outlined,
                color: Colors.red[700],
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Cancelar Orden'),
          ],
        ),
        content: const Text(
          '¿Estás seguro de que quieres cancelar esta orden?\n\nEsta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No, Mantener'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<OrderBloc>().add(CancelOrder(orderId));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.white),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Procesando cancelación...',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.orange[700],
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Sí, Cancelar'),
          ),
        ],
      ),
    );
  }
} 