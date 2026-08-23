# Backend PHP — ETL Open Library + CRUD REST

> Guia de lanzamiento general del proyecto en el `README.md` raiz.
> Este documento detalla solo el backend.

## Arquitectura

```
FLUJO MASIVO (opcional):
[1] backend/extraer.php   Open Library API ──> backend/datos/openlibrary.json (JSON crudo)
[2] backend/migrar.php    JSON crudo ────────> biblioteca_openlibrary       (SQL normalizado)

FLUJO EN VIVO (desde la web, automatico):
buscar en React ──> index.php: si MySQL no tiene resultados
                    ├─> consulta Open Library (limit 10)
                    ├─> guarda crudo en datos/busquedas/{fecha}_{termino}.json
                    └─> migrador.php::migrarDocs() upserta y responde ("fuente":"openlibrary")

[3] backend/index.php     CRUD REST sobre la BD <──> React (proxy Vite /api ─> :8000)
```

`migrador.php` es el modulo compartido: contiene toda la logica de conversion
JSON -> SQL y lo usan tanto `migrar.php` (CLI) como `index.php` (busqueda hibrida).

## Estado del desarrollo

- [x] `extraer.php`: extraccion masiva probada (30 documentos reales)
- [x] `migrar.php` + `migrador.php`: migracion incremental e idempotente
- [x] Busqueda hibrida en vivo: 1ra vez trae de Open Library (~4 s), repite desde MySQL (~0.02 s)
- [x] CRUD REST completo (POST/PUT/DELETE libros, autores, categorias) verificado con curl
- [x] Panel admin en React (`src/Admin.jsx`) integrado con boton en el header
- [x] Volcado completo de la BD incluido en `sql/biblioteca_openlibrary.sql`
- [x] `npm run build` sin errores

## Conexion a la BD (`backend/config.php`)

Cada integrante crea su propio `config.php` copiando la plantilla (no se sube al repo):

```bash
cp config.template.php config.php   # y editar usuario/clave de TU MySQL
```

| Campo | Valor tipico |
|---|---|
| host | `127.0.0.1` |
| nombre | `biblioteca_openlibrary` |
| usuario / clave | los de tu MySQL local |

Para poblar la BD usa el volcado incluido: `mysql -u root -p < sql/biblioteca_openlibrary.sql`

BD: `biblioteca_openlibrary` — esquema de `APIINvestigacion/sql/schema_openlibrary_orig.sql`
(9 tablas + vista `vw_libraria_libros`). Claves unicas para upserts: `libro.ol_work_key`,
`autor.ol_key`, `edicion.ol_edition_key`, `categoria.slug`, `editorial.nombre`.
Las FK de pivotes usan `ON DELETE CASCADE`.

## Comandos

```bash
# Una sola vez: importar la BD (volcado completo con datos incluidos)
mysql -u root -p < sql/biblioteca_openlibrary.sql

# Actualizar catalogo desde Open Library (cuando se quiera refrescar datos)
php backend/extraer.php      # guarda JSON crudo en backend/datos/openlibrary.json
php backend/migrar.php       # upsert incremental JSON -> SQL (no borra nada)

# Servidores de desarrollo (2 terminales, dentro de IBDb_UPDS/)
php -S 127.0.0.1:8000 -t backend backend/index.php   # API CRUD
npm run dev                                          # Vite en http://localhost:5173
```

Configuracion de extraccion: editar arriba de `extraer.php`:
```php
$CONSULTAS = ['classics', 'fantasy', 'science fiction'];
$LIMITE    = 10;   // total = count($CONSULTAS) * $LIMITE
```

## API REST (`http://127.0.0.1:8000`, via proxy `/api`)

| Metodo | Ruta | Body JSON | Respuesta |
|---|---|---|---|
| GET | `/libros?buscar=&orden=default\|popularity\|rating\|newness&pagina=&porPagina=` | — | `{total, rows[], fuente: "mysql"\|"openlibrary"}` |
| POST | `/libros` | `{titulo*, anio_primer_publicacion?, portada_url?, enlace_lectura?, rating_promedio?, descripcion?, autores?: ["Nombre"], categorias?: ["Nombre"]}` | `201` fila de la vista |
| PUT | `/libros/{id}` | mismos campos sin autores/categorias | fila actualizada |
| DELETE | `/libros/{id}` | — | `204` (cascade limpia pivotes) |
| GET | `/secciones/{carrusel\|destacados\|novedades\|recomendados}?limite=` | — | `[{...}]` |
| GET | `/autores` | — | `[{id, nombre, foto_url, libros}]` |
| POST | `/autores` | `{nombre*}` | `201` |
| PUT | `/autores/{id}` | `{nombre?, biografia?, obra_principal?}` | fila |
| DELETE | `/autores/{id}` | — | `204` |
| GET | `/categorias` | — | `[{id, slug, nombre, libros}]` |
| POST | `/categorias` | `{nombre*}` (slug automatico) | `201`, duplicado = `409` |
| PUT | `/categorias/{id}` | `{nombre?, descripcion?}` | fila |
| DELETE | `/categorias/{id}` | — | `204` |

Errores: JSON `{error: "mensaje"}` con codigo `400` (datos invalidos),
`404` (recurso o ruta no existe), `405` (metodo no permitido), `409` (duplicado).

Autores manuales sin clave OL reciben `ol_key` generado `OLM` + 8 hex.
Los libros creados a mano reciben `ol_work_key` generado igual.
Categorias se crean por nombre con slug automatico (`slugificar()`).

## Archivos

```
IBDb_UPDS/
├── backend/
│   ├── config.template.php   plantilla de credenciales (copiar a config.php)
│   ├── config.php            credenciales reales (NO se sube al repo)
│   ├── index.php             router unico: GET + CRUD completo + busqueda hibrida
│   ├── extraer.php           ETL masivo paso 1: API -> datos/openlibrary.json
│   ├── migrar.php            ETL masivo paso 2: JSON -> SQL (usa migrador.php)
│   ├── migrador.php          modulo compartido de migracion (upserts, transaccion)
│   ├── sql/
│   │   └── biblioteca_openlibrary.sql   volcado completo: estructura + datos ya descargados
│   └── datos/
│       ├── openlibrary.json        salida cruda de extraer.php
│       └── busquedas/*.json        historial crudo de cada busqueda traída en vivo
└── src/
    ├── librariaApi.js      cliente HTTP del frontend (+ funciones CRUD)
    ├── Libraria.jsx        catalogo publico (busqueda, ordenes, paginacion real)
    ├── Admin.jsx / Admin.css   panel de administracion (CRUD visual)
    └── Library.jsx / main.jsx  entrada de la app
```
