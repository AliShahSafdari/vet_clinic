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
