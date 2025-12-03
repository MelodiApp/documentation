# Arquitectura General

La siguiente descripción presenta la arquitectura de nuestra aplicación **MelodiApp**.  
El sistema está organizado de manera modular, con distintos componentes desplegados en la nube a través de Heroku. Para el almacenamiento de archivos multimedia, como imágenes y audios, se utiliza Amazon S3.  

La arquitectura incluye:

- Frontend móvil en React Native (Expo)
- Backoffice web desarrollado con Vite y React Admin
- Gateway central en Node.js
- Microservicios especializados en usuarios, librerías, métricas y artistas, cada uno con su propia base de datos según su dominio

Esta estructura modular permite escalabilidad, mantenimiento sencillo y separación clara de responsabilidades.
