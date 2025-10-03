# Arquitectura - Visión General

> Esta es una vista de alto nivel (C4 - Contexto/Contenedores) del sistema.

```mermaid
graph LR
  U[Usuario] -->|HTTP/HTTPS| GW[API Gateway]
  subgraph Backend
    GW --> AUTH[Auth Service]
    GW --> MUS[Music Service]
    GW --> PL[Playlist Service]
    GW --> SRCH[Search Service]
    MUS --> STG[(Object Storage)]
    PL --> DB[(Relational DB)]
    SRCH --> IDX[(Search Index)]
    AUTH --> REDIS[(Redis)]
  end
  subgraph External
    EXT[Proveedor OAuth]
  end
  AUTH -->|OAuth| EXT
```

## Decisiones clave
- Microservicios por dominio (Auth, Música, Playlists, Búsqueda)
- Event-driven para sincronizar metadatos musicales
- Base relacional para playlists (consistencia) y almacenamiento de objetos para media

Consulta las [ADRs](decisiones/README.md) para el detalle.