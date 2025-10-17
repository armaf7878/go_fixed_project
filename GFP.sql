CREATE TABLE `users` (
  `id` CHAR(36) PRIMARY KEY NOT NULL,
  `fullname` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `phone` VARCHAR(20) NOT NULL,
  `current_location` POINT,
  `password_hash` VARCHAR(255) NOT NULL,
  `avatar_url` VARCHAR(1024),
  `role` ENUM ('end_user', 'mechanic', 'admin') NOT NULL DEFAULT 'end_user',
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` DATETIME NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  `updated_at` DATETIME NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE `mechanic_profiles` (
  `user_id` CHAR(36) PRIMARY KEY NOT NULL,
  `is_online` TINYINT(1) NOT NULL DEFAULT 0,
  `rating` DECIMAL(2,1) DEFAULT null,
  `current_location` POINT,
  `updated_at` DATETIME NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE `services` (
  `id` CHAR(36) PRIMARY KEY NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `base_price` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `icon_url` VARCHAR(1024),
  `kind` ENUM ('simple_services', 'complex_services') NOT NULL DEFAULT 'simple_services',
  `created_at` DATETIME NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  `updated_at` DATETIME NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE `rescue_requests` (
  `id` CHAR(36) PRIMARY KEY NOT NULL,
  `user_id` CHAR(36) NOT NULL,
  `mechanic_id` CHAR(36),
  `service_id` CHAR(36),
  `service_type` VARCHAR(255),
  `description` TEXT,
  `status` ENUM ('pending', 'accepted', 'in_progress', 'completed', 'cancelled') NOT NULL DEFAULT 'pending',
  `location` POINT,
  `price_estimate` DECIMAL(12,2),
  `payment_status` ENUM ('unpaid', 'paid') NOT NULL DEFAULT 'unpaid',
  `created_at` DATETIME NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  `updated_at` DATETIME NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE `products` (
  `id` CHAR(36) PRIMARY KEY NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `description` TEXT,
  `category` VARCHAR(100),
  `price` DECIMAL(12,2) NOT NULL,
  `stock` INT NOT NULL DEFAULT 0,
  `images` JSON,
  `seller_id` CHAR(36) NOT NULL,
  `install_service` TINYINT(1) NOT NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  `updated_at` DATETIME NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE `orders` (
  `id` CHAR(36) PRIMARY KEY NOT NULL,
  `buyer_id` CHAR(36) NOT NULL,
  `seller_id` CHAR(36) NOT NULL,
  `total_price` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `status` ENUM ('pending', 'confirmed', 'delivering', 'completed', 'cancelled') NOT NULL DEFAULT 'pending',
  `payment_status` ENUM ('unpaid', 'paid') NOT NULL DEFAULT 'unpaid',
  `shipping_address` VARCHAR(500),
  `location` POINT,
  `created_at` DATETIME NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  `updated_at` DATETIME NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE `order_items` (
  `id` BIGINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `order_id` CHAR(36) NOT NULL,
  `product_id` CHAR(36) NOT NULL,
  `quantity` INT NOT NULL,
  `price` DECIMAL(12,2) NOT NULL
);

CREATE UNIQUE INDEX `uk_users_email` ON `users` (`email`);

CREATE UNIQUE INDEX `uk_users_phone` ON `users` (`phone`);

CREATE INDEX `spx_mech_current_location` ON `mechanic_profiles` (`current_location`);

CREATE INDEX `idx_services_name` ON `services` (`name`);

CREATE INDEX `idx_rr_user` ON `rescue_requests` (`user_id`);

CREATE INDEX `idx_rr_mech` ON `rescue_requests` (`mechanic_id`);

CREATE INDEX `idx_rr_status_created` ON `rescue_requests` (`status`, `created_at`);

CREATE INDEX `spx_rr_location` ON `rescue_requests` (`location`);

CREATE INDEX `idx_products_seller` ON `products` (`seller_id`);

CREATE INDEX `idx_products_category` ON `products` (`category`);

CREATE INDEX `idx_orders_buyer` ON `orders` (`buyer_id`);

CREATE INDEX `idx_orders_seller` ON `orders` (`seller_id`);

CREATE INDEX `idx_orders_status_created` ON `orders` (`status`, `created_at`);

CREATE INDEX `spx_orders_location` ON `orders` (`location`);

CREATE INDEX `idx_oi_order` ON `order_items` (`order_id`);

CREATE INDEX `idx_oi_product` ON `order_items` (`product_id`);

ALTER TABLE `mechanic_profiles` ADD CONSTRAINT `fk_mech_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `rescue_requests` ADD CONSTRAINT `fk_rr_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `rescue_requests` ADD CONSTRAINT `fk_rr_mechanic` FOREIGN KEY (`mechanic_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `rescue_requests` ADD CONSTRAINT `fk_rr_service` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `products` ADD CONSTRAINT `fk_products_seller` FOREIGN KEY (`seller_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `orders` ADD CONSTRAINT `fk_orders_buyer` FOREIGN KEY (`buyer_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `orders` ADD CONSTRAINT `fk_orders_seller` FOREIGN KEY (`seller_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `order_items` ADD CONSTRAINT `fk_oi_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `order_items` ADD CONSTRAINT `fk_oi_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
