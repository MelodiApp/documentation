# Backoffice Web

El backoffice web está desarrollado para la **administración interna de la plataforma**, desplegado en la nube mediante **Vercel**.

### Stack tecnológico
- React Admin
- ra-data-json-server (data provider para APIs REST)
- React 19
- TypeScript
- Material-UI
- Vite

### Funcionalidades
- Gestión de usuarios, artistas, canciones y colecciones
- Visualización de métricas
- Control de contenido de la plataforma

### Comunicación
- Toda la comunicación con microservicios se realiza a través del **Gateway**, que enruta las solicitudes al servicio correspondiente.
