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

-- Peuple les tables

-- Elèves : Méthode universelle (unitaire)
INSERT INTO greta.eleve(prenom, naiss)
VALUES('Samba', '2002-09-15')
;

-- Elèves : Méthode MySQL/MariaDB (plurielle)
INSERT INTO greta.eleve(prenom, naiss) VALUES
	('Johan', '1998-10-02'),
	('Youssef', '1982-07-25'),
	('Adam', '2004-01-02'),
	('Bachir', '2000-05-21'),
	('Terry', '2004-10-02'),
	('William', '2012-04-02'),
	('Ibrahim', '2001-09-24'),
	('Wilson', '1987-07-03'),
	('Robert', '1999-01-02'),
	('Dimitri', '2001-11-02'),
	('Sadaf', '1993-07-19'),
	('Pierre', '1999-01-30'),
	('Steven', '2002-12-02'),
	('Ismaël', '2006-06-06'),
	('Karim', '1998-07-12'),
	('Stéphane', '1997-05-12')
;

-- Professeurs
-- Date aléatoire : FROM_UNIXTIME(FLOOR(RAND()*UNIX_TIMESTAMP()))
INSERT INTO greta.prof(prenom, naiss) VALUES
	('Lesly', DATE_SUB(CURRENT_DATE(), INTERVAL (20 + (RAND()*40))*365.25  DAY)),
	('Moustapha', DATE_SUB(CURRENT_DATE(), INTERVAL (20 + (RAND()*40))*365.25  DAY)),
	('Philippe', DATE_SUB(CURRENT_DATE(), INTERVAL (20 + (RAND()*40))*365.25  DAY)),
	('Paul', DATE_SUB(CURRENT_DATE(), INTERVAL (20 + (RAND()*40))*365.25  DAY)),
    ('Nadjet', DATE_SUB(CURRENT_DATE(), INTERVAL (20 + (RAND()*40))*365.25  DAY))
;

-- Modules
INSERT INTO greta.module(id_mod, titre, code_prof) VALUES
	('CP1', 'Installer et configurer son environnement de travail en fonction du projet', 2),
	('CP2', 'Développer des interfaces utilisateur', 4),
	('CP3', 'Développer des composants métier', 4),
	('CP4', 'Contribuer à la gestion d''un projet informatique', 2),
	('CP5', 'Analyser les besoins et maquetter une application', 2),
	('CP6', 'Définir l''architecture logicielle d''une application', 4),
	('CP7', 'Concevoir et mettre en place une base de données relationnelle', 3),
	('CP8', 'Développer des composants d''accès aux données SQL et NoSQL', 1),
	('CP9', 'Préparer et exécuter les plans de tests d''une application', 2),
	('CP10', 'Préparer et documenter le déploiement d''une application', 4),
	('CP11', 'Contribuer à la mise en production dans une démarche DevOps', 2),
	('SPLC', 'Savoir planter les choux', null)
;

-- Suivre (à faire plus tard en procédural ;o)
INSERT INTO greta.suivre(id_eleve, id_mod, date_eval, note) VALUES
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20)),
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20)),
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20)),
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20)),
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20)),
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20)),
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20)),
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20)),
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20)),
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20)),
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20)),
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20)),
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20)),
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20)),
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20)),
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20)),
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20)),
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20)),
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20)),
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20)),
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20)),
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20)),
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20)),
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20)),
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20)),
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20)),
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20)),
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20)),
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20)),
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20)),
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20)),
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20)),
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20)),
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20)),
	(ceil(rand()*17), concat('CP',ceil(rand()*11)), date_sub(current_date(),INTERVAL ceil(rand()*300) DAY) ,ceil(rand()*20))
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

