#!/bin/bash

# Script para organizar widgets en carpetas por tipo
# Ejecutar desde la raíz del proyecto

# Crear las carpetas si no existen
mkdir -p lib/features/home/presentation/widgets/product
mkdir -p lib/features/home/presentation/widgets/category
mkdir -p lib/features/home/presentation/widgets/layout
mkdir -p lib/features/home/presentation/widgets/common

# Mover widgets de producto
echo "Moviendo widgets de producto..."
[ -f lib/features/home/presentation/widgets/product_card_widget.dart ] && \
  mv lib/features/home/presentation/widgets/product_card_widget.dart \
     lib/features/home/presentation/widgets/product/
[ -f lib/features/home/presentation/widgets/product_item_widget.dart ] && \
  mv lib/features/home/presentation/widgets/product_item_widget.dart \
     lib/features/home/presentation/widgets/product/
[ -f lib/features/home/presentation/widgets/product_star_rating_widget.dart ] && \
  mv lib/features/home/presentation/widgets/product_star_rating_widget.dart \
     lib/features/home/presentation/widgets/product/
[ -f lib/features/home/presentation/widgets/product_favorite_button_widget.dart ] && \
  mv lib/features/home/presentation/widgets/product_favorite_button_widget.dart \
     lib/features/home/presentation/widgets/product/
[ -f lib/features/home/presentation/widgets/product_info_section_widget.dart ] && \
  mv lib/features/home/presentation/widgets/product_info_section_widget.dart \
     lib/features/home/presentation/widgets/product/
[ -f lib/features/home/presentation/widgets/product_image_section_widget.dart ] && \
  mv lib/features/home/presentation/widgets/product_image_section_widget.dart \
     lib/features/home/presentation/widgets/product/

# Mover widgets de categoría
echo "Moviendo widgets de categoría..."
[ -f lib/features/home/presentation/widgets/category_item_widget.dart ] && \
  mv lib/features/home/presentation/widgets/category_item_widget.dart \
     lib/features/home/presentation/widgets/category/
[ -f lib/features/home/presentation/widgets/category_list_item_widget.dart ] && \
  mv lib/features/home/presentation/widgets/category_list_item_widget.dart \
     lib/features/home/presentation/widgets/category/
[ -f lib/features/home/presentation/widgets/category_selector_widget.dart ] && \
  mv lib/features/home/presentation/widgets/category_selector_widget.dart \
     lib/features/home/presentation/widgets/category/
[ -f lib/features/home/presentation/widgets/category_selector_modal.dart ] && \
  mv lib/features/home/presentation/widgets/category_selector_modal.dart \
     lib/features/home/presentation/widgets/category/
[ -f lib/features/home/presentation/widgets/category_selector_handler_widget.dart ] && \
  mv lib/features/home/presentation/widgets/category_selector_handler_widget.dart \
     lib/features/home/presentation/widgets/category/
[ -f lib/features/home/presentation/widgets/category_breadcrumbs_widget.dart ] && \
  mv lib/features/home/presentation/widgets/category_breadcrumbs_widget.dart \
     lib/features/home/presentation/widgets/category/
[ -f lib/features/home/presentation/widgets/categories_section_widget.dart ] && \
  mv lib/features/home/presentation/widgets/categories_section_widget.dart \
     lib/features/home/presentation/widgets/category/

# Mover widgets de layout
echo "Moviendo widgets de layout..."
[ -f lib/features/home/presentation/widgets/home_content_widget.dart ] && \
  mv lib/features/home/presentation/widgets/home_content_widget.dart \
     lib/features/home/presentation/widgets/layout/
[ -f lib/features/home/presentation/widgets/home_app_bar_widget.dart ] && \
  mv lib/features/home/presentation/widgets/home_app_bar_widget.dart \
     lib/features/home/presentation/widgets/layout/
[ -f lib/features/home/presentation/widgets/home_state_handler_widget.dart ] && \
  mv lib/features/home/presentation/widgets/home_state_handler_widget.dart \
     lib/features/home/presentation/widgets/layout/
[ -f lib/features/home/presentation/widgets/top_selling_section_widget.dart ] && \
  mv lib/features/home/presentation/widgets/top_selling_section_widget.dart \
     lib/features/home/presentation/widgets/layout/
[ -f lib/features/home/presentation/widgets/product_horizontal_list_section.dart ] && \
  mv lib/features/home/presentation/widgets/product_horizontal_list_section.dart \
     lib/features/home/presentation/widgets/layout/

# Mover widgets comunes
echo "Moviendo widgets comunes..."
[ -f lib/features/home/presentation/widgets/empty_state_widget.dart ] && \
  mv lib/features/home/presentation/widgets/empty_state_widget.dart \
     lib/features/home/presentation/widgets/common/
[ -f lib/features/home/presentation/widgets/error_content_widget.dart ] && \
  mv lib/features/home/presentation/widgets/error_content_widget.dart \
     lib/features/home/presentation/widgets/common/

echo "Actualización completa, revisa el archivo widgets.dart para actualizar los imports." 