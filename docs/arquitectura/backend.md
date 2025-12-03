# Backend

El backend de MelodiApp se organiza en un **Gateway central** y **microservicios especializados**, cada uno encargado de funcionalidades concretas dentro de la plataforma.

## Gateway
El **Gateway** está desarrollado en Node.js y actúa como el **puente principal entre los frontends y los microservicios**.  
Se encarga de recibir todas las solicitudes provenientes del frontend móvil y del backoffice web, enrutándolas al microservicio correspondiente según la funcionalidad requerida. Además, maneja aspectos como autenticación, control de flujo de datos y consistencia en las respuestas.

## Microservicio de Usuarios
Este microservicio, desarrollado en **Python con FastAPI**, gestiona todo lo relacionado con los usuarios de la plataforma.  
Incluye la creación y administración de usuarios, perfiles y seguimiento entre ellos.  
Se conecta a una base de datos PostgreSQL y utiliza **SQLAlchemy** para modelar los datos (tablas `users`, `profiles` y `followers`).  
Las migraciones de la base de datos se gestionan mediante Alembic, asegurando consistencia y control de cambios en la estructura de datos.

## Microservicio de Librerías
Encargado de la **gestión de playlists y bibliotecas de los usuarios**, este microservicio también está desarrollado en Python con FastAPI y conectado a PostgreSQL.  
Permite crear, modificar y almacenar playlists, canciones y colecciones.  
Su estructura de datos se organiza en tablas como `playlists`, `playlist_songs`, `liked_songs`, `playlist_saves` y `saved_collections`.  
Las migraciones se manejan con Alembic, asegurando un control completo del esquema de datos.

## Microservicio de Artistas
Este microservicio, desarrollado en **Node.js con Prisma**, se encarga de administrar los **perfiles de los artistas** y su contenido musical.  
Gestiona colecciones, álbumes, EPs, singles y canciones, así como las interacciones de los usuarios, como me gusta y picks de artistas.  
Se conecta a una base de datos SQL mediante Prisma, y las migraciones se realizan con Prisma Migrate.  
Las tablas principales incluyen `artists`, `collections`, `songs`, `about`, `about_images`, `genres`, `liked_songs` y `artist_picks`.

## Microservicio de Métricas
Este servicio se desarrolla en **Python** utilizando **MongoDB** para almacenar información analítica.  
Su función principal es **consultar los otros microservicios y generar estadísticas**, como número de usuarios activos, reproducciones por usuario y reproducciones mensuales.  
Los datos generados se utilizan en el backoffice para visualización y análisis, ayudando a la toma de decisiones.

## Microservicio de Notificaciones
Desarrollado en **Node.js**, este microservicio gestiona las **notificaciones push** a través de Expo Push Notification Service y las **notificaciones in-app** con un historial de hasta 3 días.  
Permite definir preferencias de notificación por usuario, almacenar tokens de dispositivos y programar envíos mediante un cron job que se ejecuta cada hora.  
Además, realiza la limpieza automática de notificaciones expiradas.  
La estructura de datos incluye tablas como `Notification`, `UserPushToken` y `UserNotificationPreferences`.