/* Database schema to keep the structure of entire database. */

-- This script was generated by the ERD tool in pgAdmin 4.
-- Please log an issue at https://redmine.postgresql.org/projects/pgadmin4/issues/new if you find any bugs, including reproduction steps.

-- Table: public.animals

-- DROP TABLE IF EXISTS public.animals;

CREATE TABLE IF NOT EXISTS public.animals
(
    id INT GENERATED ALWAYS AS IDENTITY,
    name character(150) COLLATE pg_catalog."default" NOT NULL,
    date_of_birth date,
    escape_attempts smallint NOT NULL DEFAULT 0,
    neutered boolean NOT NULL DEFAULT 'false',
    weight_kg numeric(10,2)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.animals
    OWNER to postgres;

/* Add a column species of type string to your animals table. Modify your schema.sql file. */
BEGIN;
ALTER TABLE animals
ADD COLUMN species VARCHAR(200);
COMMIT;


/* Create a table named owners with the following column */

BEGIN;
CREATE TABLE owners(
  id INT GENERATED ALWAYS AS IDENTITY,
  full_name VARCHAR(200),
  age INT,
  PRIMARY KEY(id)
);
COMMIT;

/* Create a table named species */

BEGIN;
CREATE TABLE species(
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(200),
    PRIMARY KEY(id)
);
COMMIT

/* Remove column species in animals */

BEGIN;

ALTER TABLE animals
DROP COLUMN species;

COMMIT;


/* Add column species_id in animals which is a foreign key referencing species table */

BEGIN;

ALTER TABLE animals
ADD COLUMN species_id INT;

ALTER TABLE animals
ADD CONSTRAINT fk_species_id
FOREIGN KEY (species_id) 
REFERENCES species(id);

COMMIT;

/* Add column owner_id in animals which is a foreign key referencing the owners table */

BEGIN;

ALTER TABLE animals
ADD COLUMN owner_id INT;

ALTER TABLE animals
ADD CONSTRAINT dk_owner_id
FOREIGN KEY(owner_id)
REFERENCES owners(id);

COMMIT;

/* Add PRIMARY KEY to animals table */
BEGIN;

ALTER TABLE animals
ADD PRIMARY KEY(id);

COMMIT;

/* Create a table named vets with the following columns: */

CREATE TABLE vets(
  id INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(200),
  age INT,
  date_of_graduation DATE,
  PRIMARY KEY(id)
);

/* specializations - Join Table between species and vets 
There is a many-to-many relationship between the tables species and vets: 
a vet can specialize in multiple species, and a species can have multiple vets specialized in it.
Create a "join table" called specializations to handle this relationship. */

CREATE TABLE specializations(
  vet_id INTEGER REFERENCES vets(id) ,
  species_id INTEGER REFERENCES species(id),
  PRIMARY KEY(vet_id, species_id)
);

/* visits - Join Table between animals and vets
There is a many-to-many relationship between the tables animals and vets:
an animal can visit multiple vets and one vet can be visited by multiple animals.
Create a "join table" called visits to handle this relationship, it should also keep track of the date of the visit. */

CREATE TABLE visits(
  animal_id INTEGER REFERENCES animals(id),
  vet_id INTEGER REFERENCES vets(id),
  date_of_visits DATE,
  PRIMARY KEY(animal_id, vet_id, date_of_visits)
);

/*
CREATE TABLE visits(
  animal_id INTEGER REFERENCES animals(id),
  vet_id INTEGER REFERENCES vets(id),
  date_of_visits DATE
);
*/

