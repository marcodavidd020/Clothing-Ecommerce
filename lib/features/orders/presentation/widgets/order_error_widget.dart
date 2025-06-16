import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';

class OrderErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const OrderErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isConnectionError = message.toLowerCase().contains('403') || 
                             message.toLowerCase().contains('conexión') ||
                             message.toLowerCase().contains('connection');
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono de error animado
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isConnectionError ? Icons.wifi_off_rounded : Icons.error_outline_rounded,
                      size: 64,
                      color: Colors.red[400],
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 32),
            
            // Título del error
            Text(
              isConnectionError ? 'Problema de Conexión' : 'Error al Cargar Órdenes',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Descripción del error
            Text(
              _getErrorMessage(message),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Botones de acción
            Column(
              children: [
                // Botón principal de reintento
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Reintentar'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Botón secundario
                if (isConnectionError)
                  OutlinedButton.icon(
                    onPressed: () => _showConnectionHelp(context),
                    icon: const Icon(Icons.help_outline_rounded),
                    label: const Text('Ayuda'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  )
                else
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/main',
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.home_outlined),
                    label: const Text('Ir al Inicio'),
                  ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Información adicional
            if (isConnectionError)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue[600],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Consejos para solucionarlo:',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTipItem('Verifica tu conexión a internet'),
                        _buildTipItem('Asegúrate de haber iniciado sesión'),
                        _buildTipItem('Intenta cerrar y abrir la aplicación'),
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

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              color: Colors.blue[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                color: Colors.blue[700],
                fontSize: 14,
              ),
            ),
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

  void _showConnectionHelp(BuildContext context) {
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
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.help_outline,
                color: Colors.blue[700],
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Ayuda de Conexión'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Si no puedes ver tus órdenes, verifica:'),
            const SizedBox(height: 16),
            _buildHelpItem(Icons.wifi, 'Tu conexión a internet está activa'),
            _buildHelpItem(Icons.person, 'Has iniciado sesión correctamente'),
            _buildHelpItem(Icons.dns, 'El servidor está disponible'),
            _buildHelpItem(Icons.refresh, 'Reinicia la aplicación si es necesario'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.blue[600],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
} 