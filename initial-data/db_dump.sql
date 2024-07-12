-- MySQL dump 10.13  Distrib 8.3.0, for macos14.2 (arm64)
--
-- Host: localhost    Database: callassure
-- ------------------------------------------------------
-- Server version	9.0.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `callassure`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `callassure` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `callassure`;

--
-- Table structure for table `addresses`
--

DROP TABLE IF EXISTS `addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `addresses` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `addr_line1` varchar(40) DEFAULT NULL,
  `addr_line2` varchar(40) DEFAULT NULL,
  `city` varchar(20) DEFAULT NULL,
  `state` varchar(2) DEFAULT NULL,
  `zip_code` varchar(5) DEFAULT NULL,
  `country` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addresses`
--

LOCK TABLES `addresses` WRITE;
/*!40000 ALTER TABLE `addresses` DISABLE KEYS */;
INSERT INTO `addresses` VALUES (1,'7842 NE 21st St',NULL,'Medina','WA','98039','US');
/*!40000 ALTER TABLE `addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `checkin_methods`
--

DROP TABLE IF EXISTS `checkin_methods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `checkin_methods` (
  `id` int NOT NULL,
  `method_name` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `checkin_methods`
--

LOCK TABLES `checkin_methods` WRITE;
/*!40000 ALTER TABLE `checkin_methods` DISABLE KEYS */;
INSERT INTO `checkin_methods` VALUES (1,'phone'),(2,'text'),(3,'app'),(4,'email');
/*!40000 ALTER TABLE `checkin_methods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `checkin_schedule`
--

DROP TABLE IF EXISTS `checkin_schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `checkin_schedule` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `member_id` int unsigned NOT NULL,
  `dayofweek` int NOT NULL,
  `deadline` time NOT NULL,
  `method_id` int NOT NULL,
  `curr_address` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `curr_address` (`curr_address`),
  KEY `member_id` (`member_id`),
  KEY `method_id` (`method_id`),
  KEY `dayofweek` (`dayofweek`),
  CONSTRAINT `checkin_schedule_ibfk_1` FOREIGN KEY (`curr_address`) REFERENCES `addresses` (`id`),
  CONSTRAINT `checkin_schedule_ibfk_2` FOREIGN KEY (`member_id`) REFERENCES `members` (`user_id`),
  CONSTRAINT `checkin_schedule_ibfk_3` FOREIGN KEY (`method_id`) REFERENCES `checkin_methods` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `checkin_schedule`
--

LOCK TABLES `checkin_schedule` WRITE;
/*!40000 ALTER TABLE `checkin_schedule` DISABLE KEYS */;
INSERT INTO `checkin_schedule` VALUES (2,1,1,'20:45:00',2,NULL),(3,1,2,'20:45:00',2,NULL),(4,1,3,'20:45:00',2,NULL),(5,1,4,'20:45:00',2,NULL),(6,1,5,'20:45:00',2,NULL),(7,1,6,'20:45:00',2,NULL),(8,1,7,'20:45:00',2,NULL),(9,2,4,'07:27:00',2,NULL),(10,2,4,'19:28:00',2,NULL),(11,2,5,'19:28:00',2,NULL),(12,2,4,'19:30:00',2,NULL),(13,2,5,'10:44:00',2,NULL),(14,2,5,'10:46:00',2,NULL);
/*!40000 ALTER TABLE `checkin_schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loved_ones`
--

DROP TABLE IF EXISTS `loved_ones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loved_ones` (
  `firstname` varchar(15) DEFAULT NULL,
  `lastname` varchar(30) DEFAULT NULL,
  `user_id` int unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(40) DEFAULT NULL,
  `password` varchar(40) DEFAULT NULL,
  `phonenumber` varchar(22) DEFAULT NULL,
  `related_member` int unsigned DEFAULT NULL,
  `primary_contact` tinyint(1) DEFAULT NULL,
  `relationship_id` int unsigned DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  KEY `related_member` (`related_member`),
  KEY `relationship_id` (`relationship_id`),
  CONSTRAINT `loved_ones_ibfk_1` FOREIGN KEY (`related_member`) REFERENCES `members` (`user_id`),
  CONSTRAINT `loved_ones_ibfk_2` FOREIGN KEY (`relationship_id`) REFERENCES `relationships` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loved_ones`
--

LOCK TABLES `loved_ones` WRITE;
/*!40000 ALTER TABLE `loved_ones` DISABLE KEYS */;
INSERT INTO `loved_ones` VALUES ('Harry','Styles',1,'hstyles@nd.edu','test','206-599-9161',1,0,2);
/*!40000 ALTER TABLE `loved_ones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_addresses`
--

DROP TABLE IF EXISTS `member_addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member_addresses` (
  `member_id` int unsigned DEFAULT NULL,
  `address_id` int unsigned DEFAULT NULL,
  KEY `member_id` (`member_id`),
  KEY `address_id` (`address_id`),
  CONSTRAINT `member_addresses_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `members` (`user_id`),
  CONSTRAINT `member_addresses_ibfk_2` FOREIGN KEY (`address_id`) REFERENCES `addresses` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_addresses`
--

LOCK TABLES `member_addresses` WRITE;
/*!40000 ALTER TABLE `member_addresses` DISABLE KEYS */;
INSERT INTO `member_addresses` VALUES (1,1);
/*!40000 ALTER TABLE `member_addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `members` (
  `firstname` varchar(15) DEFAULT NULL,
  `lastname` varchar(30) DEFAULT NULL,
  `user_id` int unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(40) DEFAULT NULL,
  `password` varchar(40) DEFAULT NULL,
  `phonenumber` varchar(22) DEFAULT NULL,
  `paymentplan` int unsigned DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
INSERT INTO `members` VALUES ('Emily','Colleran',1,'ecolleran5@icloud.com','b1c80e2fcb56e7b3e24bbbd1aaee08b8','206-599-9161',1),('Niall','Horan',2,'nhoran@nd.edu','c761cc3341c91238ba735b26874572a0','206-599-9161',1);
/*!40000 ALTER TABLE `members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `message_logs`
--

DROP TABLE IF EXISTS `message_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `message_logs` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `message_sid` varchar(34) DEFAULT NULL,
  `message_status` varchar(30) DEFAULT NULL,
  `timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `message_logs`
--

LOCK TABLES `message_logs` WRITE;
/*!40000 ALTER TABLE `message_logs` DISABLE KEYS */;
INSERT INTO `message_logs` VALUES (1,'SMac69fa9be2a9f89747d0cc568ec6390d','queued','2024-07-12 10:46:01'),(2,'SMac69fa9be2a9f89747d0cc568ec6390d','sent','2024-07-12 10:46:01'),(3,'SMac69fa9be2a9f89747d0cc568ec6390d','delivered','2024-07-12 10:46:02');
/*!40000 ALTER TABLE `message_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `relationships`
--

DROP TABLE IF EXISTS `relationships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `relationships` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `relationship_name` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `relationships`
--

LOCK TABLES `relationships` WRITE;
/*!40000 ALTER TABLE `relationships` DISABLE KEYS */;
INSERT INTO `relationships` VALUES (1,'daughter'),(2,'son');
/*!40000 ALTER TABLE `relationships` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-07-12 10:53:27
