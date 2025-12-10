# Contribuir y guiar el desarrollo local

Esta sección resume las prácticas recomendadas para contribuir al proyecto y para levantar el entorno de desarrollo localmente con finalidad educativa y de investigación.

## Estructura del repositorio

- `gateway/` – Punto de entrada para los frontends y router hacia microservicios.
- `artists-microservice/`, `libraries-microservice/`, `users-microservice/`, `metrics-microservice/` – Microservicios independientes con su propio stack y DB.
- `melodia-backoffice/` – Backoffice web (React / Vite).
- `MelodiaFront/` – Frontend móvil (React Native / Expo).
- `documentation/` – Documentación del proyecto (esta carpeta).

## Setup rápido para desarrollo local

1. Clonar el repositorio:

```bash
git clone https://github.com/MelodiApp/Melodia.git
cd Melodia
```

2. Revisar las instrucciones por microservicio — cada uno tiene su README con pasos para levantarlo (por ejemplo `artists-microservice/README.md`).

3. (Opcional) Para simular S3 localmente, usar LocalStack:

```bash
cd localstack
docker compose up -d
```

4. Bases de datos: varios microservicios usan PostgreSQL o MongoDB; ejecutar las migraciones que correspondan desde cada servicio (ver `README.md` de cada microservicio).

5. Ejemplo rápido (artists):

```bash
cd artists-microservice
npm install
npm run dev
```

6. Ejecutar el Gateway localmente para unificar las rutas:

```bash
cd gateway
npm install
npm run dev
```

## Prácticas de contribución

- Para cambios significativos, abrir un Issue para discutir antes de la implementación.
- Usar ramas con prefijo `feature/`, `fix/` o `chore/` y nombrarlas de forma descriptiva.
- Añadir tests y documentación para cambios visibles en la API o en la lógica de negocio.
- Mantener las especificaciones OpenAPI actualizadas para cualquier cambio de contrato.

## Revisión y CI

Si un cambio altera la API o la base de datos, incluir la actualización de migraciones y considerar cómo se hará el despliegue sin interrumpir producción. Consultar los CI del proyecto para ver pipelines y cómo se ejecutan tests/linters.

## Contacto

Si tiene dudas, puede contactar a los autores listados en `README.md` o abrir una issue con el prefijo `documentación:` para clarificar la documentación necesaria.
