# cinemapedia

## 💻1. Variables de entorno

```sh
# Crear el archivo de variables de entono
touch .env
```

En el archivo `.env`, tomar como base el archivo de `example.env`, para crear las variables

---

## 📀2. API - The Movie DB

- Iniciar sesión en la página
- Ir al menú de **ajustes**
- Ir a la sección de **API**
- Crear o generar una **API KEY**
- Copiar esa API KEY en las **variables de entorno**

URL de la API: <https://www.themoviedb.org/>

Documentación de desarrollo: <https://developer.themoviedb.org/docs/getting-started>

Endpoints: <https://developer.themoviedb.org/reference/authentication-how-do-i-generate-a-session-id>

---

## ⛑️3. Ayuda

### 🗺️3.1 Guías

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

### ⌨️3.2 Comandos

```sh
# Limpiar temporales
flutter clean

# Instalar los paquetes
flutter pub get

# Ejecutar el doctor para validar si todo está correcto
flutter doctor
```
