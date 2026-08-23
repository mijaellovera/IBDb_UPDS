-- Crea el usuario que usa el backend PHP (ejecutar con sudo mysql < crear_usuario.sql)
CREATE USER IF NOT EXISTS 'libraria_user'@'localhost' IDENTIFIED BY 'libraria2026';
CREATE USER IF NOT EXISTS 'libraria_user'@'127.0.0.1' IDENTIFIED BY 'libraria2026';
GRANT SELECT ON biblioteca_openlibrary.* TO 'libraria_user'@'localhost';
GRANT SELECT ON biblioteca_openlibrary.* TO 'libraria_user'@'127.0.0.1';
FLUSH PRIVILEGES;
