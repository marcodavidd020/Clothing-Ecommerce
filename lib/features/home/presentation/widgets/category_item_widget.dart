import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/core/constants/constants.dart';
import 'package:flutter_application_ecommerce/features/home/domain/domain.dart';

class CategoryItemWidget extends StatelessWidget {
  final CategoryItemModel category;
  final VoidCallback? onTap;

  const CategoryItemWidget({super.key, required this.category, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 35, // Tamaño del círculo de la imagen
            backgroundColor:
                AppColors.inputFill, // Fondo mientras carga o si falla
            backgroundImage: NetworkImage(category.imageUrl),
            onBackgroundImageError: (exception, stackTrace) {
              // Podrías mostrar un icono de error o placeholder local
              print("Error cargando imagen: ${category.imageUrl}");
            },
          ),
          const SizedBox(height: AppDimens.vSpace16 / 2),
          Text(
            category.name,
            style: AppTextStyles.categoryItem,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
