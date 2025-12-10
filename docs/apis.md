# APIs y especificaciones

En esta sección se listan las especificaciones API (OpenAPI/Swagger) disponibles en el repositorio y cómo consultarlas.

## Especificaciones disponibles

- `gateway/` — El Gateway mantiene una especificación OpenAPI que aglutina las rutas expuestas hacia los frontends. Archivo de interés: `gateway/src/docs/swagger.yaml`.
- `artists-microservice/` — Contiene `swagger.yaml` con las rutas del microservicio de artistas: `artists-microservice/swagger.yaml`.

> Nota: otros microservicios tienen especificaciones propias o README con ejemplos de endpoints. Si falta alguna especificación, verificar los README del microservicio correspondiente.

## Cómo visualizar las especificaciones

1. Abrir el archivo YAML directamente en el editor o en el repositorio.
2. Usar Swagger UI localmente para visualizar e interactuar con las APIs:

```bash
# ejemplo con Docker (swagger-ui):
docker run --rm -p 8080:8080 -e SWAGGER_JSON=/tmp/swagger.json -v "${PWD}/artists-microservice/swagger.yaml:/tmp/swagger.json" swaggerapi/swagger-ui
# luego abrir http://localhost:8080
```

3. El Gateway está pensado como punto de entrada y, en algunos entornos, sirve una especificación combinada. Consultar `gateway/README.md` para más detalles.

## Buenas prácticas

- Mantener actualizada la especificación por cada cambio de contrato en los endpoints.
- Implementar pruebas de integración para detectar discrepancias entre la especificación y la implementación.
