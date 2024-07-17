# LumoTareas

## Descripción

LumoTareas es una aplicación desarrollada en Flutter diseñada para facilitar la organización y gestión de proyectos siguiendo la metodología Scrum. Esta aplicación permite a los usuarios crear y gestionar múltiples organizaciones, dentro de las cuales se pueden definir proyectos, sprints y tareas. LumoTareas está diseñada para mejorar la colaboración y la eficiencia en equipos de trabajo, proporcionando herramientas esenciales para la planificación y el seguimiento de proyectos.

## Requisitos

Antes de ejecutar la aplicación, asegúrate de tener instalado lo siguiente:

- [Flutter](https://flutter.dev/docs/get-started/install) (versión estable más reciente)
- [Dart](https://dart.dev/get-dart) (incluido con Flutter)
- Un editor de código (recomendado: [Visual Studio Code](https://code.visualstudio.com/))

## Instalación

1. Clona el repositorio en tu máquina local:

   ```sh
   git clone https://github.com/moisesnks/lumotareas-mobile-dart.git
   cd lumotareas-mobile-dart
   ```

2. Instala las dependencias:

   ```sh
   flutter pub get
   ```

## Ejecución

Para correr la aplicación en modo desarrollo, utiliza:

```sh
flutter run
```

Si deseas ejecutar la aplicación en un dispositivo específico, asegúrate de tener un emulador o dispositivo conectado, y luego ejecuta:

```sh
flutter run -d <dispositivo>
```

## Estructura del Proyecto

La estructura principal del proyecto es la siguiente:

```
lib/
├── models/                 # Modelos de datos
│   ├── firestore/          # Modelos para Firestore
│   └── organization/       # Modelos relacionados con organizaciones
├── providers/              # Proveedores de datos y lógica de negocio
├── screens/                # Pantallas de la aplicación
│   ├── crear_proyecto/     # Pantallas para la creación de proyectos
│   ├── crear_sprint/       # Pantallas para la creación de sprints
│   ├── crear_tarea/        # Pantallas para la creación de tareas
│   ├── home/               # Pantalla de inicio
│   ├── login/              # Pantalla de inicio de sesión
│   ├── settings/           # Pantalla de configuración
│   ├── solicitud/          # Pantallas para solicitudes
│   ├── sprint/             # Pantallas para gestión de sprints
│   └── tarea/              # Pantallas para gestión de tareas
├── services/               # Servicios (autenticación, base de datos, etc.)
├── utils/                  # Utilidades y constantes
└── widgets/                # Widgets reutilizables
```

## Funcionalidades Principales

### Autenticación de Usuarios

- Registro e inicio de sesión de usuarios.
- Recuperación de contraseñas.

### Gestión de Organizaciones

- Crear y gestionar múltiples organizaciones.
- Invitar y gestionar miembros dentro de cada organización.

### Gestión de Proyectos

- Crear y gestionar proyectos dentro de las organizaciones.
- Asignar miembros a proyectos específicos.

### Gestión de Sprints

- Crear sprints para cada proyecto.
- Definir y gestionar objetivos y tareas de cada sprint.

### Gestión de Tareas

- Crear, asignar y seguir el progreso de tareas.
- Añadir comentarios y actualizar el estado de las tareas.
- Gestionar subtareas y dependencias.

### Pantalla de Inicio

- Vista general de proyectos y tareas.
- Acceso rápido a las tareas asignadas al usuario.


