-- Lists Pokémon that have the Normal type.
-- Demonstrates joining the species table through the Pokémon-type junction table.
SELECT p.name, t.type_name
FROM Pokemon AS p
         LEFT JOIN PokemonTypes AS pt ON p.pokemon_id = pt.pokemon_id
         LEFT JOIN Types AS t ON t.type_id = pt.type_id
WHERE t.type_name = 'Normal';

-- Lists trainers with their owned Pokémon, nicknames, and current levels.
-- Demonstrates a standard ownership query across Trainer, TrainerPokemon, and Pokémon.
SELECT tr.name          AS Trainer,
       tr.gender,
       tr.age,
       p.name           AS Pokemon,
       tp.nick_name     AS Nickname,
       tp.pokemon_level AS Level
FROM TrainerPokemon AS tp
         JOIN Trainer AS tr ON tp.trainer_id = tr.trainer_id
         JOIN Pokemon AS p ON tp.pokemon_id = p.pokemon_id
ORDER BY tr.name;

-- Lists each gym leader with the Pokémon they currently own.
-- Demonstrates joining trainer ownership data with gym leadership records.
SELECT tr.name          AS Trainer,
       g.gym_id         AS Gym,
       p.name           AS Pokemon,
       tp.pokemon_level AS Level
FROM Trainer AS tr
         JOIN TrainerPokemon As tp ON tr.trainer_id = tp.trainer_id
         JOIN Gym as g on g.leader_id = tr.trainer_id
         JOIN Pokemon AS p on tp.pokemon_id = p.pokemon_id
order by g.gym_id, tr.name;

-- Lists trainers with their hometown and region.
-- LEFT JOINs keep towns visible even if no trainer is assigned to them.
SELECT tr.name   AS Trainer,
       tr.gender AS Gender,
       tr.age    AS Age,
       tn.name   AS Town,
       r.name    AS Region
FROM Town AS tn
         LEFT JOIN Trainer AS tr ON tr.home_town_id = tn.town_id
         LEFT JOIN Region AS r ON r.region_id = tn.region_id;
