# Decisiones Tomadas

Durante el desarrollo de **MelodiApp**, tomamos decisiones clave para organizar la arquitectura y la implementación de la aplicación.

## Gateway
Creamos un **Gateway central** con el objetivo de que actúe como **middleware entre los microservicios y los frontends**, ya sea el backoffice web o el móvil.  
Esto permite **centralizar el enrutamiento de solicitudes** y facilita la **escalabilidad**, ya que los microservicios pueden crecer o modificarse sin afectar directamente a los frontends.

## Microservicios
Decidimos implementar **microservicios independientes** para separar claramente las funcionalidades de la aplicación:

- **Usuarios**: manejo de creación y gestión de usuarios, actualización de perfiles y seguimiento entre usuarios (seguir, dejar de seguir, lista de seguidos).  
- **Librerías**: creación y gestión de playlists y bibliotecas, así como el manejo de “me gusta” de canciones.  
- **Artistas**: gestión del perfil de artistas, publicación de lanzamientos y administración de discografía.  
- **Métricas**: procesamiento y almacenamiento de estadísticas sobre usuarios y reproducciones.  
- **Notificaciones**: envío de notificaciones push e in-app, y gestión de preferencias de notificación de los usuarios.

**Motivación:**  
Separar las funcionalidades en microservicios permite un desarrollo más modular, facilita la escalabilidad y el mantenimiento, y reduce el riesgo de que un fallo en un servicio afecte a toda la aplicación.

## Almacenamiento de Archivos Multimedia
Para el manejo de imágenes y audios, decidimos utilizar **LocalStack** durante el desarrollo local y **Amazon S3** en producción:

- **LocalStack**: permite simular un servicio S3 localmente, facilitando pruebas y desarrollo sin necesidad de conectarse a la nube.  
- **Amazon S3**: en producción, asegura **alta disponibilidad, escalabilidad y durabilidad** de los archivos multimedia.  

**Motivación:**  
Esta combinación nos permite mantener un flujo de trabajo eficiente para desarrollo local y pruebas, a la vez que garantizamos que en producción los archivos estén seguros, accesibles y replicados adecuadamente.  

## Despliegue en la Nube
- **Backend y microservicios:** desplegados en **Heroku** para asegurar disponibilidad y facilidad de escalado.  
- **Backoffice web:** desplegado en **Vercel** por su integración con proyectos React y simplicidad en el despliegue.
