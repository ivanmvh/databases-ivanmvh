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

SELECT * FROM animals;

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
SELECT * FROM animals;
ROLLBACK TO SP1
SELECT * FROM animals;

UPDATE animals
SET weight_kg = weight_kg * -1
WHERE weight_kg  < 0;

COMMIT;

SELECT * FROM animals;
/* 3-1-How many animals are there?  */

SELECT COUNT(*) FROM animals;

/* How many animals have never tried to escape? */

SELECT COUNT(*) FROM animals
WHERE escape_attempts = 0;

/* What is the average weight of animals? */

SELECT AVG(weight_kg) FROM animals;

/* Who escapes the most, neutered or not neutered animals? */

SELECT neutered, SUM(escape_attempts)
FROM animals
GROUP BY neutered;

/* What is the minimum and maximum weight of each type of animal? */

SELECT species, MIN(weight_kg) AS min_weight, MAX(weight_kg) AS max_weight
FROM animals
GROUP BY species;

/* What is the average number of escape attempts per animal type of those born between 1990 and 2000? */

SELECT species, AVG(escape_attempts)
FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY species;

/* What animals belong to Melody Pond?*/

SELECT a.name as animal, o.full_name as owner
FROM animals a
JOIN owners o
ON a.owner_id = o.id
WHERE o.full_name = 'Melody Pond';

/*  List of all animals that are pokemon (their type is Pokemon). */

SELECT a.name as animal_name, s.name as type_animal
FROM animals a
JOIN species s
ON a.species_id = s.id
WHERE s.name = 'Pokemon';

/* List all owners and their animals, remember to include those that don't own any animal */

SELECT o.full_name as owner_name, a.name as animal_name
FROM owners o
LEFT JOIN animals a
ON o.id = a.owner_id
order by o.full_name;

/* How many animals are there per species? */

SELECT s.name AS specie_name, COUNT(*) AS total_animals
FROM animals a
JOIN species s
ON a.species_id = s.id
GROUP BY s.name;

/* List all Digimon owned by Jennifer Orwell. (without JOIN) */
SELECT o.full_name as owner_name, s.name as specie_name, a.name
FROM owners o, animals a , species s
where a.owner_id = o.id and o.full_name = 'Jennifer Orwell' 
  and a.species_id = s.id and s.name = 'Digimon'

/* List all Digimon owned by Jennifer Orwell. (with JOIN) */

SELECT o.full_name as owner_name, s.name as specie_name, a.name as animal_name
FROM animals a
JOIN species s
ON a.species_id = s.id
JOIN owners o
ON a.owner_id = o.id
WHERE o.full_name = 'Jennifer Orwell' AND s.name ='Digimon';

/* List all animals owned by Dean Winchester that haven't tried to escape.*/
SELECT o.full_name as owner_name, a.name as animal_name, a.escape_attempts
FROM animals a
JOIN owners o
ON a.owner_id = o.id
WHERE o.full_name = 'Dean Winchester' AND a.escape_attempts = 0;

/* Who owns the most animals? */

SELECT o.full_name as owner_name, COUNT(*) AS number_of_animals
FROM owners o
JOIN animals a
ON a.owner_id = o.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

/* Raw data view used in queries */
SELECT a.name as animal, s.name as specie, o.full_name as owner, a.escape_attempts FROM animals a
join species s ON s.id = a.species_id
RIGHT join owners o ON o.id = a.owner_id

/* Vet clinic database: add "join table" for visits */

/* Who was the last animal seen by William Tatcher? */

SELECT a.name as last_animal_view, ve.name as by_vet_name, vi.date_of_visits as on_date
FROM animals a
JOIN visits vi
ON a.id = vi.animal_id
JOIN vets ve
ON ve.id = vi.vet_id
WHERE ve.name = 'William Tatcher'
ORDER BY vi.date_of_visits DESC
LIMIT 1;

/* How many different animals did Stephanie Mendez see? */

SELECT ve.name as vet_name, COUNT(a.id) AS animals_seen
FROM animals a
JOIN visits vi
ON a.id = vi.animal_id
JOIN vets ve
ON ve.id = vi.vet_id
GROUP BY ve.name
HAVING ve.name = 'Stephanie Mendez';

/* List all vets and their specialties, including vets with no specialties. */

SELECT v.id as vet_id, v.name as vet_name , sp.name AS specialization
FROM vets v
LEFT JOIN specializations s
ON v.id = s.vet_id
LEFT JOIN species sp
ON sp.id = s.species_id;

/* List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020. */

SELECT a.name animal, v.name as vet_name, d.date_of_visits
FROM vets v
JOIN visits d
ON v.id = d.vet_id
JOIN animals a 
ON a.id = d.animal_id
WHERE d.date_of_visits BETWEEN '2020-04-01' AND '2020-08-30'
AND v.name = 'Stephanie Mendez';

/* What animal has the most visits to vets? */

SELECT a.id as animal_id, a.name as animal_name, COUNT(*) AS number_of_visits
FROM animals a
JOIN visits vi
ON vi.animal_id = a.id
GROUP BY a.id, a.name
ORDER BY 3 DESC
LIMIT 1;

/* Who was Maisy Smith's first visit? */

SELECT a.name as animal_name, ve.name as vet_name, vi.date_of_visits
FROM vets ve 
JOIN visits vi
ON vi.vet_id = ve.id
JOIN animals a
ON a.id = vi.animal_id
WHERE ve.name = 'Maisy Smith'
ORDER BY date_of_visits ASC
LIMIT 1;

/*  Details for most recent visit: animal information, vet information, and date of visit. */

SELECT a.name AS a_name, s.name as specie, a.date_of_birth AS a_date_of_birth,
       a.neutered AS a_neutered, a.weight_kg AS a_weight_kg,
       v.name AS vet_name, v.date_of_graduation AS v_date_of_graduation,
       d.date_of_visits AS date_of_visits,
	   owners.full_name as owner
FROM animals a
JOIN visits d ON d.animal_id = a.id
JOIN vets v ON v.id = d.vet_id
JOIN owners ON owners.id = a.owner_id
JOIN species s ON s.id = a.species_id
ORDER BY d.date_of_visits DESC
LIMIT 1;

/* How many visits were with a vet that did not specialize in that animal's species? */
/* Query to count the number of visits including vets without SPECIALIZATION (left join) */ 

SELECT COUNT(*) AS number_of_visits
FROM animals a
LEFT JOIN visits vi ON vi.animal_id = a.id
LEFT JOIN specializations sp ON sp.vet_id = vi.vet_id
LEFT JOIN vets ve ON ve.id = sp.vet_id
WHERE a.species_id != sp.species_id OR ve.name IS NULL

/* What specialty should Maisy Smith consider getting? Look for the species she gets the most. */

SELECT  sp.name, COUNT(*) AS total_visited
FROM vets ve
JOIN visits vi ON  ve.id = vi.vet_id
JOIN animals a ON a.id = vi.animal_id
JOIN species sp ON sp.id = a.species_id
WHERE ve.name = 'Maisy Smith'
GROUP BY sp.name;
