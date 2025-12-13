#!/usr/bin/env bash
set -euo pipefail

# manage-services.sh
# Script para gestionar múltiples microservicios con Docker Compose y Git

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
# Orden específico de servicios 
# (localstack en 0, api-gateway en 1, users en 2, artists en 3, libraries en 4, metrics en 5)
SERVICES=(
  "localstack"
  "gateway"
  "users-microservice"
  "artists-microservice"
  "libraries-microservice"
  "metrics-microservice"
  "notifications-microservice"
)

HEROKU_APPS=(
  "api-gateway-melodia"
  "users-service-melodia"
  "artists-service-melodia"
  "libraries-service-melodia"
  "metrics-service-melodia"
  "notifications-service-melodia"
)

SESSION="melodia"
TMUX_CONF="$BASE_DIR/.tmux-melodia.conf"
LOG_TAIL="300"  # Cantidad de líneas históricas a mostrar en logs (-f)

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
RESET='\033[0m'

# Colores específicos por servicio (el orden DEBE COINCIDIR con el array SERVICES)
SERVICE_COLORS_BY_INDEX=(
  "\033[38;5;220m"  # 0: localstack - amarillo
  "\033[38;5;25m"   # 1: api-gateway - azul oscuro
  "\033[38;5;89m"   # 2: users - morado oscuro
  "\033[38;5;202m"  # 3: artists - naranja
  "\033[38;5;36m"   # 4: libraries - verde
  "\033[38;5;99m"   # 5: metrics - magenta oscuro
  "\033[38;5;165m"  # 6: notifications - rosa/magenta claro
)

# Obtener número de servicio según su posición en SERVICES
service_number() {
  local name="$1"
  local i
  for i in "${!SERVICES[@]}"; do
    if [[ "${SERVICES[$i]}" == "$name" ]]; then
      echo "$i"
      return 0
    fi
  done
  echo "?"
}

print_banner() {
  local service_name=$1
  local label=${2:-$1}
  local service_idx
  service_idx=$(service_number "$service_name")
  local color=${SERVICE_COLORS_BY_INDEX[$service_idx]:-$RESET}
  echo -e "${color}===== ${label} =====${RESET}"
}

show_usage() {
  cat << EOF
Usage: $0 <command> [options]

Commands:
  up                    Levanta todos los servicios en modo detach (SIN --build por defecto)
  rebuild               Levanta con --build (usar solo cuando cambien dependencias o Dockerfiles)
  restart               Reinicia servicios (útil tras cambiar variables de entorno)
  logs                  Abre una sesión tmux (pestañas) y sigue logs (-f) por servicio; abre en nueva pestaña
  logs-split            Igual que 'logs' pero en pantalla dividida (layout de mosaico); abre en nueva pestaña
  heroku-logs           Abre una sesión tmux (pestañas) y sigue logs (-t) de Heroku apps; abre en nueva pestaña
  down                  Detiene todos los servicios con docker compose down Y mata sesión tmux
  down -v               Detiene y elimina volúmenes con docker compose down -v Y mata sesión tmux
  kill                  Mata la sesión tmux (NO detiene contenedores, solo cierra pestañas)
  attach                Abre tmux en una nueva pestaña de la terminal
  inject-ip             Inyecta la IP local (192.168.x.x) en los .env de los servicios principales
  git [service#] <cmd>  Ejecuta un comando git en servicios específicos o en todos
  cleanup               Ejecuta limpieza rápida de Docker (contenedores, cache, imágenes dangling)

Layout Modes (para 'logs'):
  'logs' (tabs):     Pestañas separadas
  'logs-split':      Pantalla dividida → Ver todos los logs simultáneamente
                     ┌─────────────────────────────┐
                     │    gateway   │     users    │
                     ├──────────────┴──────────────┤
                     │    artists   │   libraries  │
                     └──────────────┴──────────────┘

Examples:
  # Git en todos los servicios
  $0 git status
  $0 git branch
  $0 git log --oneline -5
  
  # Git en servicios específicos (separados por coma)
  $0 git 1,2 status          # Solo en api-gateway y users
  $0 git 3 branch            # Solo en artists
  $0 git 1,3,4 status        # En api-gateway, artists y librariess

Service Numbers:
  0 - localstack
  1 - api-gateway
  2 - users
  3 - artists
  4 - libraries
  5 - metrics
  6 - notifications

Options:
  -h, --help      Muestra esta ayuda

IMPORTANTE:
  - 'up' levanta contenedores SIN rebuild (rápido, para trabajo diario)
  - 'rebuild' hace --build completo (solo cuando cambias dependencias o Dockerfiles)
  - 'restart' reinicia contenedores (útil tras cambiar .env sin rebuild)
  - 'logs'/'logs-split' crean/renuevan la sesión tmux para ver logs
  - 'kill' solo cierra tmux, NO detiene contenedores
  - 'down' detiene contenedores Y cierra sesión tmux. Workflow típico: down
  - 'cleanup' ejecuta limpieza segura de Docker (no toca volúmenes de DB)

Cuándo usar cada comando:
  • Trabajo diario (editas código):       $0 up
  • Cambiaste package.json/requirements:  $0 rebuild
  • Cambiaste variables en .env:          $0 restart
    • Sino también:               $0 down && $0 up
  • Primera vez o cambios en Dockerfile:  $0 rebuild

Notas:
  - localstack se levanta en segundo plano y NO aparece en la sesión de tmux.
    Sigue siendo manejado por 'up' y 'down'.

EOF
}

# Función para crear configuración tmux personalizada
setup_tmux_config() {
  echo -e "${GREEN}Creando configuración tmux personalizada...${RESET}"
  
  cat > "$TMUX_CONF" << 'TMUXCONF'
# Configuración personalizada para Melodia Services

# Mejorar colores
set -g default-terminal "screen-256color"

# Título de la terminal: nombre de la sesión (fijo)
set -g set-titles on
set -g set-titles-string "#S"

# Formato de la barra de estado
set -g status-style bg=colour235,fg=colour255
set -g status-left-length 30
set -g status-left "#[fg=colour220,bold]❯ #S #[default]│ "
set -g status-right "#[fg=colour33]%H:%M #[fg=colour245]%d-%b-%y"

# Colores de ventanas activas/inactivas (mostrar solo el nombre; el número lo agregamos al nombre)
set -g window-status-format "#[fg=colour244] #W "
set -g window-status-current-format "#[fg=colour220,bold] #W #[default]"

# Highlight de actividad
set -g window-status-activity-style fg=colour196

# Numeración por defecto (base-index 0) para compatibilidad con el script

# Mantener nombres de ventanas fijos (no renombrar por comando activo)
setw -g automatic-rename off

# Historial más grande
set -g history-limit 50000

# Tiempo de escape más rápido
set -s escape-time 0

# Refrescar barra de estado cada segundo
set -g status-interval 1

# Colores de paneles
set -g pane-border-style fg=colour238
set -g pane-active-border-style fg=colour220

# Mostrar títulos en los bordes de los paneles (pane titles) — sin índice lógico de tmux
set -g pane-border-status top
set -g pane-border-format "#[fg=colour220,bold]#{pane_title}#[default]"

# Modo mouse
set -g mouse on

# Splits en el directorio del panel actual
bind-key '"' split-window -v -c "#{pane_current_path}"
bind-key % split-window -h -c "#{pane_current_path}"
TMUXCONF

  echo -e "${GREEN}✓ Configuración creada en: ${CYAN}$TMUX_CONF${RESET}"
  # Configuración usada automáticamente por el script; no requiere acciones manuales
}

# Función para crear/actualizar configuración (siempre se regenera)
ensure_tmux_config() {
  setup_tmux_config > /dev/null 2>&1
}

# Helper: abrir tmux en una nueva pestaña de terminal si es posible
open_attach_new() {
  if ! tmux has-session -t "$SESSION" 2>/dev/null; then
    echo -e "${RED}Error: No existe una sesión tmux '$SESSION'.${RESET}"
    return 1
  fi

  if [ -n "$GNOME_TERMINAL_SERVICE" ] || command -v gnome-terminal >/dev/null 2>&1; then
    gnome-terminal --tab -- bash -c "tmux attach -t $SESSION"
  elif command -v konsole >/dev/null 2>&1; then
    konsole --new-tab -e bash -c "tmux attach -t $SESSION" &
  elif command -v xfce4-terminal >/dev/null 2>&1; then
    xfce4-terminal --tab -e "bash -c 'tmux attach -t $SESSION'" &
  elif [ -n "$KITTY_WINDOW_ID" ]; then
    kitty @ launch --type=tab bash -c "tmux attach -t $SESSION"
  elif command -v alacritty >/dev/null 2>&1; then
    alacritty -e bash -c "tmux attach -t $SESSION" &
  else
    echo -e "${YELLOW}No se pudo abrir una nueva pestaña. Adjuntando en esta terminal...${RESET}"
    tmux attach -t "$SESSION"
  fi
}

# up: levantar todos los servicios en modo detach SIN --build (rápido)
docker_up_detached() {
  echo -e "${GREEN}Levantando servicios en modo detach (SIN --build)...${RESET}"

  for i in "${!SERVICES[@]}"; do
    local service="${SERVICES[$i]}"
    local dir="$BASE_DIR/$service"
    if [ ! -d "$dir" ]; then
      echo -e "${YELLOW}Warning: directorio no encontrado: $dir${RESET}"
      continue
    fi

    print_banner "$service" "$service (servicio #$i)"

    if [ -f "$dir/docker-compose.yml" ] || [ -f "$dir/docker-compose.yaml" ]; then
      # Levantar sin rebuild para desarrollo diario rápido
      (cd "$dir" && docker compose up -d)
      echo ""

      # Si el servicio es artists, generar cliente de Prisma si es necesario
      if [[ $service =~ ^artists($|-) ]]; then
        echo -e "${CYAN}Generando cliente de Prisma para artists...${RESET}"
        (cd "$dir" && npx prisma generate)
        echo ""
      elif [[ $service =~ ^notifications($|-) ]]; then
        echo -e "${CYAN}Generando cliente de Prisma para notifications-microservice...${RESET}"
        (cd "$dir" && npx prisma generate)
        echo ""
      fi

    else
      echo -e "${YELLOW}No docker-compose file found, skipping...${RESET}"
      echo ""
    fi
  done

  echo -e "${GREEN}✓ Servicios levantados.${RESET}"
}

# rebuild: levantar con --build (cuando cambien dependencias o Dockerfiles)
docker_rebuild() {
  echo -e "${YELLOW}Rebuilding servicios con --build (esto puede tardar)...${RESET}"

  for i in "${!SERVICES[@]}"; do
    local service="${SERVICES[$i]}"
    local dir="$BASE_DIR/$service"
    if [ ! -d "$dir" ]; then
      echo -e "${YELLOW}Warning: directorio no encontrado: $dir${RESET}"
      continue
    fi

    print_banner "$service" "$service (servicio #$i)"

    if [ -f "$dir/docker-compose.yml" ] || [ -f "$dir/docker-compose.yaml" ]; then
      # Rebuild completo
      (cd "$dir" && docker compose up -d --build)
      echo ""

      # Si el servicio es artists, regenerar cliente de Prisma
      if [[ $service =~ ^artists($|-) ]]; then
        echo -e "${CYAN}Generando cliente de Prisma para artists...${RESET}"
        (cd "$dir" && npx prisma generate)
        echo ""
      fi

    else
      echo -e "${YELLOW}No docker-compose file found, skipping...${RESET}"
      echo ""
    fi
  done

  echo -e "${GREEN}✓ Rebuild completado.${RESET}"
}

# restart: reiniciar servicios (útil tras cambiar variables de entorno)
docker_restart() {
  echo -e "${CYAN}Reiniciando servicios...${RESET}"

  for i in "${!SERVICES[@]}"; do
    local service="${SERVICES[@]:$i:1}"
    local dir="$BASE_DIR/$service"
    if [ ! -d "$dir" ]; then
      echo -e "${YELLOW}Warning: directorio no encontrado: $dir${RESET}"
      continue
    fi

    print_banner "$service" "$service (servicio #$i)"

    if [ -f "$dir/docker-compose.yml" ] || [ -f "$dir/docker-compose.yaml" ]; then
      (cd "$dir" && docker compose restart)
      echo ""
    else
      echo -e "${YELLOW}No docker-compose file found, skipping...${RESET}"
      echo ""
    fi
  done

  echo -e "${GREEN}✓ Servicios reiniciados.${RESET}"
}

# logs: crear sesión tmux y seguir logs (-f) por servicio
docker_logs_session() {
  local split_layout=${1:-false}

  if ! command -v tmux >/dev/null 2>&1; then
    echo -e "${RED}Error: tmux no está instalado. Por favor instálalo primero.${RESET}"
    exit 1
  fi

  # Verificar si la sesión existe
  if tmux has-session -t "$SESSION" 2>/dev/null; then
    echo -e "${YELLOW}La sesión tmux '$SESSION' ya existe.${RESET}"
    echo -e "Opciones:"
    echo -e "  1. Adjuntar a la sesión existente: ${GREEN}$0 attach${RESET}"
    echo -e "  2. Matar la sesión y crear una nueva: ${RED}$0 kill${RESET} ${GREEN}&& $0 up${RESET}"
    echo ""
    read -p "¿Quieres matar la sesión existente y crear una nueva? (s/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[SsYy]$ ]]; then
      echo -e "${RED}Matando sesión existente...${RESET}"
      tmux kill-session -t "$SESSION"
      echo -e "${GREEN}Sesión eliminada. Creando nueva sesión...${RESET}"
    else
      echo -e "${YELLOW}Operación cancelada.${RESET}"
      exit 0
    fi
  fi

  # Asegurar que existe la configuración
  ensure_tmux_config

  echo -e "${GREEN}Creando sesión tmux '$SESSION' para logs...${RESET}"

  # Separar servicios de aplicación (sin localstack)
  declare -a APP_SERVICES=()
  for name in "${SERVICES[@]}"; do
    if [ "$name" != "localstack" ]; then
      APP_SERVICES+=("$name")
    fi
  done

  # No incluir localstack en logs tmux; tampoco levantar contenedores aquí

  # Validar que haya al menos un servicio de app
  if [ ${#APP_SERVICES[@]} -eq 0 ]; then
    echo -e "${RED}No hay servicios de aplicación para iniciar en tmux.${RESET}"
    exit 1
  fi

  # Crear sesión tmux solo para los servicios de aplicación
  local first="${APP_SERVICES[0]}"
  local first_dir="$BASE_DIR/$first"
  local first_num
  first_num=$(service_number "$first")
  # Crear la sesión y capturar el ID de la ventana creada (robusto ante base-index != 0)
  local root_win_id
  root_win_id=$(tmux -f "$TMUX_CONF" new-session -d -s "$SESSION" -n "${first_num} $first" -c "$first_dir" -P -F '#{window_id}')
  # Capturar el pane activo de esa ventana y enviar el comando
  local root_pane_id
  root_pane_id=$(tmux display-message -p -t "$root_win_id" '#{pane_id}')
  # Comando: solo logs continuos con historial
  local COMPOSE_LOG_CMD="docker compose logs -f --tail=${LOG_TAIL}"
  # Título del panel con el número y nombre del servicio
  tmux select-pane -t "$root_pane_id" -T "${first_num} $first"
  tmux send-keys -t "$root_pane_id" "$COMPOSE_LOG_CMD" C-m

  if [ "$split_layout" = true ]; then
    # Pantalla dividida: renombrar ventana y añadir panes para cada servicio
    tmux rename-window -t "$root_win_id" "services"
    for name in "${APP_SERVICES[@]:1}"; do
      local dir="$BASE_DIR/$name"
      local svc_num
      svc_num=$(service_number "$name")
      # Crear split y obtener el pane_id resultante
      local new_pane
      new_pane=$(tmux split-window -t "$root_win_id" -c "$dir" -P -F '#{pane_id}')
      # Asignar título del panel y lanzar comando de logs
      tmux select-pane -t "$new_pane" -T "${svc_num} $name"
      tmux send-keys -t "$new_pane" "$COMPOSE_LOG_CMD" C-m
      tmux select-layout -t "$root_win_id" tiled >/dev/null
    done
    echo -e "${GREEN}✓ Modo dividido: servicios visibles a la vez (sin localstack).${RESET}"
    echo -e "Comandos útiles: ${CYAN}Ctrl+b arrows${RESET}, ${CYAN}Ctrl+b z${RESET}, ${CYAN}Ctrl+b q${RESET}"
  else
    # Pestañas separadas: crear una ventana por servicio (orden fijo)
    for name in "${APP_SERVICES[@]:1}"; do
      local dir="$BASE_DIR/$name"
      local svc_num
      svc_num=$(service_number "$name")
      # Crear nueva ventana y capturar su ID para direccionar correctamente
      local win_id
      win_id=$(tmux new-window -t "$SESSION" -n "${svc_num} $name" -c "$dir" -P -F '#{window_id}')
      local pane_id
      pane_id=$(tmux display-message -p -t "$win_id" '#{pane_id}')
      tmux send-keys -t "$pane_id" "$COMPOSE_LOG_CMD" C-m
    done
    echo -e "${GREEN}✓ Modo pestañas: una pestaña por servicio (sin localstack).${RESET}"
    echo -e "Cambia con: ${CYAN}Ctrl+b 0..${RESET}, lista con: ${CYAN}Ctrl+b w${RESET}"
  fi

  echo -e ""
  echo -e "Para detener servicios: ${YELLOW}$0 down${RESET}  |  Cerrar tmux: ${RED}$0 kill${RESET}"
}

# heroku-logs: crear sesión tmux y seguir logs (-t) de Heroku apps
heroku_logs_session() {
  if ! command -v heroku >/dev/null 2>&1; then
    echo -e "${RED}Error: Heroku CLI no está instalado. Por favor instálalo primero.${RESET}"
    exit 1
  fi

  # Forzar una sesión dedicada: 'heroku-logs'
  local HEROKU_SESSION_NAME="heroku-logs"

  # Verificar si la sesión existe
  if tmux has-session -t "$HEROKU_SESSION_NAME" 2>/dev/null; then
    echo -e "${YELLOW}La sesión tmux '$HEROKU_SESSION_NAME' ya existe.${RESET}"
    echo -e "Opciones:"
    echo -e "  1. Adjuntar a la sesión existente: ${GREEN}$0 attach${RESET}"
    echo -e "  2. Matar la sesión y crear una nueva: ${RED}$0 kill${RESET} ${GREEN}&& $0 heroku-logs${RESET}"
    echo ""
    read -p "¿Quieres matar la sesión existente y crear una nueva? (s/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[SsYy]$ ]]; then
      echo -e "${RED}Matando sesión existente...${RESET}"
      tmux kill-session -t "$HEROKU_SESSION_NAME"
      echo -e "${GREEN}Sesión eliminada. Creando nueva sesión...${RESET}"
    else
      echo -e "${YELLOW}Operación cancelada.${RESET}"
      exit 0
    fi
  fi

  # Asegurar que existe la configuración
  ensure_tmux_config

  echo -e "${GREEN}Creando sesión tmux '$HEROKU_SESSION_NAME' para logs de Heroku...${RESET}"

  # Validar que haya al menos una app de Heroku
  if [ ${#HEROKU_APPS[@]} -eq 0 ]; then
    echo -e "${RED}No hay apps de Heroku configuradas.${RESET}"
    exit 1
  fi

  # Crear sesión tmux para las apps de Heroku
  local first="${HEROKU_APPS[0]}"
  local first_num=1  # Numeración empezando desde 1 para Heroku apps
  # Crear la sesión y capturar el ID de la ventana creada
  local root_win_id
  root_win_id=$(tmux -f "$TMUX_CONF" new-session -d -s "$HEROKU_SESSION_NAME" -n "${first_num} $first" -P -F '#{window_id}')
  # Capturar el pane activo de esa ventana y enviar el comando
  local root_pane_id
  root_pane_id=$(tmux display-message -p -t "$root_win_id" '#{pane_id}')
  # Comando: heroku logs -t -a <app>
  local HEROKU_LOG_CMD="heroku logs -t -a $first"
  # Título del panel con el número y nombre de la app
  tmux select-pane -t "$root_pane_id" -T "${first_num} $first"
  tmux send-keys -t "$root_pane_id" "$HEROKU_LOG_CMD" C-m

  # Crear una ventana por app adicional
  local idx=2
  for app in "${HEROKU_APPS[@]:1}"; do
    # Crear nueva ventana y capturar su ID
    local win_id
    win_id=$(tmux new-window -t "$HEROKU_SESSION_NAME" -n "${idx} $app" -P -F '#{window_id}')
    local pane_id
    pane_id=$(tmux display-message -p -t "$win_id" '#{pane_id}')
    local HEROKU_LOG_CMD="heroku logs -t -a $app"
    tmux send-keys -t "$pane_id" "$HEROKU_LOG_CMD" C-m
    ((idx++))
  done

  echo -e "${GREEN}✓ Sesión tmux creada con logs de Heroku apps (sesión: $HEROKU_SESSION_NAME).${RESET}"
  echo -e "Cambia con: ${CYAN}Ctrl+b 1..${RESET}, lista con: ${CYAN}Ctrl+b w${RESET}"
  echo -e ""
  echo -e "Cerrar tmux: ${RED}$0 kill${RESET}"
  # Intentar abrir la sesión heroku-logs en una nueva pestaña (si hay terminal disponible)
  # Llamamos a open_attach_new con SESSION temporal para no cambiar el valor global
  SESSION="$HEROKU_SESSION_NAME" open_attach_new || true
}

# Función para matar sesión tmux
kill_tmux_session() {
  if tmux has-session -t "$SESSION" 2>/dev/null; then
    echo -e "${RED}Matando sesión tmux '$SESSION'...${RESET}"
    tmux kill-session -t "$SESSION"
    echo -e "${GREEN}Sesión cerrada.${RESET}"
  else
    echo -e "${YELLOW}No existe una sesión tmux '$SESSION'.${RESET}"
  fi
}

# Función para ejecutar docker compose down
docker_down() {
  local extra_args="$1"
  local cmd="docker compose down $extra_args"
  
  echo -e "${YELLOW}Ejecutando '$cmd' en todos los servicios...${RESET}"
  echo ""
  
  for i in "${!SERVICES[@]}"; do
    local service="${SERVICES[$i]}"
    local dir="$BASE_DIR/$service"
    
    if [ ! -d "$dir" ]; then
      echo -e "${YELLOW}Warning: directorio no encontrado: $dir${RESET}"
      continue
    fi
    
    print_banner "$service" "$service (servicio #$i)"
    
    if [ -f "$dir/docker-compose.yml" ] || [ -f "$dir/docker-compose.yaml" ]; then
      (cd "$dir" && eval "$cmd")
      echo ""
    else
      echo -e "${YELLOW}No docker-compose file found, skipping...${RESET}"
      echo ""
    fi
  done
  
  echo -e "${GREEN}Comando completado en todos los servicios.${RESET}"
}

# Función para ejecutar comandos git
git_command() {
  local service_indices=()
  local git_cmd_args=() # Usar un array para los argumentos de git

  if [ $# -eq 0 ]; then
    echo -e "${RED}Error: debes proporcionar un comando git${RESET}"
    echo "Ejemplo: $0 git status"
    echo "Ejemplo: $0 git 1,2 status"
    exit 1
  fi

  # Detectar si el primer argumento es un número o lista de números
  if [[ "$1" =~ ^[0-9,]+$ ]]; then
    # Primer argumento es una lista de índices
    IFS=',' read -ra service_indices <<< "$1"
    shift
    git_cmd_args=("$@") # Guardar el resto de argumentos en el array

    if [ ${#git_cmd_args[@]} -eq 0 ]; then
      echo -e "${RED}Error: debes proporcionar un comando git después de los números${RESET}"
      echo "Ejemplo: $0 git 1,2 status"
      exit 1
    fi

    echo -e "${YELLOW}Ejecutando 'git ${git_cmd_args[*]}' en servicios seleccionados...${RESET}"
  else
    # Ejecutar en todos los servicios
    git_cmd_args=("$@") # Guardar todos los argumentos
    for i in "${!SERVICES[@]}"; do
      service_indices+=("$i")
    done
    echo -e "${YELLOW}Ejecutando 'git ${git_cmd_args[*]}' en todos los servicios...${RESET}"
  fi

  echo ""

  for idx in "${service_indices[@]}"; do
    # Validar que el índice esté en rango
    if [ "$idx" -ge 0 ] && [ "$idx" -lt "${#SERVICES[@]}" ]; then
      service="${SERVICES[$idx]}"
      dir="$BASE_DIR/$service"

      if [ ! -d "$dir" ]; then
        echo -e "${YELLOW}Warning: directorio no encontrado: $dir${RESET}"
        continue
      fi

      print_banner "$service" "$service (servicio #$idx)"

      if [ -d "$dir/" ]; then
        # Ejecutar el comando git con los argumentos preservados
        (cd "$dir" && git -c color.ui=always "${git_cmd_args[@]}") || echo -e "${RED}Error ejecutando git en $service${RESET}"
        echo ""
      else
        echo -e "${YELLOW}No es un repositorio git, skipping...${RESET}"
        echo ""
      fi
    else
      echo -e "${RED}Error: índice de servicio inválido: $idx (debe estar entre 0 y $((${#SERVICES[@]}-1)))${RESET}"
      echo ""
    fi
  done

  echo -e "${GREEN}Comando git completado.${RESET}"
}

# Función para inyectar IP local en .env de servicios principales
inject_ip() {
  echo -e "${GREEN}Obteniendo IP local...${RESET}"
  
  # Obtener IP local que comienza con 192.168.
  local LOCAL_IP
  LOCAL_IP=$(hostname -I | grep -o '192\.168\.[0-9]\+\.[0-9]\+' | head -1)
  
  if [ -z "$LOCAL_IP" ]; then
    echo -e "${RED}Error: No se pudo encontrar una IP local que comience con 192.168.${RESET}"
    exit 1
  fi
  
  echo -e "${GREEN}IP local encontrada: ${CYAN}$LOCAL_IP${RESET}"
  echo ""
  
  for i in "${!SERVICES[@]}"; do
    local service="${SERVICES[$i]}"

    if [[ $service =~ ^localstack($|-) ]]; then
      continue
    fi

    local dir="$BASE_DIR/$service"
    
    if [ ! -d "$dir" ]; then
      echo -e "${YELLOW}Warning: directorio no encontrado: $dir${RESET}"
      continue
    fi
    
    print_banner "$service" "$service (servicio #$i)"
    
    local env_file="$dir/.env"
    
    if [ -f "$env_file" ]; then
      # Verificar si la línea IP_LOCAL ya existe
      if grep -q "^IP_LOCAL=" "$env_file"; then
        # Reemplazar la línea existente
        sed -i "s/^IP_LOCAL=.*/IP_LOCAL=$LOCAL_IP/" "$env_file"
        echo -e "${GREEN}✓ Actualizada IP_LOCAL en $env_file${RESET}"
      else
        # Agregar al final
        echo "IP_LOCAL=$LOCAL_IP" >> "$env_file"
        echo -e "${GREEN}✓ Agregada IP_LOCAL en $env_file${RESET}"
      fi
    else
      echo -e "${YELLOW}No se encontró .env en $dir, creando uno...${RESET}"
      echo "IP_LOCAL=$LOCAL_IP" > "$env_file"
      echo -e "${GREEN}✓ Creado $env_file con IP_LOCAL${RESET}"
    fi
    
    echo ""
  done
  
  echo -e "${GREEN}✓ Inyección de IP completada en todos los servicios principales.${RESET}"
}


# Función para limpieza rápida de Docker
docker_cleanup() {
  echo -e "${YELLOW}Ejecutando limpieza rápida de Docker...${RESET}"
  echo ""
  
  # 1. Limpiar contenedores parados
  echo -e "${CYAN}1. Eliminando contenedores parados...${RESET}"
  docker container prune -f
  echo ""
  
  # 2. Limpiar imágenes dangling
  echo -e "${CYAN}2. Eliminando imágenes sin usar (dangling)...${RESET}"
  docker image prune -f
  echo ""
  
  # 3. Limpiar build cache antiguo (>7 días)
  echo -e "${CYAN}3. Limpiando build cache antiguo (>7 días)...${RESET}"
  docker builder prune -f --filter "until=168h"
  echo ""
  
  # 4. Limpiar networks no utilizadas
  echo -e "${CYAN}4. Eliminando redes no utilizadas...${RESET}"
  docker network prune -f
  echo ""
  
  echo -e "${GREEN}✓ Limpieza rápida completada${RESET}"
  echo ""
  echo -e "${YELLOW}Estado actual:${RESET}"
  docker system df
  echo ""
}

# Main
if [ $# -eq 0 ]; then
  show_usage
  exit 1
fi

case "$1" in
  up)
    docker_up_detached
    ;;
  rebuild)
    docker_rebuild
    ;;
  restart)
    docker_restart
    ;;
  logs)
    docker_logs_session false
    # Abrir en nueva pestaña automáticamente
    open_attach_new || true
    ;;
  logs-split)
    docker_logs_session true
    # Abrir en nueva pestaña automáticamente
    open_attach_new || true
    ;;
  heroku-logs)
    heroku_logs_session
    # Not opening the default session here; heroku_logs_session will handle attachment
    ;;
  down)
    if [ "${2:-}" = "-v" ]; then
      docker_down "-v"
    else
      docker_down ""
    fi
    # Matar sesión tmux después de detener contenedores
    kill_tmux_session
    ;;
  kill)
    kill_tmux_session
    ;;
  attach)
    open_attach_new || true
    ;;
  inject-ip)
    inject_ip
    ;;
  git)
    shift
    git_command "$@"
    ;;
  cleanup)
    docker_cleanup
    ;;
  -h|--help)
    show_usage
    exit 0
    ;;
  *)
    echo -e "${RED}Error: comando desconocido '$1'${RESET}"
    echo ""
    show_usage
    exit 1
    ;;
esac
