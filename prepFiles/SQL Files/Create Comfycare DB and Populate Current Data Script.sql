CREATE DATABASE  IF NOT EXISTS `comfycare` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `comfycare`;
-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: comfycare
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `emergency_contacts`
--

DROP TABLE IF EXISTS `emergency_contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `emergency_contacts` (
  `contact_id` int(11) NOT NULL AUTO_INCREMENT,
  `patient_id` char(36) NOT NULL,
  `contact_name` varchar(100) NOT NULL,
  `relationship` varchar(60) DEFAULT NULL,
  `primary_phone` varchar(25) DEFAULT NULL,
  `work_phone` varchar(25) DEFAULT NULL,
  `mobile_phone` varchar(25) DEFAULT NULL,
  `email` varchar(120) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `is_primary_contact` tinyint(1) DEFAULT 0,
  `has_key_access` tinyint(1) DEFAULT 0,
  `availability_notes` text DEFAULT NULL,
  `emergency_notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`contact_id`),
  KEY `patient_id` (`patient_id`),
  CONSTRAINT `emergency_contacts_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients_index` (`patient_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emergency_contacts`
--

LOCK TABLES `emergency_contacts` WRITE;
/*!40000 ALTER TABLE `emergency_contacts` DISABLE KEYS */;
INSERT INTO `emergency_contacts` VALUES (1,'15d823ab-82c3-11f0-a3a1-06ce1f34132b','Michael Doe','Spouse','555-7890','555-1111','555-2222','michael.doe@example.com','123 Maple St, Springfield',1,1,'Available evenings and weekends','Can authorize treatments','2025-09-08 01:48:34','2025-09-08 01:48:34'),(2,'15d823ab-82c3-11f0-a3a1-06ce1f34132b','Anna Smith','Sister','555-3333',NULL,'555-4444','anna.smith@example.com','456 Oak Ave, Springfield',0,0,'Daytime only','Prefers text communication','2025-09-08 01:48:34','2025-09-08 01:48:34'),(3,'15d84201-82c3-11f0-a3a1-06ce1f34132b','Sarah Smith','Daughter','555-5555',NULL,'555-6666','sarah.smith@example.com','789 Pine Rd, Springfield',1,0,'Available most afternoons','Lives 10 minutes away','2025-09-08 01:49:14','2025-09-08 01:49:14'),(4,'15d84201-82c3-11f0-a3a1-06ce1f34132b','Robert Johnson','Friend','555-7777','555-8888',NULL,'rjohnson@example.com','101 Elm St, Springfield',0,0,'Evenings only','Trusted neighbor for emergencies','2025-09-08 01:49:14','2025-09-08 01:49:14'),(7,'08b13d21-8f68-11f0-8afe-06ce1f34132b','Jodie Smith','Daughter','555-5555',NULL,'555-6666','sarah.smith@example.com','789 Pine Rd, Springfield',1,0,'Available most afternoons','Lives 10 minutes away','2025-09-11 23:35:43','2025-09-11 23:35:43'),(8,'a2d4a806-9038-11f0-b390-06ce1f34132b','Michael Thompson','Son','555-7722','555-8833','555-9944','mike.thompson@example.com','567 Oak Street, Same City',1,1,'Works 9-5 weekdays','Call mobile first','2025-09-13 00:28:57','2025-09-13 00:28:57');
/*!40000 ALTER TABLE `emergency_contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees` (
  `employee_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `license_no` varchar(50) DEFAULT NULL,
  `npi` varchar(20) DEFAULT NULL,
  `role_note` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`employee_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `employees_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees`
--

LOCK TABLES `employees` WRITE;
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `insurance_policy`
--

DROP TABLE IF EXISTS `insurance_policy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `insurance_policy` (
  `policy_id` int(11) NOT NULL AUTO_INCREMENT,
  `patient_id` char(36) NOT NULL,
  `insurance_pay_order` enum('primary','secondary') NOT NULL,
  `insurance_company` varchar(120) NOT NULL,
  `policy_number` varchar(80) NOT NULL,
  `group_number` varchar(80) DEFAULT NULL,
  `policy_holder` varchar(120) DEFAULT NULL,
  `effective_date` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`policy_id`),
  KEY `patient_id` (`patient_id`),
  CONSTRAINT `insurance_policy_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients_index` (`patient_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `insurance_policy`
--

LOCK TABLES `insurance_policy` WRITE;
/*!40000 ALTER TABLE `insurance_policy` DISABLE KEYS */;
INSERT INTO `insurance_policy` VALUES (1,'15d823ab-82c3-11f0-a3a1-06ce1f34132b','primary','Blue Shield','BS-12345','G-9001','Jane Doe','2024-01-01','2025-09-03 03:49:02'),(2,'15d823ab-82c3-11f0-a3a1-06ce1f34132b','secondary','—','—',NULL,NULL,NULL,'2025-09-03 03:49:02'),(3,'15d84201-82c3-11f0-a3a1-06ce1f34132b','primary','Aetna','AE-77777','G-4210','John Smith','2023-10-01','2025-09-03 03:49:02'),(8,'08b13d21-8f68-11f0-8afe-06ce1f34132b','primary','BlueShield','BS-12345','G-789','Richard Jones','2024-01-01','2025-09-11 23:35:43'),(9,'08b13d21-8f68-11f0-8afe-06ce1f34132b','secondary','Medicare','MC-55555',NULL,'Alice Jones','2024-06-01','2025-09-11 23:35:43'),(10,'a2d4a806-9038-11f0-b390-06ce1f34132b','primary','United Healthcare','UH-98765','G-444','Harold Thompson','2023-01-01','2025-09-13 00:28:57'),(11,'a2d4a806-9038-11f0-b390-06ce1f34132b','secondary','VA Benefits','VA-11111',NULL,'Harold Thompson','1970-06-01','2025-09-13 00:28:57');
/*!40000 ALTER TABLE `insurance_policy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medication`
--

DROP TABLE IF EXISTS `medication`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medication` (
  `med_id` int(11) NOT NULL AUTO_INCREMENT,
  `patient_id` char(36) NOT NULL,
  `name` varchar(120) NOT NULL,
  `dosage` varchar(60) DEFAULT NULL,
  `frequency` varchar(60) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`med_id`),
  KEY `idx_meds_patient` (`patient_id`),
  CONSTRAINT `fk_meds_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients_index` (`patient_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medication`
--

LOCK TABLES `medication` WRITE;
/*!40000 ALTER TABLE `medication` DISABLE KEYS */;
INSERT INTO `medication` VALUES (5,'15d823ab-82c3-11f0-a3a1-06ce1f34132b','Metformin','1000mg','twice daily','2025-08-31 01:12:24'),(6,'15d823ab-82c3-11f0-a3a1-06ce1f34132b','Lisinopril','10mg','once daily','2025-08-31 01:12:24'),(7,'15d823ab-82c3-11f0-a3a1-06ce1f34132b','Methotrexate','15mg','Twice weekly','2025-08-31 01:12:24'),(8,'15d84201-82c3-11f0-a3a1-06ce1f34132b','Prednisone','5mg','once daily','2025-08-31 01:12:24'),(9,'15d84201-82c3-11f0-a3a1-06ce1f34132b','Folic Acid','5mg','once daily','2025-08-31 01:12:24'),(10,'15d84201-82c3-11f0-a3a1-06ce1f34132b','Atorvastatin','5mg','once daily','2025-08-31 01:12:24'),(15,'08b13d21-8f68-11f0-8afe-06ce1f34132b','Lisinopril','10mg','Once daily','2025-09-11 23:35:43'),(16,'08b13d21-8f68-11f0-8afe-06ce1f34132b','Omeprazole','20mg','Once daily','2025-09-11 23:35:43'),(17,'a2d4a806-9038-11f0-b390-06ce1f34132b','Metformin','1000mg','Twice daily','2025-09-13 00:28:57'),(18,'a2d4a806-9038-11f0-b390-06ce1f34132b','Gabapentin','300mg','Three times daily','2025-09-13 00:28:57');
/*!40000 ALTER TABLE `medication` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nurse`
--

DROP TABLE IF EXISTS `nurse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nurse` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nurse`
--

LOCK TABLES `nurse` WRITE;
/*!40000 ALTER TABLE `nurse` DISABLE KEYS */;
INSERT INTO `nurse` VALUES (1,'Alice Johnson','alice@comfycouchcare.com','fakehash1','2025-08-21 02:48:14'),(2,'Bob Smith','bob@comfycouchcare.com','fakehash2','2025-08-21 02:48:14'),(3,'Sarah Martinez','sarah@comfycouchcare.com','fakehash3','2025-08-26 21:41:58');
/*!40000 ALTER TABLE `nurse` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patient_notes`
--

DROP TABLE IF EXISTS `patient_notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient_notes` (
  `note_id` int(11) NOT NULL AUTO_INCREMENT,
  `patient_id` char(36) NOT NULL,
  `note_text` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_by` varchar(100) DEFAULT NULL,
  `created_by_user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`note_id`),
  KEY `patient_id` (`patient_id`),
  CONSTRAINT `patient_notes_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients_index` (`patient_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient_notes`
--

LOCK TABLES `patient_notes` WRITE;
/*!40000 ALTER TABLE `patient_notes` DISABLE KEYS */;
INSERT INTO `patient_notes` VALUES (1,'15d823ab-82c3-11f0-a3a1-06ce1f34132b','Patient prefers mornings; keep sodium low.','2025-09-04 01:53:45',NULL,NULL),(4,'08b13d21-8f68-11f0-8afe-06ce1f34132b','Testing patient note creation.','2025-09-11 23:35:43','Sarah Martinez',NULL),(5,'a2d4a806-9038-11f0-b390-06ce1f34132b','Patient prefers morning appointments. Veterans discount applied.','2025-09-13 00:28:57','Maria Rodriguez',NULL);
/*!40000 ALTER TABLE `patient_notes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patients_index`
--

DROP TABLE IF EXISTS `patients_index`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patients_index` (
  `patient_id` char(36) NOT NULL,
  `display_name` varchar(120) NOT NULL,
  `date_joined` date DEFAULT curdate(),
  `patient_form_id` varchar(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`patient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patients_index`
--

LOCK TABLES `patients_index` WRITE;
/*!40000 ALTER TABLE `patients_index` DISABLE KEYS */;
INSERT INTO `patients_index` VALUES ('08b13d21-8f68-11f0-8afe-06ce1f34132b','Alice Jones','2023-07-26','CCCP-3','2025-09-11 23:35:43'),('15d823ab-82c3-11f0-a3a1-06ce1f34132b','Jane Doe','2025-08-26','CCCP-1',NULL),('15d84201-82c3-11f0-a3a1-06ce1f34132b','John Smith','2025-08-26','CCCP-2',NULL),('a2d4a806-9038-11f0-b390-06ce1f34132b','Harold Thompson','2024-02-14','CCCP-4','2025-09-13 00:28:57');
/*!40000 ALTER TABLE `patients_index` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patients_phi`
--

DROP TABLE IF EXISTS `patients_phi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patients_phi` (
  `patient_id` char(36) NOT NULL,
  `legal_name` varchar(120) NOT NULL,
  `dob` date DEFAULT NULL,
  `gender` enum('Female','Male','Nonbinary','Other') DEFAULT NULL,
  `marital_status` enum('Single','Married','Divorced','Widowed','Other') DEFAULT NULL,
  `primary_language` varchar(80) DEFAULT NULL,
  `ssn_enc` varchar(64) DEFAULT NULL,
  `sex` varchar(20) DEFAULT NULL,
  `phone` varchar(25) DEFAULT NULL,
  `email` varchar(120) DEFAULT NULL,
  `preferred_contact` enum('Home phone','email','Mobile Phone') DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `address_instructions` text DEFAULT NULL,
  `insurance_plan_name` varchar(120) DEFAULT NULL,
  `insurance_member_id_enc` varchar(255) DEFAULT NULL,
  `care_type` varchar(100) DEFAULT NULL,
  `primary_diagnosis` varchar(255) DEFAULT NULL,
  `allergies` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`patient_id`),
  CONSTRAINT `patients_phi_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients_index` (`patient_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patients_phi`
--

LOCK TABLES `patients_phi` WRITE;
/*!40000 ALTER TABLE `patients_phi` DISABLE KEYS */;
INSERT INTO `patients_phi` VALUES ('08b13d21-8f68-11f0-8afe-06ce1f34132b','Alice Jones','1950-03-15','Female','Married','English','***-**-1234',NULL,'555-555-9011','Alice.Jones@example.com','Mobile Phone','789 Birch Rd','Gate code #2271. Small dog at home.',NULL,NULL,'Infusion','Rheumatoid arthritis','Penicillin; Sulfa'),('15d823ab-82c3-11f0-a3a1-06ce1f34132b','Jane Doe','1980-04-12','Female','Married','English','***-**-1234',NULL,'555-1234','jane.doe.example@gmail.com','email','123 Maple St',NULL,NULL,NULL,'Infusion','Right knee replacement',NULL),('15d84201-82c3-11f0-a3a1-06ce1f34132b','John Smith','1975-09-30','Male','Married','English','***-**-9876',NULL,'555-5678',NULL,NULL,'456 Oak Ave',NULL,NULL,NULL,'Post-Op','Diabetes',NULL),('a2d4a806-9038-11f0-b390-06ce1f34132b','Harold Eugene Thompson','1945-09-22','Male','Widowed','English','***-**-7821',NULL,'555-555-3847','h.thompson1945@example.com','Home phone','423 Maple Avenue','Blue house with ramp. Ring doorbell twice.',NULL,NULL,'Wound Care','Type 2 Diabetes with peripheral neuropathy','None known');
/*!40000 ALTER TABLE `patients_phi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `role_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_roles`
--

DROP TABLE IF EXISTS `user_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_roles` (
  `user_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `user_roles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `user_roles_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_roles`
--

LOCK TABLES `user_roles` WRITE;
/*!40000 ALTER TABLE `user_roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(120) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `visit`
--

DROP TABLE IF EXISTS `visit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visit` (
  `visit_id` int(11) NOT NULL AUTO_INCREMENT,
  `patient_id` char(36) NOT NULL,
  `nurse_id` int(11) DEFAULT NULL,
  `scheduled_start` datetime NOT NULL,
  `scheduled_end` datetime DEFAULT NULL,
  `actual_start` datetime DEFAULT NULL,
  `actual_end` datetime DEFAULT NULL,
  `status` enum('Scheduled','In Progress','Completed','Cancelled','No-Show') DEFAULT 'Scheduled',
  PRIMARY KEY (`visit_id`),
  KEY `idx_visit_patient_sched` (`patient_id`,`scheduled_start`),
  KEY `idx_visit_status` (`status`),
  CONSTRAINT `fk_visits_new_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients_index` (`patient_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visit`
--

LOCK TABLES `visit` WRITE;
/*!40000 ALTER TABLE `visit` DISABLE KEYS */;
INSERT INTO `visit` VALUES (1,'15d823ab-82c3-11f0-a3a1-06ce1f34132b',1,'2025-02-01 00:00:00',NULL,'2025-02-01 00:00:00','2025-02-01 00:00:00','Completed'),(2,'15d84201-82c3-11f0-a3a1-06ce1f34132b',2,'2025-02-03 00:00:00',NULL,'2025-02-03 00:00:00','2025-02-03 00:00:00','Completed'),(4,'15d823ab-82c3-11f0-a3a1-06ce1f34132b',1,'2025-08-27 21:38:02',NULL,NULL,NULL,'Scheduled'),(5,'15d84201-82c3-11f0-a3a1-06ce1f34132b',2,'2025-08-28 21:38:02',NULL,NULL,NULL,'Scheduled'),(12,'15d823ab-82c3-11f0-a3a1-06ce1f34132b',3,'2025-09-17 09:30:00','2025-09-17 10:00:00',NULL,NULL,'Scheduled'),(13,'15d84201-82c3-11f0-a3a1-06ce1f34132b',3,'2025-09-18 14:00:00','2025-09-18 14:30:00',NULL,NULL,'Scheduled'),(14,'15d823ab-82c3-11f0-a3a1-06ce1f34132b',1,'2025-08-30 09:00:00','2025-08-30 09:45:00','2025-08-30 09:02:00','2025-08-30 09:44:00','Completed'),(17,'08b13d21-8f68-11f0-8afe-06ce1f34132b',3,'2025-09-13 23:35:43','2025-09-14 00:20:43',NULL,NULL,'Scheduled'),(18,'a2d4a806-9038-11f0-b390-06ce1f34132b',2,'2025-09-15 00:28:57','2025-09-15 01:28:57',NULL,NULL,'Scheduled');
/*!40000 ALTER TABLE `visit` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-09-14  5:57:59
