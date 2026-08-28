# Manual de Instalación — IBDb UPDS ("Libraria")

| | |
|---|---|
| **Proyecto** | IBDb UPDS — Biblioteca Digital "Libraria" |
| **Materia** | Diseño Web II — UPDS |
| **Integrantes** | Pedro Aaron Espinoza Vargas · Mijael Douglas Lovera Rodriguez · Jerald Jose Corrales Velasquez |
| **Documento** | Manual de Instalación y Puesta en Marcha (guía paso a paso) |
| **Fecha** | Agosto 2026 |

---

## Índice

1. [Requisitos previos (prerrequisitos)](#2-requisitos-previos-prerrequisitos)
2. [Obtención del proyecto](#3-obtencion-del-proyecto)
3. [Configuración de la base de datos](#4-configuracion-de-la-base-de-datos)
4. [Configuración del proyecto](#5-configuracion-del-proyecto)
5. [Puesta en marcha](#6-puesta-en-marcha)
6. [Verificación de instalación exitosa](#7-verificacion-de-instalacion-exitosa)
7. [Usuarios de prueba](#8-usuarios-de-prueba)
8. [Solución de problemas comunes de instalación](#9-solucion-de-problemas-comunes-de-instalacion)
9. [Referencias](#10-referencias)

---

## 2. Requisitos previos (prerrequisitos)

Este manual asume que se parte de un equipo **limpio** (sin extensiones extra ni
servidores propios). El proyecto funciona igual en **Linux** y en **Windows**; solo
cambian unas rutas y la forma de iniciar servicios.

| Componente | Windows (XAMPP) | Linux |
|---|---|---|
| **Servidor web** | Opcional — XAMPP trae Apache, pero **no es necesario**: la API se lanza con el PHP de XAMPP como servidor web. | No requerido: la API se sirve con el servidor integrado de PHP. |
| **PHP** | ≥ 8.0 (XAMPP 8.x incluye PHP 8.5) | ≥ 8.0 con la extensión `pdo_mysql` (probado con PHP 8.5.8) |
| **Base de datos** | MySQL 8 / MariaDB 10.4 (XAMPP incluye MariaDB) | MariaDB ≥ 10.6 o MySQL 8 (probado con MariaDB 11.8.8) |
| **Extensión PHP** | `pdo_mysql` y `mysqli` (en XAMPP se habilitan en `php.ini`) | `pdo_mysql` — instalar con `sudo dnf install php-mysqlnd` (Fedora) o `sudo apt install php-mysql` (Debian/Ubuntu) |
| **Node.js + npm** | ≥ 18 (probado con Node 24.15.0 / npm 11.12.1) — https://nodejs.org | ≥ 18 (probado con Node 24.15.0 / npm 11.12.1) |
| **Navegador** | Chrome, Edge o Firefox (actualizado) | — |

> **Cómo verificar que tu PHP ya tiene todo:**
> ```bash
> php -v                # versión de PHP
> php -m | grep pdo     # debe listar "pdo_mysql"
> node -v && npm -v     # versiones de Node y npm
> ```

No se necesita ninguna **clave de API externa**: la integración con **Open Library**
usa su API pública sin token (https://openlibrary.org/developers/api), por lo que no
hay que configurar credenciales de servicios de terceros.

---

## 3. Obtención del proyecto

El código fuente se entrega en el repositorio:

- **Repositorio (GitHub):** `https://github.com/mijaellovera/IBDb_UPDS`
- **Alternativa:** paquete comprimido `LIBRARIA-Online-Library.zip` (los integrantes lo
  entregan junto con los manuales).

**Opción A — Clonar el repositorio (recomendado, siempre más actualizado):**

```bash
git clone https://github.com/mijaellovera/IBDb_UPDS.git
cd IBDb_UPDS
```

**Opción B — Descomprimir el ZIP:** extrae el contenido y entra a la carpeta
`IBDb_UPDS`.

La carpeta del proyecto queda en cualquier ubicación; **no es obligatorio** instalarla
dentro de `htdocs` de XAMPP ni de `/var/www`, porque el frontend se sirve con Vite y la
API con el servidor integrado de PHP (ninguno depende de Apache). Solo hay que
acordarse de la ruta, porque se abrirán ahí las dos terminales.

Verifica que dentro estén (al menos) estas carpetas/archivos:

```
IBDb_UPDS/
├── backend/          # API REST en PHP (index.php, config.php, sql/)
├── src/              # código fuente del frontend React
├── package.json      # define las dependencias del frontend
├── vite.config.js    # configura el proxy /api → :8000
└── README.md         # la guía de arranque rápida
```

---

## 4. Configuración de la base de datos

### 4.1 Resumen de los scripts SQL entregados

Dentro de `backend/sql/` hay **dos** volcados. **Es importante elegir el correcto según
el equipo** (ver 4.3):

| Archivo | Para qué equipo | Contenido |
|---|---|---|
| `backend/sql/biblioteca_openlibrary.sql` | **Linux / MariaDB** | 9 tablas + vista `vw_libraria_libros`, colaciones `utf8mb4_unicode_ci`, 52 libros |
| `backend/sql/biblioteca_openlibrary_windows.sql` | **Windows / MySQL 8 (XAMPP)** | Mismo modelo, colaciones `utf8mb4_unicode_ci` (compatible con MySQL 8), 62 libros, portadas embebidas con sintaxis `_binary` de Workbench |

> Los dos archivos **no incluyen** la instrucción `CREATE DATABASE`: hay que crear la
> base de datos **antes** de importar. El nombre que usa el sistema es
> **`biblioteca_openlibrary`** (así viene en `config.template.php`).

### 4.2 Crear la base de datos

**Windows — XAMPP + MySQL Workbench o phpMyAdmin:**

1. Abre **XAMPP Control Panel** y presiona *Start* en **MySQL**.
2. Abre **phpMyAdmin** en http://localhost/phpmyadmin (o MySQL Workbench conectado a `root`).
3. Crea una base nueva con:
   - **Nombre:** `biblioteca_openlibrary`
   - **Cotejamiento (collation):** `utf8mb4_unicode_ci`
4. Acepta/guarda.

**Linux — consola:**

```bash
mariadb -u root -p -e "CREATE DATABASE biblioteca_openlibrary CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```

### 4.3 Importar el script correcto

> **Windows usa `biblioteca_openlibrary_windows.sql`** y **Linux usa
> `biblioteca_openlibrary.sql`**. Importar el de Windows en un MariaDB/MySQL viejo que
> no soporte su collation daría error; por eso hay dos versiones.

**Windows — Opción A (MySQL Workbench):**
menú *Server → Data Import → Import from Self-Contained File*, selecciona
`backend\sql\biblioteca_openlibrary_windows.sql`, elige *Default Target Schema*:
`biblioteca_openlibrary` (importante, porque el archivo no crea la BD), marca *Dump
Structure and Data* y presiona *Start Import*.

**Windows — Opción B (consola cmd, dentro de `IBDb_UPDS`):**

```bat
C:\xampp\mysql\bin\mysql.exe -u root biblioteca_openlibrary < backend\sql\biblioteca_openlibrary_windows.sql
```

**Linux — consola:**

```bash
mysql -u root -p biblioteca_openlibrary < backend/sql/biblioteca_openlibrary.sql
```

### 4.4 Verificar el usuario y la conexión

El sistema se conecta con el usuario `root`:

- **Windows (XAMPP recién instalado):** `root` **sin contraseña** (por defecto).
- **Linux:** `root` con la contraseña que tengas; en el equipo de desarrollo local es
  `Carlaandrea98`.

Comprueba que la importación quedó completa:

```sql
SHOW TABLES;                       -- deben verse 9 tablas (autor, categoria, edicion,
                                   -- editorial, libro, libro_autor, libro_categoria,
                                   -- libro_seccion, seccion) y la vista vw_libraria_libros
SELECT COUNT(*) FROM libro;        -- 52 (Linux) ó 62 (Windows)
```

---

## 5. Configuración del proyecto

La única configuración que hay que tocar es la conexión a la base de datos.

**Paso 1.** Crea tu archivo de configuración local a partir de la plantilla (la plantilla
es pública; tu `config.php` queda excluido de Git):

```bash
cp backend/config.template.php backend/config.php     # Linux / macOS
copy backend\config.template.php backend\config.php   # Windows (cmd o PowerShell)
```

**Paso 2.** Edita `backend/config.php` y deja tus datos:

```php
$DB = [
    'host'    => '127.0.0.1',        // servidor MySQL (normalmente localhost)
    'nombre'  => 'biblioteca_openlibrary',   // nombre exacto de la BD creada en §4
    'usuario' => 'root',             // XAMPP Windows: root sin clave
    'clave'   => 'TU_CLAVE_MYSQL',   // Windows XAMPP: '' (vacía) · Linux: tu clave
];
```

> Ejemplo XAMPP recién instalado: `'clave' => ''` (vacía). En Linux con XAMPP no hace
> falta Apache: se usa solo su MySQL y su `php.exe`.

> `config.php` está en `.gitignore`: cada máquina guarda sus propias credenciales y
> nunca se suben al repositorio. No hace falta configurar nada más (no hay `.env`,
> ni claves de servicios externos, ni variables de entorno).

---

## 6. Puesta en marcha

Se abren **dos terminales** dentro de la carpeta del proyecto (`IBDb_UPDS`).

**Terminal 1 — API REST (puerto 8000):**

```bash
php -S 127.0.0.1:8000 -t backend backend/index.php
```

> Windows/XAMPP: si `php` no está en el PATH usa
> `C:\xampp\php\php.exe -S 127.0.0.1:8000 -t backend backend/index.php` (o agrega
> `C:\xampp\php` a las variables de entorno).

**Terminal 2 — Frontend React (puerto 5173):**

```bash
npm install    # solo la primera vez: descarga las dependencias
npm run dev
```

El frontend llama a `/api/*`; **Vite reenvía automáticamente** esas peticiones al
puerto 8000 (definido en `vite.config.js`), así que no hay que configurar CORS a mano.

**URL para acceder al sistema:** http://localhost:5173

---

## 7. Verificación de instalación exitosa

Si todo quedó bien, debes ver:

- **Frontend (http://localhost:5173):** el catálogo con la barra superior, las tarjetas
  de libros con **portadas**, y los controles de búsqueda/orden/paginación.
  *(El equipo desarrollador adjunta una captura de la pantalla de inicio como referencia:
  ver archivo de imágenes entregado junto a este manual.)*
- **API (http://localhost:8000/libros?porPagina=2):** una respuesta JSON con `total`,
  `rows`, `paginas`, etc., como esta:

```json
{"total":90,"rows":[{"id":1,"ol_work_key":"OL262421W","titulo":"The Adventures of Sherlock Holmes","autores":"Arthur Conan Doyle","portada_url":"https://...","rating":"4.16","votos":171,"popularidad":2654}], ...}
```

- **Portada de un libro** (donde la BD tiene la imagen): http://localhost:8000/libros/1/portada
  debe devolver `HTTP 200` con `Content-Type: image/jpeg`.
- **Panel Admin:** botón "Admin" en la barra superior → permite listar/crear/editar/
  eliminar libros, autores y categorías.
- **Búsqueda híbrida:** escribir un título que NO esté en la BD (p. ej. "Python" o "Dune") consulta Open Library, guarda el JSON en `backend/datos/busquedas/`, migra a
  SQL y muestra los resultados marcados como *nuevos desde Open Library*.

Checklist final:

- [ ] `php -S` en 8000 sin errores y `curl http://localhost:8000/libros?porPagina=1` responde JSON.
- [ ] `npm run dev` muestra "Local: http://localhost:5173" y la web carga.
- [ ] El catálogo muestra portadas y los libros importados (52 ó 62).
- [ ] La búsqueda híbrida y el panel Admin funcionan.

---

## 8. Usuarios de prueba

El sistema **no maneja sesiones ni roles**: la página de inicio y el panel Admin se
acceden directamente, sin login, por lo que cualquier evaluador puede probar todo con la
URL http://localhost:5173 (botón **Admin** en la barra superior). No existen credenciales
de usuario normal/administrador porque la autenticación quedó fuera del alcance del
proyecto (ver "Limitaciones" en el Manual Técnico).

Los únicos datos de conexión que se usan son los de la **base de datos** (sección 4.4):
usuario `root` y la contraseña que tengas en tu MySQL (XAMPP Windows: vacía). Son solo
para la instalación local y no deben exponerse públicamente.

---

## 9. Solución de problemas comunes de instalación

| # | Problema | Causa probable | Solución |
|---|---|---|---|
| 1 | **Puerto 8000 ya está ocupado** — al iniciar `php -S` aparece "Failed to listen" o no responde. | Otra app usa el puerto (u otro `php -S` abierto). | Usa otro puerto: `php -S 127.0.0.1:8001 -t backend backend/index.php`. Si cambias el puerto, actualiza también `target` en `vite.config.js` (el proxy apunta a 8000 por defecto) y reinicia `npm run dev`. También comprueba `netstat -ano \| findstr :8000` (Windows) o `ss -ltnp \| grep 8000` (Linux) y cierra el proceso viejo. |
| 2 | **Error de conexión a la base de datos** — "Access denied for user", "Unknown database", o "Connection refused" al consultar la API. | Credenciales mal en `config.php`, MySQL apagado, o el nombre de BD no coincide. | Verifica que MySQL/MariaDB esté corriendo (XAMPP: botón *Start* en MySQL). Revisa `backend/config.php` (`host`, `nombre`, `usuario`, `clave`) e iguala el nombre de BD creado en §4. Prueba con `mysql -u root -p -e "USE biblioteca_openlibrary;"`. |
| 3 | **Extensión PHP faltante** — error "could not find driver" / "Call to undefined function db()" o PDOException de clase no encontrada. | Falta `pdo_mysql` en PHP. | **Linux:** `sudo dnf install php-mysqlnd` (Fedora) o `sudo apt install php-mysql` (Debian/Ubuntu) y reinicia. **Windows (XAMPP):** edita `C:\xampp\php\php.ini`, descomenta la línea `extension=pdo_mysql` (y `extension=mysqli`), guarda y reinicia; luego `php -m \| grep pdo` debe listar `pdo_mysql`. |
| 4 | **Error al importar el SQL** — "Unknown collation", "error 1273", o el import de Windows falla en Linux. | Se importó el archivo equivocado en el motor equivocado. | Usa SIEMPRE `biblioteca_openlibrary_windows.sql` en Windows/MySQL 8 y `biblioteca_openlibrary.sql` en Linux/MariaDB (sección 4.3). Si el error es de colación `utf8mb4_0900`, el archivo de Windows sí es válido en MySQL 8; no lo importes en MariaDB viejo. |
| 5 | **La API responde pero el frontend no muestra portadas / da error** en las imágenes. | El libro no tiene imagen en la BD (imagen `NULL`) o la descarga de portadas falló. | El sistema muestra el enlace externo como respaldo. Si quieres las portadas, descarga la portada de un libro cuyo `imagen` esté vacía: `php backend/descargar_portadas.php` (opcional) y luego recarga. Todas las portadas llegan bien si la BD corrió con la importación completa de §4. |

> **Consejo para el equipo evaluador que instale este manual:** sigan el orden exacto
> de los pasos (repositorio → crear BD → importar SQL correcto → `config.php` → dos
> terminales). Si un paso falla, revise la tabla anterior: los 5 errores más frecuentes
> están cubiertos ahí.

---

## 10. Referencias

- Repositorio del proyecto: https://github.com/mijaellovera/IBDb_UPDS
- README del proyecto (guía rápida Linux y Windows): `README.md` dentro de la carpeta raíz.
- Arquitectura y documentación de la API: `backend/README.md`.
- Manual técnico para desarrolladores: `docs/ManualTecnicoDesarrollador.md` (y `.odt`).
- Guía educativa de la API REST: `../APIINvestigacion/GuiaAPI.md`.
- Open Library API (documentación pública, sin necesidad de API key):
  https://openlibrary.org/developers/api