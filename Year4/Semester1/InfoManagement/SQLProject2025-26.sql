-- Information Management Project Code - Ane O'Byrne
-- File Context: Zoo Management SQL

-- Database creation (Only if it doesn't exist -> avoid dubplicates)
 CREATE DATABASE IF NOT EXISTS zoo_db;
 USE zoo_db;

-- Order of script re-run to be safe (delete old ones to recreate them safely)
SET FOREIGN_KEY_CHECKS = 0; -- To be able to delete tables even if linked
-- Drop tables in reverse order to delte dependent ones first, avoid collapses
DROP TABLE IF EXISTS Breeding;
DROP TABLE IF EXISTS Feeding;
DROP TABLE IF EXISTS MedicalRecord;
DROP TABLE IF EXISTS Animal;
DROP TABLE IF EXISTS Keeper;
DROP TABLE IF EXISTS Enclosure;
SET FOREIGN_KEY_CHECKS = 1; -- Turn protection rule back

-- -------------------------- TABLE CREATIONS --------------------------------------
-- 1. Create Base Tables (Regular Entities) From independent to dependet
CREATE TABLE Enclosure ( -- ENCLOSURE TABLE: Where Zoo Animals Live --
 enclosure_id INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID that increments when more are added
 type         VARCHAR(50) NOT NULL, -- Type of enclosure
 capacity     INT NOT NULL CHECK (capacity >= 0), -- Max num of animals (no negative numbers)
 location     VARCHAR(100) -- Location of enclosure (where)
) ENGINE=InnoDB; -- Storage engine that supports FK and transactions

CREATE TABLE Keeper ( -- KEEPER TABLE: Zoo Workers that Take Care of Animals --
 keeper_id        INT AUTO_INCREMENT PRIMARY KEY,
 name             VARCHAR(100) NOT NULL,
 experience_level VARCHAR(30),
 supervisor_id    INT NULL, -- Another keeper who supervises this keeper
 CONSTRAINT keeper_supervisor_fk 
  FOREIGN KEY (supervisor_id) REFERENCES Keeper(keeper_id) -- Recursive Foreign Key (FK)
  ON DELETE SET NULL -- No supervisor set to keeper if deleted
  ON UPDATE CASCADE -- Update automatically if supervisor's id changes
) ENGINE=InnoDB;

CREATE TABLE Animal ( -- ANIMAL TABLE: Existing Animals at the Zoo --
 animal_id    INT AUTO_INCREMENT PRIMARY KEY,
 name         VARCHAR(100) NOT NULL,
 species      VARCHAR(100) NOT NULL,
 gender       ENUM('Female', 'Male', 'Unknown') DEFAULT 'Unknown', -- Only three options
 birth_date   DATE,
 enclosure_id INT NULL, -- Links animal to its enclosure
 CONSTRAINT animal_enclosure_fk
  FOREIGN KEY(enclosure_id) REFERENCES Enclosure(enclosure_id) -- enclosure_id in both tables should match
  ON DELETE SET NULL
  ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE MedicalRecord ( -- MEDICAL RECORD TABLE: Medical Info of each Zoo Animal --
 record_id INT AUTO_INCREMENT PRIMARY KEY,
 animal_id INT NOT NULL,
 vet_name  VARCHAR(100),
 diagnosis TEXT,
 treatment TEXT,
 CONSTRAINT medicalrecord_animal_fk
  FOREIGN KEY (animal_id) REFERENCES Animal(animal_id) -- animal_id must match in both tables
  ON DELETE CASCADE
  ON UPDATE CASCADE,
 CONSTRAINT medicalrecord_animal_unique UNIQUE (animal_id) -- 1:1 relationship
) ENGINE=InnoDB;

-- 2. Create Table for Weak Entity: Feeding
CREATE TABLE Feeding ( -- FEEDING TABLE : Feeding action of keepers to animals
 feeding_id   INT AUTO_INCREMENT PRIMARY KEY,
 animal_id    INT NOT NULL,
 keeper_id    INT NOT NULL,
 feeding_time DATETIME DEFAULT CURRENT_TIMESTAMP, -- Current Time as default
 food_type    VARCHAR(100),
 quantity     VARCHAR (50),
 CONSTRAINT feeding_animal_fk FOREIGN KEY (animal_id) REFERENCES Animal(animal_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
 CONSTRAINT feeding_keeper_fk FOREIGN KEY (keeper_id) REFERENCES Keeper(keeper_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
 CONSTRAINT feeding_unique UNIQUE (animal_id, keeper_id, feeding_time)
) ENGINE=InnoDB;
 
 -- 3. Create Table for Recursive Entity: Breeding
 -- ¡Note: For now in this table breeding can only lead to one offspring, if there's time MULTIPLE?!
CREATE TABLE Breeding ( -- BREEDING TABLE: Breeding between two animals to get anothe animal
 breeding_id   INT AUTO_INCREMENT PRIMARY KEY,
 breeding_date DATE,
 parent1_id    INT NOT NULL,
 parent2_id    INT NOT NULL, 
 offspring_id  INT NOT NULL, 
 CONSTRAINT breeding_parent1_fk FOREIGN KEY (parent1_id) REFERENCES Animal(animal_id)
  ON DELETE RESTRICT -- Cannot delete animals in this table
  ON UPDATE CASCADE,
 CONSTRAINT breeding_parent2_fk FOREIGN KEY (parent2_id) REFERENCES Animal(animal_id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
 CONSTRAINT breeding_offspring_fk FOREIGN KEY (offspring_id) REFERENCES Animal(animal_id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
 CONSTRAINT parent_gender_check CHECK (parent1_id <> parent2_id) -- Ensure its not the same animal
 ) ENGINE=InnoDB;
 
 -- -------------------------- ADDED RULES --------------------------------------
DELIMITER $$
 -- 1. Enclosure capacity enforcement: Before inserting an animal in an enclosure, check if capacity isnt exceeded
 CREATE TRIGGER animal_before_insert_trigger
 BEFORE INSERT ON Animal
 FOR EACH ROW
 BEGIN 
   DECLARE occ INT DEFAULT 0; -- occupant (animal)
   DECLARE cap INT DEFAULT 0; -- capacity (enclosure)
  IF NEW.enclosure_id IS NOT NULL THEN
   SELECT COUNT(*) INTO occ FROM Animal WHERE enclosure_id = NEW.enclosure_id;
   SELECT capacity INTO cap FROM Enclosure WHERE enclosure_id = NEW.enclosure_id;
   IF cap IS NULL THEN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'Target enclosure does not exist';
   ELSEIF occ + 1 > cap THEN 
    SET msg = CONCAT('Enclosure capacity exceeded (capacity = ', cap, ', current = ', occ, ').');
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = msg;
   END IF;
 END IF;
END$$

CREATE TRIGGER animal_before_update_trigger -- Rule 1 also applies when updating tables
BEFORE UPDATE ON Animal
FOR EACH ROW
BEGIN 
   DECLARE occ INT DEFAULT 0;
   DECLARE cap INT DEFAULT 0;
  IF (NEW.enclosure_id IS NOT NULL) AND (OLD.enclosure_id <> NEW.enclosure_id) THEN
   SELECT COUNT(*) INTO occ FROM Animal WHERE enclosure_id = NEW.enclosure_id;
   SELECT capacity INTO cap FROM Enclosure WHERE enclosure_id = NEW.enclosure_id;
   IF cap IS NULL THEN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'Target enclosure does not exist';
   ELSEIF occ + 1 > cap THEN
    SET msg = CONCAT('Enclosure capacity exceeded (capacity = ', cap, ', current = ', occ, ').');
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = msg;
   END IF;
 END IF;
END$$

-- 2. Breeding parents must be opposite genders
CREATE TRIGGER breeding_before_insert_trigger
BEFORE INSERT ON Breeding
FOR EACH ROW 
BEGIN 
 DECLARE g1 VARCHAR(10); -- gender of parent 1
 DECLARE g2 VARCHAR(10); -- gender of parent 2
 -- Parents can't be the same animal
 IF NEW.parent1_id = NEW.parent2_id THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Breeding parents must be different animals';
 END IF;
 -- Parents have to have different genders
 SELECT gender INTO g1 FROM Animal WHERE animal_id = NEW.parent1_id;
 IF g1 IS NULL THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Parent 1 does not exist';
 END IF;
 SELECT gender INTO g2 FROM Animal WHERE animal_id = NEW.parent2_id;
 IF g2 IS NULL THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Parent 2 does not exist';
 END IF;
 IF g1 = 'Unknown' OR g2 = 'Unknown' THEN -- must know genders, unknown is not valid either
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Parents gender is Unknown';
 END IF;
 IF NOT ((g1 = 'Female' AND g2 = 'Male') OR (g1 = 'Male' AND g2 = 'Female')) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Parents must be opposite genders';
 END IF;
END$$

DELIMITER ;

-- -------------------------- SAMPLE DATA -------------------------------------- 
INSERT INTO Enclosure (type, capacity, location) VALUES
 ('Reptile House', 20, 'South'),
 ('Artic', 5, 'North'),
 ('Farm', 15, 'South'),
 ('Aviary', 20, 'East'),
 ('Savannah', 10, 'West'),
 ('Amazon', 10, 'East'),
 ('Temperate Forest', 20, 'West');
  
INSERT INTO Keeper (name, experience_level, supervisor_id) VALUES
 ('Bernard Goodwin', 'Senior', NULL), -- supervisor
 ('Nancy Jones', 'Intermediate', NULL),
 ('Samuel Beckett', 'Intermediate', 1),
 ('Lucas Moret', 'Intermediate', 1),
 ('Franklin Sierra', 'Intermediate', 1),
 ('Dominic Myers', 'Intermediate', NULL),
 ('Emma Myers', 'Junjor', 2),
 ('Ane OByrne', 'Junior', 4);
   
INSERT INTO Animal (name, species, gender, birth_date, enclosure_id) VALUES
 ('Dexter', 'Komodo Dragon', 'Male', '08-07-2017', 1),
 ('Elliot', 'Crocodile', 'Male', '06-10-2020', 1),
 ('Fang', 'Crocodile', 'Female', '24-01-2022', 1),
 ('Draco', 'Boa Constrictor', 'Unkown', '01-11-2025', 1),
 ('Lykos', 'Artic Fox', 'Male', '15-10-2023', 2),
 ('Luna', 'Artic Fox', 'Female', '29-08-2023', 2),
 ('Eeyore', 'Donkey', 'Male', '17-06-2019', 3),
 ('Wooly', 'Sheep', 'Female', '05-08-2021', 3),
 ('Shaun', 'Sheep', 'Male', '20-12-2020', 3),
 ('Shia', 'Sheep', 'Female', '08-11-2025', 3),
 ('Rio', 'Toucan', 'Male', '24-05-2023', 4),
 ('Kevin', 'Eagle', 'Male', '26-02-2022', 4),
 ('Brenda', 'Macaw', 'Female', '17-03-2025', 4),
 ('Dumbo', 'Elephat', 'Male', '11-02-2022', 5),
 ('Ruby', 'Elephat', 'Female', '01-01-2018', 5),
 ('Gaston', 'Zebra', 'Female', '22-04-2018', 5),
 ('Daisy', 'Zebra', 'Male', '28-08-2020', 5),
 ('Bagheera', 'Jaguar', 'Female', '06-10-2024', 6),
 ('Nahuel', 'Jaguar', 'Male', '19-09-2024', 6),
 ('Red', 'Red Panda', 'Male', '15-10-2023', 7),
 ('Mei', 'Red Panda', 'Female', '08-11-2025', 7),
 ('Firefox', 'Red Panda', 'Female', '18-03-2022', 7),
 ('Copper', 'Red Panda', 'Male', '20-03-2024', 7),
 ('Bambi', 'Deer', 'Male', '19-10-2018', 7),
 ('Faith', 'Deer', 'Female', '27-01-2020', 7);
 
INSERT INTO MedicalRecord (animal_id, vet_name, diagnosis, treatment) VALUES
 (1, 'Dr. Smith', 'Dental Check', 'Scale cleaning'),
 (3, 'Dr. Smith', 'Dental Check; healthy', 'No treatment'),
 (5, 'Dr. OBrien', 'Routine Check; healthy', 'No treatment'),
 (6, 'Dr. OBrien', 'Routine Check; healthy', 'No treatment'),
 (7, 'Dr. Jhin', 'Laminitis', 'Hoof care'),
 (9, 'Dr. Jhin', 'Blood test', 'Medication'),
 (11, 'Dr. Lee', 'Feather mite', 'Topical'),
 (14, 'Dr. Rakan', 'Wound', 'Antibiotics'),
 (15, 'Dr. Rakan', 'Revision; healthy', 'No treatment'),
 (23, 'Dr. Xayah', 'Routine Check; Illness', 'Surgery'),
 (25, 'Dr. Xayah', 'Routine Check; healthy', 'No treatment');
    
INSERT INTO Feeding (animal_id, keeper_id, feeding_time, food_type) VALUES
 (1, 4, '08-11-2025 08:00:00', 'Meat'),
 (2, 4, '08-11-2025 09:00:00', 'Meat'),
 (3, 4, '08-11-2025 09:00:00', 'Meat'),
 (4, 4, '08-11-2025 20:30:00', 'Rat'),
 (5, 2, '08-11-2025 09:30:00', 'Eggs'),
 (6, 2, '08-11-2025 09:30:00', 'Eggs'),
 (7, 7, '08-11-2025 09:00:00', 'Hay'),
 (8, 7, '08-11-2025 09:30:00', 'Hay'),
 (9, 7, '08-11-2025 09:30:00', 'Hay'),
 (10, 7, '08-11-2025 09:30:00', 'Hay'),
 (11, 3, '08-11-2025 10:00:00', 'Seeds'),
 (12, 3, '08-11-2025 10:20:00', 'Meat'),
 (13, 3, '08-11-2025 11:00:00', 'Seeds'),
 (14, 5, '08-11-2025 13:00:00', 'Leaves'),
 (15, 5, '08-11-2025 13:00:00', 'Leaves'),
 (16, 5, '08-11-2025 13:15:00', 'Leaves'),
 (17, 5, '08-11-2025 13:15:00', 'Leaves'),
 (18, 6, '08-11-2025 07:00:00', 'Meat'),
 (19, 6, '08-11-2025 07:00:00', 'Meat'),
 (20, 8, '08-11-2025 11:00:00', 'Bamboo'),
 (21, 8, '08-11-2025 11:00:00', 'Bamboo'),
 (22, 8, '08-11-2025 11:00:00', 'Bamboo'),
 (23, 8, '08-11-2025 11:00:00', 'Bamboo'),
 (24, 8, '08-11-2025 12:00:00', 'Berries'),
 (25, 8, '08-11-2025 12:00:00', 'Berries');
 
INSERT INTO Breeding (breeding_date, parent1_id, parent2_id, offspring_id) VALUES
 ('08-11-2025', 23, 22, 21),
 ('08-11-2025', 8, 8, 10);
    
    
    
   
