-- Supprime BDD si existe !!!
DROP DATABASE IF EXISTS greta
;

-- Crée la BDD
CREATE DATABASE IF NOT EXISTS greta
	CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci
;

USE greta
;

-- Crée les tables de la BDD
CREATE TABLE prof(
	id_prof INT AUTO_INCREMENT PRIMARY KEY,
    prenom VARCHAR(50) NOT NULL,
    naiss DATE,
    mobile CHAR(50) UNIQUE
) ENGINE = InnoDB
;

CREATE TABLE eleve(
	id_eleve INT AUTO_INCREMENT PRIMARY KEY,
    prenom VARCHAR(50) NOT NULL,
    naiss DATE,
    email CHAR(50) UNIQUE
) ENGINE = InnoDB
;

CREATE TABLE module(
	id_mod CHAR(5) PRIMARY KEY,
    titre VARCHAR(100) NOT NULL,
    code_prof INT,
    FOREIGN KEY (code_prof) REFERENCES prof(id_prof)
) ENGINE = InnoDB
;

CREATE TABLE suivre(
	id_eleve INT,
    id_mod CHAR(5),
    date_eval DATE, 
    note TINYINT CHECK (note BETWEEN 0 AND 20),
    PRIMARY KEY (id_eleve, id_mod, date_eval),
    FOREIGN KEY (id_eleve) REFERENCES eleve(id_eleve),
    FOREIGN KEY (id_mod) REFERENCES module(id_mod)
) ENGINE = InnoDB
;

-- Peuple quelques tables

-- Méthode universelle (unitaire)
INSERT INTO eleve(prenom, naiss)
VALUES('Samba', '2002-09-15')
;

-- Méthode MySQL/MariaDB (plurielle)
INSERT INTO eleve(prenom, naiss) VALUES
	('Johan', '1998-10-02'),
	('Youssef', '1982-07-25'),
	('Adam', '2004-01-02'),
	('Bachir', '2000-05-21')
;

SELECT * 
FROM eleve
;

-- Mise à jour
UPDATE eleve
SET email = CONCAT(LOWER(prenom), '@greta', '.fr')
-- WHERE email = NULL -> déconseillé
WHERE email IS NULL
;

-- Suppression
DELETE
FROM eleve
WHERE naiss < '1980-01-01'
;

