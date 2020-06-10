DROP DATABASE IF EXISTS Lyre;
CREATE DATABASE Lyre;
USE Lyre;

CREATE TABLE instruments
(
    id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    type CHAR(50),
#    time INT,
    borrowed BOOL,
    next_check DATETIME,
    price int
);

CREATE TABLE clients
(
    id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name CHAR(50),
    addr CHAR(50),
    number CHAR(15)
);

CREATE TABLE journal
(
    start DATE,
    end DATE,
    client_id INT,
    instr_id INT,
    FOREIGN KEY (client_id) REFERENCES clients (id),
    FOREIGN KEY (instr_id) REFERENCES instruments (id)
);

/* insertions

 */