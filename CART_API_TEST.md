# Prueba de Cart API - GET del Carrito

## Objetivo
Verificar que el GET al endpoint `/carts/my-cart` se ejecuta correctamente cuando se navega a la página del carrito.

## Estructura del JSON de Respuesta Esperado
```json
{
  "success": true,
  "message": "Carrito recuperado exitosamente.",
  "data": {
    "id": "844bf394-1c6a-46e3-a99d-f3cc0954985b",
    "createdAt": "2025-05-25T07:48:49.354Z",
    "updatedAt": "2025-05-25T07:48:49.354Z",
    "user_id": "ee84195f-25aa-46e3-a82a-b124b59163ef",
    "items": [
      {
        "id": "6060d87c-9a50-4fc2-a825-8264b32875c3",
        "createdAt": "2025-05-25T07:58:25.198Z",
        "updatedAt": "2025-05-25T08:06:55.606Z",
        "cart_id": "844bf394-1c6a-46e3-a99d-f3cc0954985b",
        "productVariant": {
          "id": "b29d9b8c-83c6-4eef-a031-6df441bde953",
          "createdAt": "2025-05-22T23:30:22.567Z",
          "updatedAt": "2025-05-22T23:30:22.567Z",
          "color": "Gray",
          "size": "L",
          "stock": 35,
          "productId": "0cbd6c63-21a4-4efb-96c8-b6942babe570",
          "product": {
            "id": "0cbd6c63-21a4-4efb-96c8-b6942babe570",
            "createdAt": "2025-05-22T23:30:22.523Z",
            "updatedAt": "2025-05-22T23:30:22.523Z",
            "name": "Luxurious Rubber Gloves",
            "image": "https://loremflickr.com/1258/3082?lock=887089721409014",
            "slug": "luxurious-rubber-gloves",
            "description": "Stylish Tuna designed to make you stand out with lavish looks",
            "price": "637.30",
            "discountPrice": "198.80",
            "stock": 95,
            "isActive": true
          },
          "isActive": true
        },
        "product_variant_id": "b29d9b8c-83c6-4eef-a031-6df441bde953",
        "quantity": 6
      }
    ],
    "total": 1789.2000000000003
  },
  "timestamp": "2025-05-25T08:07:03.901Z"
}
```

## Flujo de Prueba

### 1. Navegación al Carrito
1. Abre la aplicación en el navegador (http://localhost:8080)
2. Navega al carrito desde el ícono del carrito en el AppBar o desde el menú

### 2. Verificación de Logs en el Navegador
Abre las Developer Tools del navegador (F12) y ve a la consola. Deberías ver:

```
INFO: === CARGANDO CARRITO DESDE CART PAGE ===
INFO: Estado actual del carrito: CartInitial
INFO: Llamando a getMyCart endpoint: http://192.168.0.202:3000/api/carts/my-cart
INFO: Respuesta recibida: statusCode=200
SUCCESS: Carrito obtenido: 2 items, total: $1789.20
INFO: Carrito cargado desde API: 2 items
SUCCESS: Carrito cargado con 2 items
```

### 3. Verificación Visual en la Interfaz

#### Caso 1: Carrito con Items
Si la API devuelve items en el carrito, deberías ver:
- Lista de productos con imagen, nombre, color, talla
- Cantidad de cada producto con botones +/-
- Precio individual de cada producto
- Resumen del carrito al final con:
  - Subtotal
  - Envío
  - Impuestos
  - Total
- Botón de "Checkout" con el precio total

#### Caso 2: Carrito Vacío
Si la API devuelve un carrito vacío, deberías ver:
- Ícono de carrito vacío
- Mensaje "Your cart is empty"
- Mensaje "Explore products and add items to your cart"

#### Caso 3: Error de API
Si hay algún error, deberías ver:
- Ícono de error
- Mensaje "Error al cargar el carrito"
- Mensaje específico del error
- Botón "Reintentar"

### 4. Verificación de Network en Developer Tools

1. Ve a la pestaña "Network" en Developer Tools
2. Navega al carrito
3. Deberías ver una request a:
   - **URL**: `http://192.168.0.202:3000/api/carts/my-cart`
   - **Method**: GET
   - **Status**: 200 (si es exitoso)
   - **Response**: JSON con la estructura del carrito

### 5. Funcionalidades Adicionales a Probar

#### Cambio de Cantidad
1. En un item del carrito, presiona los botones +/-
2. Verifica que se envía PUT a `/carts/my-cart/items/{itemId}`
3. Verifica que la cantidad se actualiza en la interfaz

#### Eliminar Item
1. Desliza un item hacia la izquierda o presiona su botón de eliminar
2. Confirma la eliminación en el diálogo
3. Verifica que se envía DELETE a `/carts/my-cart/items/{itemId}`
4. Verifica que el item desaparece de la lista

#### Vaciar Carrito
1. Presiona el botón de "vaciar carrito" en el AppBar (ícono de escoba)
2. Confirma en el diálogo
3. Verifica que se envía DELETE a `/carts/my-cart/clear`
4. Verifica que se muestra el estado de carrito vacío

## Solución de Problemas

### Error: "API no disponible para cargar carrito"
- Verifica que el `CartBloc` tenga acceso a los use cases de la API
- Revisa la configuración de dependencias en `CartDIContainer`

### Error: Network connection
- Verifica que la URL base sea correcta: `http://192.168.0.202:3000/api`
- Asegúrate de que el backend esté ejecutándose
- Verifica que no hay problemas de CORS

### Error: "No se pudo extraer datos del carrito"
- Verifica que la estructura del JSON de respuesta coincida con `CartApiModel`
- Revisa que el `ResponseHandler` esté extrayendo correctamente el campo `data`

### El carrito no se actualiza después de añadir productos
- Verifica que después de añadir un producto desde Product Detail, el carrito se recargue
- Puede ser necesario refrescar la página del carrito para ver los cambios

## Arquitectura Implementada

### Estados del CartBloc
- `CartInitial`: Estado inicial, dispara la carga
- `CartLoading`: Mostrando loading spinner
- `CartLoaded`: Carrito cargado con items
- `CartError`: Error al cargar o procesar

### Flujo de Datos
1. `CartPage.initState()` → `CartLoadRequested()`
2. `CartBloc._onCartLoadRequested()` → `CartLoadFromApiRequested()`
3. `CartBloc._onCartLoadFromApiRequested()` → `GetMyCartUseCase.execute()`
4. `GetMyCartUseCase` → `CartRepository.getMyCart()`
5. `CartRepositoryImpl` → `CartApiRemoteDataSource.getMyCart()`
6. Response → `CartModelMapper.fromApiItems()` → `CartLoaded(items)`

### Modelos de Conversión
- **API**: `CartApiModel` → `CartItemApiModel` → `ProductVariantApiModel` → `ProductApiModel`
- **Domain**: `CartItemModel` → `ProductItemModel` → `ProductColorOption`
- **Mapper**: `CartModelMapper` convierte de API a Domain

Esta implementación proporciona una base sólida para el manejo del carrito con la API, incluyendo carga, actualización, eliminación y vaciado de items. 