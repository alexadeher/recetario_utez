# Evidencias

**Nombre:** Estefany Alexa Delgado Heredia
**Matrícula:** 20233TN083
**Fecha:** 11-Nov-2026
**Dispositivo donde se probó:** Emulador Android

## 1. Del JSON a Dart

| JSON | Campo Dart | Tipo | Regla (obligatorio, tolerado, valor por defecto) |
|---|---|---|---|
| `id` | `id` | `int` | Obligatorio |
| `name` | `nombre` | `String` | Obligatorio |
| `cuisine` | `cocina` | `String` | Obligatorio |
| `prepTimeMinutes` | `minutosPreparacion` | `int` | Obligatorio |
| `cookTimeMinutes` | `minutosCoccion` | `int` | Obligatorio |
| `servings` | `porciones` | `int` | Obligatorio |
| `rating` | `calificacion` | `double` | Obligatorio (acepta int/double) |
| `difficulty` | `dificultad` | `Dificultad` | Tolerado (usa enum, si no coincide usa desconocida) |
| `tags` | `etiquetas` | `List<String>` | Tolerado/Opcional (si no es lista de texto usa `[]`) |
| `ingredients` | `ingredientes` | `List<String>` | Tolerado/Opcional (si no es lista de texto usa `[]`) |

## 2. Escenarios probados con el servicio real

| Escenario | Cómo lo provoqué | Qué vio la persona | Línea de la bitácora | Captura | Prueba del kit que lo cubre |
|---|---|---|---|---|---|
| Éxito | Búsqueda "chicken" o vacía con red activa | Encabezado "Mostrando X de Y recetas Rápidas: Z" y lista de tarjetas | `<- 200 GET /recipes/search (215 ms)` | `docs/capturas/1_exito.png` | `etapa5_vistas_test.dart` |
| Vacío | Búsqueda "zzzz" | "No encontramos recetas para \"zzzz\"." | `<- 200 GET /recipes/search (180 ms)` | `docs/capturas/2_vacio.png` | `etapa5_vistas_test.dart` |
| Error del servidor | Interceptor temporal con `/http/503` | "El recetario no está disponible (503). Intenta más tarde." y botón Reintentar | `x badResponse 503 GET /http/503 (45 ms)` | `docs/capturas/3_servidor.png` | `etapa3_datos_test.dart` |
| Sin red | Modo avión o URL inválida | "Sin conexión. Revisa tu red e intenta de nuevo." | `x connectionError GET /recipes (10 ms)` | `docs/capturas/4_sin_red.png` | `etapa3_datos_test.dart` |
| Tiempo agotado | Interceptor con `delay: 5000` y `timeout: 2s` | "El recetario tardó demasiado en responder. Intenta de nuevo." | `x receiveTimeout GET /recipes (2005 ms)` | `docs/capturas/5_timeout.png` | `etapa3_datos_test.dart` |

## 3. Preguntas de reflexión

1. **¿En qué se diferencian el escenario "Error del servidor" y "Sin red" desde el punto de vista de HTTP?**
   En "Error del servidor", la solicitud completa la ida y vuelta mediante HTTP y el servidor entrega una respuesta con código de estado 5xx. En "Sin red", la petición HTTP no llega a establecer o completar la conexión TCP/IP a nivel de transporte.

2. **¿Por qué "Vacío" no es un error?**
   Porque el servidor procesó con éxito la petición y envió una respuesta HTTP status 200 con una lista de recetas vacía (`recipes: []`), indicando que no hubo coincidencias.

3. **La búsqueda de la persona viaja en la query. ¿Por qué tu bitácora no la escribe?**
   Porque se usó `options.path` en lugar de `options.uri` para prevenir el registro de términos de búsqueda o datos sensibles en los logs.

4. **Si DummyJSON cambiara `rating` por `score`, ¿qué archivos tendrías que modificar y por qué solo esos?**
   Solamente `lib/datos/recetas_json.dart`. Gracias a la separación de capas, los cambios en los nombres de las llaves del JSON de la API solo impactan a la capa de mapeo/deserialización, sin afectar el dominio ni las vistas.