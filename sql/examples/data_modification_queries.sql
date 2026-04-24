-- Because of constraints Delete statements can only be run properly with triggers present

-- Update pokemon level by 1 for each pokemon with trainer_id = 4
UPDATE TrainerPokemon AS tp
SET
    tp.pokemon_level = tp.pokemon_level + 1
WHERE
    tp.trainer_id = 4;

-- Delete all of trainer 6's pokemon
DELETE FROM TrainerPokemon WHERE trainer_id = 6;

-- Update a pokemons base hp
UPDATE Pokemon SET base_hp = 46 where pokemon_id = 1;

--Updates a Trainer's age
UPDATE Trainer SET age = 55 WHERE name = 'Brock';

--Delete a Town's Gym
DELETE FROM Gym
WHERE
    town_id = (
        SELECT town_id
        FROM Town
        WHERE
            name = 'Pewter City'
    );