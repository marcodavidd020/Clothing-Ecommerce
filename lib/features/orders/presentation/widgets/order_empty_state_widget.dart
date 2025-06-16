import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';

class OrderEmptyStateWidget extends StatelessWidget {
  const OrderEmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono animado
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.receipt_long_outlined,
                      size: 64,
                      color: AppColors.primary,
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 32),
            
            // Título principal
            Text(
              '¡Aún no tienes órdenes!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Descripción
            Text(
              'Cuando realices tu primera compra,\naparecerá aquí el historial de todas tus órdenes.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Botón para explorar productos
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/main',
                  (route) => false,
                );
              },
              icon: const Icon(Icons.shopping_cart_outlined),
              label: const Text('Explorar Productos'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 2,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Botón secundario para categorías
            TextButton.icon(
              onPressed: () {
                // TODO: Navegar a categorías
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Navegación a categorías próximamente'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
              icon: Icon(
                Icons.category_outlined,
                color: Colors.grey[600],
              ),
              label: Text(
                'Ver Categorías',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Beneficios de comprar
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  Text(
                    '¿Por qué comprar con nosotros?',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildBenefitItem(
                        context,
                        icon: Icons.local_shipping_outlined,
                        title: 'Envío\nGratis',
                        color: Colors.green[600]!,
                      ),
                      _buildBenefitItem(
                        context,
                        icon: Icons.security_outlined,
                        title: 'Compra\nSegura',
                        color: Colors.blue[600]!,
                      ),
                      _buildBenefitItem(
                        context,
                        icon: Icons.support_agent_outlined,
                        title: 'Soporte\n24/7',
                        color: Colors.purple[600]!,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
} 