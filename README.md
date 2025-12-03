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

## Cómo levantar la documentación

A continuación se describen varias formas sencillas para levantar esta documentación localmente usando Docsify.

### Requisitos

- Node.js (recomendado >= 12) y npm o yarn. Si no querés instalar nada, podés usar npx.

### Opción A — Usar npx (sin instalar nada globalmente)

```bash
npx docsify-cli@4 serve . -p 4000
```

### Opción B — Instalar Docsify CLI globalmente

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

- Abrí tu navegador en: <http://localhost:4000>

### Notas y solución de problemas

- Si el puerto 4000 está en uso, cambiar el número de puerto (ej: `-p 5000`).
- Si recibís errores de permisos al instalar globalmente, usá `sudo` o la opción npx.
- Para recargar cambios en los archivos markdown, sólo guardá los archivos; docsify actualiza en caliente.

### ¿Algo más?

- Si querés, puedo agregar un script al `package.json` (si existe) para simplificar aún más el arranque.

La instrucción mínima rápida:

```bash
docsify serve . -p 4000
```

o (sin instalar)

```bash
npx docsify-cli@4 serve . -p 4000
```
