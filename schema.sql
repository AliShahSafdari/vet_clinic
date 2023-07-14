/* Database schema to keep the structure of entire database. */

CREATE TABLE animals(
   id INT PRIMARY KEY     NOT NULL,
   name           varchar(100)    NOT NULL,
   date_of_birth     date            NOT NULL,
   escape_attempts  INT,
   neutered   boolean,
   weight_kg  decimal(5,2),
);

/* Add species column in animals table*/
ALTER TABLE animals ADD species VARCHAR(150);

-- owners Table
CREATE TABLE owners(
   id  SERIAL PRIMARY KEY,
   full_name    VARCHAR(100)     NOT NULL,
   age      INT      NOT NULL
);

-- species Table
CREATE TABLE species(
   id  SERIAL PRIMARY KEY,
   name    VARCHAR(100)     NOT NULL
);
-- Make sure that id is set as autoincremented PRIMARY KEY
ALTER TABLE animals DROP COLUMN id;
ALTER TABLE animals ADD COLUMN id SERIAL PRIMARY KEY;

/* Remove species column in animals table*/
ALTER TABLE animals DROP COLUMN species;

-- Add column species_id which is a foreign key referencing species table
ALTER TABLE animals ADD COLUMN species_id INT;
ALTER TABLE animals ADD CONSTRAINT fk_species FOREIGN KEY(species_id) REFERENCES species(id);

-- Add column owner_id which is a foreign key referencing the owners table
ALTER TABLE animals ADD COLUMN owner_id INT;
ALTER TABLE animals ADD CONSTRAINT fk_owners FOREIGN KEY(owner_id) REFERENCES owners(id);

-- Create a table named vets with the following columns:
-- id: integer (set it as autoincremented PRIMARY KEY)
-- name: string
-- age: integer
-- adate_of_graduation: date
CREATE TABLE vets(
   id  SERIAL PRIMARY KEY,
   name    VARCHAR(100)     NOT NULL,
   age     INT            NOT NULL,
   adate_of_graduation   date
);

-- There is a many-to-many relationship between the tables species and vets: a vet can specialize in multiple species,
--  and a species can have multiple vets specialized in it. Create a "join table" called specializations to handle this relationship.

CREATE TABLE specializations(
    species_id INTEGER REFERENCES species(id),
    vets_id INTEGER REFERENCES vets(id),
    CONSTRAINT specializations_pk PRIMARY KEY(species_id,vets_id)
     );

-- There is a many-to-many relationship between the tables animals and vets: an animal can visit multiple vets 
-- and one vet can be visited by multiple animals.
--  Create a "join table" called visits to handle this relationship, it should also keep track of the date of the visit.

CREATE TABLE visits(
    animal_id INTEGER REFERENCES animals(id),
    vets_id INTEGER REFERENCES vets(id),
    adate_of_visit  date, 
    CONSTRAINT visits_pk PRIMARY KEY(animal_id,vets_id,adate_of_visit)
     );

