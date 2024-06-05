CREATE DATABASE BackShopHubAPI CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE DATABASE BackShopHubAPI;

CREATE TABLE user_profile (
  id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  status_ ENUM('online', 'offline') DEFAULT 'offline',
  nick VARCHAR(60) NOT NULL,
  user_name VARCHAR(60) NOT NULL,
  email VARCHAR(60) NOT NULL,
  password_ VARCHAR(100) NOT NULL,
  phone CHAR(9),
  cpf CHAR(11),
  sex VARCHAR(50),
  birth DATE,
  img_url VARCHAR(255),
  access_level ENUM('adm', 'client') DEFAULT 'client',
  config_2FA ENUM('yes', 'no') DEFAULT 'no'
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE products (
  id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  name VARCHAR(60) NOT NULL,
  image VARCHAR(255),
  description TEXT NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  category VARCHAR(300) NOT NULL,
  brand VARCHAR(50) NOT NULL,
  stock INT NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE avaliation (
  id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  user_id INT NOT NULL,
  product_id INT NOT NULL,
  review TEXT,
  stars INT,
  FOREIGN KEY (user_id) REFERENCES user_profile(id),
  FOREIGN KEY (product_id) REFERENCES products(id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE photoAvaliation (
  id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  avaliation_id INT NOT NULL,
  image varchar(255),
  image_id varchar(255),
  image_filename varchar(255),
  FOREIGN KEY (avaliation_id) REFERENCES avaliation(id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- Logo a baixo estão as novas tabelas que ainda estou analizando para implementar em breve.

CREATE TABLE review_response (
  id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  avaliation_id INT NOT NULL,
  user_id INT NOT NULL,
  response TEXT NOT NULL,
  FOREIGN KEY (avaliation_id) REFERENCES avaliation(id),
  FOREIGN KEY (user_id) REFERENCES user_profile(id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE avaliation_reactions (
  id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  avaliation_id INT NOT NULL,
  user_id INT NOT NULL,
  reaction ENUM('like', 'dislike') NOT NULL,
  FOREIGN KEY (avaliation_id) REFERENCES avaliation(id),
  FOREIGN KEY (user_id) REFERENCES user_profile(id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE response_reactions (
  id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  response_id INT NOT NULL,
  user_id INT NOT NULL,
  reaction ENUM('like', 'dislike') NOT NULL,
  FOREIGN KEY (response_id) REFERENCES review_response(id),
  FOREIGN KEY (user_id) REFERENCES user_profile(id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
