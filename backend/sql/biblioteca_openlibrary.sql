/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.8.8-MariaDB, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: biblioteca_openlibrary
-- ------------------------------------------------------
-- Server version	11.8.8-MariaDB

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

--
-- Current Database: `biblioteca_openlibrary`
--

/*!40000 DROP DATABASE IF EXISTS `biblioteca_openlibrary`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `biblioteca_openlibrary` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

USE `biblioteca_openlibrary`;

--
-- Table structure for table `autor`
--

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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `autor`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `autor` WRITE;
/*!40000 ALTER TABLE `autor` DISABLE KEYS */;
INSERT INTO `autor` VALUES
(1,'OL161167A','Arthur Conan Doyle',NULL,NULL,NULL,'The Adventures of Sherlock Holmes [12 stories]',NULL,'https://covers.openlibrary.org/a/olid/OL161167A-M.jpg','2026-08-22 23:53:21'),
(2,'OL22161A','H.P. Lovecraft',NULL,NULL,NULL,'At the Mountains of Madness',NULL,'https://covers.openlibrary.org/a/olid/OL22161A-M.jpg','2026-08-23 00:06:26'),
(3,'OL2631898A','Joe Hill',NULL,NULL,NULL,'Locke & Key, Vol. 1',NULL,'https://covers.openlibrary.org/a/olid/OL2631898A-M.jpg','2026-08-23 00:06:26'),
(4,'OL539632A','Matt Ruff',NULL,NULL,NULL,'Lovecraft Country',NULL,'https://covers.openlibrary.org/a/olid/OL539632A-M.jpg','2026-08-23 00:06:26');
/*!40000 ALTER TABLE `autor` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `categoria`
--

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
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categoria`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `categoria` WRITE;
/*!40000 ALTER TABLE `categoria` DISABLE KEYS */;
INSERT INTO `categoria` VALUES
(1,'classic-literature','Classic Literature',NULL),
(2,'murder','Murder',NULL),
(3,'mystery','Mystery',NULL),
(4,'conclusions','Conclusions',NULL),
(5,'amorality','amorality',NULL),
(6,'crime-mystery','Crime & Mystery',NULL),
(7,'catalepsy','catalepsy',NULL),
(8,'amyl-nitrate','amyl nitrate',NULL),
(9,'suicide-by-hanging','suicide by hanging',NULL),
(10,'broughams','broughams',NULL),
(11,'air-guns','air guns',NULL),
(12,'americans','Americans',NULL),
(13,'anise','anise',NULL),
(14,'anonymity','anonymity',NULL),
(15,'attempted-murder','attempted murder',NULL),
(16,'fiction','Fiction',NULL),
(17,'english-detective-and-mystery-stories','English Detective and mystery stories',NULL),
(18,'private-investigators','Private investigators',NULL),
(19,'children-s-stories-english','Children\'s stories, English',NULL),
(20,'mystery-and-detective-stories','Mystery and detective stories',NULL),
(21,'action-adventure-fiction','Action & Adventure Fiction',NULL),
(22,'adventure-stories','Adventure stories',NULL),
(23,'short-stories','short stories',NULL),
(24,'detective-and-mystery-fiction','Detective and mystery fiction',NULL),
(25,'mystery-fiction','Mystery fiction',NULL),
(26,'historical-fiction','Historical fiction',NULL),
(27,'aortic-aneurysm','aortic aneurysm',NULL),
(28,'battle-of-maiwand','Battle of Maiwand',NULL),
(29,'blessing-and-cursing','Blessing and cursing',NULL),
(30,'british-and-irish-fiction-fictional-works-by-one-author','British and irish fiction (fictional works by one author)',NULL),
(31,'crime-novel','crime novel',NULL),
(32,'english-civil-war','English Civil War',NULL),
(33,'mires','mires',NULL),
(34,'tors','tors',NULL),
(35,'tombs','tombs',NULL),
(36,'private-investigators-in-fiction','Private investigators in fiction',NULL),
(37,'romans','Romans',NULL),
(38,'classic-fiction','classic fiction',NULL),
(39,'andamanese','Andamanese',NULL),
(40,'arrow-poisons','arrow poisons',NULL),
(41,'bloguns','bloguns',NULL),
(42,'fossils','Fossils',NULL),
(43,'scientific-expeditions','Scientific expeditions',NULL),
(44,'stone-carving','Stone carving',NULL),
(45,'collection-and-preservation','Collection and preservation',NULL),
(46,'comics-graphic-novels-horror','Comics & graphic novels, horror',NULL),
(47,'new-england-fiction','New england, fiction',NULL),
(48,'nyt-hardcover-graphic-books-2011-10-02','nyt:hardcover-graphic-books=2011-10-02',NULL),
(49,'new-york-times-bestseller','New York Times bestseller',NULL),
(50,'locks-and-keys','Locks and keys',NULL),
(51,'horror-tales-american','Horror tales, American',NULL),
(52,'american-horror-tales','American Horror tales',NULL),
(53,'fiction-horror','Fiction, horror',NULL),
(54,'fiction-short-stories-single-author','Fiction, short stories (single author)',NULL),
(55,'african-americans-fiction','African americans, fiction',NULL),
(56,'missing-persons-fiction','Missing persons, fiction',NULL),
(57,'fiction-fantasy-historical','Fiction, fantasy, historical',NULL),
(58,'fiction-satire','Fiction, satire',NULL),
(59,'fiction-african-american-historical','Fiction, african american, historical',NULL),
(60,'american-literature','American literature',NULL),
(61,'art','Art',NULL),
(62,'supernatural','Supernatural',NULL),
(63,'supernatural-in-fiction','Supernatural in fiction',NULL),
(64,'horror-ghost-stories','Horror & ghost stories',NULL),
(65,'cuentos-de-terror-estadounidenses','Cuentos de terror estadounidenses',NULL),
(66,'cthulhu-fictitious-character','Cthulhu (Fictitious character)',NULL),
(67,'horror-tales','Horror tales',NULL);
/*!40000 ALTER TABLE `categoria` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `edicion`
--

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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `edicion`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `edicion` WRITE;
/*!40000 ALTER TABLE `edicion` DISABLE KEYS */;
INSERT INTO `edicion` VALUES
(1,'OL62423369M',1,1,'9781086410778','1792647557',NULL,NULL,NULL),
(2,'OL46220241M',2,2,'9786074154115','1794620486',NULL,NULL,NULL),
(3,'OL57894119M',3,3,'9798485115821','1594569711',NULL,NULL,NULL),
(4,'OL57727579M',4,4,'9780425029299','1596881399',NULL,NULL,NULL),
(5,'OL24203923M',5,5,'9781593080341','1409077055',NULL,NULL,NULL),
(6,'OL60465551M',6,6,'9781480489912','0486810143',NULL,NULL,NULL),
(7,'OL61027614M',7,1,'9781986913867','1728740703',NULL,NULL,NULL),
(8,'OL61714275M',8,7,'9786052060926','8393759714',NULL,NULL,NULL),
(9,'OL57727556M',9,6,'9798543719565','1092689788',NULL,NULL,NULL),
(10,'OL61726609M',10,8,'9798847469524','0595014658',NULL,NULL,NULL),
(11,'OL62444168M',11,9,'9781480580725','0007127774',NULL,NULL,NULL),
(12,'OL24468122M',12,10,'9781600102370','1600102379',NULL,NULL,NULL),
(13,'OL10644452M',13,11,'9780575081567','0575081570',NULL,NULL,NULL),
(14,'OL62337691M',14,12,'9781665017312','1529019036',NULL,NULL,NULL),
(15,'OL33889997M',15,13,'9780241260777','1624650449',NULL,NULL,NULL),
(16,'OL61562609M',16,14,'9789879017050','0345302346',NULL,NULL,NULL),
(17,'OL8344014M',17,15,'9788420636375','0870540378',NULL,NULL,NULL),
(18,'OL34816M',18,16,'9780141182346','0141182342',NULL,NULL,NULL),
(19,'OL9639963M',19,17,'9780345019233','0345337794',NULL,NULL,NULL),
(20,'OL42442946M',20,18,'9798669398361','1691599158',NULL,NULL,NULL);
/*!40000 ALTER TABLE `edicion` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `editorial`
--

DROP TABLE IF EXISTS `editorial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `editorial` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(200) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `editorial`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `editorial` WRITE;
/*!40000 ALTER TABLE `editorial` DISABLE KEYS */;
INSERT INTO `editorial` VALUES
(15,'Arkham House Publishers'),
(14,'Belmont Books'),
(6,'Book-of-the-Month Club'),
(3,'BookSurge Classics'),
(13,'Createspace Independent Publishing Platform'),
(7,'Dār al-Nashr Kītar'),
(17,'Del Rey'),
(4,'Digireads.com Publishing'),
(5,'Doubleday & Co.'),
(2,'Fingerprint! Publishing'),
(11,'Gollancz'),
(10,'IDW'),
(18,'Independently Published'),
(1,'John Murray'),
(9,'Open Road Media Sci-Fi & Fantasy'),
(12,'Pan Macmillan'),
(16,'Penguin Books'),
(8,'SelfMadeHero');
/*!40000 ALTER TABLE `editorial` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `libro`
--

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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `libro`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `libro` WRITE;
/*!40000 ALTER TABLE `libro` DISABLE KEYS */;
INSERT INTO `libro` VALUES
(1,'OL262421W','The Adventures of Sherlock Holmes [12 stories]',NULL,1892,'https://covers.openlibrary.org/b/id/6717853-M.jpg','https://archive.org/details/adventureofsherl0000unse','public','gre',4.16,171,2654,'2026-08-22 23:53:21'),
(2,'OL262463W','Memoirs of Sherlock Holmes [11 stories]',NULL,1893,'https://covers.openlibrary.org/b/id/9246429-M.jpg','https://archive.org/details/memoirsofsherloc0000sira_g5c8','public','por',4.54,28,545,'2026-08-22 23:53:21'),
(3,'OL262477W','The Return of Sherlock Holmes',NULL,1903,'https://covers.openlibrary.org/b/id/9246467-M.jpg','https://archive.org/details/returnsherlockho00doyl','public','fre',4.29,34,487,'2026-08-22 23:53:21'),
(4,'OL262426W','The Case-Book of Sherlock Holmes',NULL,1927,'https://covers.openlibrary.org/b/id/8350410-M.jpg','https://archive.org/details/casebooksherlockholmes_2303_librivox','public','por',4.55,31,375,'2026-08-22 23:53:21'),
(5,'OL262554W','The Complete Sherlock Holmes [4 novels, 56 stories]',NULL,1900,'https://covers.openlibrary.org/b/id/12501284-M.jpg','https://archive.org/details/deysayan844_gmail_Cano','public','ger',4.51,47,815,'2026-08-22 23:53:21'),
(6,'OL262452W','His Last Bow [8 stories]',NULL,1917,'https://covers.openlibrary.org/b/id/8243267-M.jpg','https://archive.org/details/hislastbow0000unse_z0p5','public','por',4.13,30,200,'2026-08-22 23:53:21'),
(7,'OL262496W','A Study in Scarlet',NULL,1887,'https://covers.openlibrary.org/b/id/13405534-M.jpg','https://archive.org/details/crime_etrange_2206_librivox','public','spa',3.98,121,521,'2026-08-22 23:53:21'),
(8,'OL262454W','The Hound of the Baskervilles',NULL,1900,'https://covers.openlibrary.org/b/id/8063264-M.jpg','https://archive.org/details/roundofbaskervil0000cona','public','bul',4.00,62,582,'2026-08-22 23:53:21'),
(9,'OL262505W','The Valley of Fear',NULL,1914,'https://covers.openlibrary.org/b/id/8350377-M.jpg','https://archive.org/details/thevalleyoffear03289gut','public','cat',4.10,29,227,'2026-08-22 23:53:21'),
(10,'OL262438W','The Sign of Four',NULL,1889,'https://covers.openlibrary.org/b/id/9247987-M.jpg','https://archive.org/details/sherlockholmesle00doyl_093','public','cat',4.24,90,346,'2026-08-22 23:53:21'),
(11,'OL152268W','At the Mountains of Madness',NULL,1968,'https://covers.openlibrary.org/b/id/6610039-M.jpg','https://archive.org/details/atmountainsofmad00love','borrowable','eng',3.76,45,212,'2026-08-23 00:06:26'),
(12,'OL13453816W','Locke & Key, Vol. 1',NULL,2008,'https://covers.openlibrary.org/b/id/6671226-M.jpg',NULL,'no_ebook','eng',3.95,22,61,'2026-08-23 00:06:26'),
(13,'OL152258W','Necronomicon',NULL,2008,'https://covers.openlibrary.org/b/id/2521774-M.jpg',NULL,'printdisabled','eng',4.43,14,138,'2026-08-23 00:06:26'),
(14,'OL17868256W','Lovecraft Country',NULL,2016,'https://covers.openlibrary.org/b/id/8844588-M.jpg',NULL,'printdisabled','eng',3.83,6,30,'2026-08-23 00:06:26'),
(15,'OL20804234W','The Call of Cthulhu',NULL,2016,'https://covers.openlibrary.org/b/id/10102400-M.jpg','https://archive.org/details/callofcthulhu0000love','borrowable','eng',2.75,4,120,'2026-08-23 00:06:26'),
(16,'OL152269W','The Case of Charles Dexter Ward',NULL,1965,'https://covers.openlibrary.org/b/id/207586-M.jpg','https://archive.org/details/elcasodecharlesd0000hplo','borrowable','eng',3.82,11,67,'2026-08-23 00:06:26'),
(17,'OL152253W','The Dunwich Horror',NULL,1963,'https://covers.openlibrary.org/b/id/9085353-M.jpg','https://archive.org/details/dunwichhorroroth00love','borrowable','eng',4.00,8,69,'2026-08-23 00:06:26'),
(18,'OL15330916W','The call of Cthulhu and other weird stories',NULL,1999,'https://covers.openlibrary.org/b/id/107777-M.jpg',NULL,'printdisabled','eng',4.12,17,25,'2026-08-23 00:06:26'),
(19,'OL152274W','The dream-quest of unknown Kadath',NULL,1955,'https://covers.openlibrary.org/b/id/207327-M.jpg','https://archive.org/details/dreamquestofunkn0000love','borrowable','eng',3.89,9,41,'2026-08-23 00:06:26'),
(20,'OL30037596W','Call of Cthulhu',NULL,2019,'https://covers.openlibrary.org/b/id/14823912-M.jpg',NULL,'no_ebook','eng',4.50,2,30,'2026-08-23 00:06:26');
/*!40000 ALTER TABLE `libro` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `libro_autor`
--

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `libro_autor`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `libro_autor` WRITE;
/*!40000 ALTER TABLE `libro_autor` DISABLE KEYS */;
INSERT INTO `libro_autor` VALUES
(1,1,1),
(2,1,1),
(3,1,1),
(4,1,1),
(5,1,1),
(6,1,1),
(7,1,1),
(8,1,1),
(9,1,1),
(10,1,1),
(11,2,1),
(12,3,1),
(13,2,1),
(14,4,1),
(15,2,1),
(16,2,1),
(17,2,1),
(18,2,1),
(19,2,1),
(20,2,1);
/*!40000 ALTER TABLE `libro_autor` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `libro_categoria`
--

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `libro_categoria`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `libro_categoria` WRITE;
/*!40000 ALTER TABLE `libro_categoria` DISABLE KEYS */;
INSERT INTO `libro_categoria` VALUES
(1,1),
(1,2),
(1,3),
(1,4),
(1,5),
(5,5),
(2,6),
(10,6),
(2,7),
(2,8),
(2,9),
(2,10),
(3,11),
(5,11),
(3,12),
(5,12),
(3,13),
(3,14),
(3,15),
(4,16),
(6,16),
(9,16),
(11,16),
(16,16),
(18,16),
(4,17),
(9,17),
(4,18),
(9,18),
(4,19),
(4,20),
(5,21),
(7,21),
(5,22),
(6,23),
(6,24),
(6,25),
(6,26),
(7,27),
(7,28),
(7,29),
(7,30),
(8,31),
(8,32),
(8,33),
(8,34),
(8,35),
(9,36),
(9,37),
(10,38),
(10,39),
(10,40),
(10,41),
(11,42),
(11,43),
(11,44),
(11,45),
(12,46),
(12,47),
(12,48),
(12,49),
(12,50),
(13,51),
(13,52),
(15,52),
(16,52),
(17,52),
(18,52),
(13,53),
(15,53),
(18,53),
(13,54),
(18,54),
(14,55),
(14,56),
(14,57),
(14,58),
(14,59),
(15,60),
(15,61),
(16,62),
(16,63),
(16,64),
(17,65),
(18,66),
(19,67);
/*!40000 ALTER TABLE `libro_categoria` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `libro_seccion`
--

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `libro_seccion`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `libro_seccion` WRITE;
/*!40000 ALTER TABLE `libro_seccion` DISABLE KEYS */;
/*!40000 ALTER TABLE `libro_seccion` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `seccion`
--

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seccion`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `seccion` WRITE;
/*!40000 ALTER TABLE `seccion` DISABLE KEYS */;
/*!40000 ALTER TABLE `seccion` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Temporary table structure for view `vw_libraria_libros`
--

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

--
-- Current Database: `biblioteca_openlibrary`
--

USE `biblioteca_openlibrary`;

--
-- Final view structure for view `vw_libraria_libros`
--

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

-- Dump completed on 2026-08-22 21:04:49