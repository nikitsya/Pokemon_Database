-- Creates the main database used by the Pokémon management system.
CREATE DATABASE Pokemon;

USE Pokemon;

-- Stores the major world regions where towns, trainers, and wild Pokémon are located.
CREATE TABLE Region(
    region_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    climate VARCHAR(50) NOT NULL
);

-- Stores towns and links each town to the region it belongs to.
-- The region_id foreign key keeps every town connected to a valid region.
CREATE TABLE Town(
    town_id INT PRIMARY KEY AUTO_INCREMENT,
    region_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    population INT NOT NULL,
    FOREIGN KEY(region_id) REFERENCES Region(region_id)
);

-- Stores the available Pokémon type categories, such as Fire, Water, or Electric.
CREATE TABLE Types(
    type_id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(50) NOT NULL
);

-- Stores trainer profile data and links each trainer to a hometown.
-- The home_town_id foreign key ensures each trainer has a valid town reference.
CREATE TABLE Trainer(
    trainer_id INT PRIMARY KEY AUTO_INCREMENT,
    home_town_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    gender VARCHAR(50) NOT NULL,
    age INT,
    FOREIGN KEY(home_town_id) REFERENCES Town(town_id)
);

-- Stores base Pokémon species data and core battle statistics.
-- Individual owned Pokémon records are stored separately in TrainerPokemon.
CREATE TABLE Pokemon(
    pokemon_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    base_hp INT NOT NULL,
    base_attack INT NOT NULL,
    base_defense INT NOT NULL
);

-- Junction table that supports the many-to-many relationship between Pokémon and Types.
-- The composite primary key prevents duplicate type assignments for the same Pokémon.
CREATE TABLE PokemonTypes(
    pokemon_id INT NOT NULL,
    type_id INT NOT NULL,
    PRIMARY KEY(pokemon_id, type_id),
    FOREIGN KEY(pokemon_id) REFERENCES Pokemon(pokemon_id),
    FOREIGN KEY(type_id) REFERENCES Types(type_id)
);

-- Stores Pokémon owned by trainers, including nickname, level, and individual values.
-- This separates trainer-specific Pokémon data from the shared Pokémon species table.
CREATE TABLE TrainerPokemon(
    caught_id INT PRIMARY KEY AUTO_INCREMENT,
    trainer_id INT NOT NULL,
    pokemon_id INT NOT NULL,
    nick_name VARCHAR(50) NOT NULL,
    pokemon_level INT NOT NULL,
    hit_points_iv INT NOT NULL,
    attack_iv INT NOT NULL,
    defense_iv INT NOT NULL,
    FOREIGN KEY(trainer_id) REFERENCES Trainer(trainer_id),
    FOREIGN KEY(pokemon_id) REFERENCES Pokemon(pokemon_id)
);

-- Stores gym badges that can be awarded by gyms.
CREATE TABLE Badge(
    badge_id INT PRIMARY KEY AUTO_INCREMENT,
    badge_name VARCHAR(50) NOT NULL
);

-- Stores gym data, including leader, town, specialist type, and awarded badge.
-- Foreign keys keep every gym connected to valid trainer, town, type, and badge records.
CREATE TABLE Gym(
    gym_id INT PRIMARY KEY AUTO_INCREMENT,
    leader_id INT NOT NULL,
    town_id INT NOT NULL,
    type_id INT NOT NULL,
    badge_id INT NOT NULL,
    FOREIGN KEY(leader_id) REFERENCES Trainer(trainer_id),
    FOREIGN KEY(town_id) REFERENCES Town(town_id),
    FOREIGN KEY(type_id) REFERENCES Types(type_id),
    FOREIGN KEY(badge_id) REFERENCES Badge(badge_id)
);

-- Stores type matchups between two Pokémon types.
-- The composite primary key ensures each type matchup is stored only once.
CREATE TABLE TypeAdvantage(
    type_1 INT NOT NULL,
    type_2 INT NOT NULL,
    type_advantage VARCHAR(50) NOT NULL,
    PRIMARY KEY(type_1, type_2),
    FOREIGN KEY(type_1) REFERENCES Types(type_id),
    FOREIGN KEY(type_2) REFERENCES Types(type_id)
);

-- Stores wild Pokémon encounter data by region and level range.
-- This table keeps catchable Pokémon separate from trainer-owned Pokémon.
CREATE TABLE WildPokemon(
    wild_id INT PRIMARY KEY AUTO_INCREMENT,
    pokemon_id INT NOT NULL,
    region_id INT NOT NULL,
    location_description VARCHAR(50) NOT NULL,
    min_level INT NOT NULL,
    max_level INT NOT NULL,
    FOREIGN KEY(pokemon_id) REFERENCES Pokemon(pokemon_id),
    FOREIGN KEY(region_id) REFERENCES Region(region_id)
);

-- Audit table populated by delete triggers when trainer records are removed.
-- It keeps the deleted trainer ID, name, action type, and deletion timestamp.
CREATE TABLE DeletedTrainers
(
    LogID     INT PRIMARY KEY AUTO_INCREMENT,
    TrainerID INT,
    Name      VARCHAR(50),
    Action    VARCHAR(20),
    DeletedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
