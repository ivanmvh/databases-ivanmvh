/* Populate ANIMALS with sample data. */

INSERT INTO animals(name, date_of_birth, escape_attempts, neutered, weight_kg)
SELECT 'Agumon', '2020-02-03', 0, true, 10.23
UNION
SELECT 'Gabumon', '2018-11-15', 2, true, 8
UNION
SELECT 'Pikachu', '2021-01-07', 1, false, 15.04
UNION
SELECT 'Devimon', '2017-05-12', 5, true, 11;

BEGIN;
INSERT INTO animals(name, date_of_birth, escape_attempts, neutered, weight_kg) 
VALUES ('Charmander', '2020-02-08', 0, false, -11), 
       ('Plantmon', '2021-11-15', 2, true, -5.7), 
       ('Squirtle', '1993-04-02', 3, false, -12.13), 
       ('Angemon', '2005-06-12', 1, true, -45), 
       ('Boarmon', '2005-06-07', 7, true, 20.4), 
       ('Blossom', '1998-10-13', 3, true, 17), 
       ('Ditto', '2022-05-14', 4, true, 22);

COMMIT;

/* Insert data in the owners table */

BEGIN;

INSERT INTO owners(full_name, age)
VALUES ('Sam Smith', 34),
       ('Jennifer Orwell', 19),
       ('Bob', 45),
       ('Melody Pond', 77),
       ('Dean Winchester', 14),
       ('Jodie Whittaker', 38);

COMMIT;

/* Insert data in species table */

BEGIN;

INSERT INTO species(name)
VALUES ('Pokemon'),
       ('Digimon');

COMMIT;


/* Modify owner information in animals table */
BEGIN;
UPDATE animals
SET owner_id = 
    CASE 
    WHEN name = 'Agumon' THEN 1
    WHEN name = 'Gabumon' OR name = 'Pikachu' THEN 2
    WHEN name = 'Devimon' OR name = 'Plantmon' THEN 3
    WHEN name = 'Charmander' OR name = 'Squirtle' OR name = 'Blossom' THEN 4
    WHEN name = 'Angemon' OR name = 'Boarmon' THEN 5
    ELSE NULL
    END;
COMMIT;

/* check Modify owner informatiom @im */
select a."name", a.owner_id,o.full_name from animals a, owners o where a.owner_id = o.id order by a.owner_id

/* Modify your inserted animals so it includes the species_id value: */

UPDATE animals
SET species_id =
    CASE
    WHEN name LIKE '%mon' THEN 2
    ELSE 1
    END;

select * from animals;  

/* Vet clinic database: add "join table" for visits */

/* Insert the following data for vets */

INSERT INTO vets (name, age, date_of_graduation) 
VALUES 
    ('William Tatcher', 45, '2000-04-23'),
    ('Maisy Smith', 26, '2019-01-17'),
    ('Stephanie Mendez', 64, '1981-05-04'),
    ('Jack Harkness', 38, '2008-06-08');

/* Insert the following data for specialties */
INSERT INTO specializations(vet_id, species_id)
VALUES 
        (1, 1),
        (3, 1),
        (3, 2),
        (4, 2);

/* Insert the following data for visits */
INSERT INTO visit(animal_id, vet_id, date_of_visits)
VALUES
    (1, 1, '2020-05-24'),
    (1, 3, '2020-07-22'),
    (2, 4, '2021-02-02'),
    (1, 2, '2020-01-05'),
    (1, 2, '2020-03-08'),
    (1, 2, '2020-05-14'),
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
    (10, 1, '2021-01-11');
