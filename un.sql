USE university;

#1
SELECT * FROM employee WHERE NOW() >= end ORDER BY name;

#2
SELECT * FROM employee WHERE degree = 'phd';

#3
SELECT COUNT(*) AS amount from employee
GROUP BY degree;

#4
SELECT SUM(hours)/COUNT(*) FROM work GROUP BY type;

#5
SELECT MAX(hours) FROM work
JOIN employee on work.emp_id = id
WHERE name = 'Natalya Genrigovna';

#6
SELECT place FROM work
JOIN employee on work.emp_id = employee.id
WHERE employee.name = 'Terehov' AND type = 'lection' AND NOW() between work.start
    AND work.end AND TIME(NOW()) between start_time and start_time + hours;

#7
SELECT name, YEAR(start), COUNT(*) FROM work
JOIN employee on work.emp_id = employee.id
GROUP BY YEAR(start);

#8
SELECT * from unit
JOIN unit as unit2 on unit.upper_id = unit2.id
WHERE unit2.name = 'math-mech' AND unit.type = 'faculty';

#9

#10
SELECT SUM(hours) from work
JOIN employee  ON emp_id = employee.id
JOIN unit ON employee.unit_id = unit.id
JOIN unit as unit2 on unit.upper_id = unit2.id
WHERE unit.type = 'faculty' AND unit2.name = 'math-mech';

#procs
CREATE PROCEDURE  BONUS(name_ CHAR(30))
begin
    DECLARE c1, c2 INT DEFAULT 0;
    DECLARE id_ INT;
    DECLARE pos, deg CHAR(30);
    SELECT id, position, degree INTO id_, pos, deg FROM work JOIN employee ON work.emp_id = employee.id
    WHERE name = name_;
    IF id_ IS NULL THEN
        SIGNAL sqlstate '30000'
            SET MESSAGE_TEXT = 'NOT_APPLICABLE';
    end if;
    if pos = 'rector' then
        SET c1 = 1.2;
        else
        if pos = 'teacher' then
            set c1 = 1.1;
        end if;
    end if;
    if deg = 'phd' then
        SET c2 = 1.2;
        else
        if deg = 'doc' then
            set c2 = 1.1;
        end if;
    end if;
    return c1+c2;
end;

CREATE PROCEDURE TREE()
begin

end;