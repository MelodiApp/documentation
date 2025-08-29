<p align="center">
  <img src="frontend/src/assets/images/logo_wide.png" width="1500" alt="Logo Melodía">
</p>

# Melodia - API de Playlists

> **Trabajo Práctico Grupal - Ingeniería de Software II**

Melodía es una aplicación de música en streaming desarrollada para ofrecer una experiencia completa y atractiva. Su objetivo es permitir a los usuarios descubrir nuevas canciones, reproducir su música favorita y organizar playlists de forma sencilla e intuitiva.

## Autores

| Nombre         | Apellido      | Mail                  | Padrón |
| -------------- | ------------- | --------------------- | ------ |
| Ian            | von der Heyde | ivon@fi.uba.ar        | 107638 |
| Valentín       | Schneider     | vschneider@fi.uba.ar  | 107964 |
| Daniela        | Ojeda         | dojeda@fi.uba.ar      | 107690 |
| Alan           | Cantero       | acantero@fi.uba.ar    | 99676  |
| Ezequiel       | Lazarte       | ezlazarte@fi.uba.ar   | 108063 |


## Índice

- [Características y Stack Tecnológico](#características-y-stack-tecnológico)
- [Arquitectura del Proyecto](#arquitectura-del-proyecto)
- [Inicio Rápido](#inicio-rápido)
- [Endpoints Implementados](#endpoints-implementados)
  - [Songs](#songs)
  - [Playlists](#playlists)
- [Testing](#testing)
- [Calidad de Código](#calidad-de-código)
  - [Linter y Formateador](#linter-y-formateador)
  - [Pre-commit hooks](#pre-commit-hooks)
- [Esquema de Base de Datos y Contrato API](#esquema-de-base-de-datos-y-contrato-api)
- [Dependencias de desarrollo](#dependencias-de-desarrollo)
- [Logs](#logs)
- [Proceso de Pensamiento](#proceso-de-pensamiento)
- [Desafíos Encontrados](#desafíos-encontrados)
- [Requerimientos](#requerimientos)
- [Desafíos Opcionales Realizados](#desafíos-opcionales-realizados)
- [CI/CD: Tests automáticos con GitHub Actions](#cicd-tests-automáticos-con-github-actions)


## Características y Stack Tecnológico

- **API RESTful** desarrollada con **Python** y **FastAPI**
- **Base de datos**: PostgreSQL 16
- **ORM**: SQLAlchemy
- **Arquitectura en capas** (routers, crud, models, schemas)
- **CRUD genérico** reutilizable
- **Containerización**: Docker & Docker Compose
- **Tests automatizados** con pytest
- **Validación robusta** con Pydantic v2
- **Linter y formateador**: Ruff
- **Errores estándar** RFC 7807
- **OpenAPI** con 422 removido (todas las validaciones devuelven 400)

---

## Arquitectura del Proyecto

### Estructura de Archivos

  ```
  app/
  ├── main.py                     # 
  │
  tests/
  ├── 
  └──

  db/
  ├── 
  └── 
  ```

---

## Inicio Rápido


## Endpoints Implementados

### Songs


### Playlists

## Testing

Para correr los tests dentro del contenedor backend:
1. **Todas las pruebas**
    ```bash
    a
    ```

## Calidad de Código

### Linter y Formateador 

- **Verificar código:**
  ```bash
  a
  ```

- **Arreglar problemas automáticamente:**
  ```bash
  a
  ```

- **Formatear código:**
  ```bash
  a
  ```

### Pre-commit hooks

## Esquema de Base de Datos y Contrato API

## Dependencias de desarrollo


## Logs

- Logging 
  ```bash
  a
  ```

### Niveles de logueo

El nivel de logueo depende del entorno:

- Si `ENVIRONMENT=production`, **siempre se usa `WARNING`** (no importa el valor de `LOG_LEVEL`).
- Si `ENVIRONMENT=development`, puedes configurar el nivel con la variable `LOG_LEVEL` en tu archivo `.env` (por defecto: `INFO`).

Valores posibles para `LOG_LEVEL` (de mayor a menor severidad):

- `CRITICAL`
- `ERROR`
- `WARNING`
- `INFO`
- `DEBUG`
- `NOTSET`

> **Recomendación:**  
> - Usa `INFO` para desarrollo general.  
> - Usa `DEBUG` solo para troubleshooting detallado.  
> - En producción, el nivel es siempre `WARNING` para evitar ruido innecesario.

---

## Proceso de Pensamiento


## Desafíos Encontrados


## Requerimientos

### Dependencias principales

- `fastapi`

### Dependencias solo para desarrollo

- `colorlog` — formateo de logs en color

> **Nota:**  
> Las dependencias de desarrollo se encuentran en `requirements-dev.txt` y se instalan automáticamente si `ENVIRONMENT=development` en tu `.env`.

---

## CI/CD: Tests automáticos con GitHub Actions

El proyecto incluye un workflow de GitHub Actions que ejecuta los tests automáticamente en cada push o pull request a la rama `main`.
