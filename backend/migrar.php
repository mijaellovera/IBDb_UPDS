<?php

require_once __DIR__ . '/config.php';
require_once __DIR__ . '/migrador.php';

$archivoJson = $argv[1] ?? __DIR__ . '/datos/openlibrary.json';
if (!is_file($archivoJson)) {
    fwrite(STDERR, "No existe {$archivoJson}. Ejecuta antes: php extraer.php\n");
    exit(1);
}

$paquete = json_decode(file_get_contents($archivoJson), true);
if (!is_array($paquete)) {
    fwrite(STDERR, "El JSON no tiene el formato esperado\n");
    exit(1);
}

$docs = [];
if (isset($paquete['resultados'])) {
    foreach ($paquete['resultados'] as $resultado) {
        echo "Migrando \"{$resultado['consulta']}\"...\n";
        $docs = array_merge($docs, $resultado['docs']);
    }
} elseif (isset($paquete['docs'])) {
    echo "Migrando \"{$paquete['termino']}\"...\n";
    $docs = $paquete['docs'];
} else {
    $docs = $paquete;
}

$conteo = migrarDocs($docs);

echo "\n=== Resumen de migración ===\n";
foreach ($conteo as $concepto => $cantidad) {
    echo str_replace('_', ' ', $concepto) . ": {$cantidad}\n";
}
