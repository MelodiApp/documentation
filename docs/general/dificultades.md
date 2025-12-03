# Dificultades Encontradas

Durante el desarrollo de **MelodiApp**, nos encontramos con varios desafíos técnicos y de coordinación que nos permitieron aprender y mejorar nuestro flujo de trabajo.

## Migraciones de Base de Datos
Al inicio del proyecto, **no estábamos familiarizados con las migraciones** y el manejo de cambios en la base de datos.  
Esto generó problemas frecuentes al ejecutar los comandos de migración, especialmente cuando un integrante realizaba modificaciones en el esquema de datos.  
Cada cambio requería generar una nueva migración manualmente, y estas no se actualizaban automáticamente para los demás miembros del equipo, lo que provocaba inconsistencias temporales y errores de sincronización.

## Almacenamiento de Archivos
El manejo de archivos multimedia, como imágenes y audios, también presentó dificultades.  
Tuvimos problemas con **Amazon S3** y con **LocalStack** durante la etapa de desarrollo y pruebas locales.  
En particular, la configuración de buckets y permisos, así como la simulación de S3 en LocalStack, generó errores inesperados que debimos resolver iterativamente.

## Coordinación entre integrantes
La combinación de microservicios, gateways y frontends hizo necesario establecer un flujo de trabajo claro para evitar conflictos de integración.  
El equipo aprendió a coordinar cambios, especialmente en la base de datos y en la configuración de servicios de almacenamiento, para mantener la consistencia del proyecto.

---

> *Nota:* Cada una de estas dificultades nos permitió mejorar la planificación, documentación y comunicación interna del equipo, estableciendo buenas prácticas que se aplicaron en las siguientes etapas del proyecto.