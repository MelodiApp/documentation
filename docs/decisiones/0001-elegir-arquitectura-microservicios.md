# ADR 0001 - Elegir arquitectura de microservicios
Fecha: 2025-09-20
Estado: Aprobada

## Contexto
Necesitamos escalar y desplegar de forma independiente módulos como autenticación, catálogo musical y playlists.

## Opciones evaluadas
1) Monolito modular
2) Microservicios por dominio
3) SOA con ESB

## Decisión
Adoptar microservicios por dominio con API Gateway y mensajería para eventos.

## Consecuencias
+ Despliegue independiente, escalado selectivo
- Mayor complejidad operativa y observabilidad