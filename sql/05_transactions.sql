-- Trades two owned Pokémon between trainers inside a single transaction.
-- The procedure commits only when both ownership updates succeed; otherwise, it rolls back.
-- Test example:
-- CALL TradePokemon(1, 1, 8, 4); 

DELIMITER $$

  -- Creates the Pokémon trade procedure.
CREATE PROCEDURE TradePokemon(
    IN p1_id INT,
    IN t1_id INT,
    IN p2_id INT,
    IN t2_id INT
)
BEGIN
  -- Track how many ownership rows are updated for each side of the trade.
    DECLARE rows1 INT DEFAULT 0;
    DECLARE rows2 INT DEFAULT 0;

-- Roll back the transaction if any SQL error occurs.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Trade failed, rolled back' AS status;
    END;

    START TRANSACTION;

    -- Transfer the first Pokémon to the second trainer and record the affected row count.
    UPDATE TrainerPokemon
    SET trainer_id = t2_id
    WHERE caught_id = p1_id AND trainer_id = t1_id;
    SET rows1 = ROW_COUNT();

    -- Transfer the second Pokémon to the first trainer and record the affected row count.
    UPDATE TrainerPokemon
    SET trainer_id = t1_id
    WHERE caught_id = p2_id AND trainer_id = t2_id;
    SET rows2 = ROW_COUNT();

    -- Commit only if both Pokémon were transferred successfully.
    IF rows1 = 1 AND rows2 = 1 THEN
        COMMIT;
        SELECT 'Trade successful' AS status;
    ELSE
        ROLLBACK;
        SELECT 'Trade failed, rolled back' AS status;
    END IF;
END$$

DELIMITER ;



-- Moves a wild Pokémon into a trainer's owned Pokémon records inside a transaction.
-- The procedure rolls back if the lookup, insert, or delete step fails.
-- Example test:
-- CALL BuyPokemon(1, 1, 5, 25, 12, 10, 10, 10);

DELIMITER $$

CREATE PROCEDURE BuyPokemon(
    IN wild_pokemon_id INT,  -- WildPokemon row to transfer
    IN trainer_id INT,       -- Trainer receiving the Pokémon
    IN pokemon_level INT,
    IN hit_iv INT,
    IN atk_iv INT,
    IN def_iv INT
)
BEGIN
    DECLARE pkmn_id INT;
    DECLARE pkmn_name VARCHAR(50);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Purchase failed, rolled back' AS status;
    END;

    START TRANSACTION;

    -- Get the Pokémon species ID and name from the selected wild encounter.
    SELECT wp.pokemon_id, p.name
    INTO pkmn_id, pkmn_name
    FROM WildPokemon AS wp
    JOIN Pokemon AS p ON wp.pokemon_id = p.pokemon_id
    WHERE wp.wild_id = wild_pokemon_id;

    -- Insert the Pokémon into TrainerPokemon so the trainer owns it.
    INSERT INTO TrainerPokemon(trainer_id, pokemon_id, nick_name, pokemon_level, hit_points_iv, attack_iv, defense_iv)
    VALUES (trainer_id, pkmn_id, pkmn_name, pokemon_level, hit_iv, atk_iv, def_iv);

    -- Remove the wild encounter after ownership is created.
    DELETE FROM WildPokemon WHERE wild_id = wild_pokemon_id;

    COMMIT;
    SELECT CONCAT('Trainer ', trainer_id, ' successfully bought ', pkmn_name) AS status;
END$$

DELIMITER ;
