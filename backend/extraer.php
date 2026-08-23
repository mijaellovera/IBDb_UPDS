<?php

$CONSULTAS = ['classics', 'fantasy', 'science fiction'];
$LIMITE    = 10;

$CAMPOS = implode(',', [
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

function pedir(string $url): array
{
    $contexto = stream_context_create([
        'http' => [
            'header'  => "User-Agent: IBDb-UPDS/1.0 (proyecto universitario)\r\n",
            'timeout' => 30,
        ],
    ]);

    $respuesta = @file_get_contents($url, false, $contexto);
    if ($respuesta === false) {
        throw new RuntimeException("No se pudo consultar: {$url}");
    }

    $datos = json_decode($respuesta, true);
    if (!is_array($datos) || !isset($datos['docs'])) {
        throw new RuntimeException("Respuesta no válida de Open Library");
    }

    return $datos;
}

$carpeta = __DIR__ . '/datos';
if (!is_dir($carpeta)) {
    mkdir($carpeta, 0775, true);
}

$resultados = [];
foreach ($CONSULTAS as $consulta) {
    $url = 'https://openlibrary.org/search.json?' . http_build_query([
        'q'      => $consulta,
        'fields' => $CAMPOS,
        'limit'  => $LIMITE,
    ]);

    echo "Consultando \"{$consulta}\"... ";
    $datos = pedir($url);

    $resultados[] = [
        'consulta' => $consulta,
        'numFound' => $datos['numFound'],
        'docs'     => $datos['docs'],
    ];
    echo count($datos['docs']) . " documentos\n";
}

$salida = [
    'extraido_en' => date('c'),
    'resultados'  => $resultados,
];

$archivo = "{$carpeta}/openlibrary.json";
file_put_contents(
    $archivo,
    json_encode($salida, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES)
);

echo "Guardado en {$archivo}\n";
