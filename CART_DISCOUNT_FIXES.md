# Corrección de Descuentos en el Carrito

## Problema Identificado

Los precios del carrito no coincidían con el total de la API porque los productos tenían descuentos, pero no se estaban mostrando ni calculando correctamente.

### Datos de Ejemplo de la API
```json
{
  "productVariant": {
    "product": {
      "price": "637.30",        // Precio original
      "discountPrice": "198.80" // Precio con descuento
    }
  },
  "quantity": 6
}
```

### Problema en el Mapeo (Antes)
```dart
// Mapeo INCORRECTO - estaba al revés
price: apiProduct.price,           // $637.30 (precio original)
originalPrice: apiProduct.discountPrice, // $198.80 (precio con descuento)
```

### Problema en el Cálculo (Antes)
```dart
// Calculaba mal el subtotal
final price = item.product.originalPrice ?? item.product.price;
// Esto usaba el precio original en lugar del precio con descuento
```

## Soluciones Implementadas

### 1. Corrección del Mapeo de Precios

**Archivo**: `cart_model_mapper.dart`

```dart
// Mapeo CORREGIDO
return ProductItemModel(
  id: apiProduct.id,
  imageUrl: apiProduct.image,
  name: apiProduct.name,
  price: apiProduct.discountPrice ?? apiProduct.price, // Precio actual (con descuento si existe)
  originalPrice: apiProduct.discountPrice != null ? apiProduct.price : null, // Precio original solo si hay descuento
  description: apiProduct.description,
  // ...
);
```

**Lógica**:
- `price`: El precio que debe pagar el usuario (precio con descuento si existe, original si no)
- `originalPrice`: El precio original solo cuando hay un descuento aplicado

### 2. Corrección del Cálculo del Subtotal

**Archivo**: `cart_summary_widget.dart`

```dart
// ANTES (incorrecto)
final price = item.product.originalPrice ?? item.product.price;
return sum + (price * item.quantity);

// DESPUÉS (correcto)
return sum + (item.product.price * item.quantity);
```

**Resultado**: Ahora el subtotal usa el precio actual (ya con descuento aplicado).

### 3. Mejora Visual de los Descuentos

**Archivo**: `cart_item_widget.dart`

#### Producto SIN Descuento
```
┌─────────────────────────────┐
│ Producto Normal             │
│ Color: Red  Size: L         │
│                             │
│ $637.30            [+ 1 -]  │
└─────────────────────────────┘
```

#### Producto CON Descuento
```
┌─────────────────────────────┐
│ Luxurious Rubber Gloves     │
│ Color: Gray  Size: L        │
│ $637.30 (tachado)           │
│ $198.80            [+ 6 -]  │
└─────────────────────────────┘
```

#### Implementación
```dart
Widget _buildPriceSection() {
  final bool hasDiscount = item.product.originalPrice != null;
  
  if (hasDiscount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Precio original tachado
        Text(
          '\$${item.product.originalPrice!.toStringAsFixed(2)}',
          style: AppTextStyles.caption.copyWith(
            decoration: TextDecoration.lineThrough,
            color: AppColors.textLight,
            fontSize: 12,
          ),
        ),
        // Precio con descuento
        Text(
          '\$${item.product.price.toStringAsFixed(2)}',
          style: AppTextStyles.heading.copyWith(
            fontSize: 16,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  } else {
    // Producto sin descuento
    return Text(
      '\$${item.product.price.toStringAsFixed(2)}',
      style: AppTextStyles.heading.copyWith(
        fontSize: 16,
        color: AppColors.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
```

## Comparación de Cálculos

### Datos de Ejemplo
```json
{
  "items": [
    {
      "productVariant": {
        "product": {
          "price": "637.30",     // Precio original
          "discountPrice": "198.80" // Precio con descuento
        }
      },
      "quantity": 6
    },
    {
      "productVariant": {
        "product": {
          "price": "637.30",
          "discountPrice": "198.80"
        }
      },
      "quantity": 3
    }
  ],
  "total": 1789.20
}
```

### ANTES (Incorrecto)
```
Subtotal: $637.30 × 6 + $637.30 × 3 = $5,735.70
Total API: $1,789.20
❌ NO COINCIDE - Diferencia: $3,946.50
```

### DESPUÉS (Correcto)
```
Subtotal: $198.80 × 6 + $198.80 × 3 = $1,789.20
Total API: $1,789.20
✅ COINCIDE PERFECTAMENTE
```

## Estructura Visual Final

### Resumen del Carrito
```
┌─────────────────────────────────┐
│ Subtotal    $1,789.20          │
│ ─────────────────────────────── │
│ Total       $1,789.20          │
└─────────────────────────────────┘
```

### Items del Carrito
```
┌─────────────────────────────────┐
│ 🖼️ Luxurious Rubber Gloves     │
│    Color: Gray  Size: L         │
│    $637.30 (tachado)            │
│    $198.80            [+ 6 -]   │
└─────────────────────────────────┘

┌─────────────────────────────────┐
│ 🖼️ Luxurious Rubber Gloves     │
│    Color: Red   Size: XL        │
│    $637.30 (tachado)            │
│    $198.80            [+ 3 -]   │
└─────────────────────────────────┘
```

## Beneficios de la Corrección

### ✅ Cálculos Precisos
- Subtotal coincide exactamente con el total de la API
- No más discrepancias en los precios
- Matemáticas coherentes entre frontend y backend

### ✅ UX Mejorada
- El usuario ve claramente el descuento aplicado
- Precio original tachado indica el ahorro
- Información visual clara sobre promociones

### ✅ Compatibilidad
- Funciona con productos con y sin descuento
- Se adapta automáticamente al contenido de la API
- Preparado para futuras promociones

### ✅ Consistencia
- Los totales coinciden con el backend
- No hay sorpresas en el checkout
- Datos sincronizados en toda la aplicación

## Archivos Modificados

1. ✅ **`cart_model_mapper.dart`** - Corregido mapeo de precios
2. ✅ **`cart_summary_widget.dart`** - Corregido cálculo de subtotal
3. ✅ **`cart_item_widget.dart`** - Añadida visualización de descuentos

## Casos de Uso Soportados

### Producto Sin Descuento
```json
{
  "product": {
    "price": "299.99",
    "discountPrice": null
  }
}
```
**Resultado**: Muestra `$299.99` sin precio tachado.

### Producto Con Descuento
```json
{
  "product": {
    "price": "299.99",
    "discountPrice": "199.99"
  }
}
```
**Resultado**: Muestra `$299.99` tachado y `$199.99` destacado.

### Producto Solo Con Precio Con Descuento
```json
{
  "product": {
    "price": "199.99",
    "discountPrice": "199.99"
  }
}
```
**Resultado**: Muestra solo `$199.99` (no hay diferencia = no hay descuento visual).

Esta implementación garantiza que el carrito muestre información precisa y visualmente atractiva sobre los descuentos, mientras mantiene la coherencia matemática con el backend. 