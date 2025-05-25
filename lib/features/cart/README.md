# Módulo Cart - Integración API

Este módulo implementa la funcionalidad completa del carrito de compras con integración a la API backend.

## Estructura del Módulo

```
lib/features/cart/
├── core/
│   ├── constants/
│   │   ├── cart_constants.dart    # Constantes generales del carrito
│   │   ├── cart_strings.dart      # Strings específicos del carrito
│   │   └── cart_ui.dart           # Constantes de UI del carrito
│   └── core.dart                  # Barrel file para core
├── data/
│   ├── datasources/
│   │   └── cart_api_datasource.dart    # Fuente de datos de la API
│   ├── models/
│   │   └── cart_api_model.dart         # Modelos para la API
│   ├── repositories/
│   │   └── cart_repository_impl.dart   # Implementación del repositorio
│   └── data.dart                       # Barrel file para data
├── domain/
│   ├── entities/
│   │   └── cart_item_model.dart        # Modelo de dominio existente
│   ├── helpers/
│   │   └── cart_model_mapper.dart      # Helper para conversión de modelos
│   ├── repositories/
│   │   └── cart_repository.dart        # Interfaz del repositorio
│   ├── usecases/
│   │   ├── get_my_cart_usecase.dart
│   │   ├── add_item_to_cart_usecase.dart
│   │   ├── update_cart_item_usecase.dart
│   │   ├── remove_cart_item_usecase.dart
│   │   └── clear_cart_usecase.dart
│   └── domain.dart                     # Barrel file para domain
├── presentation/
│   ├── bloc/
│   │   ├── cart_bloc.dart              # BLoC principal (actualizado)
│   │   ├── cart_event.dart             # Eventos (actualizados)
│   │   └── cart_state.dart             # Estados (existentes)
│   ├── helpers/
│   │   └── cart_quantity_helper.dart   # Helpers existentes
│   ├── pages/
│   │   └── cart_page.dart              # Página principal del carrito
│   └── widgets/                        # Widgets existentes del carrito
├── di_container.dart                   # Contenedor de dependencias
└── README.md                           # Este archivo
```

## Funcionalidades Implementadas

### 1. Integración con API
- **GET** `/cart/my-cart` - Obtener carrito del usuario
- **POST** `/cart/items` - Añadir item al carrito
- **PUT** `/cart/items/:id` - Actualizar cantidad de item
- **DELETE** `/cart/items/:id` - Eliminar item del carrito
- **DELETE** `/cart/clear` - Vaciar carrito completo

### 2. Casos de Uso
- `GetMyCartUseCase` - Obtener carrito desde API
- `AddItemToCartUseCase` - Añadir producto al carrito
- `UpdateCartItemUseCase` - Actualizar cantidad de producto
- `RemoveCartItemUseCase` - Eliminar producto del carrito
- `ClearCartUseCase` - Vaciar carrito completamente

### 3. Eventos del BLoC (Nuevos)
- `CartLoadFromApiRequested` - Cargar carrito desde API
- `CartItemAddedToApi` - Añadir item usando API
- `CartItemRemovedFromApi` - Eliminar item usando API
- `CartItemQuantityUpdatedInApi` - Actualizar cantidad usando API
- `CartClearedFromApi` - Vaciar carrito usando API

### 4. Integración con Product Detail
- `CartIntegrationHelper` - Helper para integrar carrito con detalle de producto
- `CartModelMapper` - Conversión entre modelos API y dominio
- Búsqueda automática de variantes de producto por talla y color
- Validación de stock disponible
- Fallback a método local si API no está disponible

## Flujo de Funcionamiento

### 1. Añadir Producto al Carrito
```dart
// Desde ProductDetailPage
final success = await CartIntegrationHelper.addProductToCart(
  context: context,
  product: product,
  selectedSize: size,
  selectedColor: color,
  quantity: quantity,
  productDetail: productDetail, // Opcional, para API
);
```

### 2. Conversión de Modelos
```dart
// API Model -> Domain Model
final domainItems = CartModelMapper.fromApiItems(apiItems);

// Buscar variante de producto
final variantId = CartModelMapper.findProductVariantId(
  productDetail,
  selectedSize,
  selectedColor,
);
```

### 3. Manejo de Estados
- **Método Local**: Usa `CartItemAdded` para operaciones offline
- **Método API**: Usa `CartItemAddedToApi` para operaciones online
- **Fallback**: Si API falla, usa método local automáticamente

## Configuración de Dependencias

El módulo se registra automáticamente en:
- `DIContainer` - Registro principal
- `InjectionContainer` - Providers de repositorio
- `BlocModule` - Providers de BLoC

```dart
// En di_container.dart
await CartDIContainer.register(sl);

// En injection_container.dart
final cartProviders = CartDIContainer.getRepositoryProviders();

// En bloc_module.dart
...CartDIContainer.getBlocProviders(sl),
```

## Uso en la Aplicación

### 1. Cargar Carrito
```dart
// Automático al inicializar CartBloc
context.read<CartBloc>().add(const CartLoadRequested());

// Desde API específicamente
context.read<CartBloc>().add(const CartLoadFromApiRequested());
```

### 2. Añadir Producto
```dart
// Método local
context.read<CartBloc>().add(CartItemAdded(
  product: product,
  size: size,
  color: color,
  quantity: quantity,
));

// Método API
context.read<CartBloc>().add(CartItemAddedToApi(
  productVariantId: variantId,
  quantity: quantity,
));
```

### 3. Gestionar Items
```dart
// Actualizar cantidad (API)
context.read<CartBloc>().add(CartItemQuantityUpdatedInApi(
  apiItemId: itemId,
  newQuantity: newQuantity,
));

// Eliminar item (API)
context.read<CartBloc>().add(CartItemRemovedFromApi(
  apiItemId: itemId,
));

// Vaciar carrito (API)
context.read<CartBloc>().add(const CartClearedFromApi());
```

## Características Especiales

### 1. Compatibilidad Dual
- Funciona con y sin API disponible
- Fallback automático a método local
- Mantiene compatibilidad con implementación existente

### 2. Validación de Stock
- Verifica disponibilidad antes de añadir
- Valida cantidad contra stock disponible
- Muestra mensajes de error apropiados

### 3. Búsqueda Inteligente de Variantes
- Encuentra variante exacta por talla y color
- Fallback a primera variante disponible
- Manejo de errores cuando no hay variantes

### 4. Logging Completo
- Logs detallados de todas las operaciones
- Información de debug para desarrollo
- Manejo de errores con contexto

## Próximos Pasos

1. **Testing**: Implementar tests unitarios y de integración
2. **Persistencia Local**: Sincronización con almacenamiento local
3. **Optimización**: Cache de carrito para mejor rendimiento
4. **Notificaciones**: Push notifications para cambios de carrito
5. **Analytics**: Tracking de eventos del carrito 