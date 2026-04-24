-- Speeds up wild Pokémon lookups filtered or joined by region.
CREATE INDEX index_wildpokemon_region ON WildPokemon (region_id);

-- Speeds up wild Pokémon lookups filtered or joined by Pokémon species.
CREATE INDEX index_wildpokemon_pokemon ON WildPokemon (pokemon_id);

-- Speeds up joins from Pokémon records to their assigned type rows.
CREATE INDEX idx_pokemontypes_pokemon_id ON PokemonTypes (pokemon_id);

-- Speeds up joins and filters that find Pokémon by type.
CREATE INDEX idx_pokemontypes_type_id ON PokemonTypes (type_id);

-- Speeds up trainer lookups filtered by home town.
CREATE INDEX index_trainer_home_town ON Trainer (home_town_id);

-- Shows the trainer home town index in the query plan.
EXPLAIN SELECT * FROM Trainer WHERE home_town_id = 1;

-- Shows how MySQL plans joins between wild encounters, regions, and Pokémon species.
EXPLAIN
SELECT p.name AS pokemon_name, r.name AS region, w.location_description, w.min_level, w.max_level
FROM
    WildPokemon AS w
    JOIN Region AS r ON w.region_id = r.region_id
    JOIN Pokemon AS p ON w.pokemon_id = p.pokemon_id;
