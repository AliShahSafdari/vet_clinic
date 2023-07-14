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


-- Write queries (using JOIN) to answer the following questions:

-- 1 What animals belong to Melody Pond?
SELECT full_name, name from owners INNER JOIN animals ON owners.id = animals.owner_id  WHERE full_name='Melody Pond';

-- 2 List of all animals that are pokemon (their type is Pokemon).
SELECT a.name, s.name from species s INNER JOIN animals a ON s.id = a.species_id  WHERE s.name='Pokemon';

-- 3 List all owners and their animals, remember to include those that don't own any animal.
SELECT full_name as owners_name, name as animal_name from owners LEFT OUTER JOIN animals ON owners.id = animals.owner_id;

-- 4 How many animals are there per species?
SELECT s.name, count(*) as total from species s INNER JOIN animals a ON s.id = a.species_id GROUP BY s.name;

-- 5 List all Digimon owned by Jennifer Orwell.
SELECT o.full_name as owners_name, a.name as animal_name,  s.name as species_name from owners o INNER JOIN animals a ON o.id = a.owner_id 
 INNER JOIN species s ON s.id = a.species_id   WHERE o.full_name='Jennifer Orwell' And s.name='Digimon';

-- 6 List all animals owned by Dean Winchester that haven't tried to escape.
SELECT o.full_name as owners_name, a.name as animal_name, a.escape_attempts from owners o INNER JOIN animals a ON o.id = a.owner_id 
 WHERE full_name='Dean Winchester' AND escape_attempts = 0 ;

-- 7 Who owns the most animals?

SELECT o.full_name as owner_name, COUNT(a.id) as number_of_animals FROM animals a JOIN owners o ON a.owner_id = o.id GROUP BY 
o.full_name ORDER BY number_of_animals DESC LIMIT 1;


-- Write queries to answer the following:

--1 Who was the last animal seen by William Tatcher?
SELECT vs.name as name, v.adate_of_visit FROM visits v INNER JOIN
 vets vs  ON vs.id = v.vets_id WHERE vs.name ='William Tatcher' ORDER BY v.adate_of_visit DESC LIMIT 1;

--2 How many different animals did Stephanie Mendez see?
SELECT count( DISTINCT a.name) FROM visits v INNER JOIN
 vets vs  ON vs.id = v.vets_id  INNER JOIN animals a ON a.id= v.animal_id  WHERE vs.name ='Stephanie Mendez';

--3 List all vets and their specialties, including vets with no specialties.
SELECT vs.name as name, sp.name as species_name FROM specializations s RIGHT OUTER JOIN
 vets vs  ON vs.id = s.vets_id  LEFT OUTER JOIN species sp ON sp.id = s.species_id;

--4 List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT vs.name as name, v.adate_of_visit,a.name as animals_name FROM visits v INNER JOIN
 vets vs  ON vs.id = v.vets_id  INNER JOIN animals a ON a.id= v.animal_id  WHERE vs.name ='Stephanie Mendez'
  AND adate_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

--5 What animal has the most visits to vets?
SELECT a.name as animals_name, count(a.name) FROM visits v INNER JOIN
 vets vs  ON vs.id = v.vets_id  INNER JOIN animals a ON a.id= v.animal_id 
 GROUP BY a.name ORDER BY count( a.name) DESC LIMIT 1;

--6 Who was Maisy Smith's first visit?
SELECT vs.name as name, v.adate_of_visit,a.name as animals_name FROM visits v INNER JOIN
 vets vs  ON vs.id = v.vets_id  INNER JOIN animals a ON a.id= v.animal_id  
 WHERE vs.name ='Stephanie Mendez'  ORDER BY adate_of_visit LIMIT 1;

--7 Details for most recent visit: animal information, vet information, and date of visit.

SELECT vs.name as name, v.adate_of_visit,a.name as animals_name FROM visits v INNER JOIN
 vets vs  ON vs.id = v.vets_id  INNER JOIN animals a ON a.id= v.animal_id  
 ORDER BY adate_of_visit DESC LIMIT 1;

--8 How many visits were with a vet that did not specialize in that animal's species?

  SELECT COUNT(*) FROM visits v JOIN animals a ON a.id = v.animal_id
  JOIN vets vs ON vs.id = v.vets_id LEFT JOIN specializations spec ON
  spec.vets_id = vs.id AND spec.species_id = a.species_id WHERE spec.vets_id IS NULL;


--9  What specialty should Maisy Smith consider getting? Look for the species she gets the most.
 SELECT COUNT(visits.animal_id) FROM visits where vets_id =
 (select id from vets WHERE name = 'Maisy Smith') AND 
 animal_id IN (SELECT id from animals WHERE species_id =
  (SELECT id FROM species WHERE name = 'Digimon'));