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
    `firstName` varchar(50) NOT NULL,
    `password` varchar(255) NOT NULL,
    `email` varchar(50) NOT NULL CHECK(REGEXP_LIKE(email, '^.+@.*\..+$'))
) ENGINE=InnoDB;

--
-- Table structure of `membership`
--

DROP TABLE IF EXISTS `MEMBERSHIP_t`;
CREATE TABLE IF NOT EXISTS `MEMBERSHIP_t` (
    `idLevel` bigint PRIMARY KEY AUTO_INCREMENT,
    `nameLevel` varchar(25) NOT NULL,
    -- nb days after what all points are expired; use DATE_ADD to obtain expiry date, if NULL, no expiry delay, points could be permanent
    `nbDaysExpiryDelay` smallint CHECK(nbDaysExpiryDelay > 0),
    -- NULL means grade is attribuated by hand
    `necessaryMemberPoints` int CHECK(necessaryMemberPoints IS NULL OR necessaryMemberPoints > -1)
) ENGINE=InnoDB;

--
-- Table structure of `customer`
--

DROP TABLE IF EXISTS `CUSTOMER_t`;
CREATE TABLE IF NOT EXISTS `CUSTOMER_t` (
    `idCustomer` varchar(12) PRIMARY KEY CHECK(REGEXP_LIKE(idCustomer, '^[0-9]{2}-[A-Z]{3}-[0-9]{4}$')),
    `lastName` varchar(50) NOT NULL,
    `firstName` varchar(50) NOT NULL,
    `password` varchar(255) NOT NULL,
    `email` varchar(50) NOT NULL CHECK(REGEXP_LIKE(email, '^.+@.*\..+$')),
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

-- if membershipPoints is set to value, then idLevel cannot be null
-- use trigger strategy here because CHECK cannot use columns used in foreign key referential actions (here idLevel)
DROP TRIGGER IF EXISTS check_points_only_if_membership_insert;
DELIMITER $$
CREATE TRIGGER IF NOT EXISTS check_points_only_if_membership_insert
BEFORE INSERT ON CUSTOMER_t
FOR EACH ROW
BEGIN
    IF NEW.membershipPoints IS NOT NULL AND new.idLevel IS NULL THEN
        SIGNAL SQLSTATE '02001' SET MESSAGE_TEXT = 'Illegal Values upon insert: membershipPoints should be null if idLevel is null!';
    END IF;
END$$
DROP TRIGGER IF EXISTS check_points_only_if_membership_update$$
CREATE TRIGGER IF NOT EXISTS check_points_only_if_membership_update
BEFORE UPDATE ON CUSTOMER_t
FOR EACH ROW
BEGIN
    IF NEW.membershipPoints IS NOT NULL AND new.idLevel IS NULL THEN
        SIGNAL SQLSTATE '02002' SET MESSAGE_TEXT = 'Illegal Values upon update: membershipPoints should be null if idLevel is null!';
    END IF;
END$$
DELIMITER ;

--
-- Table structure of `social_media`
--

DROP TABLE IF EXISTS `SOCIAL_MEDIA_t`;
CREATE TABLE IF NOT EXISTS `SOCIAL_MEDIA_t` (
    `idSocialMedia` bigint PRIMARY KEY AUTO_INCREMENT,
    `alias` varchar(50) NOT NULL,
    `platformName`varchar(50) NOT NULL,
    `link`varchar(150) CHECK(REGEXP_LIKE(link, '^https?:\/\/.*\..*\/.*$')),
    `idCustomer` varchar(12) NOT NULL,
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
    `numberInRoad` int CHECK(numberInRoad > 0),
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
    `idCustomer` varchar(12),
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
    `startDate` date NOT NULL,
    `endDate` date NOT NULL,
    -- endDate shouldn't be strictly less than starting date
    CONSTRAINT sp_check_end_after_start CHECK(DATEDIFF(new.endDate, new.startDate) > -1)
) ENGINE=InnoDB;


-- starting date should be atleast equal to today
-- check with trigger because mysql CHECK does not support not-deterministic function as CURRENT_DATE()
DROP TRIGGER IF EXISTS special_event_check_begin_date_insert;
DELIMITER $$ -- set delimiter for query end to $$
CREATE TRIGGER IF NOT EXISTS special_event_check_begin_date_insert
BEFORE INSERT ON SPECIAL_EVENT_t
FOR EACH ROW
BEGIN
    IF DATEDIFF(new.startDate, CURRENT_DATE()) < 0 THEN -- 02 means exception, here 0001 means "Illegal Values upon insert"
        SIGNAL SQLSTATE '02001' SET MESSAGE_TEXT = 'Illegal Values upon insert: startDate cannot be before today s date!';
    END IF;
END$$
DROP TRIGGER IF EXISTS special_event_check_begin_date_update$$
CREATE TRIGGER IF NOT EXISTS special_event_check_begin_date_update
BEFORE UPDATE ON SPECIAL_EVENT_t
FOR EACH ROW
BEGIN
    IF DATEDIFF(new.startDate, CURRENT_DATE()) < 0 THEN -- 02 means exception, here 0002 means "Illegal Values upon update"
        SIGNAL SQLSTATE '02002' SET MESSAGE_TEXT = 'Illegal Values upon update: startDate cannot be before today s date!';
    END IF;
END$$
DELIMITER ; -- set back delimiter to ;

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
    `startDate` date NOT NULL,
    `endDate` date,
    `multiplierPoints` float CHECK(multiplierPoints IS NULL OR (multiplierPoints >= 0.0 AND multiplierPoints <= 1.0)),
    `operatorPoints` varchar(5),
    `reductionPercent` float CHECK(reductionPercent IS NULL OR (reductionPercent >= 0.0 AND reductionPercent <= 1.0)),
    `operatorPercent` varchar(5),
    `minAmountTrigger` float CHECK(minAmountTrigger IS NULL OR minAmountTrigger >= 0.0),
    `fidelityPointsPercent` float CHECK(fidelityPointsPercent IS NULL OR (fidelityPointsPercent >= 0.0 AND fidelityPointsPercent <= 1.0)),

    -- if endDate is not null, endDate should be atleast equal to today
    CONSTRAINT bill_check_end_after_start CHECK(endDate IS NULL OR DATEDIFF(endDate, startDate) > -1)
) ENGINE=InnoDB;

-- can create new promotions only from today (included)
DROP TRIGGER IF EXISTS promotion_check_begin_date_insert;
DELIMITER $$
CREATE TRIGGER IF NOT EXISTS promotion_check_begin_date_insert
BEFORE INSERT ON PROMOTION_t
FOR EACH ROW
BEGIN
    IF DATEDIFF(new.startDate, CURRENT_DATE()) < 0 THEN
        SIGNAL SQLSTATE '02001' SET MESSAGE_TEXT = 'Illegal Values upon insert: startDate cannot be before today s date!';
    END IF;
END$$
DROP TRIGGER IF EXISTS promotion_check_begin_date_update$$
CREATE TRIGGER IF NOT EXISTS promotion_check_begin_date_update
BEFORE UPDATE ON PROMOTION_t
FOR EACH ROW
BEGIN
    IF DATEDIFF(new.startDate, CURRENT_DATE()) < 0 THEN
        SIGNAL SQLSTATE '02002' SET MESSAGE_TEXT = 'Illegal Values upon update: startDate cannot be before today s date!';
    END IF;
END$$
DELIMITER ;

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
    -- match the two possible given format:
    -- DDMMYY-<Customer initials (at least 2 chars)>-<Category abreviation (at least 2 chars)>-<Order ID (4 digits)>
    -- DDMMYY-<Category abreviation (at least 2 chars)>-C<Order ID (3 digits)>
    `idOrder` varchar(20) PRIMARY KEY CHECK(REGEXP_LIKE(idOrder, '^[0-9]{6}-[A-Z]{3}-([A-Z]{3}-[0-9]|C)[0-9]{3}$')),
    `orderDate` date NOT NULL, -- can create whenever, to allow correction for adding missing orders
    `note` text,
    -- minimum percent deposit
    `percentDeposit` float NOT NULL CHECK(percentDeposit >= 0.0 AND percentDeposit <= 1.0),
    `spEventExpirationDate` date,
    `idSalesman` bigint NOT NULL,
    `idAdress` bigint NOT NULL,
    `idCustomer` varchar(12) NOT NULL,
    `idEvent` bigint,
    `idPromotion` bigint,
    FOREIGN KEY (`idSalesman`)
        REFERENCES SALESMAN_t(idSalesman)
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

-- upon order update, have to check if new orderDate is not after any of the possible bills
DROP TRIGGER IF EXISTS is_new_order_date_valid;
DELIMITER $$
CREATE TRIGGER IF NOT EXISTS is_new_order_date_valid
BEFORE UPDATE ON ORDER_t
FOR EACH ROW
BEGIN
    DECLARE nb_bill_invalided INT;
    IF new.orderDate > old.orderDate THEN -- new orderDate is more recent, some bills could have their dates between oldDate and newDate
        SELECT COUNT(*) INTO nb_bill_invalided FROM BILL_t WHERE billInitialDate < new.orderDate;
        IF nb_bill_invalided > 0 THEN
            SIGNAL SQLSTATE '02002' SET MESSAGE_TEXT = 'Illegal Values upon update: newer orderDate is after some linked bills initialDate!';
        END IF;
    END IF;
END$$
DELIMITER ;

-- trigger when modifying points, to check if the ones there before are outdated
DROP TRIGGER IF EXISTS outdated_membership_points_check_insert;
DELIMITER $$
CREATE TRIGGER IF NOT EXISTS outdated_membership_points_check_insert
BEFORE INSERT ON ORDER_t
FOR EACH ROW
BEGIN
    DECLARE oldLatestOrderedDate DATE;
    DECLARE nbDaysDelay SMALLINT;
    SELECT orderDate INTO oldLatestOrderedDate FROM ORDER_t WHERE idCustomer=new.idCustomer;
    SELECT nbDaysExpiryDelay INTO nbDaysDelay FROM MEMBERSHIP_t NATURAL JOIN CUSTOMER_t WHERE idCustomer=new.idCustomer;

    IF DATE_ADD(orderDate, INTERVAL nbDaysExpiryDelay DAY) < CURRENT_DATE() THEN
        UPDATE CUSTOMER_t SET membershipPoints = 0 WHERE idCustomer=new.idCustomer;
    END IF;
END$$
DELIMITER ;

--
-- Table structure of `promotion_on_order`
--

DROP TABLE IF EXISTS `PROMOTION_ON_ORDER_tj`;
CREATE TABLE IF NOT EXISTS `PROMOTION_ON_ORDER_tj` (
    `idOrder` varchar(20),
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
    -- idBill was initially meant to be the same as idOrder (foreign key), but with an F replacing the C
    -- but we determined that we could have multiple bills for one single order, which would handle one supplier for example
    -- this new constraint end up in the incomptability of the older system for idBill. It will stay as an bigint
    `idBill` bigint PRIMARY KEY AUTO_INCREMENT,
    `billInitialDate` date NOT NULL,
    `lastUpdateDate` date NOT NULL,
    `deliveryCost` float NOT NULL CHECK(deliveryCost >= 0) DEFAULT 0,
    `serviceCost` float NOT NULL CHECK(serviceCost >= 0) DEFAULT 0,
    `reasonAmountPoints` text,
    idOrder varchar(20) NOT NULL,
    FOREIGN KEY (`idOrder`)
        REFERENCES ORDER_t(idOrder)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT check_update_after_creation_date CHECK(DATEDIFF(lastUpdateDate, billInitialDate) > -1)
) ENGINE=InnoDB;

-- can create new bills only from order date (included)
DROP TRIGGER IF EXISTS bill_check_initial_date_after_order_date_insert;
DELIMITER $$
CREATE TRIGGER IF NOT EXISTS bill_check_initial_date_after_order_date_insert
BEFORE INSERT ON BILL_t
FOR EACH ROW
BEGIN
    IF DATEDIFF(new.billInitialDate, CURRENT_DATE()) > -1 THEN
        SIGNAL SQLSTATE '02001' SET MESSAGE_TEXT = 'Illegal Values upon insert: billInitialDate cannot be before today s date!';
    END IF;
END$$
DROP TRIGGER IF EXISTS bill_check_initial_date_after_order_date_update$$
CREATE TRIGGER IF NOT EXISTS bill_check_initial_date_after_order_date_update
BEFORE UPDATE ON BILL_t
FOR EACH ROW
BEGIN
    IF DATEDIFF(new.billInitialDate, CURRENT_DATE()) > -1 THEN
        SIGNAL SQLSTATE '02002' SET MESSAGE_TEXT = 'Illegal Values upon update: billInitialDate cannot be before today s date!';
    END IF;
END$$

DELIMITER ;

--
-- Table structure of `item`
--

DROP TABLE IF EXISTS `ITEM_t`;
CREATE TABLE IF NOT EXISTS `ITEM_t` (
    `idItem` bigint PRIMARY KEY AUTO_INCREMENT,
    `nameItem` varchar(50) NOT NULL,
    `initialPrice` float NOT NULL CHECK(initialPrice > 0.0),
    `givingPoints` int NOT NULL CHECK(givingPoints >= 0.0) DEFAULT 0,
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
    `deliverStatus` varchar(50) NOT NULL CHECK(deliverStatus IN('packed', 'dispatched', 'arrived', 'delivered')),
    `deliverStateDate` date NOT NULL,
    `trackingNumber` varchar(50),
    -- if = 0, then it's gifted
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
    PRIMARY KEY(`idItem`, `idBill`),

    CONSTRAINT check_tracking_available CHECK(trackingNumber IS NULL OR deliverStatus NOT IN ('packed'))
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
    `percentAmountPerBill` float NOT NULL CHECK(percentAmountPerBill > 0.0 AND percentAmountPerBill <= 1.0),
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

-- check if creation is possible, cannot exceed 1.0
DROP TRIGGER IF EXISTS max_bill_acompte_reached_insert;
DELIMITER $$
CREATE TRIGGER IF NOT EXISTS max_bill_acompte_reached_insert
BEFORE INSERT ON ACOMPTE_tj
FOR EACH ROW
BEGIN
    DECLARE totalPercentUsed double;
    SELECT SUM(percentAmountPerBill) INTO totalPercentUsed FROM ACOMPTE_tj WHERE idPaiement = new.idPaiement;
    IF new.percentAmountPerBill + totalPercentUsed > 1.0 THEN
        SIGNAL SQLSTATE '02001' SET MESSAGE_TEXT = 'Illegal Values upon insert: linked paiement is already too muched used in other acompte to apply percentAmountPerBill!';
    END IF;
END$$
DROP TRIGGER IF EXISTS max_bill_acompte_reached_update$$
CREATE TRIGGER IF NOT EXISTS max_bill_acompte_reached_update
BEFORE UPDATE ON ACOMPTE_tj
FOR EACH ROW
BEGIN
    DECLARE totalPercentUsed double;
    SELECT SUM(percentAmountPerBill) INTO totalPercentUsed FROM ACOMPTE_tj WHERE idPaiement = new.idPaiement;
    IF new.percentAmountPerBill + totalPercentUsed > 1.0 THEN
        SIGNAL SQLSTATE '02002' SET MESSAGE_TEXT = 'Illegal Values upon update: linked paiement is already too muched used in other acompte to apply percentAmountPerBill!';
    END IF;
END$$
DELIMITER ;


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
    `availabilityStatus` varchar(20) NOT NULL CHECK(availabilityStatus IN("in stock", "available", "not available", "out of stock")),
    `supplierDiscountPercent` float CHECK(supplierDiscountPercent IS NULL OR (supplierDiscountPercent >= 0.0 AND supplierDiscountPercent <= 1.0)),
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