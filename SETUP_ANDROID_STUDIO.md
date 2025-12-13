# Guía de Configuración de Entorno de Desarrollo Android para React Native (Expo)

Esta guía explica cómo configurar un entorno de desarrollo nativo en un sistema basado en Debian/Ubuntu para compilar y ejecutar aplicaciones de React Native con Expo.

## Paso 1: Instalar Java Development Kit (JDK 17)

React Native requiere una versión específica del JDK.

```bash
# 1. Actualizar los repositorios del sistema
sudo apt update

# 2. Instalar OpenJDK 17
sudo apt install openjdk-17-jdk -y

# 3. Verificar la instalación
java -version
```

La salida debería mostrar `openjdk version "17.0.x"` o similar.

## Paso 2: Instalar Android Studio

Android Studio es el IDE oficial para desarrollo en Android e incluye el Android SDK y otras herramientas necesarias.

**Opción A (Recomendada): Usar Snap**
```bash
sudo snap install android-studio --classic
```

**Opción B: Descarga Manual**
1.  Ve a la [página oficial de Android Studio](https://developer.android.com/studio).
2.  Descarga el archivo `.tar.gz`.
3.  Extrae y mueve el contenido a una ubicación estándar.
    ```bash
    # Navega a la carpeta de descargas
    cd ~/Downloads
    # Extrae el archivo (reemplaza '*' con el nombre del archivo)
    tar -xvzf android-studio-*.tar.gz
    # Mueve la carpeta a /opt/ para que esté disponible para todos los usuarios
    sudo mv android-studio /opt/
    # Ejecuta el script de instalación
    /opt/android-studio/bin/studio.sh
    ```

## Paso 3: Configurar Android Studio y el SDK

1.  **Abre Android Studio**. La primera vez, realizará una configuración inicial.
2.  Sigue el asistente de instalación y elige la opción **"Standard Installation"**. Esto descargará los componentes más recientes del Android SDK.
3.  Una vez en la pantalla de bienvenida, ve a `More Actions` > `SDK Manager` (o `Tools` > `SDK Manager` si tienes un proyecto abierto).
4.  **En la pestaña "SDK Platforms"**:
    - Asegúrate de que **Android 13.0 (Tiramisu) - API 33** esté marcado.
    - Opcionalmente, marca **Android 14.0 (UpsideDownCake) - API 34**.
5.  **En la pestaña "SDK Tools"**:
    - Asegúrate de que los siguientes elementos estén marcados:
        - `Android SDK Build-Tools`
        - `Android SDK Command-line Tools`
        - `Android Emulator`
        - `Android SDK Platform-Tools`
6.  Haz clic en **"Apply"** para descargar e instalar los paquetes seleccionados.

## Paso 4: Configurar Variables de Entorno

Para que la terminal pueda encontrar las herramientas de Java y Android, necesitas agregarlas a tu `PATH`.

1.  Abre el archivo de configuración de tu shell.
    ```bash
    # Si usas bash (el predeterminado en Ubuntu)
    nano ~/.bashrc

    # Si usas zsh
    nano ~/.zshrc
    ```
2.  Agrega las siguientes líneas al **final** del archivo:
    ```bash
    # Variable para el Android SDK
    export ANDROID_HOME=$HOME/Android/Sdk
    # Añadir herramientas del SDK al PATH
    export PATH=$PATH:$ANDROID_HOME/emulator
    export PATH=$PATH:$ANDROID_HOME/platform-tools
    export PATH=$PATH:$ANDROID_HOME/tools
    export PATH=$PATH:$ANDROID_HOME/tools/bin
    export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin

    # Variable para Java
    export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
    # Añadir Java al PATH
    export PATH=$PATH:$JAVA_HOME/bin
    ```
3.  Guarda el archivo (`Ctrl + O`, `Enter`) y ciérralo (`Ctrl + X`).
4.  Aplica los cambios a tu sesión de terminal actual:
    ```bash
    # Si usas bash
    source ~/.bashrc

    # Si usas zsh
    source ~/.zshrc
    ```

## Paso 5: Aceptar Licencias de Android

Debes aceptar las licencias del SDK para poder compilar.
```bash
yes | sdkmanager --licenses
```

## Paso 6: Verificar la Instalación

Abre una **nueva terminal** y ejecuta los siguientes comandos para asegurarte de que todo está configurado correctamente.

```bash
# Verificar Java
java -version
echo $JAVA_HOME

# Verificar Android SDK
echo $ANDROID_HOME
adb --version
```
Si todos los comandos devuelven una versión o una ruta sin errores, la configuración está completa.

## Compilar y Ejecutar la App

Ahora que tu entorno está listo, este es el flujo de trabajo para compilar y ejecutar tu proyecto.

### Primera vez o al cambiar dependencias

1.  **Conecta tu teléfono por USB** y habilita la **"Depuración por USB"** en las Opciones de desarrollador.
2.  Navega a la carpeta del proyecto front.
    ```bash
    cd /ruta/a/melodia-tp/front
    ```
3.  (Opcional, solo la primera vez) Limpia todo para asegurar una compilación limpia.
    ```bash
    rm -rf android ios node_modules
    npm install --legacy-peer-deps
    npx expo prebuild --clean
    ```
4.  **Compila e instala la app en tu dispositivo.**
    ```bash
    npx expo run:android
    ```

La primera compilación puede tardar varios minutos. Las compilaciones posteriores serán más rápidas. La app se instalará y abrirá en tu teléfono automáticamente.

> **Importante**: Debes ejecutar `npx expo run:android` cada vez que:
> - Sea la primera vez que compiles la app
> - Cambies dependencias en `package.json`
> - Modifiques configuración nativa en Android

### Desarrollo diario con hot-reload

Una vez que ya tienes la app compilada e instalada en tu dispositivo, para el trabajo diario usa:

```bash
npx expo start --dev-client
```

Este comando:
- Inicia el servidor de desarrollo con hot-reload activado
- Se conecta con la app ya compilada en tu dispositivo
- Permite ver cambios en tiempo real sin recompilar
- Es mucho más rápido que `npx expo run:android`

**Requisitos**:
- La app debe estar ya compilada e instalada en el dispositivo (con `npx expo run:android`)
- El teléfono debe estar conectado por USB
- La depuración USB debe estar habilitada

## Resumen del Flujo de Trabajo

```bash
# PRIMERA VEZ o al cambiar dependencias
npx expo run:android           # Compila e instala (tarda varios minutos)

# DESARROLLO DIARIO (después de tener la app compilada)
npx expo start --dev-client    # Inicia con hot-reload (rápido)
```

## Troubleshooting

**Si el dispositivo no se detecta:**
```bash
# Verificar que el dispositivo esté conectado
adb devices

# Si no aparece, reinicia el servidor adb
adb kill-server
adb start-server
```

**Si hay problemas de permisos USB:**
```bash
# Configurar reglas udev para dispositivos Android
sudo usermod -aG plugdev $USER
```

**Si la compilación falla:**
```bash
# Limpiar cache y recompilar
cd android
./gradlew clean
cd ..
npx expo run:android
```
