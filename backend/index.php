<?php

require_once __DIR__ . '/config.php';
require_once __DIR__ . '/migrador.php';

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

function responder($datos, int $codigo = 200): void
{
    http_response_code($codigo);
    echo json_encode($datos, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

function cuerpo(): array
{
    $json = json_decode(file_get_contents('php://input'), true);
    return is_array($json) ? $json : [];
}

function idDeRuta(array $segmentos): int
{
    $id = (int)($segmentos[1] ?? 0);
    if ($id <= 0) {
        responder(['error' => 'Se esperaba un identificador numérico'], 400);
    }
    return $id;
}

function filaLibro(int $id): array
{
    $stmt = db()->prepare("SELECT * FROM vw_libraria_libros WHERE id = ?");
    $stmt->execute([$id]);
    $fila = $stmt->fetch();
    if (!$fila) {
        responder(['error' => 'Libro no encontrado'], 404);
    }
    return $fila;
}

// ---------------------------------------------------------------- LIBROS

function autorIdPorNombre(PDO $pdo, string $nombre): int
{
    $stmt = $pdo->prepare("SELECT id FROM autor WHERE nombre = ? LIMIT 1");
    $stmt->execute([$nombre]);
    $id = $stmt->fetchColumn();
    if ($id !== false) {
        return (int)$id;
    }

    $olKey = 'OLM' . strtoupper(bin2hex(random_bytes(4)));
    $stmt = $pdo->prepare(
        "INSERT INTO autor (ol_key, nombre, foto_url) VALUES (?, ?, ?)"
    );
    $stmt->execute([
        $olKey,
        $nombre,
        "https://covers.openlibrary.org/a/olid/{$olKey}-M.jpg",
    ]);
    return (int)$pdo->lastInsertId();
}

function categoriaIdPorNombre(PDO $pdo, string $nombre): ?int
{
    $slug = slugificar($nombre);
    if ($slug === '') {
        return null;
    }

    $id = idExistente($pdo, 'categoria', 'slug', $slug);
    if ($id !== null) {
        return $id;
    }

    $stmt = $pdo->prepare("INSERT INTO categoria (slug, nombre) VALUES (?, ?)");
    $stmt->execute([$slug, trim($nombre)]);
    return (int)$pdo->lastInsertId();
}

function listarLibros(): void
{
    $buscar   = trim($_GET['buscar'] ?? '');
    $categoria = trim($_GET['categoria'] ?? '');
    $orden    = $_GET['orden'] ?? 'default';
    $pagina   = max(1, (int)($_GET['pagina'] ?? 1));
    $porPagina = min(50, max(1, (int)($_GET['porPagina'] ?? 12)));

    $mapaOrden = [
        'default'    => 'id',
        'popularity' => 'popularidad DESC, votos DESC',
        'rating'     => 'rating DESC, votos DESC',
        'newness'    => 'anio DESC',
    ];
    $ordenSql = $mapaOrden[$orden] ?? 'id';

    $where  = '';
    $params = [];
    if ($buscar !== '') {
        $where  = 'WHERE titulo LIKE ? OR autores LIKE ?';
        $params = ["%{$buscar}%", "%{$buscar}%"];
    }
    if ($categoria !== '') {
        $where .= ($where ? ' AND ' : 'WHERE ')
                . 'id IN (SELECT lc.libro_id FROM libro_categoria lc JOIN categoria c ON c.id = lc.categoria_id WHERE c.slug = ?)';
        $params[] = $categoria;
    }

    $stmt = db()->prepare("SELECT COUNT(*) FROM vw_libraria_libros {$where}");
    $stmt->execute($params);
    $total = (int)$stmt->fetchColumn();

    $fuente = 'mysql';

    if ($total === 0 && $buscar !== '') {
        $docs = consultarOpenLibrary($buscar);
        if ($docs) {
            guardarBusqueda($buscar, $docs);
            migrarDocs($docs);

            $stmt = db()->prepare("SELECT COUNT(*) FROM vw_libraria_libros {$where}");
            $stmt->execute($params);
            $total = (int)$stmt->fetchColumn();
            if ($total > 0) {
                $fuente = 'openlibrary';
            }
        }
    }

    $offset = ($pagina - 1) * $porPagina;
    $stmt = db()->prepare(
        "SELECT * FROM vw_libraria_libros {$where}
         ORDER BY {$ordenSql}
         LIMIT {$porPagina} OFFSET {$offset}"
    );
    $stmt->execute($params);

    responder(['total' => $total, 'rows' => $stmt->fetchAll(), 'fuente' => $fuente]);
}

function consultarOpenLibrary(string $termino): array
{
    $campos = implode(',', [
        'key',
        'title',
        'author_name',
        'author_key',
        'first_publish_year',
        'cover_i',
        'ratings_average',
        'ratings_count',
        'want_to_read_count',
        'ebook_access',
        'ia',
        'language',
        'isbn',
        'edition_key',
        'publisher',
        'subject',
    ]);

    $url = 'https://openlibrary.org/search.json?' . http_build_query([
        'q'      => $termino,
        'limit'  => 10,
        'fields' => $campos,
    ]);

    $contexto = stream_context_create([
        'http' => [
            'header'  => "User-Agent: IBDb-UPDS/1.0 (proyecto universitario)\r\n",
            'timeout' => 10,
        ],
    ]);

    $respuesta = @file_get_contents($url, false, $contexto);
    if ($respuesta === false) {
        return [];
    }

    $datos = json_decode($respuesta, true);
    return is_array($datos['docs'] ?? null) ? $datos['docs'] : [];
}

function guardarBusqueda(string $termino, array $docs): string
{
    $carpeta = __DIR__ . '/datos/busquedas';
    if (!is_dir($carpeta)) {
        mkdir($carpeta, 0775, true);
    }

    $archivo = "{$carpeta}/" . date('Y-m-d_H-i-s') . '_' . slugificar($termino) . '.json';
    file_put_contents($archivo, json_encode([
        'termino'     => $termino,
        'extraido_en' => date('c'),
        'numFound'    => count($docs),
        'docs'        => $docs,
    ], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES));

    return $archivo;
}

function crearLibro(): void
{
    $datos = cuerpo();
    $titulo = trim((string)($datos['titulo'] ?? ''));
    if ($titulo === '') {
        responder(['error' => 'El título es obligatorio'], 400);
    }

    $anio = null;
    if (isset($datos['anio_primer_publicacion']) && $datos['anio_primer_publicacion'] !== null && $datos['anio_primer_publicacion'] !== '') {
        $anio = max(0, min(65535, (int)$datos['anio_primer_publicacion']));
    }

    $rating = null;
    if (isset($datos['rating_promedio']) && $datos['rating_promedio'] !== null && $datos['rating_promedio'] !== '') {
        $rating = round((float)$datos['rating_promedio'], 2);
        if ($rating < 0 || $rating > 5) {
            responder(['error' => 'El rating debe estar entre 0 y 5'], 400);
        }
    }

    $portada = trim((string)($datos['portada_url'] ?? '')) ?: null;
    $enlace  = trim((string)($datos['enlace_lectura'] ?? '')) ?: null;
    $descripcion = trim((string)($datos['descripcion'] ?? '')) ?: null;

    $imagen = null;
    if (!empty($datos['imagen'])) {
        $decoded = base64_decode($datos['imagen'], true);
        if ($decoded !== false && strlen($decoded) > 100) {
            $imagen = $decoded;
        }
    }

    $pdo = db();
    $pdo->beginTransaction();
    try {
        $clave = trim((string)($datos['ol_work_key'] ?? ''))
            ?: 'OLM' . strtoupper(bin2hex(random_bytes(4)));

        $stmt = $pdo->prepare(
            "INSERT INTO libro (ol_work_key, titulo, descripcion, anio_primer_publicacion,
             portada_url, imagen, enlace_lectura, rating_promedio)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
        );
        $stmt->execute([$clave, $titulo, $descripcion, $anio, $portada, $imagen, $enlace, $rating]);
        $libroId = (int)$pdo->lastInsertId();

        foreach ((array)($datos['autores'] ?? []) as $nombreAutor) {
            $nombreAutor = trim((string)$nombreAutor);
            if ($nombreAutor === '') {
                continue;
            }
            $autorId = autorIdPorNombre($pdo, $nombreAutor);
            $pdo->prepare("INSERT IGNORE INTO libro_autor (libro_id, autor_id) VALUES (?, ?)")
                ->execute([$libroId, $autorId]);
        }

        foreach ((array)($datos['categorias'] ?? []) as $nombreCategoria) {
            $categoriaId = categoriaIdPorNombre($pdo, trim((string)$nombreCategoria));
            if ($categoriaId) {
                $pdo->prepare("INSERT IGNORE INTO libro_categoria (libro_id, categoria_id) VALUES (?, ?)")
                    ->execute([$libroId, $categoriaId]);
            }
        }

        $pdo->commit();
    } catch (Throwable $e) {
        $pdo->rollBack();
        throw $e;
    }

    responder(filaLibro($libroId), 201);
}

function actualizarLibro(int $id): void
{
    filaLibro($id);

    $permitidos = [
        'titulo'                  => 's',
        'descripcion'             => 's',
        'anio_primer_publicacion' => 'i',
        'portada_url'             => 's',
        'imagen'                  => 'b',
        'enlace_lectura'          => 's',
        'rating_promedio'         => 'f',
    ];

    $datos = cuerpo();
    $campos  = [];
    $valores = [];
    foreach ($permitidos as $campo => $tipo) {
        if (!array_key_exists($campo, $datos)) {
            continue;
        }
        $valor = $datos[$campo];
        if ($tipo === 'b') {
            $valor = (!empty($valor)) ? base64_decode($valor, true) : null;
            if ($valor !== false && strlen($valor) > 100) {
                $campos[]  = "{$campo} = ?";
                $valores[] = $valor;
            }
            continue;
        } elseif ($tipo === 'i') {
            $valor = ($valor === null || $valor === '') ? null : max(0, min(65535, (int)$valor));
        } elseif ($tipo === 'f') {
            $valor = ($valor === null || $valor === '') ? null : round((float)$valor, 2);
            if ($valor !== null && ($valor < 0 || $valor > 5)) {
                responder(['error' => 'El rating debe estar entre 0 y 5'], 400);
            }
        } else {
            $valor = ($valor === null || trim((string)$valor) === '') ? null : trim((string)$valor);
        }
        $campos[]  = "{$campo} = ?";
        $valores[] = $valor;
    }

    if (!$campos) {
        responder(['error' => 'No hay campos para actualizar'], 400);
    }

    $valores[] = $id;
    db()->prepare("UPDATE libro SET " . implode(', ', $campos) . " WHERE id = ?")
        ->execute($valores);

    responder(filaLibro($id));
}

function eliminarLibro(int $id): void
{
    filaLibro($id);
    db()->prepare("DELETE FROM libro WHERE id = ?")->execute([$id]);
    http_response_code(204);
    exit;
}

function servirPortada(int $id): void
{
    $stmt = db()->prepare("SELECT imagen, portada_url FROM libro WHERE id = ?");
    $stmt->execute([$id]);
    $row = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$row) {
        responder(['error' => 'Libro no encontrado'], 404);
    }

    if ($row['imagen'] !== null) {
        header('Content-Type: image/jpeg');
        header('Cache-Control: public, max-age=2592000');
        echo $row['imagen'];
        exit;
    }

    if ($row['portada_url']) {
        header('Location: ' . $row['portada_url'], true, 302);
        exit;
    }

    responder(['error' => 'Portada no disponible'], 404);
}

// ---------------------------------------------------------------- AUTORES

function crearAutor(): void
{
    $nombre = trim((string)(cuerpo()['nombre'] ?? ''));
    if ($nombre === '') {
        responder(['error' => 'El nombre es obligatorio'], 400);
    }

    $pdo = db();
    $olKey = 'OLM' . strtoupper(bin2hex(random_bytes(4)));
    $stmt = $pdo->prepare(
        "INSERT INTO autor (ol_key, nombre, foto_url) VALUES (?, ?, ?)"
    );
    $stmt->execute([
        $olKey,
        $nombre,
        "https://covers.openlibrary.org/a/olid/{$olKey}-M.jpg",
    ]);

    $stmt = $pdo->prepare("SELECT * FROM autor WHERE id = ?");
    $stmt->execute([(int)$pdo->lastInsertId()]);
    responder($stmt->fetch(), 201);
}

function actualizarAutor(int $id): void
{
    $permitidos = ['nombre', 'biografia', 'obra_principal', 'fecha_nacimiento', 'fecha_fallecimiento'];

    $datos = cuerpo();
    $campos  = [];
    $valores = [];
    foreach ($permitidos as $campo) {
        if (!array_key_exists($campo, $datos)) {
            continue;
        }
        $valor = trim((string)$datos[$campo]);
        if ($campo === 'nombre' && $valor === '') {
            responder(['error' => 'El nombre no puede quedar vacío'], 400);
        }
        $campos[]  = "{$campo} = ?";
        $valores[] = $valor === '' ? null : $valor;
    }

    if (!$campos) {
        responder(['error' => 'No hay campos para actualizar'], 400);
    }

    $valores[] = $id;
    $stmt = db()->prepare("UPDATE autor SET " . implode(', ', $campos) . " WHERE id = ?");
    $stmt->execute($valores);

    if ($stmt->rowCount() === 0 && !idExistente(db(), 'autor', 'id', (string)$id)) {
        responder(['error' => 'Autor no encontrado'], 404);
    }

    $stmt = db()->prepare("SELECT * FROM autor WHERE id = ?");
    $stmt->execute([$id]);
    responder($stmt->fetch());
}

function eliminarAutor(int $id): void
{
    $stmt = db()->prepare("DELETE FROM autor WHERE id = ?");
    $stmt->execute([$id]);

    if ($stmt->rowCount() === 0) {
        responder(['error' => 'Autor no encontrado'], 404);
    }
    http_response_code(204);
    exit;
}

function listarAutores(): void
{
    $stmt = db()->query(
        "SELECT a.id, a.ol_key, a.nombre, a.foto_url,
                a.obra_principal, a.total_obras,
                COUNT(la.libro_id) AS libros
         FROM autor a
         LEFT JOIN libro_autor la ON la.autor_id = a.id
         GROUP BY a.id
         ORDER BY libros DESC, a.nombre"
    );

    responder($stmt->fetchAll());
}

// ---------------------------------------------------------------- CATEGORIAS

function crearCategoria(): void
{
    $nombre = trim((string)(cuerpo()['nombre'] ?? ''));
    if ($nombre === '') {
        responder(['error' => 'El nombre es obligatorio'], 400);
    }

    $slug = slugificar($nombre);
    if ($slug === '' || strlen($slug) > 120) {
        responder(['error' => 'El nombre no genera un slug válido'], 400);
    }
    if (idExistente(db(), 'categoria', 'slug', $slug) !== null) {
        responder(['error' => 'Ya existe una categoría con ese nombre'], 409);
    }

    db()->prepare("INSERT INTO categoria (slug, nombre) VALUES (?, ?)")
        ->execute([$slug, $nombre]);

    $id = (int)db()->lastInsertId();
    $stmt = db()->prepare("SELECT * FROM categoria WHERE id = ?");
    $stmt->execute([$id]);
    responder($stmt->fetch(), 201);
}

function actualizarCategoria(int $id): void
{
    $stmt = db()->prepare("SELECT * FROM categoria WHERE id = ?");
    $stmt->execute([$id]);
    $categoria = $stmt->fetch();
    if (!$categoria) {
        responder(['error' => 'Categoría no encontrada'], 404);
    }

    $datos = cuerpo();
    $nombre = array_key_exists('nombre', $datos)
        ? trim((string)$datos['nombre'])
        : $categoria['nombre'];
    $descripcion = array_key_exists('descripcion', $datos)
        ? (trim((string)$datos['descripcion']) ?: null)
        : $categoria['descripcion'];

    if ($nombre === '') {
        responder(['error' => 'El nombre no puede quedar vacío'], 400);
    }

    $slug = slugificar($nombre);
    $otro = idExistente(db(), 'categoria', 'slug', $slug);
    if ($otro !== null && $otro !== $id) {
        responder(['error' => 'Ya existe una categoría con ese nombre'], 409);
    }

    db()->prepare("UPDATE categoria SET slug = ?, nombre = ?, descripcion = ? WHERE id = ?")
        ->execute([$slug, $nombre, $descripcion, $id]);

    $stmt = db()->prepare("SELECT * FROM categoria WHERE id = ?");
    $stmt->execute([$id]);
    responder($stmt->fetch());
}

function eliminarCategoria(int $id): void
{
    $stmt = db()->prepare("DELETE FROM categoria WHERE id = ?");
    $stmt->execute([$id]);

    if ($stmt->rowCount() === 0) {
        responder(['error' => 'Categoría no encontrada'], 404);
    }
    http_response_code(204);
    exit;
}

function listarCategorias(): void
{
    $stmt = db()->query(
        "SELECT c.id, c.slug, c.nombre, COUNT(lc.libro_id) AS libros
         FROM categoria c
         LEFT JOIN libro_categoria lc ON lc.categoria_id = c.id
         GROUP BY c.id, c.slug, c.nombre
         ORDER BY c.nombre"
    );

    responder($stmt->fetchAll());
}

// ---------------------------------------------------------------- SECCIONES

function listarSeccion(array $segmentos): void
{
    $permitidos = ['carrusel', 'destacados', 'novedades', 'recomendados'];
    $slug = $segmentos[1] ?? '';

    if (!in_array($slug, $permitidos, true)) {
        responder(['error' => 'Sección no válida'], 404);
    }

    $limite = min(50, max(1, (int)($_GET['limite'] ?? 10)));

    $stmt = db()->prepare(
        "SELECT v.*
         FROM vw_libraria_libros v
         JOIN libro_seccion ls ON ls.libro_id = v.id
         JOIN seccion s ON s.id = ls.seccion_id
         WHERE s.slug = ?
         ORDER BY ls.posicion
         LIMIT {$limite}"
    );
    $stmt->execute([$slug]);

    responder($stmt->fetchAll());
}

// ---------------------------------------------------------------- ROUTER

$metodo   = $_SERVER['REQUEST_METHOD'];
$ruta     = trim(parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH), '/');
$segmentos = $ruta === '' ? [] : explode('/', $ruta);

try {
    switch ($segmentos[0] ?? '') {
        case 'libros':
            if (($segmentos[2] ?? '') === 'portada') {
                $metodo === 'GET' ? servirPortada(idDeRuta($segmentos)) : responder(['error' => 'Método no permitido'], 405);
                break;
            }
            match (true) {
                $metodo === 'GET'    => listarLibros(),
                $metodo === 'POST'   => crearLibro(),
                $metodo === 'PUT'    => actualizarLibro(idDeRuta($segmentos)),
                $metodo === 'DELETE' => eliminarLibro(idDeRuta($segmentos)),
                default              => responder(['error' => 'Método no permitido'], 405),
            };
            break;

        case 'secciones':
            listarSeccion($segmentos);
            break;

        case 'categorias':
            match (true) {
                $metodo === 'GET'    => listarCategorias(),
                $metodo === 'POST'   => crearCategoria(),
                $metodo === 'PUT'    => actualizarCategoria(idDeRuta($segmentos)),
                $metodo === 'DELETE' => eliminarCategoria(idDeRuta($segmentos)),
                default              => responder(['error' => 'Método no permitido'], 405),
            };
            break;

        case 'autores':
            match (true) {
                $metodo === 'GET'    => listarAutores(),
                $metodo === 'POST'   => crearAutor(),
                $metodo === 'PUT'    => actualizarAutor(idDeRuta($segmentos)),
                $metodo === 'DELETE' => eliminarAutor(idDeRuta($segmentos)),
                default              => responder(['error' => 'Método no permitido'], 405),
            };
            break;

        default:
            responder(['error' => 'Ruta no encontrada'], 404);
    }
} catch (Throwable $e) {
    responder(['error' => $e->getMessage()], 500);
}
