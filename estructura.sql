/*M!999999\- enable the sandbox mode */ 

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;
DROP TABLE IF EXISTS `autor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `autor` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ol_key` varchar(20) NOT NULL COMMENT 'ej. OL23919A',
  `nombre` varchar(255) NOT NULL,
  `fecha_nacimiento` varchar(60) DEFAULT NULL,
  `fecha_fallecimiento` varchar(60) DEFAULT NULL,
  `biografia` text DEFAULT NULL,
  `obra_principal` varchar(255) DEFAULT NULL COMMENT 'top_work',
  `total_obras` int(10) unsigned DEFAULT NULL,
  `foto_url` varchar(300) DEFAULT NULL COMMENT 'covers.openlibrary.org/a/olid/{ol_key}-M.jpg',
  `sincronizado_en` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `ol_key` (`ol_key`)
) ENGINE=InnoDB AUTO_INCREMENT=59 ;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `categoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `categoria` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `slug` varchar(120) NOT NULL COMMENT 'URL amigable ej. ciencia-ficcion',
  `nombre` varchar(150) NOT NULL,
  `descripcion` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=197 ;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `edicion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `edicion` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ol_edition_key` varchar(30) NOT NULL COMMENT 'ej. OL61281195M',
  `libro_id` int(10) unsigned NOT NULL,
  `editorial_id` int(10) unsigned DEFAULT NULL,
  `isbn_13` varchar(20) DEFAULT NULL,
  `isbn_10` varchar(15) DEFAULT NULL,
  `anio_publicacion` smallint(5) unsigned DEFAULT NULL,
  `portada_url` varchar(300) DEFAULT NULL,
  `num_paginas` smallint(5) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ol_edition_key` (`ol_edition_key`),
  UNIQUE KEY `isbn_13` (`isbn_13`),
  KEY `libro_id` (`libro_id`),
  KEY `editorial_id` (`editorial_id`),
  CONSTRAINT `edicion_ibfk_1` FOREIGN KEY (`libro_id`) REFERENCES `libro` (`id`) ON DELETE CASCADE,
  CONSTRAINT `edicion_ibfk_2` FOREIGN KEY (`editorial_id`) REFERENCES `editorial` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=83 ;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `editorial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `editorial` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(200) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=68 ;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `libro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `libro` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ol_work_key` varchar(30) NOT NULL COMMENT 'ej. OL82563W',
  `titulo` varchar(500) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `anio_primer_publicacion` smallint(5) unsigned DEFAULT NULL,
  `portada_url` varchar(300) DEFAULT NULL COMMENT 'covers.openlibrary.org/b/id/{cover_i}-M.jpg',
  `imagen` longblob DEFAULT NULL,
  `enlace_lectura` varchar(300) DEFAULT NULL COMMENT 'https://archive.org/details/{ia} si ebook_access public/borrowable',
  `ebook_access` enum('public','borrowable','printdisabled','no_ebook') NOT NULL DEFAULT 'no_ebook',
  `idioma_principal` char(3) DEFAULT NULL,
  `rating_promedio` decimal(3,2) DEFAULT NULL COMMENT 'Sort by rating',
  `rating_total_votos` int(10) unsigned NOT NULL DEFAULT 0,
  `popularidad` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'want_to_read_count -> Sort by popularity',
  `sincronizado_en` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `ol_work_key` (`ol_work_key`),
  KEY `idx_libro_titulo` (`titulo`(200)),
  KEY `idx_libro_rating` (`rating_promedio` DESC,`rating_total_votos` DESC),
  KEY `idx_libro_anio` (`anio_primer_publicacion` DESC),
  KEY `idx_libro_pop` (`popularidad` DESC),
  CONSTRAINT `chk_rating` CHECK (`rating_promedio` is null or `rating_promedio` between 0 and 5)
) ENGINE=InnoDB AUTO_INCREMENT=83 ;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `libro_autor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `libro_autor` (
  `libro_id` int(10) unsigned NOT NULL,
  `autor_id` int(10) unsigned NOT NULL,
  `orden` tinyint(3) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`libro_id`,`autor_id`),
  KEY `autor_id` (`autor_id`),
  CONSTRAINT `libro_autor_ibfk_1` FOREIGN KEY (`libro_id`) REFERENCES `libro` (`id`) ON DELETE CASCADE,
  CONSTRAINT `libro_autor_ibfk_2` FOREIGN KEY (`autor_id`) REFERENCES `autor` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB ;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `libro_categoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `libro_categoria` (
  `libro_id` int(10) unsigned NOT NULL,
  `categoria_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`libro_id`,`categoria_id`),
  KEY `categoria_id` (`categoria_id`),
  CONSTRAINT `libro_categoria_ibfk_1` FOREIGN KEY (`libro_id`) REFERENCES `libro` (`id`) ON DELETE CASCADE,
  CONSTRAINT `libro_categoria_ibfk_2` FOREIGN KEY (`categoria_id`) REFERENCES `categoria` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB ;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `libro_seccion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `libro_seccion` (
  `libro_id` int(10) unsigned NOT NULL,
  `seccion_id` int(10) unsigned NOT NULL,
  `posicion` smallint(5) unsigned NOT NULL DEFAULT 1 COMMENT 'orden dentro de la sección/carrusel',
  PRIMARY KEY (`libro_id`,`seccion_id`),
  KEY `seccion_id` (`seccion_id`),
  CONSTRAINT `libro_seccion_ibfk_1` FOREIGN KEY (`libro_id`) REFERENCES `libro` (`id`) ON DELETE CASCADE,
  CONSTRAINT `libro_seccion_ibfk_2` FOREIGN KEY (`seccion_id`) REFERENCES `seccion` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB ;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `seccion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `seccion` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `slug` varchar(60) NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `descripcion` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB ;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `vw_libraria_libros`;
/*!50001 DROP VIEW IF EXISTS `vw_libraria_libros`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `vw_libraria_libros` AS SELECT
 NULL AS `id`,
 NULL AS `ol_work_key`,
 NULL AS `titulo`,
 NULL AS `autores`,
 NULL AS `autor_key`,
 NULL AS `isbn_13`,
 NULL AS `portada_url`,
 NULL AS `enlace_lectura`,
 NULL AS `anio`,
 NULL AS `rating`,
 NULL AS `votos`,
 NULL AS `popularidad`,
 NULL AS `categorias`,
 NULL AS `destacado`,
 NULL AS `novedad`,
 NULL AS `recomendado`,
 NULL AS `en_carrusel`,
 NULL AS `posicion_carrusel` */;
SET character_set_client = @saved_cs_client;
/*!50001 DROP VIEW IF EXISTS `vw_libraria_libros`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_libraria_libros` AS select `l`.`id` AS `id`,`l`.`ol_work_key` AS `ol_work_key`,`l`.`titulo` AS `titulo`,group_concat(distinct `a`.`nombre` order by `a`.`nombre` ASC separator ', ') AS `autores`,(select `a2`.`ol_key` from (`libro_autor` `la2` join `autor` `a2` on(`a2`.`id` = `la2`.`autor_id`)) where `la2`.`libro_id` = `l`.`id` order by `la2`.`orden` limit 1) AS `autor_key`,(select `e`.`isbn_13` from `edicion` `e` where `e`.`libro_id` = `l`.`id` and `e`.`isbn_13` is not null order by `e`.`id` limit 1) AS `isbn_13`,`l`.`portada_url` AS `portada_url`,`l`.`enlace_lectura` AS `enlace_lectura`,`l`.`anio_primer_publicacion` AS `anio`,`l`.`rating_promedio` AS `rating`,`l`.`rating_total_votos` AS `votos`,`l`.`popularidad` AS `popularidad`,group_concat(distinct `c`.`nombre` order by `c`.`nombre` ASC separator ', ') AS `categorias`,exists(select 1 from (`libro_seccion` `ls` join `seccion` `s` on(`s`.`id` = `ls`.`seccion_id`)) where `ls`.`libro_id` = `l`.`id` and `s`.`slug` = 'destacados' limit 1) AS `destacado`,exists(select 1 from (`libro_seccion` `ls` join `seccion` `s` on(`s`.`id` = `ls`.`seccion_id`)) where `ls`.`libro_id` = `l`.`id` and `s`.`slug` = 'novedades' limit 1) AS `novedad`,exists(select 1 from (`libro_seccion` `ls` join `seccion` `s` on(`s`.`id` = `ls`.`seccion_id`)) where `ls`.`libro_id` = `l`.`id` and `s`.`slug` = 'recomendados' limit 1) AS `recomendado`,exists(select 1 from (`libro_seccion` `ls` join `seccion` `s` on(`s`.`id` = `ls`.`seccion_id`)) where `ls`.`libro_id` = `l`.`id` and `s`.`slug` = 'carrusel' limit 1) AS `en_carrusel`,(select `ls`.`posicion` from (`libro_seccion` `ls` join `seccion` `s` on(`s`.`id` = `ls`.`seccion_id`)) where `ls`.`libro_id` = `l`.`id` and `s`.`slug` = 'carrusel' limit 1) AS `posicion_carrusel` from ((((`libro` `l` join `libro_autor` `la` on(`la`.`libro_id` = `l`.`id`)) join `autor` `a` on(`a`.`id` = `la`.`autor_id`)) left join `libro_categoria` `lc` on(`lc`.`libro_id` = `l`.`id`)) left join `categoria` `c` on(`c`.`id` = `lc`.`categoria_id`)) group by `l`.`id`,`l`.`ol_work_key`,`l`.`titulo`,`l`.`portada_url`,`l`.`enlace_lectura`,`l`.`anio_primer_publicacion`,`l`.`rating_promedio`,`l`.`rating_total_votos`,`l`.`popularidad` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

