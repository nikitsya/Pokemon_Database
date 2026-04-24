-- Calculates battle stats for each trainer-owned Pokémon.
-- The view combines species base stats, individual values, and level into readable HP, Attack, and Defense values.
CREATE VIEW TrainerPokemonStats AS
SELECT tp.caught_id,
       tp.trainer_id,
       tp.nick_name              AS Name,
       p.name                    AS Species,
       tp.pokemon_level          as Level,

-- Calculates HP from base HP, HP IV, and Pokémon level.
       FLOOR(
               (
                   (p.base_hp + tp.hit_points_iv) * 2 * tp.pokemon_level
                   ) / 100
       ) + tp.pokemon_level + 10 AS HP,

-- Calculates Attack from base attack, attack IV, and Pokémon level.
       FLOOR(
               (
                   (p.base_attack + tp.attack_iv) * 2 * tp.pokemon_level
                   ) / 100
       ) + 5                     AS Attack,

-- Calculates Defense from base defense, defense IV, and Pokémon level.
       FLOOR(
               (
                   (
                       p.base_defense + tp.defense_iv
                       ) * 2 * tp.pokemon_level
                   ) / 100
       ) + 5                     AS Defense
FROM TrainerPokemon tp
         JOIN Pokemon p ON tp.pokemon_id = p.pokemon_id;


-- Lists each Pokémon with all assigned types combined into a single row.
-- This makes type reporting easier than reading one row per Pokémon-type relationship.
CREATE VIEW PokemonWithTypes AS
SELECT p.pokemon_id,
       p.name,
       GROUP_CONCAT(
               t.type_name ORDER BY t.type_name SEPARATOR '/'
       ) AS types
FROM Pokemon AS p
         LEFT JOIN PokemonTypes AS pt ON pt.pokemon_id = p.pokemon_id
         LEFT JOIN Types AS t ON t.type_id = pt.type_id
GROUP BY p.pokemon_id,
         p.name;


-- Summarizes trainer details, team size, home location, and gym leader information.
-- LEFT JOINs keep trainers visible even when they do not own Pokémon or lead a gym.
CREATE VIEW TrainerSummary AS
SELECT tr.trainer_id,
       tr.name              AS TrainerName,
       tr.gender,
       tr.age,
       COUNT(tp.pokemon_id) AS TotalPokemon,
       CASE
           WHEN g.leader_id IS NOT NULL THEN 'Yes'
           ELSE 'No'
           END              AS IsGymLeader,
       twn.name             AS HomeTown,
       r.name               AS Region,
       gt.name              AS GymTown,
       ty.type_name         AS GymType
FROM Trainer AS tr
         LEFT JOIN TrainerPokemon AS tp ON tr.trainer_id = tp.trainer_id
         LEFT JOIN Gym AS g ON tr.trainer_id = g.leader_id
         LEFT JOIN Town AS gt ON g.town_id = gt.town_id
         LEFT JOIN Types AS ty ON g.type_id = ty.type_id
         JOIN Town AS twn ON tr.home_town_id = twn.town_id
         JOIN Region AS r ON twn.region_id = r.region_id
GROUP BY tr.trainer_id,
         tr.name,
         tr.gender,
         tr.age,
         g.leader_id,
         twn.name,
         r.name,
         gt.name,
         ty.type_name;


-- Shows the highest-level Pokémon owned by each trainer.
-- The correlated subquery compares each owned Pokémon against the trainer's maximum recorded level.
CREATE VIEW TrainerPokemonMaxLevelView AS
SELECT t.trainer_id,
       t.name           AS trainer_name,
       p.name           AS pokemon_name,
       tp.pokemon_level AS pokemons_level
FROM Trainer t
         JOIN TrainerPokemon tp ON t.trainer_id = tp.trainer_id
         JOIN Pokemon p ON tp.pokemon_id = p.pokemon_id
WHERE tp.pokemon_level = (SELECT MAX(p2.pokemon_level)
                          FROM TrainerPokemon p2
                          WHERE p2.trainer_id = t.trainer_id);
