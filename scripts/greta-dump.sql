-- MariaDB dump 10.19  Distrib 10.11.6-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: greta
-- ------------------------------------------------------
-- Server version	10.11.6-MariaDB-0+deb12u1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE DATABASE IF NOT EXISTS greta
	CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_general_ci
;

USE greta
;

--
-- Table structure for table `eleve`
--

DROP TABLE IF EXISTS `eleve`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eleve` (
  `id_eleve` int(11) NOT NULL AUTO_INCREMENT,
  `prenom` varchar(50) NOT NULL,
  `naiss` date DEFAULT NULL,
  `email` char(50) DEFAULT NULL,
  PRIMARY KEY (`id_eleve`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eleve`
--

LOCK TABLES `eleve` WRITE;
/*!40000 ALTER TABLE `eleve` DISABLE KEYS */;
INSERT INTO `eleve` VALUES
(1,'Samba','2002-09-15','samba@greta.fr'),
(2,'Johan','1998-10-02','johan@greta.fr'),
(3,'Youssef','1982-07-25','youssef@greta.fr'),
(4,'Adam','2004-01-02','adam@greta.fr'),
(5,'Bachir','2000-05-21','bachir@greta.fr'),
(6,'Terry','2004-10-02','terry@greta.fr'),
(7,'William','2012-04-02','william@greta.fr'),
(8,'Ibrahim','2001-09-24','ibrahim@greta.fr'),
(9,'Wilson','1987-07-03','wilson@greta.fr'),
(10,'Robert','1999-01-02','robert@greta.fr'),
(11,'Dimitri','2001-11-02','dimitri@greta.fr'),
(12,'Sadaf','1993-07-19','sadaf@greta.fr'),
(13,'Pierre','1999-01-30','pierre@greta.fr'),
(14,'Steven','2002-12-02','steven@greta.fr'),
(15,'Ismaël','2006-06-06','ismaël@greta.fr'),
(16,'Karim','1998-07-12','karim@greta.fr'),
(17,'Stéphane','1997-05-12','stéphane@greta.fr');
/*!40000 ALTER TABLE `eleve` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `module`
--

DROP TABLE IF EXISTS `module`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `module` (
  `id_mod` char(5) NOT NULL,
  `titre` varchar(100) NOT NULL,
  `code_prof` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_mod`),
  KEY `code_prof` (`code_prof`),
  CONSTRAINT `module_ibfk_1` FOREIGN KEY (`code_prof`) REFERENCES `prof` (`id_prof`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `module`
--

LOCK TABLES `module` WRITE;
/*!40000 ALTER TABLE `module` DISABLE KEYS */;
INSERT INTO `module` VALUES
('CP1','Installer et configurer son environnement de travail en fonction du projet',2),
('CP10','Préparer et documenter le déploiement d\'une application',4),
('CP11','Contribuer à la mise en production dans une démarche DevOps',2),
('CP2','Développer des interfaces utilisateur',4),
('CP3','Développer des composants métier',4),
('CP4','Contribuer à la gestion d\'un projet informatique',2),
('CP5','Analyser les besoins et maquetter une application',2),
('CP6','Définir l\'architecture logicielle d\'une application',4),
('CP7','Concevoir et mettre en place une base de données relationnelle',3),
('CP8','Développer des composants d\'accès aux données SQL et NoSQL',1),
('CP9','Préparer et exécuter les plans de tests d\'une application',2),
('SPLC','Savoir planter les choux',NULL);
/*!40000 ALTER TABLE `module` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prof`
--

DROP TABLE IF EXISTS `prof`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `prof` (
  `id_prof` int(11) NOT NULL AUTO_INCREMENT,
  `prenom` varchar(50) NOT NULL,
  `naiss` date DEFAULT NULL,
  `mobile` char(50) DEFAULT NULL,
  PRIMARY KEY (`id_prof`),
  UNIQUE KEY `mobile` (`mobile`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prof`
--

LOCK TABLES `prof` WRITE;
/*!40000 ALTER TABLE `prof` DISABLE KEYS */;
INSERT INTO `prof` VALUES
(1,'Lesly','1965-06-10',NULL),
(2,'Moustapha','1987-11-29',NULL),
(3,'Philippe','1998-01-27',NULL),
(4,'Paul','1981-06-20',NULL),
(5,'Nadjet','1987-12-17',NULL);
/*!40000 ALTER TABLE `prof` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suivre`
--

DROP TABLE IF EXISTS `suivre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `suivre` (
  `id_eleve` int(11) NOT NULL,
  `id_mod` char(5) NOT NULL,
  `date_eval` date NOT NULL,
  `note` tinyint(4) DEFAULT NULL CHECK (`note` between 0 and 20),
  PRIMARY KEY (`id_eleve`,`id_mod`,`date_eval`),
  KEY `id_mod` (`id_mod`),
  CONSTRAINT `suivre_ibfk_1` FOREIGN KEY (`id_eleve`) REFERENCES `eleve` (`id_eleve`),
  CONSTRAINT `suivre_ibfk_2` FOREIGN KEY (`id_mod`) REFERENCES `module` (`id_mod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suivre`
--

LOCK TABLES `suivre` WRITE;
/*!40000 ALTER TABLE `suivre` DISABLE KEYS */;
INSERT INTO `suivre` VALUES
(3,'CP3','2024-09-28',20),
(3,'CP5','2024-10-08',6),
(4,'CP1','2024-10-19',4),
(4,'CP10','2024-09-13',6),
(4,'CP8','2024-09-18',16),
(5,'CP11','2024-06-23',9),
(5,'CP6','2024-09-14',8),
(6,'CP6','2024-10-01',2),
(6,'CP9','2024-07-15',11),
(7,'CP3','2024-06-12',15),
(7,'CP3','2025-01-14',20),
(7,'CP7','2024-07-14',2),
(8,'CP4','2024-09-13',15),
(8,'CP4','2024-12-14',6),
(9,'CP1','2024-09-23',12),
(9,'CP10','2024-05-26',20),
(10,'CP2','2025-01-20',5),
(10,'CP6','2024-07-15',8),
(10,'CP9','2025-01-27',5),
(11,'CP9','2024-05-27',7),
(12,'CP5','2025-01-12',10),
(12,'CP6','2024-08-15',14),
(12,'CP7','2024-05-25',18),
(12,'CP9','2024-05-21',6),
(13,'CP1','2025-01-13',12),
(13,'CP8','2024-05-09',19),
(14,'CP1','2024-05-22',11),
(14,'CP4','2024-12-04',9),
(15,'CP2','2024-11-20',3),
(15,'CP3','2024-07-04',4),
(15,'CP3','2024-08-03',14),
(15,'CP8','2024-08-14',8),
(16,'CP6','2024-08-12',18),
(16,'CP9','2024-05-21',11),
(17,'CP5','2025-01-12',11);
/*!40000 ALTER TABLE `suivre` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-03-03  8:23:12
