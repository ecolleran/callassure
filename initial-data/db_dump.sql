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
  `member_id` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `member_id` (`member_id`),
  CONSTRAINT `addresses_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `members` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addresses`
--

LOCK TABLES `addresses` WRITE;
/*!40000 ALTER TABLE `addresses` DISABLE KEYS */;
INSERT INTO `addresses` VALUES (1,'7842 NE 21st Street',NULL,'Medina','WA','98039','US',NULL);
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
  `timezone` varchar(30) DEFAULT NULL,
  `method_id` int NOT NULL,
  `curr_address` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `curr_address` (`curr_address`),
  KEY `member_id` (`member_id`),
  KEY `method_id` (`method_id`),
  CONSTRAINT `checkin_schedule_ibfk_1` FOREIGN KEY (`curr_address`) REFERENCES `addresses` (`id`),
  CONSTRAINT `checkin_schedule_ibfk_2` FOREIGN KEY (`member_id`) REFERENCES `members` (`user_id`),
  CONSTRAINT `checkin_schedule_ibfk_3` FOREIGN KEY (`method_id`) REFERENCES `checkin_methods` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `checkin_schedule`
--

LOCK TABLES `checkin_schedule` WRITE;
/*!40000 ALTER TABLE `checkin_schedule` DISABLE KEYS */;
INSERT INTO `checkin_schedule` VALUES (1,1,1,'15:59:00','America/Los_Angeles',2,NULL),(2,1,2,'15:59:00','America/Los_Angeles',2,NULL),(3,1,3,'15:59:00','America/Los_Angeles',2,NULL),(4,1,4,'15:59:00','America/Los_Angeles',2,NULL),(5,1,5,'15:59:00','America/Los_Angeles',2,NULL),(6,1,6,'15:59:00','America/Los_Angeles',2,NULL),(7,1,7,'15:59:00','America/Los_Angeles',2,NULL),(8,3,1,'16:00:00','America/Los_Angeles',2,NULL),(9,3,2,'16:00:00','America/Los_Angeles',2,NULL),(10,3,3,'16:00:00','America/Los_Angeles',2,NULL),(11,3,4,'16:00:00','America/Los_Angeles',2,NULL),(12,3,5,'16:00:00','America/Los_Angeles',2,NULL),(13,3,6,'16:00:00','America/Los_Angeles',2,NULL),(14,3,7,'16:00:00','America/Los_Angeles',2,NULL),(15,4,1,'16:00:00','America/Los_Angeles',2,NULL),(16,4,2,'16:00:00','America/Los_Angeles',2,NULL),(17,4,3,'16:00:00','America/Los_Angeles',2,NULL),(18,4,4,'16:00:00','America/Los_Angeles',2,NULL),(19,4,5,'16:00:00','America/Los_Angeles',2,NULL),(20,4,6,'16:00:00','America/Los_Angeles',2,NULL),(21,4,7,'16:00:00','America/Los_Angeles',2,NULL),(22,2,1,'16:00:00','America/Los_Angeles',2,NULL),(23,2,2,'16:00:00','America/Los_Angeles',2,NULL),(24,2,3,'16:00:00','America/Los_Angeles',2,NULL),(25,2,4,'16:00:00','America/Los_Angeles',2,NULL),(26,2,5,'16:00:00','America/Los_Angeles',2,NULL),(27,2,6,'16:00:00','America/Los_Angeles',2,NULL),(28,2,7,'16:00:00','America/Los_Angeles',2,NULL),(29,5,4,'22:20:00','America/Los_Angeles',2,NULL),(30,5,5,'15:54:00','America/Los_Angeles',2,NULL);
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
INSERT INTO `loved_ones` VALUES ('Emily','Colleran',1,'ecolleran5@icloud.com','Test','206-599-9161',1,1,1);
/*!40000 ALTER TABLE `loved_ones` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
INSERT INTO `members` VALUES ('Emily','Colleran',1,'ecolleran5@icloud.com','b1c80e2fcb56e7b3e24bbbd1aaee08b8','206-599-9161',1),('Joe','Colleran',2,'joseph.colleran@gmail.com','c99760932bf5a0ca161442215f582a3a','206-618-3566',1),('Kathleen','Colleran',3,'kcolleran@gmail.com','c988fa7c33ce43962b9803702b747a35','206-412-2127',1),('Bill','Colleran',4,'william.colleran@gmail.com','cb525f817e0092b3cf415aa813cc98be','206-390-7945',1),('Niall','Horan',5,'nhoran@nd.edu','ba59165b9042cccb62f2cd117ea829cc','206-599-9161',1);
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
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `message_logs`
--

LOCK TABLES `message_logs` WRITE;
/*!40000 ALTER TABLE `message_logs` DISABLE KEYS */;
INSERT INTO `message_logs` VALUES (1,'SM1234567890abcdef1234567890abcdef','delivered','2024-07-25 14:08:34'),(2,'SM88cf2dddbe796d15a42118c426051ace','sent','2024-07-25 15:20:01'),(3,'SM88cf2dddbe796d15a42118c426051ace','queued','2024-07-25 15:20:01'),(4,'SM88cf2dddbe796d15a42118c426051ace','delivered','2024-07-25 15:20:01'),(5,'SMe9a9db89044f6692e3e2da8ac1cbe3e9','queued','2024-07-25 15:24:45'),(6,'SMe9a9db89044f6692e3e2da8ac1cbe3e9','sent','2024-07-25 15:24:45'),(7,'SMe9a9db89044f6692e3e2da8ac1cbe3e9','delivered','2024-07-25 15:24:45'),(8,'SM5f7f8787fdf9463171b11f898e800a46','queued','2024-07-25 15:24:51'),(9,'SM5f7f8787fdf9463171b11f898e800a46','sent','2024-07-25 15:24:51'),(10,'SM5f7f8787fdf9463171b11f898e800a46','delivered','2024-07-25 15:24:52'),(11,'SMe73dcb5c712046e4205bf41fab6d04ce','queued','2024-07-25 15:24:55'),(12,'SMe73dcb5c712046e4205bf41fab6d04ce','sent','2024-07-25 15:24:55'),(13,'SMe73dcb5c712046e4205bf41fab6d04ce','delivered','2024-07-25 15:24:56'),(14,'SM8997d4aede1c7f164a044f2fc604fecc','queued','2024-07-25 15:30:43'),(15,'SM8997d4aede1c7f164a044f2fc604fecc','sent','2024-07-25 15:30:43'),(16,'SM8997d4aede1c7f164a044f2fc604fecc','delivered','2024-07-25 15:30:44'),(17,'SM32756fcf2a923723b8f191d2b276c201','queued','2024-07-26 08:54:01'),(18,'SM32756fcf2a923723b8f191d2b276c201','sent','2024-07-26 08:54:01'),(19,'SM32756fcf2a923723b8f191d2b276c201','delivered','2024-07-26 08:54:01'),(20,'SM6aa72fb360bad3fc99bdc7b16cd81139','queued','2024-07-26 08:54:15'),(21,'SM6aa72fb360bad3fc99bdc7b16cd81139','sent','2024-07-26 08:54:15'),(22,'SM6aa72fb360bad3fc99bdc7b16cd81139','delivered','2024-07-26 08:54:15'),(23,'SMef40741fb9d72132786d1ee5ed5c7b60','queued','2024-07-26 08:59:01'),(24,'SMef40741fb9d72132786d1ee5ed5c7b60','sent','2024-07-26 08:59:01'),(25,'SMef40741fb9d72132786d1ee5ed5c7b60','delivered','2024-07-26 08:59:02'),(26,'SMc18c11338549031df1c5836f2e2b4108','sent','2024-07-26 09:00:00'),(27,'SMc18c11338549031df1c5836f2e2b4108','queued','2024-07-26 09:00:00'),(28,'SMf5b95d90d7facdd15dbfcf563c1d6ed5','sent','2024-07-26 09:00:01'),(29,'SMf5b95d90d7facdd15dbfcf563c1d6ed5','queued','2024-07-26 09:00:01'),(30,'SMc18c11338549031df1c5836f2e2b4108','delivered','2024-07-26 09:00:01'),(31,'SMf5b95d90d7facdd15dbfcf563c1d6ed5','delivered','2024-07-26 09:00:01'),(32,'SM48032899c7b4833c490a812e0dc688e9','sent','2024-07-26 09:01:37'),(33,'SM48032899c7b4833c490a812e0dc688e9','queued','2024-07-26 09:01:37'),(34,'SM48032899c7b4833c490a812e0dc688e9','delivered','2024-07-26 09:01:40'),(35,'SM07629b929f6696320d83d6d6a7f0eda4','sent','2024-07-26 09:12:50'),(36,'SM07629b929f6696320d83d6d6a7f0eda4','queued','2024-07-26 09:12:50'),(37,'SM07629b929f6696320d83d6d6a7f0eda4','delivered','2024-07-26 09:12:51'),(38,'SMad7649e532cd6d0dc24d9ff9045959f2','queued','2024-07-26 09:14:15'),(39,'SMad7649e532cd6d0dc24d9ff9045959f2','sent','2024-07-26 09:14:15'),(40,'SMad7649e532cd6d0dc24d9ff9045959f2','delivered','2024-07-26 09:14:16'),(41,'SM3a77c6e66050e96961d6bdc937927dcc','sent','2024-07-26 09:14:29'),(42,'SM3a77c6e66050e96961d6bdc937927dcc','queued','2024-07-26 09:14:29'),(43,'SM3a77c6e66050e96961d6bdc937927dcc','delivered','2024-07-26 09:14:29'),(44,'SM47647be4383601451d0bdcebe471238f','queued','2024-07-26 10:16:53'),(45,'SM47647be4383601451d0bdcebe471238f','sent','2024-07-26 10:16:53'),(46,'SM47647be4383601451d0bdcebe471238f','delivered','2024-07-26 10:16:54');
/*!40000 ALTER TABLE `message_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phone_scripts`
--

DROP TABLE IF EXISTS `phone_scripts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_scripts` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `message_body` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phone_scripts`
--

LOCK TABLES `phone_scripts` WRITE;
/*!40000 ALTER TABLE `phone_scripts` DISABLE KEYS */;
INSERT INTO `phone_scripts` VALUES (1,'This is a test message for the phone script.');
/*!40000 ALTER TABLE `phone_scripts` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `relationships`
--

LOCK TABLES `relationships` WRITE;
/*!40000 ALTER TABLE `relationships` DISABLE KEYS */;
INSERT INTO `relationships` VALUES (1,'Family');
/*!40000 ALTER TABLE `relationships` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `text_messages`
--

DROP TABLE IF EXISTS `text_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `text_messages` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `message_body` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `text_messages`
--

LOCK TABLES `text_messages` WRITE;
/*!40000 ALTER TABLE `text_messages` DISABLE KEYS */;
INSERT INTO `text_messages` VALUES (1,'This is a test message for texts.');
/*!40000 ALTER TABLE `text_messages` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-07-26 10:20:44
