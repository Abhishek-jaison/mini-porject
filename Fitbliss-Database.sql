-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: fitbliss
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

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

--
-- Table structure for table `exercises`
--

DROP TABLE IF EXISTS `exercises`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `exercises` (
  `exerciseID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `exerciseName` varchar(25) NOT NULL,
  `caloriesPerMin` int(10) NOT NULL,
  PRIMARY KEY (`exerciseID`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exercises`
--

LOCK TABLES `exercises` WRITE;
/*!40000 ALTER TABLE `exercises` DISABLE KEYS */;
INSERT INTO `exercises` VALUES (1,'Running',12),(2,'Stair climbing',7),(3,'Walking',4),(4,'Cycling',12),(5,'Swimming',7),(6,'Weight training',6),(7,'Aerobics',8),(8,'Gymnastics',6),(9,'Jump rope',15),(10,'Badminton',9),(11,'Basketball',9),(12,'Football',9),(13,'Tennis',9),(14,'Volleyball',12);
/*!40000 ALTER TABLE `exercises` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `histories`
--

DROP TABLE IF EXISTS `histories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `histories` (
  `historyID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(15) NOT NULL,
  `exerciseID` int(10) unsigned NOT NULL,
  `duration` int(10) unsigned NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`historyID`),
  KEY `exercise` (`exerciseID`),
  KEY `user` (`username`) USING BTREE,
  CONSTRAINT `exercise` FOREIGN KEY (`exerciseID`) REFERENCES `exercises` (`exerciseID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `username` FOREIGN KEY (`username`) REFERENCES `users` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=79 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `histories`
--

LOCK TABLES `histories` WRITE;
/*!40000 ALTER TABLE `histories` DISABLE KEYS */;
INSERT INTO `histories` VALUES (73,'abhishek',12,90,'2025-03-16'),(74,'abhishek',2,30,'2025-03-16'),(75,'abhishek',1,30,'2025-03-16'),(76,'abhishek',10,45,'2025-03-16'),(77,'abhishek',7,10,'2025-03-16'),(78,'abhishek',1,30,'2025-03-16');
/*!40000 ALTER TABLE `histories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `username` varchar(15) NOT NULL,
  `height` int(10) unsigned NOT NULL,
  `weight` int(10) unsigned NOT NULL,
  `birthYear` year(4) NOT NULL,
  `gender` enum('Male','Female') NOT NULL,
  `password` varchar(64) NOT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('abhishek',173,63,2004,'Male','F9A87A37970674A74265B45DEA7BA40DAD4038FD83768F349D698C7F15CCD917');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `diet_preferences`
--

DROP TABLE IF EXISTS `diet_preferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `diet_preferences` (
  `username` varchar(15) NOT NULL,
  `diet_type` enum('Vegetarian','Non-Vegetarian') NOT NULL,
  `goal` enum('Weight Loss','Weight Gain','Maintain') NOT NULL,
  PRIMARY KEY (`username`),
  CONSTRAINT `diet_pref_username` FOREIGN KEY (`username`) REFERENCES `users` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Table structure for table `diet_plans`
--

DROP TABLE IF EXISTS `diet_plans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `diet_plans` (
  `plan_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `diet_type` enum('Vegetarian','Non-Vegetarian') NOT NULL,
  `goal` enum('Weight Loss','Weight Gain','Maintain') NOT NULL,
  `meal_time` enum('Breakfast','Lunch','Dinner','Snack') NOT NULL,
  `food_items` text NOT NULL,
  `calories` int(10) NOT NULL,
  `protein` int(10) NOT NULL,
  `carbs` int(10) NOT NULL,
  `fats` int(10) NOT NULL,
  PRIMARY KEY (`plan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `diet_plans`
--

LOCK TABLES `diet_plans` WRITE;
/*!40000 ALTER TABLE `diet_plans` DISABLE KEYS */;
INSERT INTO `diet_plans` VALUES 
-- Weight Loss Plans (Vegetarian)
(1, 'Vegetarian', 'Weight Loss', 'Breakfast', 'Oatmeal with fruits, Almonds, Green tea', 300, 12, 45, 8),
(2, 'Vegetarian', 'Weight Loss', 'Lunch', 'Quinoa bowl with mixed vegetables, Lentil soup', 400, 20, 60, 10),
(3, 'Vegetarian', 'Weight Loss', 'Dinner', 'Mixed vegetable curry with brown rice, Tofu', 350, 15, 50, 9),
(4, 'Vegetarian', 'Weight Loss', 'Snack', 'Greek yogurt with berries, Chia seeds', 150, 8, 20, 5),

-- Weight Gain Plans (Vegetarian)
(5, 'Vegetarian', 'Weight Gain', 'Breakfast', 'Protein smoothie, Peanut butter sandwich, Banana', 600, 25, 80, 20),
(6, 'Vegetarian', 'Weight Gain', 'Lunch', 'Rice with mixed vegetable curry, Paneer, Chickpeas', 700, 30, 90, 25),
(7, 'Vegetarian', 'Weight Gain', 'Dinner', 'Vegetable pasta with cheese, Mixed nuts', 650, 28, 85, 22),
(8, 'Vegetarian', 'Weight Gain', 'Snack', 'Trail mix, Protein bar', 300, 15, 35, 12),

-- Weight Loss Plans (Non-Vegetarian)
(9, 'Non-Vegetarian', 'Weight Loss', 'Breakfast', 'Egg white omelette, Whole grain toast, Green tea', 300, 20, 35, 8),
(10, 'Non-Vegetarian', 'Weight Loss', 'Lunch', 'Grilled chicken salad, Quinoa', 400, 35, 40, 10),
(11, 'Non-Vegetarian', 'Weight Loss', 'Dinner', 'Baked fish with steamed vegetables', 350, 30, 30, 12),
(12, 'Non-Vegetarian', 'Weight Loss', 'Snack', 'Boiled eggs, Apple', 150, 12, 15, 6),

-- Weight Gain Plans (Non-Vegetarian)
(13, 'Non-Vegetarian', 'Weight Gain', 'Breakfast', 'Eggs, Chicken sausage, Oatmeal with nuts', 600, 40, 60, 25),
(14, 'Non-Vegetarian', 'Weight Gain', 'Lunch', 'Chicken breast with rice, Mixed vegetables', 700, 45, 75, 20),
(15, 'Non-Vegetarian', 'Weight Gain', 'Dinner', 'Salmon with sweet potato, Quinoa', 650, 42, 70, 22),
(16, 'Non-Vegetarian', 'Weight Gain', 'Snack', 'Protein shake, Mixed nuts', 300, 25, 25, 15);
/*!40000 ALTER TABLE `diet_plans` ENABLE KEYS */;
UNLOCK TABLES;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-03-16 11:31:58
