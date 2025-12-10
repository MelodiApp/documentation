# Diagramas de Arquitectura

En esta sección se muestran diagramas de alto nivel que ilustran cómo interactúan los componentes del sistema.

## Diagrama general (Componentes)

```mermaid
flowchart LR
  subgraph Frontends
    Mobile[Frontend Móvil (Expo)]
    Backoffice[Backoffice web (Vite/React)]
  end

  subgraph Infra
    Gateway[Gateway (Node.js)]
    S3[(Almacenamiento S3 / LocalStack)]
  end

  subgraph Services
    Users[Users Service]
    Artists[Artists Service]
    Libraries[Libraries Service]
    Metrics[Metrics Service]
    Notifications[Notifications Service]
  end

  Mobile -->|HTTP/REST| Gateway
  Backoffice -->|HTTP/REST| Gateway
  Gateway -->|Enrutamiento| Users
  Gateway -->|Enrutamiento| Artists
  Gateway -->|Enrutamiento| Libraries
  Gateway -->|Enrutamiento| Metrics
  Gateway -->|Enrutamiento| Notifications
  Artists -- S3 --> S3
  Libraries -- S3 --> S3
```

## Diagrama de secuencia (Solicitud de reproducción / detalle de artista)

```mermaid
sequenceDiagram
  participant Mobile
  participant Gateway
  participant Artists
  participant S3

  Mobile->>Gateway: GET /artists/{id}
  Gateway->>Artists: GET /artists/{id}
  Artists->>S3: GET /assets/{image}
  S3-->>Artists: image
  Artists-->>Gateway: artist details + asset URLs
  Gateway-->>Mobile: artist details + asset URLs
```

## Diagrama de despliegue (alto nivel)

```mermaid
flowchart TD
  subgraph Heroku
    Gateway
    Users
    Artists
    Libraries
    Metrics
    Notifications
  end

  subgraph Vercel
    Backoffice
  end

  subgraph Expo
    Mobile
  end

  Mobile --> Gateway --> Services
  Backoffice --> Gateway --> Services
```

Estos diagramas son conceptuales y facilitan la comprensión de la arquitectura. Para detalles concretos de despliegue (tamaños de instancia, variables de entorno y secretos), consultar los README de cada microservicio y la configuración de Heroku/Vercel.

