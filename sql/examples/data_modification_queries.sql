-- Data modification examples for the Pokemon database.
-- Delete examples depend on the trigger setup because related tables use foreign key constraints.

-- Increases the level of every Pokémon owned by trainer 4 by one.
UPDATE TrainerPokemon AS tp
SET
    tp.pokemon_level = tp.pokemon_level + 1
WHERE
    tp.trainer_id = 4;

-- Deletes all owned Pokémon records for trainer 6.
DELETE FROM TrainerPokemon WHERE trainer_id = 6;

-- Updates the base HP value for a specific Pokémon species.
UPDATE Pokemon SET base_hp = 46 where pokemon_id = 1;

-- Updates a trainer's age by trainer name.
UPDATE Trainer SET age = 55 WHERE name = 'Brock';

-- Deletes the gym located in Pewter City.
DELETE FROM Gym
WHERE
    town_id = (
        SELECT town_id
        FROM Town
        WHERE
            name = 'Pewter City'
    );
