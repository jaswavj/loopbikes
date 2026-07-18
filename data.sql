/*
SQLyog Community v13.3.1 (64 bit)
MySQL - 8.4.7 : Database - loopbikes
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`loopbikes` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `loopbikes`;

/*Table structure for table `bike_images` */

DROP TABLE IF EXISTS `bike_images`;

CREATE TABLE `bike_images` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `reference_type` enum('sell_request','bike') COLLATE utf8mb4_unicode_ci NOT NULL,
  `reference_id` bigint unsigned NOT NULL,
  `image_path` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image_url` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `original_filename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file_size` int unsigned DEFAULT NULL,
  `width` int unsigned DEFAULT NULL,
  `height` int unsigned DEFAULT NULL,
  `is_primary` tinyint(1) DEFAULT '0',
  `display_order` int DEFAULT NULL,
  `uploaded_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_reference_images` (`reference_type`,`reference_id`,`display_order`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `bike_images` */

insert  into `bike_images`(`id`,`reference_type`,`reference_id`,`image_path`,`image_url`,`original_filename`,`file_size`,`width`,`height`,`is_primary`,`display_order`,`uploaded_at`) values 
(1,'sell_request',1,'bike-images/2026/07/7cac4788-40d1-4322-b2fc-a5ff5ea549c7.jpg','bike-images/2026/07/7cac4788-40d1-4322-b2fc-a5ff5ea549c7.jpg','lb_11327638716826003663.jpg',NULL,NULL,NULL,1,1,'2026-07-18 10:58:58'),
(2,'sell_request',1,'bike-images/2026/07/3ded39e2-1c80-4df4-a7f7-5a1936512d54.jpg','bike-images/2026/07/3ded39e2-1c80-4df4-a7f7-5a1936512d54.jpg','lb_1993543780993275734.jpg',NULL,NULL,NULL,0,2,'2026-07-18 10:58:58'),
(3,'bike',1,'bike-images/2026/07/2f41acb1-7874-4f2e-b866-ff8c574e92d8.jpg','bike-images/2026/07/2f41acb1-7874-4f2e-b866-ff8c574e92d8.jpg','lb_16027108846262039632.jpg',NULL,NULL,NULL,1,1,'2026-07-18 11:01:48'),
(4,'bike',1,'bike-images/2026/07/a0189246-b83c-4bed-aab6-6e8f72a8c07d.jpg','bike-images/2026/07/a0189246-b83c-4bed-aab6-6e8f72a8c07d.jpg','lb_9552737102438080274.jpg',NULL,NULL,NULL,0,2,'2026-07-18 11:01:48');

/*Table structure for table `bikes` */

DROP TABLE IF EXISTS `bikes`;

CREATE TABLE `bikes` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `source_type` enum('admin_direct','user_submission') COLLATE utf8mb4_unicode_ci DEFAULT 'admin_direct',
  `sell_request_id` bigint unsigned DEFAULT NULL,
  `brand_id` int unsigned NOT NULL,
  `model_id` int unsigned NOT NULL,
  `registration_number` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `year` int NOT NULL,
  `km_driven` int unsigned NOT NULL,
  `fuel_type` enum('petrol','diesel','electric') COLLATE utf8mb4_unicode_ci DEFAULT 'petrol',
  `bike_condition` enum('excellent','good','average') COLLATE utf8mb4_unicode_ci DEFAULT 'good',
  `price` decimal(10,2) NOT NULL,
  `original_price` decimal(10,2) DEFAULT NULL,
  `is_negotiable` tinyint(1) DEFAULT '1',
  `status` int DEFAULT '0' COMMENT '0=Available,1=Reserved,2=Sold,3=Damaged',
  `uploaded_by` bigint NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `sold_date` timestamp NULL DEFAULT NULL,
  `sold_to_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sold_to_phone` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sold_price` decimal(10,2) DEFAULT NULL,
  `slug` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `featured` tinyint(1) DEFAULT '0',
  `views_count` int unsigned DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_unique_bike_registration` (`registration_number`),
  UNIQUE KEY `idx_slug` (`slug`),
  KEY `idx_status_available` (`status`,`created_at` DESC),
  KEY `idx_brand_model_search` (`brand_id`,`model_id`,`status`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `bikes` */

insert  into `bikes`(`id`,`source_type`,`sell_request_id`,`brand_id`,`model_id`,`registration_number`,`year`,`km_driven`,`fuel_type`,`bike_condition`,`price`,`original_price`,`is_negotiable`,`status`,`uploaded_by`,`description`,`sold_date`,`sold_to_name`,`sold_to_phone`,`sold_price`,`slug`,`featured`,`views_count`,`created_at`,`updated_at`) values 
(1,'admin_direct',NULL,8,1,'A',2026,22212,'petrol','good',12222.00,NULL,1,0,2,'',NULL,NULL,NULL,NULL,'ktm-duke-2026-a',0,3,'2026-07-18 11:01:48','2026-07-18 11:33:00');

/*Table structure for table `buyer_wishlist` */

DROP TABLE IF EXISTS `buyer_wishlist`;

CREATE TABLE `buyer_wishlist` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `bike_id` bigint unsigned NOT NULL,
  `notes` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_contacted` tinyint(1) DEFAULT '0',
  `added_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_unique_wishlist` (`user_id`,`bike_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `buyer_wishlist` */

insert  into `buyer_wishlist`(`id`,`user_id`,`bike_id`,`notes`,`is_contacted`,`added_at`) values 
(1,2,1,NULL,0,'2026-07-18 11:33:00');

/*Table structure for table `config_bike_brands` */

DROP TABLE IF EXISTS `config_bike_brands`;

CREATE TABLE `config_bike_brands` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `brand_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `logo_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `display_order` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_brand_name` (`brand_name`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `config_bike_brands` */

insert  into `config_bike_brands`(`id`,`brand_name`,`logo_url`,`is_active`,`display_order`,`created_at`,`updated_at`) values 
(1,'Honda',NULL,1,1,'2026-07-18 10:31:11','2026-07-18 10:31:11'),
(2,'Hero',NULL,1,2,'2026-07-18 10:31:11','2026-07-18 10:31:11'),
(3,'TVS',NULL,1,3,'2026-07-18 10:31:11','2026-07-18 10:31:11'),
(4,'Royal Enfield',NULL,1,4,'2026-07-18 10:31:11','2026-07-18 10:31:11'),
(5,'Bajaj',NULL,1,5,'2026-07-18 10:31:11','2026-07-18 10:31:11'),
(6,'Yamaha',NULL,1,6,'2026-07-18 10:31:11','2026-07-18 10:31:11'),
(7,'Suzuki',NULL,1,7,'2026-07-18 10:31:11','2026-07-18 10:31:11'),
(8,'KTM',NULL,1,8,'2026-07-18 10:31:11','2026-07-18 10:31:11'),
(9,'Other',NULL,1,9,'2026-07-18 10:31:11','2026-07-18 10:31:11');

/*Table structure for table `config_bike_models` */

DROP TABLE IF EXISTS `config_bike_models`;

CREATE TABLE `config_bike_models` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `brand_id` int unsigned NOT NULL,
  `model_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `variant` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `engine_cc` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fuel_type` enum('petrol','diesel','electric','hybrid') COLLATE utf8mb4_unicode_ci DEFAULT 'petrol',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_brand_models` (`brand_id`,`is_active`),
  CONSTRAINT `fk_model_brand` FOREIGN KEY (`brand_id`) REFERENCES `config_bike_brands` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `config_bike_models` */

insert  into `config_bike_models`(`id`,`brand_id`,`model_name`,`variant`,`engine_cc`,`fuel_type`,`is_active`,`created_at`,`updated_at`) values 
(1,8,'duke',NULL,'200','petrol',1,'2026-07-18 11:00:24','2026-07-18 11:01:02');

/*Table structure for table `contact_config` */

DROP TABLE IF EXISTS `contact_config`;

CREATE TABLE `contact_config` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `config_key` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `config_value` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `config_key` (`config_key`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `contact_config` */

insert  into `contact_config`(`id`,`config_key`,`config_value`,`description`,`is_active`) values 
(1,'customer_support_phone','9342217202','Customer support contact number',1),
(2,'site_name','LoopBikes','Website name',1),
(3,'site_address','Nagercoil, Tamil Nadu','Office address',1);

/*Table structure for table `finance` */

DROP TABLE IF EXISTS `finance`;

CREATE TABLE `finance` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone_number` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `aadhar_number` varchar(12) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bike_brand` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `bike_model` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `registration_number` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `year` year NOT NULL,
  `finance_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0=Pending,1=Active,2=Taken,3=Closed',
  `is_called` int DEFAULT NULL,
  `call_answered` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `registration_number` (`registration_number`),
  UNIQUE KEY `aadhar_number` (`aadhar_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `finance` */

/*Table structure for table `user_bike_sell_requests` */

DROP TABLE IF EXISTS `user_bike_sell_requests`;

CREATE TABLE `user_bike_sell_requests` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone_number` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `aadhar_number` char(12) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` text COLLATE utf8mb4_unicode_ci,
  `brand_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `registration_number` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `registration_year` int NOT NULL,
  `km_driven` int unsigned NOT NULL,
  `fuel_type` enum('petrol','diesel','electric') COLLATE utf8mb4_unicode_ci DEFAULT 'petrol',
  `bike_condition` enum('excellent','good','average','needs_repair') COLLATE utf8mb4_unicode_ci DEFAULT 'good',
  `asking_price` decimal(10,2) NOT NULL,
  `owner_type` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `has_accident_history` tinyint(1) NOT NULL DEFAULT '0',
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '0=pending,1=under_review,2=approved,3=rejected,4=contacted',
  `admin_notes` text COLLATE utf8mb4_unicode_ci,
  `rejection_reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `negotiated_price` decimal(10,2) DEFAULT NULL,
  `is_bike_purchased` tinyint(1) DEFAULT '0',
  `reviewed_by` bigint DEFAULT NULL,
  `reviewed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_unique_registration` (`registration_number`),
  KEY `idx_user_requests` (`user_id`,`status`,`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `user_bike_sell_requests` */

insert  into `user_bike_sell_requests`(`id`,`user_id`,`name`,`phone_number`,`aadhar_number`,`email`,`address`,`brand_name`,`model_name`,`registration_number`,`registration_year`,`km_driven`,`fuel_type`,`bike_condition`,`asking_price`,`owner_type`,`has_accident_history`,`description`,`status`,`admin_notes`,`rejection_reason`,`negotiated_price`,`is_bike_purchased`,`reviewed_by`,`reviewed_at`,`created_at`,`updated_at`) values 
(1,2,'wq','2332232332','','','','as','sa','SA',2021,2121,'diesel','excellent',21333.00,'first',0,'',0,NULL,NULL,NULL,0,NULL,NULL,'2026-07-18 10:58:58','2026-07-18 10:58:58');

/*Table structure for table `users` */

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `phone_number` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `country_code` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '+91',
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_phone_verified` tinyint(1) NOT NULL DEFAULT '0',
  `role` enum('USER','ADMIN') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USER',
  `is_super_admin` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_phone_unique` (`phone_number`),
  KEY `idx_role` (`role`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `users` */

insert  into `users`(`id`,`phone_number`,`password`,`country_code`,`name`,`email`,`is_phone_verified`,`role`,`is_super_admin`,`created_at`,`updated_at`) values 
(1,'9876543210','7fcf4ba391c48784edde599889d6e3f1e47a27db36ecc050cc92f259bfac38afad2c68a1ae804d77075e8fb722503f3eca2b2c1006ee6f6c7b7628cb45fffd1d','+91','Admin',NULL,1,'ADMIN',1,'2026-07-18 10:31:11','2026-07-18 10:31:11'),
(2,'9597451419','bcdb5b38bc646b97b515e709aef01e4abc8a62cceec50ec678b2ee812587daf8c88e57431a83434aeebe76d0b3ccb9466754dfa2f04683935e94617fd0688792','+91','Jaswa',NULL,1,'USER',1,'2026-07-18 10:57:17','2026-07-18 10:57:48'),
(3,'8667214152','bcdb5b38bc646b97b515e709aef01e4abc8a62cceec50ec678b2ee812587daf8c88e57431a83434aeebe76d0b3ccb9466754dfa2f04683935e94617fd0688792','+91','vj',NULL,1,'USER',0,'2026-07-18 11:37:53','2026-07-18 11:37:53');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
