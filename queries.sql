USE Lyre;
#1
SELECT journal.from, journal.to, clients.name, instruments.type FROM journal
    JOIN instruments on journal.instr_id = insteruments.id
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
WHERE journal.to < NOW();

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

CREATE PROCEDURE TAKE (@name as char(50), @type as char(50), @start as DATE, @end as DATE) AS
BEGIN
    DECLARE
    IF (SELECT )


END;