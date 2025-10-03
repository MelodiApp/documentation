# Bitácora y Lecciones

## Hitos
- Sprint 1: POC de streaming y autenticación
- Sprint 2: Playlists colaborativas
- Sprint 3: Búsqueda y afinamiento de relevancia

## Problemas encontrados
- Límite de sockets por contenedor → solucionado ajustando ulimits
- Desbalance del índice de búsqueda → re-sharding nocturno

## Lecciones aprendidas
- Evitar fan-out de eventos sin tracing distribuido
- Definir budgets de latencia por endpoint al inicio