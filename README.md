# E-Commerce Flutter App

Aplicación de comercio electrónico desarrollada con Flutter siguiendo arquitectura limpia y patrones de diseño modernos. Este proyecto implementa una experiencia de usuario fluida para compras móviles con navegación intuitiva, gestión de categorías y funcionalidades esenciales de un e-commerce.

## Diseño

El diseño de la aplicación está basado en el siguiente modelo de Figma:
[E-commerce Mobile App - Community](https://www.figma.com/design/fFJD7eqx4qAXqdk08v3ljK/Ecommerce-Mobile-App--Community-?node-id=125-1079&t=I7bROm5ZDh9sTMCg-1)

## Estructura del Proyecto

La aplicación sigue los principios de arquitectura limpia, organizando el código por features:

```
lib/
  ├── core/                      # Componentes compartidos en toda la app
  │   ├── constants/             # Constantes (colores, strings, dimensiones)
  │   ├── theme/                 # Configuración del tema de la aplicación
  │   ├── utils/                 # Utilidades y helpers
  │   └── widgets/               # Widgets reutilizables
  │
  ├── features/                  # Funcionalidades organizadas por dominio
  │   ├── auth/                  # Autenticación (registro, inicio de sesión)
  │   │   ├── data/              # Capa de datos
  │   │   ├── domain/            # Entidades y casos de uso
  │   │   └── presentation/      # UI y gestión de estado
  │   │
  │   ├── home/                  # Pantalla principal y features relacionadas
  │   ├── notifications/         # Sistema de notificaciones
  │   ├── profile/               # Perfil de usuario
  │   ├── receipts/              # Gestión de recibos/compras
  │   └── splash/                # Pantalla de carga inicial
  │
  └── main.dart                  # Punto de entrada de la aplicación
```

## Características Implementadas

- **Autenticación**: Registro y login con validación de formularios
- **Navegación principal**: Sistema de tabs con mantenimiento de estado entre pestañas
- **Categorías de productos**: Visualización horizontal con imágenes y etiquetas
- **Filtro por género**: Selector Men/Women en la barra superior
- **Diseño responsivo**: Adaptable a diferentes tamaños de pantalla
- **Animaciones**: Efectos de carga y transiciones suaves entre pantallas
- **Carga de imágenes**: Sistema optimizado con placeholders animados durante la carga

## Componentes Clave

- **CustomAppBar**: Barra superior personalizable con soporte para botón de retroceso, título, icono de bolsa y perfil
- **BottomNavigationBar**: Navegación inferior con 4 tabs principales
- **NetworkImageWithPlaceholder**: Widget para carga de imágenes con efecto de redacción durante la carga
- **AnimatedStaggeredList**: Carga animada escalonada de elementos en listas
- **Custom Inputs**: Campos de texto con validación y estilo consistente

## Tecnologías Utilizadas

- **Flutter**: Framework para desarrollo multiplataforma
- **Dart**: Lenguaje de programación
- **Arquitectura Limpia**: Separación por capas (presentación, dominio, datos)
- **SVG**: Soporte para iconos vectoriales
- **Fuentes personalizadas**: Implementación de la fuente "Gabarito"
- **Gestión de estados**: Preparado para implementación de BLoC pattern

## Cómo Ejecutar

1. Asegúrate de tener Flutter instalado (versión 3.x recomendada)
2. Clona el repositorio
3. Ejecuta `flutter pub get` para instalar dependencias
4. Conecta un dispositivo o inicia un emulador
5. Ejecuta `flutter run` para iniciar la aplicación

## Capturas de Pantalla

_(Próximamente)_

## Roadmap

- Implementación completa de la gestión de estados con BLoC
- Integración con API backend para datos reales
- Implementación de carrito de compras y proceso de pago
- Sistema de búsqueda avanzada de productos

## Licencia

Este proyecto es de código abierto bajo licencia MIT.
