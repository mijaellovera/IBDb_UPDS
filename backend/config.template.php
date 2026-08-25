<?php

$DB = [
    'host'    => '127.0.0.1',
    'nombre'  => 'biblioteca_openlibrary',
    'usuario' => 'root',
    'clave'   => 'root',
];

function db(): PDO
{
    global $DB;
    static $pdo = null;

    if ($pdo === null) {
        $dsn = "mysql:host={$DB['host']};dbname={$DB['nombre']};charset=utf8mb4";
        $pdo = new PDO($dsn, $DB['usuario'], $DB['clave'], [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        ]);
    }

    return $pdo;
}
