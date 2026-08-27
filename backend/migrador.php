<?php

function slugificar(string $texto): string
{
    $texto = mb_strtolower(trim($texto));
    $texto = iconv('UTF-8', 'ASCII//TRANSLIT', $texto) ?: $texto;
    return trim((string)preg_replace('/[^a-z0-9]+/', '-', $texto), '-');
}

function descargarPortada(?string $url): ?string
{
    if ($url === null) {
        return null;
    }
    $ctx = stream_context_create(['http' => ['timeout' => 10, 'user_agent' => 'IBDb-UPDS/1.0']]);
    $datos = @file_get_contents($url, false, $ctx);
    if ($datos === false || strlen($datos) < 100) {
        return null;
    }
    return $datos;
}

function isbn13De(array $isbns): ?string
{
    foreach ($isbns as $isbn) {
        if (preg_match('/^(97[89]\d{10})$/', $isbn)) {
            return $isbn;
        }
    }
    return null;
}

function isbn10De(array $isbns, ?string $isbn13): ?string
{
    foreach ($isbns as $isbn) {
        if (preg_match('/^\d{9}[\dX]$/', $isbn) && $isbn !== $isbn13) {
            return $isbn;
        }
    }
    return null;
}

function idExistente(PDO $pdo, string $tabla, string $columna, string $valor): ?int
{
    $stmt = $pdo->prepare("SELECT id FROM {$tabla} WHERE {$columna} = ?");
    $stmt->execute([$valor]);
    $id = $stmt->fetchColumn();
    return $id === false ? null : (int)$id;
}

function conteoInicial(): array
{
    return [
        'libros_nuevos'        => 0,
        'libros_actualizados'  => 0,
        'autores_nuevos'       => 0,
        'editoriales_nuevas'   => 0,
        'categorias_nuevas'    => 0,
        'ediciones_nuevas'     => 0,
        'relaciones_autor'     => 0,
        'relaciones_categoria' => 0,
        'descartados'          => 0,
    ];
}

function crearAutorSiNoExiste(PDO $pdo, string $olKey, string $nombre, string $obraPrincipal, array &$conteo): int
{
    $id = idExistente($pdo, 'autor', 'ol_key', $olKey);
    if ($id !== null) {
        return $id;
    }

    $stmt = $pdo->prepare(
        "INSERT INTO autor (ol_key, nombre, obra_principal, foto_url)
         VALUES (?, ?, ?, ?)"
    );
    $stmt->execute([
        $olKey,
        $nombre,
        $obraPrincipal,
        "https://covers.openlibrary.org/a/olid/{$olKey}-M.jpg",
    ]);
    $conteo['autores_nuevos']++;
    return (int)$pdo->lastInsertId();
}

function crearEditorialSiNoExiste(PDO $pdo, string $nombre, array &$conteo): int
{
    $stmt = $pdo->prepare("SELECT id FROM editorial WHERE nombre = ?");
    $stmt->execute([$nombre]);
    $id = $stmt->fetchColumn();
    if ($id !== false) {
        return (int)$id;
    }

    $stmt = $pdo->prepare("INSERT INTO editorial (nombre) VALUES (?)");
    $stmt->execute([$nombre]);
    $conteo['editoriales_nuevas']++;
    return (int)$pdo->lastInsertId();
}

function crearCategoriaSiNoExiste(PDO $pdo, string $nombre, array &$conteo): ?int
{
    $slug = slugificar($nombre);
    if ($slug === '' || strlen($slug) > 120) {
        return null;
    }

    $id = idExistente($pdo, 'categoria', 'slug', $slug);
    if ($id !== null) {
        return $id;
    }

    $stmt = $pdo->prepare("INSERT INTO categoria (slug, nombre) VALUES (?, ?)");
    $stmt->execute([$slug, $nombre]);
    $conteo['categorias_nuevas']++;
    return (int)$pdo->lastInsertId();
}

function migrarLibro(PDO $pdo, array $doc, array &$conteo): void
{
    $clave = basename($doc['key'] ?? '');
    $titulo = trim($doc['title'] ?? '');
    if ($clave === '' || $titulo === '') {
        $conteo['descartados']++;
        return;
    }

    $acceso = $doc['ebook_access'] ?? 'no_ebook';
    if (!in_array($acceso, ['public', 'borrowable', 'printdisabled', 'no_ebook'], true)) {
        $acceso = 'no_ebook';
    }

    $ia = $doc['ia'][0] ?? null;
    $enlaceLectura = $ia && in_array($acceso, ['public', 'borrowable'], true)
        ? "https://archive.org/details/{$ia}"
        : null;

    $portada = !empty($doc['cover_i'])
        ? "https://covers.openlibrary.org/b/id/{$doc['cover_i']}-M.jpg"
        : null;

    $rating = isset($doc['ratings_average'])
        ? round(min(5, max(0, (float)$doc['ratings_average'])), 2)
        : null;

    $datosLibro = [
        'titulo'                  => $titulo,
        'anio_primer_publicacion' => $doc['first_publish_year'] ?? null,
        'portada_url'             => $portada,
        'enlace_lectura'          => $enlaceLectura,
        'ebook_access'            => $acceso,
        'idioma_principal'        => isset($doc['language'][0]) ? substr($doc['language'][0], 0, 3) : null,
        'rating_promedio'         => $rating,
        'rating_total_votos'      => (int)($doc['ratings_count'] ?? 0),
        'popularidad'             => (int)($doc['want_to_read_count'] ?? 0),
    ];

    $id = idExistente($pdo, 'libro', 'ol_work_key', $clave);

    if ($id === null) {
        $sql = "INSERT INTO libro (ol_work_key, titulo, anio_primer_publicacion, portada_url,
                 enlace_lectura, ebook_access, idioma_principal, rating_promedio,
                 rating_total_votos, popularidad)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        $stmt = $pdo->prepare($sql);
        $stmt->execute([
            $clave,
            ...array_values($datosLibro),
        ]);
        $id = (int)$pdo->lastInsertId();
        $conteo['libros_nuevos']++;
    } else {
        $sql = "UPDATE libro SET titulo = ?, anio_primer_publicacion = ?, portada_url = ?,
                 enlace_lectura = ?, ebook_access = ?, idioma_principal = ?, rating_promedio = ?,
                 rating_total_votos = ?, popularidad = ?
                WHERE ol_work_key = ?";
        $stmt = $pdo->prepare($sql);
        $stmt->execute([
            ...array_values($datosLibro),
            $clave,
        ]);
        $conteo['libros_actualizados']++;
    }

    $nombresAutores = $doc['author_name'] ?? [];
    $clavesAutores  = $doc['author_key'] ?? [];
    foreach ($clavesAutores as $i => $autorKey) {
        $nombreAutor = $nombresAutores[$i] ?? null;
        if (!$autorKey || !$nombreAutor) {
            continue;
        }

        $autorId = crearAutorSiNoExiste($pdo, $autorKey, $nombreAutor, $titulo, $conteo);

        $stmt = $pdo->prepare(
            "INSERT IGNORE INTO libro_autor (libro_id, autor_id, orden) VALUES (?, ?, ?)"
        );
        $stmt->execute([$id, $autorId, $i + 1]);
        $conteo['relaciones_autor'] += $stmt->rowCount();
    }

    $materias = array_filter(
        $doc['subject'] ?? [],
        fn($s) => !preg_match('/^(series:|accessible_book|protected_daisy|in_library|lending_library|overdrive)/i', $s)
    );

    $usadas = [];
    foreach (array_slice(array_values($materias), 0, 5) as $materia) {
        $categoriaId = crearCategoriaSiNoExiste($pdo, $materia, $conteo);
        if (!$categoriaId || in_array($categoriaId, $usadas, true)) {
            continue;
        }
        $usadas[] = $categoriaId;

        $stmt = $pdo->prepare(
            "INSERT IGNORE INTO libro_categoria (libro_id, categoria_id) VALUES (?, ?)"
        );
        $stmt->execute([$id, $categoriaId]);
        $conteo['relaciones_categoria'] += $stmt->rowCount();
    }

    $edicionKey = $doc['edition_key'][0] ?? null;
    if ($edicionKey && idExistente($pdo, 'edicion', 'ol_edition_key', $edicionKey) === null) {
        $editorialId = isset($doc['publisher'][0])
            ? crearEditorialSiNoExiste($pdo, $doc['publisher'][0], $conteo)
            : null;

        $stmt = $pdo->prepare(
            "INSERT INTO edicion (ol_edition_key, libro_id, editorial_id, isbn_13, isbn_10)
             VALUES (?, ?, ?, ?, ?)"
        );
        $stmt->execute([
            $edicionKey,
            $id,
            $editorialId,
            isbn13De($doc['isbn'] ?? []),
            isbn10De($doc['isbn'] ?? [], isbn13De($doc['isbn'] ?? [])),
        ]);
        $conteo['ediciones_nuevas']++;
    }
}

function migrarDocs(array $docs): array
{
    $conteo = conteoInicial();
    $pdo = db();

    $pdo->beginTransaction();
    try {
        foreach ($docs as $doc) {
            migrarLibro($pdo, $doc, $conteo);
        }
        $pdo->commit();
    } catch (Throwable $e) {
        $pdo->rollBack();
        throw $e;
    }

    $conteo['portadas_descargadas'] = descargarPortadasPendientes($pdo);

    return $conteo;
}

function descargarPortadasPendientes(PDO $pdo): int
{
    $stmt = $pdo->query("SELECT id, portada_url FROM libro WHERE imagen IS NULL AND portada_url IS NOT NULL");
    $libros = $stmt->fetchAll(PDO::FETCH_KEY_PAIR);

    $descargadas = 0;
    $update = $pdo->prepare("UPDATE libro SET imagen = ? WHERE id = ?");

    foreach ($libros as $id => $url) {
        $blob = descargarPortada($url);
        if ($blob !== null) {
            $update->execute([$blob, $id]);
            $descargadas++;
        }
    }

    return $descargadas;
}
