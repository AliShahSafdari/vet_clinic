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