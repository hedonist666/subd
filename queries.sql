USE Lyre;
#1

CALL TAKE('Vsevolod Drozdov', 'drum', NOW(), ADDTIME(NOW(), 10000));


SELECT journal.start, journal.end, clients.name, instruments.type FROM journal
    JOIN instruments on journal.instr_id = instruments.id
    JOIN clients on journal.client_id = clients.id;

#2
SELECT * from instruments WHERE NOW() >= next_check;

#3 drums
SELECT instruments.id FROM instruments
    WHERE instruments.type = 'drum' AND instruments.borrowed = TRUE;

#4
SELECT * FROM instruments WHERE price between  10 and 20;

#5
SELECT instruments.* FROM journal
JOIN instruments ON journal.instr_id = instruments.id;

#6
SELECT clients.* from journal
JOIN clients on journal.client_id = clients.id
WHERE journal.end < NOW();

#7
SELECT * from instruments
WHERE NOT instruments.borrowed = TRUE;

#8
SELECT clients.*, SUM(instruments.price) from journal
JOIN instruments ON journal.instr_id = instruments.id
JOIN clients ON journal.client_id = clients.id
GROUP BY clients.id;

#9
SELECT instruments.type, SUM(instruments.price) / COUNT(*) FROM instruments
JOIN journal ON journal.instr_id = instruments.id
GROUP BY instruments.type;

#10
select instruments.type, COUNT(*) from journal
JOIN instruments ON journal.instr_id = instruments.id
GROUP BY instruments.type;

#procs

CALL TAKE('Vsevolod', 'drum', NOW(), ADDTIME(NOW(), 10000));

SELECT * from journal;

CREATE PROCEDURE TAKE (name char(50), type char(50), start DATE, end DATE)
BEGIN
    DECLARE client_id, instr_id INT;

    SELECT instruments.id INTO instr_id FROM instruments WHERE instruments.type = type AND instruments.borrowed = FALSE LIMIT 1;
    IF instr_id IS NULL THEN
        SIGNAL sqlstate '20000'
            SET MESSAGE_TEXT = 'RENT_UNAVAILABLE';
    end if;
    SELECT clients.id INTO client_id FROM clients WHERE clients.name = name LIMIT 1;
    IF client_id IS NULL THEN
        INSERT INTO clients(name) VALUES(name);
        SELECT clients.id INTO client_id FROM clients WHERE clients.name = name LIMIT 1;
    end if;
    INSERT INTO journal(client_id, instr_id, start, end) VALUES(client_id, instr_id, start, end);
END;


CREATE PROCEDURE NEW_CHECK (nextCheck DATE)
BEGIN
    DECLARE done INTEGER DEFAULT 0;
    DECLARE id_ INT;
    DECLARE next_check DATE;
    DECLARE cur CURSOR FOR SELECT id, next_check from instruments WHERE borrowed = false;
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
    OPEN cur;

    WHILE done = 0 DO
        FETCH cur INTO id_, next_check;
        IF next_check < NOW() THEN
            UPDATE instruments SET next_check = nextCheck WHERE id = id_;
        end if;
    end while;
end;

CREATE PROCEDURE COUPON ()
BEGIN
    DECLARE id_ INT;
    DECLARE cnt INT;
    DECLARE done INTEGER DEFAULT 0;
    DECLARE cur CURSOR FOR SELECT id from instruments;
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
    OPEN cur;

    WHILE done = 0 DO
        FETCH cur INTO id_;
        SELECT COUNT(*) INTO cnt FROM journal WHERE instr_id = id_;
        IF cnt >= 100 THEN
            UPDATE instruments SET price = price * 0.5 WHERE id = id_;
        end if;
    end while;

    SELECT id, type, price as NEW, price*2 as OLD, COUNT(*) AS amount FROM instruments
    JOIN journal ON instr_id = instruments.id
    GROUP BY instr_id
    HAVING amount >= 100;
end;

CREATE TRIGGER NEW_TAKE AFTER INSERT ON journal
for each row begin
    UPDATE instruments SET borrowed = true WHERE id = NEW.instr_id;
END;

CREATE TRIGGER NEW_CHECK BEFORE UPDATE ON instruments
for each row begin
 IF NOT OLD.next_check = NEW.next_check THEN
     if OLD.borrowed = TRUE THEN
        SIGNAL sqlstate '20000'
            SET MESSAGE_TEXT = 'BORROWED';
     end if;
 end if;
END;
