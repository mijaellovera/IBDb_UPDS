# IBDb_UPDS
Proyecto Universitario

Implementacion de una plataforma Web Interactiva para la gestiokn de catalogo digital de Libros

Nombres de los integrantes
Pedro Aaron Espinoza Vargas
Mijael Douglas Lovera Rodriguez
Jerald Jose Corrales Velasquez

---

## Que incluye el proyecto

- **Catalogo web (React + Vite)**: listado con portadas, busqueda por titulo/autor,
  ordenamientos (popularity / rating / newness), paginacion real y vista grid o lista.
- **API REST propia en PHP**: CRUD completo de libros, autores y categorias sobre MySQL,
  con validaciones, prepared statements y transacciones.
- **Integracion con Open Library** (patron cache-aside): si una busqueda no esta en la BD,
  el backend consulta la API publica, guarda el JSON crudo en `backend/datos/busquedas/`,
  lo migra a SQL y responde; las busquedas repetidas salen directo de MySQL.
- **Panel de administracion**: boton "Admin" en la barra superior para crear, editar y
  eliminar libros, autores y categorias desde el navegador.
- **Extraccion masiva por CLI**: `extraer.php` + `migrar.php` para poblar la BD sin la web.

Documentacion detallada: [`backend/README.md`](backend/README.md) (arquitectura y endpoints)

---

## Como lanzar el proyecto

### 1. Requisitos previos

- PHP 8 con la extension pdo_mysql (`sudo dnf install php php-mysqlnd`)
- Node.js + npm
- MariaDB / MySQL corriendo localmente

### 2. Configurar la conexion y la base de datos (solo la primera vez)

**a) Crea tu archivo de configuracion local** a partir de la plantilla:

```bash
cp backend/config.template.php backend/config.php
```

Luego edita `backend/config.php` y coloca los datos de TU MySQL:

```php
$DB = [
    'host'    => '127.0.0.1',          // tu servidor MySQL
    'nombre'  => 'biblioteca_openlibrary',
    'usuario' => 'root',               // tu usuario
    'clave'   => 'TU_CLAVE_MYSQL',     // tu clave
];
```

> `config.php` esta en `.gitignore`: cada integrante tiene el suyo y la clave nunca sube al repo.

**b) Importa la base de datos.** :

Volcado completo incluido en el repositorio (estructura + los 20 libros ya descargados):

```bash
mysql -u root -p < backend/sql/biblioteca_openlibrary.sql
```

### 3. Levantar los servidores (2 terminales, dentro de IBDb_UPDS/)

```bash
# Terminal 1 - API REST en el puerto 8000
php -S 127.0.0.1:8000 -t backend backend/index.php

# Terminal 2 - Frontend React en el puerto 5173
npm run dev
```

Abrir en el navegador: **http://localhost:5173**

El frontend llama a `/api/*`, Vite lo redirige automaticamente al puerto 8000.

### 4. Uso basico

- **Buscar** un termino que no exista en la BD: la web consulta Open Library,
  guarda el JSON crudo en `backend/datos/busquedas/`, lo migra a SQL y muestra
  los resultados marcados como "nuevos desde Open Library". La segunda busqueda
  sale directo de MySQL.
- **Panel Admin**: boton "Admin" en la barra superior para crear, editar y
  eliminar libros, autores y categorias.
- **Extraccion masiva manual** (opcional):

```bash
php backend/extraer.php     # Open Library -> backend/datos/openlibrary.json
php backend/migrar.php      # JSON -> SQL (acepta otro archivo JSON como argumento)
```

Mas detalles tecnicos en `backend/README.md` 
