# Frontend Móvil

La interfaz destinada a los usuarios finales fue desarrollada utilizando **React Native (Expo)**.  
Durante la fase de desarrollo y pruebas, la aplicación se ejecuta mediante **Expo Go**, permitiendo una experiencia móvil multiplataforma con una base de código unificada.

### Funcionamiento
- El frontend realiza solicitudes al **Gateway**, que enruta cada petición al microservicio correspondiente según la funcionalidad requerida.
- Esto asegura un **flujo de datos controlado y consistente**.

### Tecnologías
- **React Native (Expo)** con TypeScript
- **Expo Router** para navegación
- **React Query (@tanstack/react-query)** para gestión de estado del servidor
- **Context API** para estado global (autenticación, reproductor, playlists)
- **Firebase Cloud Messaging** para notificaciones push
- **react-native-track-player** para reproducción de audio en segundo plano
- **Expo AV** para gestión multimedia
- Comunicación con backend a través del Gateway