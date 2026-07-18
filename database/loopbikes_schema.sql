-- LoopBikes Database Schema
-- Database: loopbikes
-- Run this script after creating the database: CREATE DATABASE loopbikes CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE loopbikes;

-- 1. Users
CREATE TABLE IF NOT EXISTS `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `phone_number` varchar(15) NOT NULL,
  `password` varchar(255) NOT NULL,
  `country_code` varchar(5) NOT NULL DEFAULT '+91',
  `name` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `is_phone_verified` tinyint(1) NOT NULL DEFAULT '0',
  `role` enum('USER','ADMIN') NOT NULL DEFAULT 'USER',
  `is_super_admin` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_phone_unique` (`phone_number`),
  KEY `idx_role` (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Bike Brands
CREATE TABLE IF NOT EXISTS `config_bike_brands` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `brand_name` varchar(50) NOT NULL,
  `logo_url` varchar(500) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `display_order` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_brand_name` (`brand_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. Bike Models
CREATE TABLE IF NOT EXISTS `config_bike_models` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `brand_id` int unsigned NOT NULL,
  `model_name` varchar(100) NOT NULL,
  `variant` varchar(50) DEFAULT NULL,
  `engine_cc` varchar(10) DEFAULT NULL,
  `fuel_type` enum('petrol','diesel','electric','hybrid') DEFAULT 'petrol',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_brand_models` (`brand_id`,`is_active`),
  CONSTRAINT `fk_model_brand` FOREIGN KEY (`brand_id`) REFERENCES `config_bike_brands` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. Bikes (Inventory)
CREATE TABLE IF NOT EXISTS `bikes` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `source_type` enum('admin_direct','user_submission') DEFAULT 'admin_direct',
  `sell_request_id` bigint unsigned DEFAULT NULL,
  `brand_id` int unsigned NOT NULL,
  `model_id` int unsigned NOT NULL,
  `registration_number` varchar(20) NOT NULL,
  `year` int NOT NULL,
  `km_driven` int unsigned NOT NULL,
  `fuel_type` enum('petrol','diesel','electric') DEFAULT 'petrol',
  `bike_condition` enum('excellent','good','average') DEFAULT 'good',
  `price` decimal(10,2) NOT NULL,
  `original_price` decimal(10,2) DEFAULT NULL,
  `is_negotiable` tinyint(1) DEFAULT '1',
  `status` int DEFAULT '0' COMMENT '0=Available,1=Reserved,2=Sold,3=Damaged',
  `uploaded_by` bigint NOT NULL,
  `description` text,
  `sold_date` timestamp NULL DEFAULT NULL,
  `sold_to_name` varchar(100) DEFAULT NULL,
  `sold_to_phone` varchar(15) DEFAULT NULL,
  `sold_price` decimal(10,2) DEFAULT NULL,
  `slug` varchar(200) DEFAULT NULL,
  `featured` tinyint(1) DEFAULT '0',
  `views_count` int unsigned DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_unique_bike_registration` (`registration_number`),
  UNIQUE KEY `idx_slug` (`slug`),
  KEY `idx_status_available` (`status`,`created_at` DESC),
  KEY `idx_brand_model_search` (`brand_id`,`model_id`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. Bike Images
CREATE TABLE IF NOT EXISTS `bike_images` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `reference_type` enum('sell_request','bike') NOT NULL,
  `reference_id` bigint unsigned NOT NULL,
  `image_path` varchar(500) NOT NULL,
  `image_url` varchar(500) NOT NULL,
  `original_filename` varchar(255) DEFAULT NULL,
  `file_size` int unsigned DEFAULT NULL,
  `width` int unsigned DEFAULT NULL,
  `height` int unsigned DEFAULT NULL,
  `is_primary` tinyint(1) DEFAULT '0',
  `display_order` int DEFAULT NULL,
  `uploaded_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_reference_images` (`reference_type`,`reference_id`,`display_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. Sell Requests
CREATE TABLE IF NOT EXISTS `user_bike_sell_requests` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `name` varchar(100) NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  `aadhar_number` char(12) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `address` text,
  `brand_name` varchar(100) NOT NULL,
  `model_name` varchar(100) NOT NULL,
  `registration_number` varchar(20) NOT NULL,
  `registration_year` int NOT NULL,
  `km_driven` int unsigned NOT NULL,
  `fuel_type` enum('petrol','diesel','electric') DEFAULT 'petrol',
  `bike_condition` enum('excellent','good','average','needs_repair') DEFAULT 'good',
  `asking_price` decimal(10,2) NOT NULL,
  `owner_type` varchar(20) DEFAULT NULL,
  `has_accident_history` tinyint(1) NOT NULL DEFAULT '0',
  `description` varchar(500) DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '0=pending,1=under_review,2=approved,3=rejected,4=contacted',
  `admin_notes` text,
  `rejection_reason` varchar(255) DEFAULT NULL,
  `negotiated_price` decimal(10,2) DEFAULT NULL,
  `is_bike_purchased` tinyint(1) DEFAULT '0',
  `reviewed_by` bigint DEFAULT NULL,
  `reviewed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_unique_registration` (`registration_number`),
  KEY `idx_user_requests` (`user_id`,`status`,`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 7. Wishlist
CREATE TABLE IF NOT EXISTS `buyer_wishlist` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `bike_id` bigint unsigned NOT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `is_contacted` tinyint(1) DEFAULT '0',
  `added_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_unique_wishlist` (`user_id`,`bike_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 8. Finance Enquiries
CREATE TABLE IF NOT EXISTS `finance` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  `aadhar_number` varchar(12) DEFAULT NULL,
  `bike_brand` varchar(50) NOT NULL,
  `bike_model` varchar(50) NOT NULL,
  `registration_number` varchar(20) NOT NULL,
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

-- 9. Contact Config
CREATE TABLE IF NOT EXISTS `contact_config` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `config_key` varchar(50) NOT NULL,
  `config_value` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `config_key` (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Default data
INSERT INTO contact_config (config_key, config_value, description) VALUES
('customer_support_phone', '+91-9876543210', 'Customer support contact number'),
('site_name', 'LoopBikes', 'Website name'),
('site_address', 'Nagercoil, Tamil Nadu', 'Office address');

INSERT INTO config_bike_brands (brand_name, display_order) VALUES
('Honda', 1), ('Hero', 2), ('TVS', 3), ('Royal Enfield', 4),
('Bajaj', 5), ('Yamaha', 6), ('Suzuki', 7), ('KTM', 8), ('Other', 9);

-- Default super admin (password: admin123 - SHA-512 hash)
INSERT INTO users (phone_number, password, name, role, is_super_admin, is_phone_verified) VALUES
('9876543210', '7fcf4ba391c48784edde599889d6e3f1e47a27db36ecc050cc92f259bfac38afad2c68a1ae804d77075e8fb722503f3eca2b2c1006ee6f6c7b7628cb45fffd1d', 'Admin', 'ADMIN', 1, 1);
