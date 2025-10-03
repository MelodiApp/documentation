# Funcionalidades y errores conocidos

## Incompletas / por pulir
- Búsqueda por similitud (falta ranking por popularidad)
- Cacheo de portadas en CDN

## Errores conocidos
- En navegadores móviles antiguos, el reproductor no libera el audio al pausar (issue #123)
- Intermitencia 1-2% en refresh de tokens (ver logs del Auth Service)

## Métricas y calidad (opcional)
- Cobertura de tests backend: 78%
- Tiempo de respuesta P95: 180ms en /play (ambiente staging)