-- ============================================================
--  RestaurantApp — Schéma de base de données MySQL
--  Exécutez ce script en tant que root ou utilisateur MySQL
-- ============================================================

-- 1. Créer la base de données
CREATE DATABASE IF NOT EXISTS restaurant_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE restaurant_db;

-- 2. Table des tables du restaurant
CREATE TABLE IF NOT EXISTS table_restaurant (
  id       INT          NOT NULL AUTO_INCREMENT,
  numero   INT          NOT NULL UNIQUE,
  capacite INT          NOT NULL DEFAULT 2,
  statut   ENUM('LIBRE','OCCUPEE','RESERVEE') NOT NULL DEFAULT 'LIBRE',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Table des plats (menu)
CREATE TABLE IF NOT EXISTS plat (
  id          INT            NOT NULL AUTO_INCREMENT,
  nom         VARCHAR(120)   NOT NULL,
  description TEXT,
  prix        DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
  categorie   ENUM('ENTREE','PLAT','DESSERT','BOISSON') NOT NULL DEFAULT 'PLAT',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. Table des commandes
CREATE TABLE IF NOT EXISTS commande (
  id         INT         NOT NULL AUTO_INCREMENT,
  table_id   INT         NOT NULL,
  date_heure TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
  statut     ENUM('EN_COURS','SERVIE','ANNULEE') NOT NULL DEFAULT 'EN_COURS',
  PRIMARY KEY (id),
  CONSTRAINT fk_commande_table
    FOREIGN KEY (table_id) REFERENCES table_restaurant(id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. Lignes de commande (commande ↔ plat)
CREATE TABLE IF NOT EXISTS ligne_commande (
  id           INT           NOT NULL AUTO_INCREMENT,
  commande_id  INT           NOT NULL,
  plat_id      INT           NOT NULL,
  quantite     INT           NOT NULL DEFAULT 1,
  prix_unitaire DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_lc_commande
    FOREIGN KEY (commande_id) REFERENCES commande(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_lc_plat
    FOREIGN KEY (plat_id) REFERENCES plat(id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6. (Optionnel) Factures persistées
CREATE TABLE IF NOT EXISTS facture (
  id           INT           NOT NULL AUTO_INCREMENT,
  commande_id  INT           NOT NULL UNIQUE,
  montant_ht   DECIMAL(10,2) NOT NULL,
  tva          DECIMAL(10,2) NOT NULL,
  montant_ttc  DECIMAL(10,2) NOT NULL,
  date_facture TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  statut       ENUM('EN_ATTENTE','PAYEE') NOT NULL DEFAULT 'EN_ATTENTE',
  PRIMARY KEY (id),
  CONSTRAINT fk_facture_commande
    FOREIGN KEY (commande_id) REFERENCES commande(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
--  Données de test (optionnel — supprimez si non souhaité)
-- ============================================================

INSERT INTO table_restaurant (numero, capacite, statut) VALUES
  (1, 2, 'LIBRE'),
  (2, 4, 'LIBRE'),
  (3, 4, 'LIBRE'),
  (4, 6, 'LIBRE'),
  (5, 2, 'LIBRE');

INSERT INTO plat (nom, description, prix, categorie) VALUES
  ('Soupe Harira',    'Soupe marocaine traditionnelle aux légumes et épices',  35.00, 'ENTREE'),
  ('Salade Marocaine','Tomates, concombres, oignons, herbes fraîches',          45.00, 'ENTREE'),
  ('Tajine d\'agneau','Agneau mijoté aux pruneaux, amandes et épices',         120.00, 'PLAT'),
  ('Couscous Royal',  'Semoule, légumes, agneau et merguez',                   110.00, 'PLAT'),
  ('Pastilla au Poulet','Feuilleté sucré-salé au poulet, amandes, cannelle',    95.00, 'PLAT'),
  ('Brochettes mixtes','Kefta, poulet et agneau grillés, légumes',              90.00, 'PLAT'),
  ('Chebakia',        'Gâteau miel et sésame',                                  30.00, 'DESSERT'),
  ('Cornes de Gazelle','Pâtisseries amandes et eau de fleur d\'oranger',        35.00, 'DESSERT'),
  ('Thé à la menthe', 'Thé vert, menthe fraîche, sucre',                        20.00, 'BOISSON'),
  ('Jus d\'orange',   'Orange fraîchement pressée',                             25.00, 'BOISSON');

-- ============================================================
--  Créer un utilisateur dédié (remplacez le mot de passe !)
-- ============================================================

-- CREATE USER IF NOT EXISTS 'restaurant_user'@'localhost' IDENTIFIED BY 'VotreMotDePasse!';
-- GRANT SELECT, INSERT, UPDATE, DELETE ON restaurant_db.* TO 'restaurant_user'@'localhost';
-- FLUSH PRIVILEGES;
