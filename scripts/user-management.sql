-- #######################################################
-- Gestion des users
-- #######################################################

DESCRIBE mysql.user
;

-- Liste des users
SELECT host, user, password
FROM mysql.user
;

-- Cryptage avec SQL
SELECT PASSWORD('secret')
;

SELECT MD5('ismael'),
		SHA1('terry'),
        SHA2('pierre', 256),
        SHA1(CONCAT(MD5('secret'), 'lesly.lodin@greta.fr'))
;

-- Création d'un user admin
DROP USER IF EXISTS 'ryan';
CREATE USER 'ryan'@'%' IDENTIFIED BY 'secret';
GRANT ALL PRIVILEGES ON *.* TO 'ryan'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

-- Création de deux users standards
DROP USER IF EXISTS adam;
DROP USER IF EXISTS 'adam'@'localhost';
CREATE USER 'adam'@'%' IDENTIFIED BY 'secret';

DROP USER IF EXISTS sadaf;
DROP USER IF EXISTS 'sadaf'@'localhost';
CREATE USER 'sadaf'@'%'	IDENTIFIED BY 'secret';

-- #######################################################
-- Gestion des rôles
-- #######################################################

-- Liste des rôles (users sans mdp)
SELECT host, user, password
FROM mysql.user
WHERE LENGTH(password) = 0
;

-- Rôle 1 : Lire toutes les tables de toutes les 
-- bases de données
DROP ROLE IF EXISTS 'readonly';
CREATE ROLE readonly;
GRANT usage, select ON grocery.* TO readonly;
GRANT readonly TO 'adam'@'%';
SET DEFAULT ROLE readonly FOR 'adam'@'%'; -- Important !
SHOW GRANTS FOR 'adam'@'%';
FLUSH PRIVILEGES;

-- Rôle 2 : Lire et écrire dans toutes les tables de la 
-- base de données 'greta'
DROP ROLE IF EXISTS readwrite;
CREATE ROLE readwrite;
GRANT usage, select, insert, update, delete ON greta.* TO readwrite;
GRANT readwrite TO 'sadaf'@'%';
SHOW GRANTS FOR 'sadaf'@'%';
FLUSH PRIVILEGES;
-- SET ROLE readwrite; 