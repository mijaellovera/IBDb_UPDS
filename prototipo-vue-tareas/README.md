# Gestor de Tareas - Vue.js

Aplicación de demostración desarrollada con **Vue.js 3** (Composition API), **Pinia**, **Vue Router** y **Vite**. Forma parte del trabajo de investigación de la materia **Diseño Web II** sobre frameworks frontend.

## 🚀 Características

- ✅ Crear tareas mediante un formulario
- ✅ Marcar tareas como completadas
- ✅ Editar el título de las tareas
- ✅ Eliminar tareas
- ✅ Listado dinámico con transiciones animadas
- ✅ Contadores en tiempo real (total, pendientes, completadas)
- ✅ Navegación entre vistas con Vue Router
- ✅ Gestión de estado global con Pinia

## 🛠️ Tecnologías

| Tecnología | Versión | Descripción |
|------------|---------|-------------|
| Vue.js | 3.x | Framework frontend progresivo |
| Pinia | 2.x | Gestión de estado global |
| Vue Router | 4.x | Enrutamiento entre vistas |
| Vite | 8.x | Herramienta de compilación |

## 📁 Estructura del Proyecto

```
prototipo-vue-tareas/
├── public/                 # Archivos estáticos
│   └── favicon.svg
├── src/
│   ├── assets/
│   │   └── styles.css      # Estilos globales
│   ├── components/         # Componentes reutilizables
│   │   ├── TareaForm.vue
│   │   ├── TareaItem.vue
│   │   └── TareaLista.vue
│   ├── stores/
│   │   └── tareas.js       # Estado global (Pinia)
│   ├── views/              # Vistas (páginas)
│   │   ├── InicioView.vue
│   │   ├── TareasView.vue
│   │   └── AcercaView.vue
│   ├── router/
│   │   └── index.js        # Configuración de rutas
│   ├── App.vue             # Componente raíz
│   └── main.js             # Punto de entrada
├── index.html
├── package.json
├── vite.config.js
└── README.md
```

## 🚦 Requisitos Previos

- [Node.js](https://nodejs.org/) versión 18 o superior
- npm (incluido con Node.js)

## ⚙️ Instalación y Ejecución

```bash
# Clonar el repositorio
git clone https://github.com/usuario/prototipo-vue-tareas.git

# Navegar al directorio del proyecto
cd prototipo-vue-tareas

# Instalar dependencias
npm install

# Iniciar servidor de desarrollo
npm run dev
```

Abre `http://localhost:5173` en tu navegador.

## 🏗️ Comandos

| Comando | Descripción |
|---------|-------------|
| `npm run dev` | Inicia el servidor de desarrollo |
| `npm run build` | Compila la aplicación para producción |
| `npm run preview` | Sirve la compilación de producción localmente |

## 📄 Licencia

Proyecto académico — Diseño Web II · UPDS · 2026
