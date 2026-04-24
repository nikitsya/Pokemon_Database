-- Records deleted trainers in the audit table after a Trainer row is removed.
-- This keeps a deletion history for recovery, review, and administrative tracking.
DELIMITER
$$

CREATE TRIGGER after_trainer_delete
    AFTER DELETE
    ON Trainer
    FOR EACH ROW
BEGIN
    INSERT INTO DeletedTrainers (TrainerID, Name, Action)
    VALUES (OLD.trainer_id, OLD.name, 'deleted');

    END$$

    DELIMITER;


-- Removes a trainer's owned Pokémon before deleting the trainer.
-- This prevents foreign key conflicts because TrainerPokemon depends on Trainer.
DELIMITER $$

    CREATE TRIGGER delete_trainer_pokemon
        BEFORE DELETE
        ON Trainer
        FOR EACH ROW
    BEGIN
        DELETE
        FROM TrainerPokemon
        WHERE trainer_id = OLD.trainer_id;

    END $$

DELIMITER;


    -- Reassigns gyms before deleting a trainer who is currently a gym leader.
-- This keeps Gym.leader_id valid and prevents broken leader references.
    DELIMITER $$

    CREATE TRIGGER change_leader_if_deleted
        BEFORE DELETE
        ON Trainer
        FOR EACH ROW
    BEGIN
        DECLARE new_leader INT;

    -- Use trainer 4 as the default replacement leader when available.
    IF OLD.trainer_id <> 4 THEN
        -- Reassign the deleted trainer's gyms to the default leader.
        UPDATE Gym
        SET leader_id = 4
        WHERE leader_id = OLD.trainer_id;

        -- If trainer 4 is being deleted, select the next available trainer.
        ELSE
        SELECT trainer_id
        INTO new_leader
        FROM Trainer
        WHERE trainer_id <> OLD.trainer_id
        ORDER BY trainer_id LIMIT 1;

        -- Reassign affected gyms to the selected replacement leader.
        IF new_leader IS NOT NULL THEN
        UPDATE Gym
        SET leader_id = new_leader
        WHERE leader_id = OLD.trainer_id;
    END IF;
END IF;

END $$

DELIMITER;


-- Normalises inserted Pokémon levels to the valid gameplay range of 1 to 100.
-- Values below 1 are raised to 1, and values above 100 are capped at 100.
DELIMITER
$$

CREATE TRIGGER check_pokemon_level
    BEFORE INSERT
    ON TrainerPokemon
    FOR EACH ROW
BEGIN
    -- Raise levels below the minimum allowed value.
    IF NEW.pokemon_level < 1 THEN
    SET NEW.pokemon_level = 1;
END IF;

-- Cap levels above the maximum allowed value.
IF
NEW.pokemon_level > 100 THEN
    SET NEW.pokemon_level = 100;
END IF;
END$$

DELIMITER;


-- Caps inserted IV values at the maximum allowed value of 31.
-- This protects stat calculations from invalid overpowered Pokémon data.
DELIMITER
$$

create trigger cap_max_iv
    before insert
    on TrainerPokemon
    for each row
begin
    -- Cap each IV independently if it exceeds the allowed maximum.
    if NEW.hit_points_iv > 31 then
            set new.hit_points_iv = 31;
end if;
if
NEW.attack_iv > 31 then
            set new.attack_iv = 31;
end if;
        if
NEW.defense_iv > 31 then
            set new.defense_iv = 31;
end if;
end;

DELIMITER;


-- Enforces the maximum party size of 6 Pokémon per trainer.
-- Inserts beyond this limit are rejected with a database error.

DELIMITER
$$

CREATE TRIGGER cap_trainer_pokemon
    BEFORE INSERT
    ON TrainerPokemon
    FOR EACH ROW
BEGIN
    DECLARE pokemon_count INT;
    SELECT COUNT(*) INTO pokemon_count FROM TrainerPokemon WHERE trainer_id = NEW.trainer_id;
    IF pokemon_count >=6 THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Trainer already has 6 pokemon, they cannot have more in their party';
END IF;
END$$

DELIMITER;
