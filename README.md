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

## Cómo levantar la documentación

A continuación se describen varias formas sencillas para levantar esta documentación localmente usando Docsify.

### Requisitos

Node.js (recomendado >= 12) y npm o yarn si prefiere usar Docsify. Para el flujo recomendado con MkDocs, necesitará Python 3 y pip.

### Opción recomendada — Usar MkDocs (igual que lo publicado en GitHub Pages)

MkDocs genera el sitio estático final que se publica en GitHub Pages. Si desea reproducir exactamente la versión publicada y usar el tema Material, esta es la opción recomendada.

```bash
# Sin venv — método recomendado (pipx)
# 1) instalar pipx (si no está instalado):
python3 -m pip install --user pipx
python3 -m pipx ensurepath
# Si pipx añade rutas al PATH, cerrá y reabrí la terminal

# 2) instalar mkdocs con pipx y añadir plugins:
pipx install mkdocs
pipx runpip mkdocs install mkdocs-material mkdocs-mermaid2-plugin

# 3) servir en vivo en puerto 4000:
mkdocs serve -a 127.0.0.1:4000

# Alternativa sin pipx (pip --user):
python3 -m pip install --user mkdocs mkdocs-material mkdocs-mermaid2-plugin
export PATH="$HOME/.local/bin:$PATH"
mkdocs serve -a 127.0.0.1:4000

# Alternativa con virtualenv (opcional, aislada):
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install mkdocs mkdocs-material mkdocs-mermaid2-plugin
mkdocs serve -a 127.0.0.1:4000

# O generar el sitio estático (directorio `site/`)
mkdocs build --strict
```

### Opción B — Usar Docsify (rápido, sin instalar nada globalmente)

Docsify es útil para ver rápidamente los archivos markdown con recarga en caliente, pero no genera el sitio final con MkDocs. Si desea usar Docsify para edición rápida:

```bash
# Servir la carpeta docs (desde la raíz del repo)
npx docsify-cli@4 serve docs -p 4000
```

Si `docs/index.html` falta, Docsify solicitará ejecutar `docsify init docs`. Si prefiere usar Docsify como alternativa, puede generar `index.html` con:

```bash
npx docsify-cli@4 init docs --force
```

### Opción C — Instalar Docsify CLI globalmente

- Instalar:

```bash
npm install -g docsify-cli
# o con yarn
yarn global add docsify-cli
```

- Levantar la docs:

```bash
docsify serve . -p 4000
```

### Acceder a la documentación

- Abra su navegador en: <http://localhost:4000>

También puede consultar la sección "APIs" para ver las especificaciones OpenAPI/Swagger (ver `docs/apis.md` en esta carpeta o el índice de la documentación).

### Servir la versión estática (`site/`)

Si ya generó el sitio con `mkdocs build`, puede servir el contenido HTML generado con Python (rápido):

```bash
cd /home/daniela/Escritorio/IDS2/Melodia/documentation
python3 -m http.server 4000 --directory site
```

### Notas y solución de problemas

- Si el puerto 4000 está en uso, cambiar el número de puerto (ej: `-p 5000`).
- Si recibís errores de permisos al instalar globalmente, usá `sudo` o la opción npx.
- Para recargar cambios en los archivos markdown, sólo guarde los archivos; docsify actualiza en caliente.

### ¿Algo más?

- Si lo desea, puedo agregar un script al `package.json` (si existe) para simplificar aún más el arranque.

La instrucción mínima rápida:

```bash
# desde la raíz del repo
npx docsify-cli@4 serve docs -p 4000
```

o (sin instalar)

```bash
npx docsify-cli@4 serve docs -p 4000
```

Scripts de ayuda (opcional)

```bash
# sirve con docsify y crea index si falta
./scripts/serve-docsify.sh

# sirve con mkdocs (crea .venv e instala deps si es necesario)
./scripts/serve-mkdocs.sh
```
