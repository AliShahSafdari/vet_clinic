/*Find all animals whose name ends in "mon".*/
SELECT * FROM animals WHERE name LIKE '%mon';
/*List the name of all animals born between 2016 and 2019.*/
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
/*List the name of all animals that are neutered and have less than 3 escape attempts.*/
SELECT name FROM animals WHERE neutered=true  AND escape_attempts<3;
/*List the date of birth of all animals named either "Agumon" or "Pikachu".*/
SELECT date_of_birth FROM animals WHERE name='Agumon'  OR name='Pikachu';
/*List name and escape attempts of animals that weigh more than 10.5kg*/
SELECT (name,escape_attempts) FROM animals WHERE weight_kg>10.5;
/*Find all animals that are neutered.*/
SELECT name FROM animals WHERE neutered=true;
/*Find all animals not named Gabumon.*/
SELECT * FROM animals WHERE name NOT LIKE 'Gabumon';
/*Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg)*/
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

/*Inside a transaction update the animals table by setting the species column to unspecified.
Verify that change was made. Then roll back the change and verify that the species columns went back to the state before the transaction.*/

-- start a transaction
BEGIN TRANSACTION;

-- Update animals table 
UPDATE animals
SET species = 'unspecified';
SELECT * FROM animals;
-- Roll it back later
ROLLBACK;
SELECT * FROM animals;


--Inside a transaction:
/*
Update the animals table by setting the species column to digimon for all animals that have a name ending in mon.
Update the animals table by setting the species column to pokemon for all animals that don't have species already set.
Verify that changes were made.
Commit the transaction.
Verify that changes persist after commit.
*/

BEGIN TRANSACTION;

UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';

UPDATE animals SET species = 'pokemon' WHERE name NOT LIKE '%mon';

SELECT * FROM animals;

COMMIT;

SELECT * FROM animals;


/*
Now, take a deep breath and... Inside a transaction delete all records in the animals table, then roll back the transaction.
After the rollback verify if all records in the animals table still exists. After that, you can start breathing as usual ;)
*/
BEGIN TRANSACTION;

DELETE FROM animals;

ROLLBACK;

SELECT * FROM animals;


-- Inside a transaction:
/*Delete all animals born after Jan 1st, 2022.
Create a savepoint for the transaction.
Update all animals' weight to be their weight multiplied by -1.
Rollback to the savepoint
Update all animals' weights that are negative to be their weight multiplied by -1.
Commit transaction
*/
BEGIN TRANSACTION;

DELETE FROM animals WHERE date_of_birth > '2022-01-01';

SAVEPOINT firstSavePoint;

UPDATE animals SET weight_kg = weight_kg * -1 ;

ROLLBACK To firstSavePoint;

UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;

COMMIT;

SELECT * FROM animals;


-- Write queries to answer the following questions:
-- How many animals are there?
SELECT count(*) FROM animals;

-- How many animals have never tried to escape?
SELECT count(*) FROM animals WHERE escape_attempts = 0;

-- What is the average weight of animals?
SELECT AVG(weight_kg) FROM animals;

-- Who escapes the most, neutered or not neutered animals?
SELECT neutered, MAX(escape_attempts) FROM animals GROUP BY neutered;

-- What is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, AVG(escape_attempts) AS average_escape_attempts
FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY species;

/*
Write queries (using JOIN) to answer the following questions:
What animals belong to Melody Pond?
List of all animals that are pokemon (their type is Pokemon).
List all owners and their animals, remember to include those that don't own any animal.
How many animals are there per species?
List all Digimon owned by Jennifer Orwell.
List all animals owned by Dean Winchester that haven't tried to escape.
Who owns the most animals?
*/
