<p align="center">
  <img src="docs/assets/logo_wide.png" width="1500" alt="Logo Melodía">
</p>

# Melodia - API de Playlists

> **Trabajo Práctico Grupal - Ingeniería de Software II**

Melodía es una aplicación de música en streaming desarrollada para ofrecer una experiencia completa y didáctica. Su objetivo es permitir a los usuarios descubrir nuevas canciones, reproducir música y organizar playlists de forma sencilla e intuitiva. Esta documentación detalla arquitectura, decisiones de diseño, hitos, y cómo contribuir y ejecutar el proyecto localmente.

## Autores

| Nombre         | Apellido      | Mail                  | Padrón |
| -------------- | ------------- | --------------------- | ------ |
| Ian            | von der Heyde | ivon@fi.uba.ar        | 107638 |
| Valentín       | Schneider     | vschneider@fi.uba.ar  | 107964 |
| Daniela        | Ojeda         | dojeda@fi.uba.ar      | 107690 |
| Alan           | Cantero       | acantero@fi.uba.ar    | 99676  |
| Ezequiel       | Lazarte       | ezlazarte@fi.uba.ar   | 108063 |

## Como iniciar el proyecto localmente

Esta sección explica cómo clonar todos los repositorios necesarios y levantar el proyecto completo de Melodia con todos sus microservicios.

### Pre-requisitos

Antes de comenzar, asegúrate de tener instalado:

- **Docker** y **Docker Compose** - [Descargar](https://www.docker.com/products/docker-desktop)
- **Git** - [Descargar](https://git-scm.com/)
- **Node.js** (v20 o superior) - [Descargar](https://nodejs.org/) *(solo para frontend móvil)*
- **Python 3.12** - [Descargar](https://www.python.org/) *(opcional, para desarrollo local)*

### 1. Estructura de directorios

Crea una carpeta raíz para todo el proyecto y clona todos los repositorios:

```bash
# Crear directorio raíz del proyecto
mkdir melodia-tp
cd melodia-tp
```

### 2. Clonar todos los repositorios

Clona cada uno de los repositorios del proyecto:

```bash
# Infraestructura y servicios de soporte
git clone https://github.com/MelodiApp/localstack.git
git clone https://github.com/MelodiApp/documentation.git

# Backend - Microservicios
git clone https://github.com/MelodiApp/gateway.git
git clone https://github.com/MelodiApp/users-microservice.git
git clone https://github.com/MelodiApp/artists-microservice.git
git clone https://github.com/MelodiApp/libraries-microservice.git
git clone https://github.com/MelodiApp/metrics-microservice.git
git clone https://github.com/MelodiApp/notifications-microservice.git

# Frontend
git clone https://github.com/MelodiApp/MelodiaFront.git front
git clone https://github.com/MelodiApp/melodia-backoffice.git backoffice
```

Estructura final esperada:

```
melodia-tp/
├── localstack/          # Simula AWS S3 localmente
├── api-gateway/         # Punto de entrada y enrutamiento
├── users/               # Gestión de usuarios y autenticación
├── artists/             # Gestión de artistas, canciones y álbumes
├── libraries/           # Gestión de playlists y contenido guardado
├── metrics/             # Análisis y métricas de reproducción
├── notifications/       # Notificaciones push e in-app
├── front/               # Aplicación móvil (React Native/Expo)
├── backoffice/          # Panel de administración (React)
└── documentation/       # Documentación del proyecto (este repo)
```

### 3. Configurar variables de entorno

Cada microservicio necesita su archivo `.env`. Copia los archivos de ejemplo:

```bash
# Backend services
cd api-gateway && cp .env.example .env && cd ..
cd users && cp .env.example .env && cd ..
cd artists && cp .env.example .env && cd ..
cd libraries && cp .env.example .env && cd ..
cd metrics && cp .env.example .env && cd ..
cd notifications && cp .env.example .env && cd ..

# LocalStack (requiere token de LocalStack Pro)
cd localstack && cp .env.example .env && cd ..
# Edita localstack/.env y agrega tu LOCALSTACK_AUTH_TOKEN

# Frontend móvil
cd front && cp .env.example .env && cd ..
```

> **Nota**: Para LocalStack, necesitas un token de autenticación que puedes obtener en [LocalStack Dashboard](https://app.localstack.cloud/). Los demás servicios pueden usar los valores por defecto para desarrollo local.

### 4. Usar el script de gestión `manage-service.sh`

El script `manage-service.sh` facilita la gestión de todos los microservicios. Primero, cópialo a la carpeta raíz:

```bash
# Copiar el script desde el repo de documentación
cp documentation/manage-service.sh .
chmod +x manage-service.sh
```

### 5. Levantar todos los servicios

Con el script en la carpeta raíz, puedes levantar todos los servicios con un solo comando:

```bash
# Levantar todos los servicios (primera vez)
./manage-service.sh up
```

Este comando:
- Levanta LocalStack (simulación de S3)
- Levanta API Gateway
- Levanta todos los microservicios (users, artists, libraries, metrics, notifications)
- Aplica migraciones de base de datos automáticamente
- Genera los clientes de Prisma necesarios

**Servicios disponibles:**
- API Gateway: `http://localhost:8091`
- Users Service: `http://localhost:8092`
- Artists Service: `http://localhost:8093`
- Libraries Service: `http://localhost:8094`
- Metrics Service: `http://localhost:8095`
- Notifications Service: `http://localhost:8096`
- LocalStack S3: `http://localhost:4566`

### 6. Verificar que todo funciona

```bash
# Verificar el estado de los contenedores
docker ps

# Ver logs en tiempo real (abre una nueva pestaña de terminal automáticamente)
./manage-service.sh logs

# O ver logs en pantalla dividida
./manage-service.sh logs-split
```

### 7. Frontend móvil (Desarrollo con dispositivo físico)

La aplicación móvil requiere compilar una versión de desarrollo nativa para trabajar localmente.

#### Configuración inicial del entorno Android

Antes de poder compilar la app, necesitas configurar el entorno de desarrollo Android. Sigue la guía completa en [SETUP_ANDROID_STUDIO.md](SETUP_ANDROID_STUDIO.md).

**Requisitos previos:**
- JDK 17
- Android Studio con SDK API 33
- Variables de entorno configuradas (ANDROID_HOME, JAVA_HOME)
- Dispositivo Android físico con depuración USB habilitada

#### Primera compilación

```bash
cd front

# Instalar dependencias
npm install --legacy-peer-deps

# Conectar el teléfono por USB y verificar conexión
adb devices

# Compilar e instalar la app en el dispositivo (primera vez)
npx expo run:android
```

> **Nota**: La primera compilación puede tardar varios minutos. Este comando debe ejecutarse:
> - La primera vez que configures el proyecto
> - Cada vez que cambies dependencias en `package.json`
> - Cuando modifiques configuración nativa

#### Desarrollo diario con hot-reload

Una vez compilada e instalada la app, para el trabajo diario usa:

```bash
# Iniciar servidor de desarrollo con hot-reload (con teléfono conectado por USB)
npx expo start --dev-client
```

Este comando es mucho más rápido y permite ver cambios en tiempo real sin recompilar toda la app.

### 8. Backoffice web (opcional)

Para levantar el panel de administración:

```bash
cd backoffice

# Instalar dependencias
npm install

# Iniciar en modo desarrollo
npm run dev
```

El backoffice estará disponible en `http://localhost:5173`

### Comandos útiles del script

```bash
# Ver todos los comandos disponibles
./manage-service.sh --help

# Levantar servicios (uso diario, sin rebuild)
./manage-service.sh up

# Rebuild completo (cuando cambies dependencias o Dockerfiles)
./manage-service.sh rebuild

# Reiniciar servicios (útil tras cambiar .env)
./manage-service.sh restart

# Ver logs en tiempo real
./manage-service.sh logs        # Pestañas separadas por servicio
./manage-service.sh logs-split  # Pantalla dividida

# Detener todos los servicios
./manage-service.sh down

# Detener y eliminar volúmenes
./manage-service.sh down -v

# Ejecutar comandos git en todos los repos
./manage-service.sh git status
./manage-service.sh git pull

# Ejecutar git solo en servicios específicos (números: 0-6)
./manage-service.sh git 1,2 status  # Solo gateway y users

# Limpieza de Docker
./manage-service.sh cleanup
```

### Troubleshooting

**Si los servicios no se conectan entre sí:**

1. Verifica que la red Docker existe:
   ```bash
   docker network create melodiapp-net
   ```

2. Reinicia los servicios:
   ```bash
   ./manage-service.sh restart
   ```

**Si necesitas limpiar todo y empezar de nuevo:**

```bash
# Detener servicios y eliminar volúmenes
./manage-service.sh down -v

# Limpiar recursos de Docker
./manage-service.sh cleanup

# Volver a levantar
./manage-service.sh rebuild
```

**Para actualizar el código de todos los repos:**

```bash
# Hacer pull en todos los servicios
./manage-service.sh git pull
```

**Si cambias variables de entorno:**

```bash
# Simplemente reinicia (no necesitas rebuild)
./manage-service.sh restart
```

### Workflow típico de desarrollo

```bash
# 1. Levantar servicios al inicio del día
./manage-service.sh up

# 2. Ver logs si necesitas debuggear
./manage-service.sh logs

# 3. Editar código (los cambios se reflejan automáticamente con hot-reload)

# 4. Si cambias package.json o requirements.txt
./manage-service.sh rebuild

# 5. Al terminar el día
./manage-service.sh down
```

## Cómo levantar la documentación

A continuación se muestran los comandos mínimos para servir la documentación localmente usando MkDocs (recomendado) o Docsify (vista rápida).

1) Servir con MkDocs (recomendado — reproduce la versión publicada)

```bash
# sin venv (usa pipx o pip --user)
python3 -m pip install --user pipx && python3 -m pipx ensurepath
pipx install mkdocs
pipx runpip mkdocs install mkdocs-material mkdocs-mermaid2-plugin
mkdocs serve -a 127.0.0.1:4000
```

Alternativa (pip --user):
```bash
python3 -m pip install --user mkdocs mkdocs-material mkdocs-mermaid2-plugin
export PATH="$HOME/.local/bin:$PATH"
mkdocs serve -a 127.0.0.1:4000
```

2) Servir con Docsify (vista rápida)

```bash
npx docsify-cli@4 serve docs -p 4000
```

3) Servir la versión estática (si ya ejecutaste `mkdocs build`):

```bash
python3 -m http.server 4000 --directory site
```

Scripts de ayuda (opcional; ya incluidos en el repo):
```bash
./scripts/serve-docsify.sh
./scripts/serve-mkdocs-no-venv.sh
./scripts/serve-mkdocs.sh
```


