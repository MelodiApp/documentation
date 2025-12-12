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


