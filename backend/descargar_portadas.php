<?php

require_once __DIR__ . '/config.php';
require_once __DIR__ . '/migrador.php';

echo "Descargando portadas pendientes...\n";
$descargadas = descargarPortadasPendientes(db());
echo "Portadas descargadas: {$descargadas}\n";
