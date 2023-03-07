/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES  */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

DROP TABLE IF EXISTS "animals";
CREATE TABLE IF NOT EXISTS "animals" (
	"id" INTEGER NOT NULL,
	"name" CHAR(150) NOT NULL,
	"date_of_birth" DATE NULL DEFAULT NULL,
	"escape_attempts" SMALLINT NOT NULL DEFAULT '0',
	"neutered" BOOLEAN NOT NULL DEFAULT 'false',
	"weight_kg" NUMERIC(10,2) NULL DEFAULT NULL,
	"species_id" INTEGER NULL DEFAULT NULL,
	"owner_id" INTEGER NULL DEFAULT NULL,
	PRIMARY KEY ("id"),
	CONSTRAINT "dk_owner_id" FOREIGN KEY ("owner_id") REFERENCES "owners" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT "fk_species_id" FOREIGN KEY ("species_id") REFERENCES "species" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);

DELETE FROM "animals";
/*!40000 ALTER TABLE "animals" DISABLE KEYS */;
INSERT INTO "animals" ("id", "name", "date_of_birth", "escape_attempts", "neutered", "weight_kg", "species_id", "owner_id") VALUES
	(1, 'Pikachu                                                                                                                                               ', '2021-01-07', 1, 'false', 15.04, 1, 2),
	(2, 'Agumon                                                                                                                                                ', '2020-02-03', 0, 'true', 10.23, 2, 1),
	(3, 'Devimon                                                                                                                                               ', '2017-05-12', 5, 'true', 11.00, 2, 3),
	(4, 'Gabumon                                                                                                                                               ', '2018-11-15', 2, 'true', 8.00, 2, 2),
	(5, 'Charmander                                                                                                                                            ', '2020-02-08', 0, 'false', 11.00, 1, 4),
	(9, 'Boarmon                                                                                                                                               ', '2005-06-07', 7, 'true', 20.40, 2, 5),
	(10, 'Blossom                                                                                                                                               ', '1998-10-13', 3, 'true', 17.00, 1, 4),
	(6, 'Plantmon                                                                                                                                              ', '2021-11-15', 2, 'true', 5.70, 2, 3),
	(8, 'Angemon                                                                                                                                               ', '2005-06-12', 1, 'true', 45.00, 2, 5),
	(7, 'Squirtle                                                                                                                                              ', '1993-04-02', 3, 'false', 12.13, 1, 4);
/*!40000 ALTER TABLE "animals" ENABLE KEYS */;

DROP TABLE IF EXISTS "owners";
CREATE TABLE IF NOT EXISTS "owners" (
	"id" INTEGER NOT NULL,
	"full_name" VARCHAR(200) NULL DEFAULT NULL,
	"age" INTEGER NULL DEFAULT NULL,
	PRIMARY KEY ("id")
);

DELETE FROM "owners";
/*!40000 ALTER TABLE "owners" DISABLE KEYS */;
INSERT INTO "owners" ("id", "full_name", "age") VALUES
	(1, 'Sam Smith', 34),
	(2, 'Jennifer Orwell', 19),
	(3, 'Bob', 45),
	(4, 'Melody Pond', 77),
	(5, 'Dean Winchester', 14),
	(6, 'Jodie Whittaker', 38);
/*!40000 ALTER TABLE "owners" ENABLE KEYS */;

DROP TABLE IF EXISTS "specializations";
CREATE TABLE IF NOT EXISTS "specializations" (
	"vet_id" INTEGER NOT NULL,
	"species_id" INTEGER NOT NULL,
	PRIMARY KEY ("vet_id", "species_id"),
	CONSTRAINT "specializations_species_id_fkey" FOREIGN KEY ("species_id") REFERENCES "species" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT "specializations_vet_id_fkey" FOREIGN KEY ("vet_id") REFERENCES "vets" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);

DELETE FROM "specializations";
/*!40000 ALTER TABLE "specializations" DISABLE KEYS */;
INSERT INTO "specializations" ("vet_id", "species_id") VALUES
	(1, 1),
	(3, 1),
	(3, 2),
	(4, 2);
/*!40000 ALTER TABLE "specializations" ENABLE KEYS */;

DROP TABLE IF EXISTS "species";
CREATE TABLE IF NOT EXISTS "species" (
	"id" INTEGER NOT NULL,
	"name" VARCHAR(200) NULL DEFAULT NULL,
	PRIMARY KEY ("id")
);

DELETE FROM "species";
/*!40000 ALTER TABLE "species" DISABLE KEYS */;
INSERT INTO "species" ("id", "name") VALUES
	(1, 'Pokemon'),
	(2, 'Digimon');
/*!40000 ALTER TABLE "species" ENABLE KEYS */;

DROP TABLE IF EXISTS "vets";
CREATE TABLE IF NOT EXISTS "vets" (
	"id" INTEGER NOT NULL,
	"name" VARCHAR(200) NULL DEFAULT NULL,
	"age" INTEGER NULL DEFAULT NULL,
	"date_of_graduation" DATE NULL DEFAULT NULL,
	PRIMARY KEY ("id")
);

DELETE FROM "vets";
/*!40000 ALTER TABLE "vets" DISABLE KEYS */;
INSERT INTO "vets" ("id", "name", "age", "date_of_graduation") VALUES
	(1, 'William Tatcher', 45, '2000-04-23'),
	(2, 'Maisy Smith', 26, '2019-01-17'),
	(3, 'Stephanie Mendez', 64, '1981-05-04'),
	(4, 'Jack Harkness', 38, '2008-06-08');
/*!40000 ALTER TABLE "vets" ENABLE KEYS */;

DROP TABLE IF EXISTS "visits";
CREATE TABLE IF NOT EXISTS "visits" (
	"animal_id" INTEGER NOT NULL,
	"vet_id" INTEGER NOT NULL,
	"date_of_visits" DATE NOT NULL,
	PRIMARY KEY ("animal_id", "vet_id", "date_of_visits"),
	CONSTRAINT "visits_animal_id_fkey" FOREIGN KEY ("animal_id") REFERENCES "animals" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT "visits_vet_id_fkey" FOREIGN KEY ("vet_id") REFERENCES "vets" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);

DELETE FROM "visits";
/*!40000 ALTER TABLE "visits" DISABLE KEYS */;
INSERT INTO "visits" ("animal_id", "vet_id", "date_of_visits") VALUES
	(1, 1, '2020-05-24'),
	(1, 3, '2020-07-22'),
	(2, 4, '2021-02-02'),
	(4, 3, '2021-05-04'),
	(5, 4, '2021-02-24'),
	(6, 2, '2019-12-21'),
	(6, 1, '2020-08-10'),
	(6, 2, '2021-04-07'),
	(7, 3, '2019-09-29'),
	(8, 4, '2020-10-03'),
	(8, 4, '2020-11-04'),
	(9, 2, '2019-01-24'),
	(9, 2, '2019-05-15'),
	(9, 2, '2020-02-27'),
	(9, 2, '2020-08-03'),
	(10, 3, '2020-05-24'),
	(10, 1, '2021-01-11'),
	(1, 2, '2020-01-05'),
	(1, 2, '2020-03-08'),
	(1, 2, '2020-05-14');
/*!40000 ALTER TABLE "visits" ENABLE KEYS */;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
