-- =====================================================================
-- BD: biblioteca_openlibrary | MySQL / MariaDB (utf8mb4)
-- Modelo relacional completo para alimentar la página Libraria.jsx
-- Fuente de datos: Open Library (ver docs/investigacion-openlibrary.md)
--
-- Tablas maestras : autor, categoria, editorial, seccion
-- Tabla principal : libro (nivel WORK)
-- Relaciones      : libro_autor, libro_categoria, libro_seccion
-- Detalle         : edicion (nivel EDITION: ISBN, editorial, portada)
-- Consumo frontend: vistas vw_libraria_* (filas planas para el React)
-- =====================================================================

CREATE DATABASE IF NOT EXISTS biblioteca_openlibrary
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE biblioteca_openlibrary;

SET FOREIGN_KEY_CHECKS = 0;
DROP VIEW IF EXISTS vw_libraria_libros;
DROP TABLE IF EXISTS libro_seccion;
DROP TABLE IF EXISTS libro_categoria;
DROP TABLE IF EXISTS libro_autor;
DROP TABLE IF EXISTS edicion;
DROP TABLE IF EXISTS seccion;
DROP TABLE IF EXISTS libro;
DROP TABLE IF EXISTS editorial;
DROP TABLE IF EXISTS categoria;
DROP TABLE IF EXISTS autor;
SET FOREIGN_KEY_CHECKS = 1;

-- ---------------------------------------------------------------------
-- AUTOR  (API: /search/authors.json, /authors/{key}.json)
-- ---------------------------------------------------------------------
CREATE TABLE autor (
  id                  INT UNSIGNED  AUTO_INCREMENT PRIMARY KEY,
  ol_key              VARCHAR(20)   NOT NULL UNIQUE COMMENT 'ej. OL23919A',
  nombre              VARCHAR(255)  NOT NULL,
  fecha_nacimiento    VARCHAR(60)   NULL,
  fecha_fallecimiento VARCHAR(60)   NULL,
  biografia           TEXT          NULL,
  obra_principal      VARCHAR(255)  NULL COMMENT 'top_work',
  total_obras         INT UNSIGNED  NULL,
  foto_url            VARCHAR(300)  NULL COMMENT 'covers.openlibrary.org/a/olid/{ol_key}-M.jpg',
  sincronizado_en     TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- CATEGORIA  (subjects de Open Library)
-- ---------------------------------------------------------------------
CREATE TABLE categoria (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  slug        VARCHAR(120) NOT NULL UNIQUE COMMENT 'URL amigable ej. ciencia-ficcion',
  nombre      VARCHAR(150) NOT NULL,
  descripcion TEXT NULL
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- EDITORIAL  (publishers de las ediciones)
-- ---------------------------------------------------------------------
CREATE TABLE editorial (
  id     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(200) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- LIBRO (nivel WORK: lo que se muestra en tarjetas y carruseles)
-- ---------------------------------------------------------------------
CREATE TABLE libro (
  id                      INT UNSIGNED   AUTO_INCREMENT PRIMARY KEY,
  ol_work_key             VARCHAR(30)    NOT NULL UNIQUE COMMENT 'ej. OL82563W',
  titulo                  VARCHAR(500)   NOT NULL,
  descripcion             TEXT           NULL,
  anio_primer_publicacion SMALLINT UNSIGNED NULL,
  portada_url             VARCHAR(300)   NULL COMMENT 'covers.openlibrary.org/b/id/{cover_i}-M.jpg',
  enlace_lectura          VARCHAR(300)   NULL COMMENT 'https://archive.org/details/{ia} si ebook_access public/borrowable',

  ebook_access            ENUM('public','borrowable','printdisabled','no_ebook')
                          NOT NULL DEFAULT 'no_ebook',
  idioma_principal        CHAR(3)        NULL,

  -- Ordenamientos del filtro de Libraria.jsx
  rating_promedio         DECIMAL(3,2)   NULL COMMENT 'Sort by rating',
  rating_total_votos      INT UNSIGNED   NOT NULL DEFAULT 0,
  popularidad             INT UNSIGNED   NOT NULL DEFAULT 0 COMMENT 'want_to_read_count -> Sort by popularity',

  sincronizado_en         TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT chk_rating CHECK (rating_promedio IS NULL OR rating_promedio BETWEEN 0 AND 5)
) ENGINE=InnoDB;

CREATE INDEX idx_libro_titulo ON libro (titulo(200));
CREATE INDEX idx_libro_rating ON libro (rating_promedio DESC, rating_total_votos DESC);
CREATE INDEX idx_libro_anio  ON libro (anio_primer_publicacion DESC);
CREATE INDEX idx_libro_pop    ON libro (popularidad DESC);

-- ---------------------------------------------------------------------
-- EDICION (nivel EDITION: ISBN concreto que muestra la tarjeta)
-- ---------------------------------------------------------------------
CREATE TABLE edicion (
  id               INT UNSIGNED  AUTO_INCREMENT PRIMARY KEY,
  ol_edition_key   VARCHAR(30)   NOT NULL UNIQUE COMMENT 'ej. OL61281195M',
  libro_id         INT UNSIGNED  NOT NULL,
  editorial_id     INT UNSIGNED  NULL,
  isbn_13          VARCHAR(20)   NULL UNIQUE,
  isbn_10          VARCHAR(15)   NULL,
  anio_publicacion SMALLINT UNSIGNED NULL,
  portada_url      VARCHAR(300)  NULL,
  num_paginas      SMALLINT UNSIGNED NULL,
  FOREIGN KEY (libro_id)     REFERENCES libro (id)     ON DELETE CASCADE,
  FOREIGN KEY (editorial_id) REFERENCES editorial (id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- RELACIONES N:M
-- ---------------------------------------------------------------------
CREATE TABLE libro_autor (
  libro_id INT UNSIGNED NOT NULL,
  autor_id INT UNSIGNED NOT NULL,
  orden    TINYINT UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (libro_id, autor_id),
  FOREIGN KEY (libro_id) REFERENCES libro (id) ON DELETE CASCADE,
  FOREIGN KEY (autor_id) REFERENCES autor (id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE libro_categoria (
  libro_id     INT UNSIGNED NOT NULL,
  categoria_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (libro_id, categoria_id),
  FOREIGN KEY (libro_id)     REFERENCES libro (id)     ON DELETE CASCADE,
  FOREIGN KEY (categoria_id) REFERENCES categoria (id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- SECCIONES del sitio (navbar / home) con orden por libro
-- slugs fijos: carrusel, destacados, novedades, recomendados
-- ---------------------------------------------------------------------
CREATE TABLE seccion (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  slug        VARCHAR(60)  NOT NULL UNIQUE,
  nombre      VARCHAR(120) NOT NULL,
  descripcion TEXT NULL
) ENGINE=InnoDB;

CREATE TABLE libro_seccion (
  libro_id   INT UNSIGNED NOT NULL,
  seccion_id INT UNSIGNED NOT NULL,
  posicion   SMALLINT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'orden dentro de la sección/carrusel',
  PRIMARY KEY (libro_id, seccion_id),
  FOREIGN KEY (libro_id)   REFERENCES libro (id)    ON DELETE CASCADE,
  FOREIGN KEY (seccion_id) REFERENCES seccion (id)  ON DELETE CASCADE
) ENGINE=InnoDB;

-- =====================================================================
-- VISTA PLANA: una fila por libro con TODO lo que pinta Libraria.jsx
-- (titulo, autores, isbn, portada, año, rating, categorias, secciones)
-- =====================================================================
CREATE VIEW vw_libraria_libros AS
SELECT
  l.id,
  l.ol_work_key,
  l.titulo,
  GROUP_CONCAT(DISTINCT a.nombre ORDER BY a.nombre SEPARATOR ', ')       AS autores,
  (SELECT a2.ol_key FROM libro_autor la2 JOIN autor a2 ON a2.id = la2.autor_id
    WHERE la2.libro_id = l.id ORDER BY la2.orden LIMIT 1)                AS autor_key,
  (SELECT e.isbn_13 FROM edicion e
    WHERE e.libro_id = l.id AND e.isbn_13 IS NOT NULL
    ORDER BY e.id LIMIT 1)                                               AS isbn_13,
  l.portada_url,
  l.enlace_lectura,
  l.anio_primer_publicacion                                              AS anio,
  l.rating_promedio                                                      AS rating,
  l.rating_total_votos                                                   AS votos,
  l.popularidad,
  GROUP_CONCAT(DISTINCT c.nombre ORDER BY c.nombre SEPARATOR ', ')       AS categorias,
  EXISTS(SELECT 1 FROM libro_seccion ls JOIN seccion s ON s.id = ls.seccion_id
         WHERE ls.libro_id = l.id AND s.slug = 'destacados')             AS destacado,
  EXISTS(SELECT 1 FROM libro_seccion ls JOIN seccion s ON s.id = ls.seccion_id
         WHERE ls.libro_id = l.id AND s.slug = 'novedades')              AS novedad,
  EXISTS(SELECT 1 FROM libro_seccion ls JOIN seccion s ON s.id = ls.seccion_id
         WHERE ls.libro_id = l.id AND s.slug = 'recomendados')           AS recomendado,
  EXISTS(SELECT 1 FROM libro_seccion ls JOIN seccion s ON s.id = ls.seccion_id
         WHERE ls.libro_id = l.id AND s.slug = 'carrusel')               AS en_carrusel,
  (SELECT ls.posicion FROM libro_seccion ls JOIN seccion s ON s.id = ls.seccion_id
         WHERE ls.libro_id = l.id AND s.slug = 'carrusel' LIMIT 1)       AS posicion_carrusel
FROM libro l
JOIN libro_autor la      ON la.libro_id = l.id
JOIN autor a             ON a.id = la.autor_id
LEFT JOIN libro_categoria lc ON lc.libro_id = l.id
LEFT JOIN categoria c        ON c.id = lc.categoria_id
GROUP BY l.id, l.ol_work_key, l.titulo, l.portada_url, l.enlace_lectura,
         l.anio_primer_publicacion, l.rating_promedio, l.rating_total_votos, l.popularidad;

-- ---------------------------------------------------------------------
-- CONSULTAS PARA LA PÁGINA (todas sobre la vista)
-- ---------------------------------------------------------------------
-- Listado con filtros del <select orderby>:
--   Sort by rating     -> SELECT * FROM vw_libraria_libros ORDER BY rating DESC, votos DESC;
--   Sort by popularity -> SELECT * FROM vw_libraria_libros ORDER BY popularidad DESC;
--   Sort by newness    -> SELECT * FROM vw_libraria_libros ORDER BY anio DESC;
-- Buscador del header:
--   SELECT * FROM vw_libraria_libros WHERE titulo LIKE ? OR autores LIKE ?;
-- Navbar Autores:
--   SELECT a.*, COUNT(la.libro_id) AS libros FROM autor a
--   LEFT JOIN libro_autor la ON la.autor_id = a.id GROUP BY a.id ORDER BY libros DESC;
-- Navbar Categorías:
--   SELECT c.*, COUNT(lc.libro_id) AS libros FROM categoria c
--   LEFT JOIN libro_categoria lc ON lc.categoria_id = c.id GROUP BY c.id ORDER BY c.nombre;
-- Secciones del navbar (ordenadas):
--   SELECT v.* FROM vw_libraria_libros v
--   JOIN libro_seccion ls ON ls.libro_id = v.id
--   JOIN seccion s ON s.id = ls.seccion_id
--   WHERE s.slug = 'destacados' ORDER BY ls.posicion;
-- Carrusel del home:
--   ... WHERE s.slug = 'carrusel' ORDER BY ls.posicion LIMIT 10;
