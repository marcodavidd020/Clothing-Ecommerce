# Prueba de Cart API - POST de Productos

## Objetivo
Verificar que el POST al endpoint `/cart/items` se ejecuta correctamente cuando se añade un producto desde `product_detail_page.dart`.

## Modelo de POST Esperado
```json
{
  "productVariantId": "c0413d68-8017-4fc5-8e15-0faaeed23cc5",
  "quantity": 1
}
```

## Flujo de Prueba

### 1. Navegación al Detalle del Producto
1. Abre la aplicación en el navegador (http://localhost:8080)
2. Navega a la página Home
3. Selecciona cualquier producto para ir a su detalle

### 2. Verificación de Logs
Abre las Developer Tools del navegador (F12) y ve a la consola. Deberías ver:

```
INFO: Cargando detalle del producto: [PRODUCT_ID]
SUCCESS: Detalle del producto cargado: [PRODUCT_NAME]
INFO: === INICIANDO PROCESO DE AÑADIR AL CARRITO ===
INFO: Producto: [PRODUCT_NAME]
INFO: Talla: [SELECTED_SIZE]
INFO: Color: [SELECTED_COLOR]
INFO: Cantidad: 1
INFO: ProductDetail disponible: true
INFO: CartBloc encontrado
INFO: ¿Tiene casos de uso API? true
INFO: 🚀 USANDO MÉTODO API
INFO: === PROCESANDO VIA API ===
INFO: ProductDetail ID: [PRODUCT_ID]
INFO: Número de variantes disponibles: [NUMBER]
INFO: Variante 0: ID=[VARIANT_ID], Size=[SIZE], Color=[COLOR], Stock=[STOCK]
INFO: Variante encontrada: [VARIANT_ID]
INFO: ✅ AÑADIENDO AL CARRITO VIA API - Variante: [VARIANT_ID], Cantidad: 1
```

### 3. Verificación de Network Request
En las Developer Tools:
1. Ve a la pestaña "Network"
2. Filtra por "XHR" o "Fetch"
3. Añade un producto al carrito
4. Deberías ver una petición POST a `/api/cart/items`
5. Verifica que el payload sea:
   ```json
   {
     "productVariantId": "[VARIANT_ID]",
     "quantity": 1
   }
   ```

### 4. Estados Esperados

#### Caso Exitoso (API Disponible)
- Se ejecuta el POST a `/api/cart/items`
- Se muestra SnackBar de confirmación
- El carrito se actualiza con la respuesta de la API

#### Caso Fallback (API No Disponible)
- Se ve el log: "📱 USANDO MÉTODO LOCAL (fallback)"
- Se ejecuta el método local sin API
- Se muestra SnackBar de confirmación

## Problemas Potenciales

### Si no se ejecuta el POST:
1. **Verificar que ProductDetail se carga**: Buscar en logs "ProductDetail disponible: true"
2. **Verificar CartBloc**: Buscar en logs "¿Tiene casos de uso API? true"
3. **Verificar variantes**: Buscar en logs el número de variantes disponibles

### Si se usa método local en lugar de API:
- Verificar que las dependencias de Cart estén registradas correctamente
- Verificar que CartBloc tenga access a los use cases API

## Código Relevante Modificado

### ProductDetailPage.dart
- Ahora carga `ProductDetailModel` completo antes de crear `ProductDetailBloc`
- Pasa el detalle completo con variantes al bloc

### CartIntegrationHelper.dart
- Detecta automáticamente si usar API o método local
- Logs detallados para debugging
- Búsqueda de `productVariantId` desde las variantes

### CartModelMapper.dart
- Método `findProductVariantId()` para encontrar variante por talla y color
- Métodos helper para validación de stock y disponibilidad

## Resultado Esperado
✅ POST exitoso a `/api/cart/items` con el modelo correcto cuando se añade un producto al carrito desde la página de detalle. 