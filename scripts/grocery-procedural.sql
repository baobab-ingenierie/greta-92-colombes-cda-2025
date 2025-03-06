-- =======================================================
-- Procédures
-- =======================================================

-- Création procédure
DELIMITER $$
CREATE OR REPLACE PROCEDURE greta.hello()
BEGIN
END$$
DELIMITER ;

-- Modification procédure
ALTER PROCEDURE greta.hello
	COMMENT 'Ma première procédure'
    SQL SECURITY INVOKER -- respecte les privs du user
;

-- Avec paramètres
DELIMITER $$
CREATE OR REPLACE PROCEDURE greta.hello2(IN fname VARCHAR(30))
BEGIN
	SELECT CONCAT('Salut ', fname);
END$$
DELIMITER ;

-- Appel de la procédure
CALL greta.hello2();
CALL greta.hello2('Ibrahim');

-- Procédure DML
DELIMITER $$
CREATE OR REPLACE PROCEDURE greta.ajoutProf(
	IN fname VARCHAR(30),
    IN dnaiss DATE,
    IN mob CHAR(20))
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;
	START TRANSACTION;

	INSERT INTO greta.prof(prenom, naiss, mobile)
    VALUES(fname, dnaiss, mob);

    COMMIT;
END$$
DELIMITER ;

CALL greta.ajoutProf(
	'Dimitri', 
    '1997-06-23', 
    '06 56 23 78 14');

-- =======================================================
-- Structures
-- =======================================================

-- IF
DELIMITER $$
CREATE OR REPLACE PROCEDURE testIf(IN val INT)
BEGIN
	-- Test
    IF val > 18 THEN
		SELECT 'Félicitations, tu es majeur !' AS message;
	ELSE
		SELECT 'Désolé, reviens plus tard !' AS message;
    END IF;
END$$
DELIMITER ;

CALL testif(25);

-- CASE simple
DELIMITER $$
CREATE OR REPLACE PROCEDURE testCase1(IN val INT)
BEGIN
	-- Test
    CASE val
		WHEN 1 THEN SELECT 'Beaucoup trop jeune !' AS message;
		WHEN 2 THEN SELECT 'Beaucoup trop jeune !' AS message;
		WHEN 3 THEN SELECT 'Beaucoup trop jeune !' AS message;
		WHEN 4 THEN SELECT 'Beaucoup trop jeune !' AS message;
		-- ...
		WHEN 17 THEN SELECT 'Presque !' AS message;
		ELSE SELECT 'Bravo, tu es majeur !' AS message;
    END CASE;
END$$
DELIMITER ;

CALL testcase1(23);

-- CASE élaboré
DELIMITER $$
CREATE OR REPLACE PROCEDURE testCase2(IN val INT)
BEGIN
	-- Test
    CASE 
		WHEN val BETWEEN 1 AND 5 THEN SELECT 'Beaucoup trop jeune !' AS message;
		WHEN val BETWEEN 6 AND 16 THEN SELECT 'En trop jeune !' AS message;
		WHEN 17 THEN SELECT 'Presque !' AS message;
		ELSE SELECT 'Bravo, tu es majeur !' AS message;
    END CASE;
END$$
DELIMITER ;

CALL testcase2(23);

-- =======================================================
-- Challenge 1
-- =======================================================

-- Ecrire une proc qui ajoute dans la table 'produit' 
-- un nombre de produits passé en paramètre :
-- nom_prod = 'Produit ' + n°
-- prix = valeur réelles aléatoire comprise entre 1 et 100
-- code_four = valeur entière aléatoire comprise entre 1 et 250
-- Bonus : limiter le nombre de produits à ajouter à 100

DELIMITER $$
CREATE OR REPLACE PROCEDURE grocery.ajoutProds(IN nb TINYINT)
	SQL SECURITY INVOKER
BEGIN
	-- Variables
    DECLARE i TINYINT;
    SET i = 0;

	-- Tant que nb n'est pas atteint
	WHILE (i < nb) DO
		INSERT INTO grocery.produit(nom_prod, prix, code_four)
        VALUES(
			CONCAT('Produit ', (i + 1)), 
            ROUND(rand() * 100, 2),
            CEILING(rand() * 250)
		);
        SET i = i + 1;
    END WHILE;
END$$
DELIMITER ;

CALL ajoutProds(50);

SELECT *
FROM grocery.produit
WHERE id_prod > 1000;

-- =======================================================
-- Fonctions
-- =======================================================

DELIMITER $$
CREATE OR REPLACE FUNCTION grocery.averagePrice(IN no_four INT(11)) RETURNS VARCHAR(100)
BEGIN
	-- Variable
    DECLARE msg VARCHAR(100);
    
    -- Calcul
    SELECT CONCAT(f.nom, ' : ', ROUND(AVG(p.prix), 2)) INTO msg
    FROM grocery.fournisseur f
		INNER JOIN grocery.produit p
			ON f.code_four = p.code_four
    WHERE f.code_four = no_four
    GROUP BY f.code_four;
    
	RETURN msg;
END$$
DELIMITER ;

-- Test
SELECT grocery.averagePrice(11);
SELECT grocery.averagePrice(345);

-- =======================================================
-- Challenge 2
-- =======================================================

-- Ecrire une fonction qui permet de renvoyer le prix TTC à
-- partir d'un prix HT :
-- param mt : doit être positif
-- param taux : doit valoir 0.055, 0.1 ou 0.2

DELIMITER $$
CREATE OR REPLACE FUNCTION ttc(IN mt FLOAT, IN taux DECIMAL(7,3)) RETURNS FLOAT
	SQL SECURITY INVOKER
BEGIN
	-- Test si montant OK
    IF (mt < 0) THEN 
		SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Le montant doit être positif';
    END IF;

	-- Test si taux OK
--    IF (taux <> .055) AND (taux <> .1) AND (taux <> .2) THEN 
    IF (taux NOT IN (.055, .1, .2)) THEN 
		SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Le taux doit valoir : 5.5%, 10% ou 20%';
    END IF;

	-- Calcul et renvoi TTC
    RETURN mt * (1 + taux);
END$$
DELIMITER ;

-- Test
SELECT ttc(10.10, .2);

SELECT nom_prod, prix AS puht, ttc(prix, .1) AS puttc
FROM grocery.produit
;

-- =======================================================
-- Triggers
-- =======================================================

-- Prix doit être compris entre 10 et 40
DELIMITER $$
CREATE OR REPLACE TRIGGER grocery.prod_prix_upd 
	BEFORE UPDATE
    ON grocery.produit
    FOR EACH ROW
BEGIN
	IF (NEW.prix NOT BETWEEN 10 AND 40) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Le prix doit être compris entre 10 et 40.';
    END IF;
END$$
DELIMITER ;

-- Test
UPDATE grocery.produit
SET prix = 9.99
WHERE id_prod = 1;

SELECT *
FROM grocery.produit
WHERE code_four = 11
AND prix < 10;

UPDATE grocery.produit
SET prix = 7.5
WHERE code_four = 11
AND prix < 10;