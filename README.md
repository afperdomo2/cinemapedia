# cinemapedia

## 📚1. Documentación

Esta aplicación permite a los usuarios explorar una amplia variedad de películas, ver detalles específicos de cada una, y mantenerse actualizados con las últimas novedades en el mundo del cine.

### 1.1 Descripción de la Aplicación

Cinemapedia es una aplicación móvil que ofrece una interfaz intuitiva y atractiva para que los usuarios puedan descubrir y explorar películas. La aplicación utiliza diversas APIs para obtener información actualizada sobre películas, incluyendo detalles como sinopsis, elenco, fechas de lanzamiento, y más. Además, la aplicación está diseñada para ser rápida y eficiente, proporcionando una experiencia de usuario fluida y agradable.

### 1.2 Bibliotecas y Dependencias Utilizadas

- **animate_do:** Esta biblioteca se utiliza para agregar animaciones a la aplicación.

- **card_swiper:** Utilizada para crear carruseles de tarjetas.

- **dio:** Dio es una biblioteca de cliente HTTP que se utiliza para realizar solicitudes a las APIs.

- **flutter_dotenv:** Esta biblioteca permite cargar variables de entorno desde un archivo .env.

- **flutter_riverpod:** Riverpod es una biblioteca de gestión de estado que facilita la creación de aplicaciones escalables y mantenibles.

- **go_router:** Go Router es una biblioteca de enrutamiento para Flutter que simplifica la navegación dentro de la aplicación. Permite definir rutas de manera declarativa y manejar la navegación de manera eficiente.

- **intl:** La biblioteca intl se utiliza para la internacionalización y formateo de fechas y números.

## 💻2. Variables de entorno

```sh
# Crear el archivo de variables de entono
touch .env
```

En el archivo `.env`, tomar como base el archivo de `example.env`, para crear las variables

---

## 💾3. Isar Database

Base de datos con Isar (NoSQL)

<https://isar.dev/es/>

<https://isar.dev/es/tutorials/quickstart.html>

```sh
# Ejecutar el generador de código

# Con Flutter
flutter pub run build_runner build

# Con Dart
dart run build_runner build
```

## 📀4. API - The Movie DB

- Iniciar sesión en la página
- Ir al menú de **ajustes**
- Ir a la sección de **API**
- Crear o generar una **API KEY**
- Copiar esa API KEY en las **variables de entorno**

URL de la API: <https://www.themoviedb.org/>

Documentación de desarrollo: <https://developer.themoviedb.org/docs/getting-started>

Endpoints: <https://developer.themoviedb.org/reference/authentication-how-do-i-generate-a-session-id>

---

## ⛑️5. Ayuda

### 🗺️5.1 Guías

**Comillas simples en vez de dobles:**

Abrir el archivo de `analysis_options.yaml` y establecer la siguiente configuración:

```sh
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    prefer_single_quotes: true # Aquí se habilita
```

```sh
# Analizar el código y ver los problemas encontrados por el linter
flutter analyze

# Corregir automáticamente las correcciones sugeridas (ej: Comillas simples por dobles)
dart fix --apply
````

---

### ⌨️5.2 Comandos

```sh
# Instalar los paquetes o dependencias
flutter pub get

# Compilar y ejecutar la aplicación en un dispositivo conectado o emulador
flutter run
```

```sh
# Limpiar temporales
flutter clean

# Ejecutar el doctor para validar si todo está correcto
flutter doctor
```
