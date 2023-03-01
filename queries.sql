/*Queries that provide answers to the questions from all projects.*/

/* all animals */
SELECT * FROM public.animals

/*  Find all animals whose name ends in "mon". */
SELECT * FROM public.animals where  TRIM(name) LIKE '%mon%';

/*  List the name of all animals born between 2016 and 2019. */
SELECT name FROM public.animals WHERE '[2016-01-01, 2019-12-31]'::daterange @> date_of_birth;

/*  List the name of all animals that are neutered and have less than 3 escape attempts. */
SELECT name FROM public.animals WHERE neutered AND escape_attempts < 3;

/*  List the date of birth of all animals named either "Agumon" or "Pikachu". */
SELECT name,date_of_birth FROM public.animals WHERE name IN ('Agumon', 'Pikachu');

/*  List name and escape attempts of animals that weigh more than 10.5kg */
SELECT name, escape_attempts, weight_kg FROM public.animals WHERE weight_kg > 10.5	;

/*  Find all animals that are neutered. */
SELECT * FROM public.animals WHERE neutered	;

/*  Find all animals not named Gabumon. */
SELECT * FROM public.animals WHERE name <> 'Gabumon';

/*  Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg) */
SELECT * FROM public.animals WHERE weight_kg BETWEEN 10.4 AND 17.3;


/* Inside a transaction update the animals table by setting the species column to unspecified. Verify that change was made. Then roll back the change and verify that the species columns went back to the state before the transaction. */

BEGIN;
UPDATE animals SET species='unspecified';
SELECT * FROM animals;

ROLLBACK;

/* Change the species from animals ended in mon with commit */

BEGIN;

UPDATE animals
SET species = 'digimon'
WHERE trim(name) LIKE '%mon';

UPDATE animals
SET species = 'pokemon'
WHERE species IS NULL;

COMMIT;
SELECT * FROM animals;

/* Inside a transaction delete all records in the animal's table, then roll back the transaction. */

BEGIN;
DELETE FROM animals;
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

/*
Inside a transaction:
  Delete all animals born after Jan 1st, 2022.
  Create a savepoint for the transaction.
  Update all animals' weight to be their weight multiplied by -1.
  Rollback to the savepoint
  Update all animals' weights that are negative to be their weight multiplied by -1.
  Commit transaction
*/

BEGIN;

DELETE FROM animals
WHERE date_of_birth > '2022-01-01';

SAVEPOINT SP1;

UPDATE animals
SET weight_kg = weight_kg * -1;

ROLLBACK TO SP1

UPDATE animals
SET weight_kg = weight_kg * -1
WHERE weight_kg  < 0;

COMMIT;

/* 3-1-How many animals are there?  */

SELECT COUNT(*) FROM animals;










