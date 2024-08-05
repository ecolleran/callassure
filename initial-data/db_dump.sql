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
  `utc_deadline` time NOT NULL,
  `original_timezone` varchar(30) DEFAULT NULL,
  `method_id` int NOT NULL,
  `curr_address` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `curr_address` (`curr_address`),
  KEY `member_id` (`member_id`),
  KEY `method_id` (`method_id`),
  CONSTRAINT `checkin_schedule_ibfk_1` FOREIGN KEY (`curr_address`) REFERENCES `addresses` (`id`),
  CONSTRAINT `checkin_schedule_ibfk_2` FOREIGN KEY (`member_id`) REFERENCES `members` (`user_id`),
  CONSTRAINT `checkin_schedule_ibfk_3` FOREIGN KEY (`method_id`) REFERENCES `checkin_methods` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `checkin_schedule`
--

LOCK TABLES `checkin_schedule` WRITE;
/*!40000 ALTER TABLE `checkin_schedule` DISABLE KEYS */;
INSERT INTO `checkin_schedule` VALUES (1,1,1,'15:59:00','America/Los_Angeles',2,NULL),(2,1,2,'15:59:00','America/Los_Angeles',2,NULL),(3,1,3,'15:59:00','America/Los_Angeles',2,NULL),(4,1,4,'15:59:00','America/Los_Angeles',2,NULL),(5,1,5,'15:59:00','America/Los_Angeles',2,NULL),(6,1,6,'15:59:00','America/Los_Angeles',2,NULL),(7,1,7,'15:59:00','America/Los_Angeles',2,NULL),(8,3,1,'16:00:00','America/Los_Angeles',2,NULL),(9,3,2,'16:00:00','America/Los_Angeles',2,NULL),(10,3,3,'16:00:00','America/Los_Angeles',2,NULL),(11,3,4,'16:00:00','America/Los_Angeles',2,NULL),(12,3,5,'16:00:00','America/Los_Angeles',2,NULL),(13,3,6,'16:05:00','America/Los_Angeles',2,NULL),(14,3,7,'16:05:00','America/Los_Angeles',2,NULL),(15,4,1,'16:00:00','America/Los_Angeles',2,NULL),(16,4,2,'16:00:00','America/Los_Angeles',2,NULL),(17,4,3,'16:00:00','America/Los_Angeles',2,NULL),(18,4,4,'16:00:00','America/Los_Angeles',2,NULL),(19,4,5,'16:00:00','America/Los_Angeles',2,NULL),(20,4,6,'16:05:00','America/Los_Angeles',2,NULL),(21,4,7,'16:05:00','America/Los_Angeles',2,NULL),(22,2,1,'16:00:00','America/Los_Angeles',2,NULL),(23,2,2,'16:00:00','America/Los_Angeles',2,NULL),(24,2,3,'16:00:00','America/Los_Angeles',2,NULL),(25,2,4,'16:00:00','America/Los_Angeles',2,NULL),(26,2,5,'16:00:00','America/Los_Angeles',2,NULL),(27,2,6,'16:05:00','America/Los_Angeles',2,NULL),(28,2,7,'16:05:00','America/Los_Angeles',2,NULL),(40,6,3,'15:52:00','America/Los_Angeles',2,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
INSERT INTO `members` VALUES ('Emily','Colleran',1,'ecolleran5@icloud.com','b1c80e2fcb56e7b3e24bbbd1aaee08b8','206-599-9161',1),('Joe','Colleran',2,'joseph.colleran@gmail.com','c99760932bf5a0ca161442215f582a3a','206-618-3566',1),('Kathleen','Colleran',3,'kcolleran@gmail.com','c988fa7c33ce43962b9803702b747a35','206-412-2127',1),('Bill','Colleran',4,'william.colleran@gmail.com','cb525f817e0092b3cf415aa813cc98be','206-390-7945',1),('Niall','Horan',5,'nhoran@nd.edu','ba59165b9042cccb62f2cd117ea829cc','206-599-9161',1),('Harry','Styles',6,'hstyles@nd.edu','9aa80c57478c55b3bcb34290d248d364','206-599-9161',1);
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
  `to` varchar(22) DEFAULT NULL,
  `from` varchar(22) DEFAULT NULL,
  `body` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `message_logs`
--

LOCK TABLES `message_logs` WRITE;
/*!40000 ALTER TABLE `message_logs` DISABLE KEYS */;
INSERT INTO `message_logs` VALUES (1,'SM1234567890abcdef1234567890abcdef','delivered','2024-07-25 14:08:34',NULL,NULL,NULL),(2,'SM88cf2dddbe796d15a42118c426051ace','sent','2024-07-25 15:20:01',NULL,NULL,NULL),(3,'SM88cf2dddbe796d15a42118c426051ace','queued','2024-07-25 15:20:01',NULL,NULL,NULL),(4,'SM88cf2dddbe796d15a42118c426051ace','delivered','2024-07-25 15:20:01',NULL,NULL,NULL),(5,'SMe9a9db89044f6692e3e2da8ac1cbe3e9','queued','2024-07-25 15:24:45',NULL,NULL,NULL),(6,'SMe9a9db89044f6692e3e2da8ac1cbe3e9','sent','2024-07-25 15:24:45',NULL,NULL,NULL),(7,'SMe9a9db89044f6692e3e2da8ac1cbe3e9','delivered','2024-07-25 15:24:45',NULL,NULL,NULL),(8,'SM5f7f8787fdf9463171b11f898e800a46','queued','2024-07-25 15:24:51',NULL,NULL,NULL),(9,'SM5f7f8787fdf9463171b11f898e800a46','sent','2024-07-25 15:24:51',NULL,NULL,NULL),(10,'SM5f7f8787fdf9463171b11f898e800a46','delivered','2024-07-25 15:24:52',NULL,NULL,NULL),(11,'SMe73dcb5c712046e4205bf41fab6d04ce','queued','2024-07-25 15:24:55',NULL,NULL,NULL),(12,'SMe73dcb5c712046e4205bf41fab6d04ce','sent','2024-07-25 15:24:55',NULL,NULL,NULL),(13,'SMe73dcb5c712046e4205bf41fab6d04ce','delivered','2024-07-25 15:24:56',NULL,NULL,NULL),(14,'SM8997d4aede1c7f164a044f2fc604fecc','queued','2024-07-25 15:30:43',NULL,NULL,NULL),(15,'SM8997d4aede1c7f164a044f2fc604fecc','sent','2024-07-25 15:30:43',NULL,NULL,NULL),(16,'SM8997d4aede1c7f164a044f2fc604fecc','delivered','2024-07-25 15:30:44',NULL,NULL,NULL),(17,'SM32756fcf2a923723b8f191d2b276c201','queued','2024-07-26 08:54:01',NULL,NULL,NULL),(18,'SM32756fcf2a923723b8f191d2b276c201','sent','2024-07-26 08:54:01',NULL,NULL,NULL),(19,'SM32756fcf2a923723b8f191d2b276c201','delivered','2024-07-26 08:54:01',NULL,NULL,NULL),(20,'SM6aa72fb360bad3fc99bdc7b16cd81139','queued','2024-07-26 08:54:15',NULL,NULL,NULL),(21,'SM6aa72fb360bad3fc99bdc7b16cd81139','sent','2024-07-26 08:54:15',NULL,NULL,NULL),(22,'SM6aa72fb360bad3fc99bdc7b16cd81139','delivered','2024-07-26 08:54:15',NULL,NULL,NULL),(23,'SMef40741fb9d72132786d1ee5ed5c7b60','queued','2024-07-26 08:59:01',NULL,NULL,NULL),(24,'SMef40741fb9d72132786d1ee5ed5c7b60','sent','2024-07-26 08:59:01',NULL,NULL,NULL),(25,'SMef40741fb9d72132786d1ee5ed5c7b60','delivered','2024-07-26 08:59:02',NULL,NULL,NULL),(26,'SMc18c11338549031df1c5836f2e2b4108','sent','2024-07-26 09:00:00',NULL,NULL,NULL),(27,'SMc18c11338549031df1c5836f2e2b4108','queued','2024-07-26 09:00:00',NULL,NULL,NULL),(28,'SMf5b95d90d7facdd15dbfcf563c1d6ed5','sent','2024-07-26 09:00:01',NULL,NULL,NULL),(29,'SMf5b95d90d7facdd15dbfcf563c1d6ed5','queued','2024-07-26 09:00:01',NULL,NULL,NULL),(30,'SMc18c11338549031df1c5836f2e2b4108','delivered','2024-07-26 09:00:01',NULL,NULL,NULL),(31,'SMf5b95d90d7facdd15dbfcf563c1d6ed5','delivered','2024-07-26 09:00:01',NULL,NULL,NULL),(32,'SM48032899c7b4833c490a812e0dc688e9','sent','2024-07-26 09:01:37',NULL,NULL,NULL),(33,'SM48032899c7b4833c490a812e0dc688e9','queued','2024-07-26 09:01:37',NULL,NULL,NULL),(34,'SM48032899c7b4833c490a812e0dc688e9','delivered','2024-07-26 09:01:40',NULL,NULL,NULL),(35,'SM07629b929f6696320d83d6d6a7f0eda4','sent','2024-07-26 09:12:50',NULL,NULL,NULL),(36,'SM07629b929f6696320d83d6d6a7f0eda4','queued','2024-07-26 09:12:50',NULL,NULL,NULL),(37,'SM07629b929f6696320d83d6d6a7f0eda4','delivered','2024-07-26 09:12:51',NULL,NULL,NULL),(38,'SMad7649e532cd6d0dc24d9ff9045959f2','queued','2024-07-26 09:14:15',NULL,NULL,NULL),(39,'SMad7649e532cd6d0dc24d9ff9045959f2','sent','2024-07-26 09:14:15',NULL,NULL,NULL),(40,'SMad7649e532cd6d0dc24d9ff9045959f2','delivered','2024-07-26 09:14:16',NULL,NULL,NULL),(41,'SM3a77c6e66050e96961d6bdc937927dcc','sent','2024-07-26 09:14:29',NULL,NULL,NULL),(42,'SM3a77c6e66050e96961d6bdc937927dcc','queued','2024-07-26 09:14:29',NULL,NULL,NULL),(43,'SM3a77c6e66050e96961d6bdc937927dcc','delivered','2024-07-26 09:14:29',NULL,NULL,NULL),(44,'SM47647be4383601451d0bdcebe471238f','queued','2024-07-26 10:16:53',NULL,NULL,NULL),(45,'SM47647be4383601451d0bdcebe471238f','sent','2024-07-26 10:16:53',NULL,NULL,NULL),(46,'SM47647be4383601451d0bdcebe471238f','delivered','2024-07-26 10:16:54',NULL,NULL,NULL),(47,'SM3da079aec0c177adcb7ad878d62b19f7','queued','2024-07-26 14:59:01',NULL,NULL,NULL),(48,'SM3da079aec0c177adcb7ad878d62b19f7','sent','2024-07-26 14:59:01',NULL,NULL,NULL),(49,'SM3da079aec0c177adcb7ad878d62b19f7','delivered','2024-07-26 14:59:02',NULL,NULL,NULL),(50,'SM4e6e1c9542574cbbfc16576e9cf96b2d','queued','2024-07-27 09:05:01',NULL,NULL,NULL),(51,'SM4e6e1c9542574cbbfc16576e9cf96b2d','sent','2024-07-27 09:05:01',NULL,NULL,NULL),(52,'SM4e6e1c9542574cbbfc16576e9cf96b2d','delivered','2024-07-27 09:05:02',NULL,NULL,NULL),(53,'SMa3de8aa2f840aa5e912084e4ce526be8','queued','2024-07-27 09:06:00',NULL,NULL,NULL),(54,'SMa3de8aa2f840aa5e912084e4ce526be8','sent','2024-07-27 09:06:00',NULL,NULL,NULL),(55,'SM3548bda48e180e72210d0189f1c88d24','queued','2024-07-27 09:06:01',NULL,NULL,NULL),(56,'SM3548bda48e180e72210d0189f1c88d24','sent','2024-07-27 09:06:01',NULL,NULL,NULL),(57,'SMa3de8aa2f840aa5e912084e4ce526be8','delivered','2024-07-27 09:06:01',NULL,NULL,NULL),(58,'SM3548bda48e180e72210d0189f1c88d24','delivered','2024-07-27 09:06:01',NULL,NULL,NULL),(59,'SM9aa8ad4736664a187dce481f08b6d1a1','queued','2024-07-27 09:15:55',NULL,NULL,NULL),(60,'SM9aa8ad4736664a187dce481f08b6d1a1','sent','2024-07-27 09:15:55',NULL,NULL,NULL),(61,'SM9aa8ad4736664a187dce481f08b6d1a1','delivered','2024-07-27 09:15:55',NULL,NULL,NULL),(62,'SM4f6ca64ebd5b203cf4f217a790a81be1','queued','2024-07-28 09:04:01',NULL,NULL,NULL),(63,'SM4f6ca64ebd5b203cf4f217a790a81be1','sent','2024-07-28 09:04:01',NULL,NULL,NULL),(64,'SM4f6ca64ebd5b203cf4f217a790a81be1','delivered','2024-07-28 09:04:01',NULL,NULL,NULL),(65,'SMd75118a610b038dcc420f0a0e6b749a1','queued','2024-07-28 09:05:00',NULL,NULL,NULL),(66,'SMd75118a610b038dcc420f0a0e6b749a1','sent','2024-07-28 09:05:00',NULL,NULL,NULL),(67,'SMdeb2b9a439fb23b2b232f7b9c9b2e77c','queued','2024-07-28 09:05:01',NULL,NULL,NULL),(68,'SMdeb2b9a439fb23b2b232f7b9c9b2e77c','sent','2024-07-28 09:05:01',NULL,NULL,NULL),(69,'SMd75118a610b038dcc420f0a0e6b749a1','delivered','2024-07-28 09:05:01',NULL,NULL,NULL),(70,'SMdeb2b9a439fb23b2b232f7b9c9b2e77c','delivered','2024-07-28 09:05:01',NULL,NULL,NULL),(71,'SM95a7c47b5507cb129177fd677752db3f','queued','2024-07-28 09:05:02',NULL,NULL,NULL),(72,'SM95a7c47b5507cb129177fd677752db3f','sent','2024-07-28 09:05:02',NULL,NULL,NULL),(73,'SM95a7c47b5507cb129177fd677752db3f','delivered','2024-07-28 09:05:02',NULL,NULL,NULL),(74,'SM2b93fa7aa5d9497c6cd2980c7467273d','sent','2024-07-28 09:05:51',NULL,NULL,NULL),(75,'SM2b93fa7aa5d9497c6cd2980c7467273d','queued','2024-07-28 09:05:51',NULL,NULL,NULL),(76,'SM2b93fa7aa5d9497c6cd2980c7467273d','delivered','2024-07-28 09:05:51',NULL,NULL,NULL),(77,'SM776ccb30aa79838e3e5fe6c455ff906a','queued','2024-07-29 11:30:01',NULL,NULL,NULL),(78,'SM776ccb30aa79838e3e5fe6c455ff906a','sent','2024-07-29 11:30:01',NULL,NULL,NULL),(79,'SM776ccb30aa79838e3e5fe6c455ff906a','delivered','2024-07-29 11:30:03',NULL,NULL,NULL),(80,'SM8bcaa3fbc025e02f5f72246f11e1e8ee','queued','2024-08-01 08:59:01',NULL,NULL,NULL),(81,'SM8bcaa3fbc025e02f5f72246f11e1e8ee','sent','2024-08-01 08:59:01',NULL,NULL,NULL),(82,'SM8bcaa3fbc025e02f5f72246f11e1e8ee','delivered','2024-08-01 08:59:02',NULL,NULL,NULL),(83,'SMf5d65da588badd17cc40c31225eca02e','queued','2024-08-01 09:00:00',NULL,NULL,NULL),(84,'SMf5d65da588badd17cc40c31225eca02e','sent','2024-08-01 09:00:00',NULL,NULL,NULL),(85,'SMc1dfcf1fdb647f868bd35cd6522eb411','sent','2024-08-01 09:00:01',NULL,NULL,NULL),(86,'SMc1dfcf1fdb647f868bd35cd6522eb411','queued','2024-08-01 09:00:01',NULL,NULL,NULL),(87,'SM69d11c999df4da0f94f1d9d6aa01ab85','sent','2024-08-01 09:00:01',NULL,NULL,NULL),(88,'SMf5d65da588badd17cc40c31225eca02e','delivered','2024-08-01 09:00:01',NULL,NULL,NULL),(89,'SM69d11c999df4da0f94f1d9d6aa01ab85','queued','2024-08-01 09:00:02',NULL,NULL,NULL),(90,'SMc1dfcf1fdb647f868bd35cd6522eb411','delivered','2024-08-01 09:00:02',NULL,NULL,NULL),(91,'SM69d11c999df4da0f94f1d9d6aa01ab85','delivered','2024-08-01 09:00:02',NULL,NULL,NULL),(92,'SM89b135a4c596e9b9b94c89fcbfdcc42a','queued','2024-08-01 09:18:35',NULL,NULL,NULL),(93,'SM89b135a4c596e9b9b94c89fcbfdcc42a','sent','2024-08-01 09:18:35',NULL,NULL,NULL),(94,'SM89b135a4c596e9b9b94c89fcbfdcc42a','delivered','2024-08-01 09:18:36',NULL,NULL,NULL),(95,'SM1f4bff6d52e93faacdab5e285672fe4d','sent','2024-08-01 16:21:53','2065999161','4252509408',''),(96,'SM1f4bff6d52e93faacdab5e285672fe4d','delivered','2024-08-01 16:21:54','2065999161','4252509408',''),(97,'SM107635130c25e2b330f01004e6c61384','sent','2024-08-01 16:24:45','2065999161','4252509408',''),(98,'SM107635130c25e2b330f01004e6c61384','delivered','2024-08-01 16:24:45','2065999161','4252509408',''),(99,'SM0057a4ac9cca97aa5507ca7bfe556eec','delivered','2024-08-01 16:25:13','2065999161','4252509408',''),(100,'SMf9af029d7f9ad63551f62f41ee3ecb24','delivered','2024-08-02 08:59:02','2065999161','4252509408',''),(101,'SM65ff19274cff97d72967b5f92cca8fde','delivered','2024-08-02 09:00:01','2066183566','4252509408',''),(102,'SM8ec39d1a7c21b5750478bbe21d33c86c','delivered','2024-08-02 09:00:01','2063907945','4252509408',''),(103,'SM4b2c60f99134d7f2a36ae7fa7d4cd025','delivered','2024-08-02 09:00:02','2064122127','4252509408',''),(104,'SMb0d33bcd3384d9f9189c2cdf1678f7d5','delivered','2024-08-02 11:13:40','2064122127','4252509408','');
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

-- Dump completed on 2024-08-05  8:25:50
