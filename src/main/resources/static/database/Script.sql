-- Host: 127.0.0.1:3306 (by default)
-- Server version: 5.7.36

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

--
-- DataBasea :`gogifty_bdd`
--

DROP DATABASE IF EXISTS `gogifty_bdd`;
CREATE DATABASE IF NOT EXISTS `gogifty_bdd` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `gogifty_bdd`;

-- --------------------------------------------------------

--
-- User : gogifty_access
-- Used to connect with the application, with all rights only on the database
--

DROP USER IF EXISTS 'gogifty_access'@'localhost';
CREATE USER IF NOT EXISTS 'gogifty_access'@'localhost'
    IDENTIFIED BY 'gogitfy&72_access_App'
    PASSWORD EXPIRE NEVER;
    

-- only data management rights, not db structure, if needed, you can create another user, this one if for general app use, limit hackers possibilities
GRANT SELECT, INSERT, DELETE, UPDATE ON `gogifty_bdd`.* TO 'gogifty_access'@'localhost';

-- --------------------------------------------------------

--
-- Table structure of `salesman`
--

DROP TABLE IF EXISTS `SALESMAN_t`;
CREATE TABLE IF NOT EXISTS `SALESMAN_t` (
    `idSalesman` bigint PRIMARY KEY AUTO_INCREMENT,
    `lastName` varchar(50) NOT NULL,
    `firstName` varchar(50) NOT NULL
) ENGINE=InnoDB;

--
-- Table structure of `membership`
--

DROP TABLE IF EXISTS `MEMBERSHIP_t`;
CREATE TABLE IF NOT EXISTS `MEMBERSHIP_t` (
    `idLevel` bigint PRIMARY KEY AUTO_INCREMENT,
    `nameLevel` varchar(25) NOT NULL,
    `expiryDelay` date,
    `necessaryMemberPoints` int
) ENGINE=InnoDB;

--
-- Table structure of `customer`
--

DROP TABLE IF EXISTS `CUSTOMER_t`;
CREATE TABLE IF NOT EXISTS `CUSTOMER_t` (
    -- TODO: change to format expected at first
    `idCustomer` bigint PRIMARY KEY AUTO_INCREMENT,
    `lastName` varchar(50) NOT NULL,
    `firstName` varchar(50) NOT NULL,
    -- TODO: check if match email
    `email` varchar(50) NOT NULL,
    `phoneNumber` varchar(20) NOT NULL,
    `membershipPoints` int,
    `idSalesman` bigint,
    `idLevel` bigint,
    FOREIGN KEY (`idSalesman`)
        REFERENCES SALESMAN_t(idSalesman)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    FOREIGN KEY (`idLevel`)
        REFERENCES MEMBERSHIP_t(idLevel)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

--
-- Table structure of `social_media`
--

DROP TABLE IF EXISTS `SOCIAL_MEDIA_t`;
CREATE TABLE IF NOT EXISTS `SOCIAL_MEDIA_t` (
    `idSocialMedia` bigint PRIMARY KEY AUTO_INCREMENT,
    `alias` varchar(50) NOT NULL,
    `platformName`varchar(50) NOT NULL,
    `link`varchar(150),
    `idCustomer` bigint NOT NULL,
    FOREIGN KEY (`idCustomer`)
        REFERENCES CUSTOMER_t(idCustomer)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

--
-- Table structure of `adress`
--

DROP TABLE IF EXISTS `ADRESS_t`;
CREATE TABLE IF NOT EXISTS `ADRESS_t` (
    `idAdress` bigint PRIMARY KEY AUTO_INCREMENT,
    `numberInRoad` int,
    `lieuDitName` varchar(50),
    `roadName` varchar(50) NOT NULL,
    `cityName` varchar(50) NOT NULL,
    `postalCode` varchar(10) NOT NULL
) ENGINE=InnoDB;

--
-- Table structure of `CUSTOMER_ADRESS`
--

DROP TABLE IF EXISTS `CUSTOMER_ADRESS_tj`;
CREATE TABLE IF NOT EXISTS `CUSTOMER_ADRESS_tj` (
    `idCustomer` bigint,
    `idAdress` bigint,
    FOREIGN KEY (`idCustomer`)
        REFERENCES CUSTOMER_t(idCustomer)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (`idAdress`)
        REFERENCES ADRESS_t(idAdress)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    PRIMARY KEY(`idCustomer`, `idAdress`)
);

--
-- Table structure of `special_event`
--

DROP TABLE IF EXISTS `SPECIAL_EVENT_t`;
CREATE TABLE IF NOT EXISTS `SPECIAL_EVENT_t` (
    `idEvent` bigint PRIMARY KEY AUTO_INCREMENT,
    `nameEvent` varchar(50) NOT NULL,
    -- TODO: check cohérence entre date de debut et de fin de l'evenement
    `startDate` date NOT NULL,
    `endDate` date NOT NULL
) ENGINE=InnoDB;

--
-- Table structure of `brand`
--

DROP TABLE IF EXISTS `BRAND_t`;
CREATE TABLE IF NOT EXISTS `BRAND_t` (
    `idBrand` bigint PRIMARY KEY AUTO_INCREMENT,
    `nameBrand` varchar(50) NOT NULL
) ENGINE=InnoDB;

--
-- Table structure of `category`
--

DROP TABLE IF EXISTS `CATEGORY_t`;
CREATE TABLE IF NOT EXISTS `CATEGORY_t` (
    `idCategory` bigint PRIMARY KEY AUTO_INCREMENT,
    `nameCategory` varchar(50) NOT NULL
) ENGINE=InnoDB;

--
-- Table structure of `promotion`
--

DROP TABLE IF EXISTS `PROMOTION_t`;
CREATE TABLE IF NOT EXISTS `PROMOTION_t` (
    `idPromotion` bigint PRIMARY KEY AUTO_INCREMENT,
    -- TODO: multiple check to do
    `startDate` date NOT NULL,
    `endDate` date,
    `multiplierPoints` float,
    `operatorPoints` varchar(5),
    `reductionPercent` float,
    `operatorPercent` varchar(5),
    `minAmountTrigger` float,
    `fidelityPointsPercent` float
) ENGINE=InnoDB;

--
-- Table structure of `promotion_on_membership`
--

DROP TABLE IF EXISTS `PROMOTION_ON_MEMBERSHIP_tj`;
CREATE TABLE IF NOT EXISTS `PROMOTION_ON_MEMBERSHIP_tj` (
    idLevel bigint NOT NULL,
    idPromotion bigint NOT NULL,
    FOREIGN KEY (`idLevel`)
        REFERENCES MEMBERSHIP_t(idLevel)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (`idPromotion`)
        REFERENCES PROMOTION_t(idPromotion)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    PRIMARY KEY (`idLevel`, `idPromotion`)
) ENGINE=InnoDB;

--
-- Table structure of `promotion_on_brand`
--

DROP TABLE IF EXISTS `PROMOTION_ON_BRAND_tj`;
CREATE TABLE IF NOT EXISTS `PROMOTION_ON_BRAND_tj` (
    idBrand bigint NOT NULL,
    idPromotion bigint NOT NULL,
    FOREIGN KEY (`idBrand`)
        REFERENCES BRAND_t(idBrand)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (`idPromotion`)
        REFERENCES PROMOTION_t(idPromotion)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    PRIMARY KEY (`idBrand`, `idPromotion`)
) ENGINE=InnoDB;

--
-- Table structure of `promotion_on_category`
--

DROP TABLE IF EXISTS `PROMOTION_ON_CATEGORY_tj`;
CREATE TABLE IF NOT EXISTS `PROMOTION_ON_CATEGORY_tj` (
    idCategory bigint NOT NULL,
    idPromotion bigint NOT NULL,
    FOREIGN KEY (`idCategory`)
        REFERENCES CATEGORY_t(idCategory)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (`idPromotion`)
        REFERENCES PROMOTION_t(idPromotion)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    PRIMARY KEY (`idCategory`, `idPromotion`)
) ENGINE=InnoDB;

--
-- Structure de la table `order`
--

DROP TABLE IF EXISTS `ORDER_t`;
CREATE TABLE IF NOT EXISTS `ORDER_t` (
    -- TODO: forcer idOrder
    `idOrder` bigint PRIMARY KEY AUTO_INCREMENT,
    `orderDate` date NOT NULL,
    `note` text,
    `percentDeposit` float NOT NULL,
    `spEventExpirationDate` date,
    `idSalesman` bigint NOT NULL,
    `idAdress` bigint NOT NULL,
    `idCustomer` bigint NOT NULL,
    `idEvent` bigint,
    `idPromotion` bigint,
    FOREIGN KEY (`idSalesman`)
        REFERENCES SALESMAN_t(idSalesman)
        -- TODO: reflechir a mettre plutot en 0,  car salesman pourrait quitter l'entreprise
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (`idAdress`)
        REFERENCES ADRESS_t(idAdress)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (`idCustomer`)
        REFERENCES CUSTOMER_t(idCustomer)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (`idEvent`)
        REFERENCES SPECIAL_EVENT_t(idEvent)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    FOREIGN KEY (`idPromotion`)
        REFERENCES PROMOTION_t(idPromotion)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB;

--
-- Table structure of `promotion_on_order`
--

DROP TABLE IF EXISTS `PROMOTION_ON_ORDER_tj`;
CREATE TABLE IF NOT EXISTS `PROMOTION_ON_ORDER_tj` (
    `idOrder` bigint,
    `idPromotion` bigint,
    FOREIGN KEY(`idOrder`)
        REFERENCES ORDER_t(idOrder)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (`idPromotion`)
        REFERENCES PROMOTION_t(idPromotion)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    PRIMARY KEY (`idOrder`, `idPromotion`)
) ENGINE=InnoDB;

--
-- Table structure of `bill`
--

DROP TABLE IF EXISTS `BILL_t`;
CREATE TABLE IF NOT EXISTS `BILL_t` (
    `idBill` bigint PRIMARY KEY AUTO_INCREMENT,
    `billInitialDate` date NOT NULL,
    -- TODO: check date is at least equal or later than initial
    `lastUpdateDate` date NOT NULL,
    `deliveryCost` float NOT NULL CHECK(deliveryCost >= 0) DEFAULT 0,
    `serviceCost` float NOT NULL CHECK(serviceCost >= 0) DEFAULT 0,
    `reasonAmountPoints` text,
    idOrder bigint NOT NULL,
    FOREIGN KEY (`idOrder`)
        REFERENCES ORDER_t(idOrder)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

--
-- Table structure of `item`
--

DROP TABLE IF EXISTS `ITEM_t`;
CREATE TABLE IF NOT EXISTS `ITEM_t` (
    `idItem` bigint PRIMARY KEY AUTO_INCREMENT,
    `nameItem` varchar(50) NOT NULL,
    `initialPrice` float NOT NULL,
    `givingPoints` int NOT NULL DEFAULT 0,
    `idBrand` bigint NOT NULL,
    FOREIGN KEY (`idBrand`)
        REFERENCES BRAND_t(idBrand)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

--
-- Table structure of `Bill_Item`
--

DROP TABLE IF EXISTS `BILL_ITEM_t`;
CREATE TABLE IF NOT EXISTS `BILL_ITEM_t` (
    `quantity` int NOT NULL CHECK(quantity > 0),
    -- TODO: only precise status
    `deliverStatus` varchar(50) NOT NULL,
    `deliverStateDate` date NOT NULL,
    `trackingNumber` varchar(50),
    `actualPrice` float NOT NULL CHECK(actualPrice >= 0),
    `itemPoints` int CHECK(itemPoints >= 0),
    `reasonItemPoints` text,
    `idItem` bigint NOT NULL,
    `idBill`bigint NOT NULL,
    FOREIGN KEY (`idItem`)
        REFERENCES ITEM_t(idItem)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (`idBill`)
        REFERENCES BILL_t(idBill)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    PRIMARY KEY(`idItem`, `idBill`)
) ENGINE=InnoDB;

--
-- Table structure of `Paiement`
--
DROP TABLE IF EXISTS `PAIEMENT_t`;
CREATE TABLE IF NOT EXISTS `PAIEMENT_t` (
    `idPaiement` bigint PRIMARY KEY AUTO_INCREMENT,
    `origin` varchar(50) NOT NULL,
    `date` date,
    `amount` float NOT NULL CHECK(amount > 0)
);

--
-- Table structure of `acompte` 
--

DROP TABLE IF EXISTS `ACOMPTE_tj`;
CREATE TABLE IF NOT EXISTS `ACOMPTE_tj` (
    `idPaiement` bigint NOT NULL,
    `idBill` bigint NOT NULL,
    -- TODO: between 0 and 1
    `percentAmountPerBill` float NOT NULL,
    FOREIGN KEY(`idPaiement`)
        REFERENCES PAIEMENT_t(idPaiement)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY(`idBill`)
        REFERENCES BILL_t(idBill)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    PRIMARY KEY(`idPaiement`, `idBill`)
);

--
-- Table structure of `promotion_on_item`
--

DROP TABLE IF EXISTS `PROMOTION_ON_ITEM_tj`;
CREATE TABLE IF NOT EXISTS `PROMOTION_ON_ITEM_tj` (
    `idItem` bigint,
    `idPromotion` bigint,
    FOREIGN KEY (`idItem`)
        REFERENCES ITEM_t(idItem)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (`idPromotion`)
        REFERENCES PROMOTION_t(idPromotion)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    PRIMARY KEY (`idItem`,`idPromotion`)
) ENGINE=InnoDB;

--
-- Table structure of `supplier`
--

DROP TABLE IF EXISTS `SUPPLIER_t`;
CREATE TABLE IF NOT EXISTS `SUPPLIER_t` (
    `idSupplier` bigint PRIMARY KEY AUTO_INCREMENT,
    `nameSupplier` varchar(50) NOT NULL
) ENGINE=InnoDB;

--
-- Table structure of `Supplied_item`
--

DROP TABLE IF EXISTS `SUPPLIED_ITEM_tj`;
CREATE TABLE IF NOT EXISTS `SUPPLIED_ITEM_tj` (
    `idItem` bigint,
    `idSupplier` bigint,
    -- TODO: check à faire
    `availabilityStatus` varchar(20) NOT NULL,
    `supplierDiscountPercent` float,
    FOREIGN KEY (`idItem`)
        REFERENCES ITEM_t(idItem)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (`idSupplier`)
        REFERENCES SUPPLIER_t(idSupplier)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    PRIMARY KEY(`idItem`, `idSupplier`)
) ENGINE=InnoDB;

--
-- Table structure of `Supplier_adress`
--

DROP TABLE IF EXISTS `SUPPLIER_ADRESS_tj`;
CREATE TABLE IF NOT EXISTS `SUPPLIER_ADRESS_tj` (
    `idAdress` bigint,
    `idSupplier` bigint,
    FOREIGN KEY (`idAdress`)
        REFERENCES ADRESS_t(idAdress)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (`idSupplier`)
        REFERENCES SUPPLIER_t(idSupplier)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    PRIMARY KEY(`idAdress`, `idSupplier`)
) ENGINE=InnoDB;

--
-- Table structure of `item_category`
--

DROP TABLE IF EXISTS `ITEM_CATEGORY_tj`;
CREATE TABLE IF NOT EXISTS `ITEM_CATEGORY_tj` (
    `idItem` bigint,
    `idCategory` bigint,
    FOREIGN KEY (`idItem`)
        REFERENCES ITEM_t(idItem)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (`idCategory`)
        REFERENCES CATEGORY_t(idCategory)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    PRIMARY KEY(`idItem`, `idCategory`)
) ENGINE=InnoDB;

COMMIT;
