DROP DATABASE IF EXISTS University;
CREATE DATABASE University;
USE University;


CREATE TABLE unit
(
  id INT NOT NULL UNIQUE PRIMARY KEY,
  type CHAR(30),
  upper_id INT,
  name CHAR(30)
);

CREATE TABLE employee
(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    unit_id INT,
    position CHAR(30),
    degree CHAR(30),
    name CHAR(30),
    number CHAR(30),
    address CHAR(30),
    start DATE,
    end DATE,
    FOREIGN KEY (unit_id) REFERENCES unit(id)
);

CREATE TABLE work
(
    type CHAR(30),
    emp_id INT NOT NULL,
    start_time TIME,
    hours INT,
    place CHAR(30),
    start DATE,
    end DATE,
    FOREIGN KEY (emp_id) REFERENCES employee(id)
);

INSERT INTO unit(id, type, upper_id, name) VALUES(1, 'university', NULL, 'spbu');
INSERT INTO unit(id, type, upper_id, name) VALUES(2, 'faculty', NULL, 'math-mech');
INSERT INTO unit(id, type, upper_id, name) VALUES(3, 'faculty', NULL, 'pmpu');

INSERT INTO employee()