-- Create database users for different access levels.
-- Each account represents a separate application or operational role.
CREATE
USER 'pokemon_app'@'localhost' IDENTIFIED BY 'Strong_Pass123!';
CREATE
USER 'pokemon_app'@'%' IDENTIFIED BY 'Strong_Pass123!';
CREATE
USER 'pokemon_readonly'@'localhost' IDENTIFIED BY 'ReadOnly_Pass123!';
CREATE
USER 'pokemon_admin'@'localhost' IDENTIFIED BY 'Admin_Pass123!';
CREATE
USER 'trainer_user'@'localhost' IDENTIFIED BY 'Trainer_Pass123!';

-- Grant privileges by role.
-- Admin receives full database access, the app receives standard CRUD access,
-- trainer_user receives limited table-level access, and readonly receives SELECT only.
GRANT ALL PRIVILEGES ON Pokemon.* TO
'pokemon_admin'@'localhost';
GRANT
SELECT,
INSERT
,
UPDATE,
DELETE
ON Pokemon.* TO 'pokemon_app'@'localhost';
GRANT
SELECT,
INSERT
ON Pokemon.TrainerPokemon TO 'trainer_user'@'localhost';
GRANT
SELECT
ON Pokemon.Pokemon TO 'trainer_user'@'localhost';
GRANT
SELECT
ON Pokemon.Types TO 'trainer_user'@'localhost';
GRANT
SELECT
ON Pokemon.* TO 'pokemon_readonly'@'localhost';

FLUSH
PRIVILEGES;

-- Review the active grants for the main application and limited-access users.
SHOW
GRANTS FOR 'pokemon_app'@'localhost';
SHOW
GRANTS FOR 'pokemon_readonly'@'localhost';
SHOW
GRANTS FOR 'trainer_user'@'localhost';

-- Allow trainer_user to update owned Pokémon records after initial account setup.
GRANT
UPDATE ON Pokemon.TrainerPokemon TO 'trainer_user'@'localhost';
FLUSH
PRIVILEGES;

-- Remove insert access from trainer_user to restrict direct creation of ownership records.
REVOKE INSERT ON Pokemon.TrainerPokemon FROM 'trainer_user'@'localhost';

FLUSH
PRIVILEGES;

-- Rotate the local application user's password.
ALTER
USER 'pokemon_app'@'localhost' IDENTIFIED BY 'NewPassword123!';

-- Recreate the local application and readonly users with final credentials.
DROP
USER 'pokemon_app'@'localhost', 'pokemon_readonly'@'localhost';

CREATE
USER 'pokemon_app'@'localhost' IDENTIFIED BY 'App_Pass123!';
GRANT
SELECT,
INSERT
,
UPDATE,
DELETE
ON Pokemon.* TO 'pokemon_app'@'localhost';
FLUSH
PRIVILEGES;

CREATE
USER 'pokemon_readonly'@'localhost' IDENTIFIED BY 'Read_Pass123!';
GRANT
SELECT
ON Pokemon.* TO 'pokemon_readonly'@'localhost';
FLUSH
PRIVILEGES;

-- Create a trainer-facing account with access limited to trainer workflow tables.
CREATE
USER 'pokemon_trainer'@'localhost' IDENTIFIED BY 'Trainer_Pass123!';
GRANT
SELECT
ON Pokemon.Pokemon TO 'pokemon_trainer'@'localhost';
GRANT
SELECT
ON Pokemon.Gym TO 'pokemon_trainer'@'localhost';
GRANT
SELECT
ON Pokemon.Types TO 'pokemon_trainer'@'localhost';
GRANT
SELECT,
INSERT
,
UPDATE,
DELETE
ON Pokemon.TrainerPokemon TO 'pokemon_trainer'@'localhost';
GRANT
SELECT,
INSERT
,
UPDATE
    ON Pokemon.Trainer TO 'pokemon_trainer'@'localhost';
FLUSH
PRIVILEGES;

-- Inspect global user privileges for the final application roles.
SELECT user,
       host,
       Select_priv,
       Insert_priv,
       Update_priv,
       Delete_priv
FROM mysql.user
WHERE user IN ('pokemon_app', 'pokemon_readonly', 'pokemon_trainer');

-- Inspect table-level privileges assigned inside the Pokemon database.
SELECT *
FROM mysql.tables_priv
WHERE Db = 'Pokemon';


-- Cleanup commands for resetting the database users during local setup.
DROP
USER IF EXISTS 'pokemon_app'@'localhost';
DROP
USER IF EXISTS 'pokemon_app'@'%';
DROP
USER IF EXISTS 'pokemon_readonly'@'localhost';
DROP
USER IF EXISTS 'pokemon_admin'@'localhost';
DROP
USER IF EXISTS 'pokemon_trainer'@'localhost';
DROP
USER IF EXISTS 'trainer_user'@'localhost';

-- Verify remaining MySQL users after cleanup.
SELECT user, host
FROM mysql.user;
