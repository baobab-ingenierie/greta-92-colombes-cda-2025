-- Tables système

-- Combien de tables j'ai dans la BDD grocery
SELECT table_catalog,
		table_schema,
		table_name,
        table_type
FROM information_schema.tables
WHERE UPPER(table_schema) = 'GROCERY'
;
--
SELECT COUNT(*) AS nb
FROM information_schema.tables
WHERE UPPER(table_schema) = 'GROCERY'
;

-- Liste des users
SELECT host, user
FROM mysql.user
;

-- Projection : toutes les lignes et quelques colonnes
USE grocery
;

SELECT *
FROM produit
;

SELECT nom_prod, prix
FROM grocery.produit
;

SELECT nom_prod, prix * 1.1 AS PUTTC
FROM produit
;

SELECT 'Hello World!', 45 + 14 - 78 * 2, nom
FROM fournisseur
;

DESCRIBE fournisseur
;

-- Chasser les doublons
SELECT ALL pays
FROM fournisseur
;

SELECT DISTINCT pays
FROM fournisseur
;

DESCRIBE client
;

SELECT ville, pays
FROM client
;

SELECT DISTINCT ville, pays
FROM client
;

-- Marqueur NULL
SELECT pays
FROM fournisseur
;

SELECT pays, COALESCE(pays, 'Unknown') AS "Pays 2" -- `pays 2`
FROM fournisseur
;

-- Sélection : quelques lignes et quelques colonnes
-- Clause WHERE -> filtrer avec prédicat

-- BETWEEN
SELECT *
FROM greta.suivre
WHERE (note >= 9) AND (note <= 15)
;
--
SELECT *
FROM greta.suivre
WHERE (note BETWEEN 9 AND 15) -- Inclusif !
;
--
SELECT *
FROM greta.suivre
WHERE (note NOT BETWEEN 9 AND 15) -- Exclusif !
;

-- IN
SELECT *
FROM greta.module
WHERE (code_prof = 1) 
OR (code_prof = 3) 
OR (code_prof = 5)
OR (code_prof = 7)
;
--
SELECT *
FROM greta.module
WHERE code_prof IN (1,3,5,7)
;
--
SELECT *
FROM greta.module
WHERE code_prof NOT IN (1,3,5,7)
;
--
SELECT *
FROM greta.module
WHERE code_prof IN (SELECT id_prof
					FROM greta.prof
					WHERE YEAR(naiss) < 2000) -- Sous-requête
;

-- LIKE
-- % = 0 à n caractères
-- _ = 1 seul caractère
SELECT *
FROM greta.eleve
-- WHERE prenom LIKE '%f' -- Finit par 'f'
-- WHERE prenom LIKE 'p%' -- Commence par 'p'
-- WHERE prenom LIKE '%e%' -- Contient un 'e'
-- WHERE prenom LIKE '%e%e%' -- Contient deux 'e'
WHERE prenom LIKE '___s%' -- Contient un 'e'
;

-- Fonctions de type REGEXP
-- https://mariadb.com/kb/en/regexp/

-- NULL
SELECT *
FROM grocery.fournisseur
WHERE pays IS NULL
;

-- #######################################################
-- Challenges 1
-- #######################################################

-- Lister les fournisseurs situés en france, belgique et
-- congo.
SELECT *
FROM grocery.fournisseur
WHERE pays IN ('france','belgium','congo')
;

-- Afficher les produits dont le prix TTC (10%) est compris
-- entre 34 et 56 EUR.
SELECT nom_prod, prix AS PUHT, prix * 1.1 AS PUTTC
FROM grocery.produit
WHERE prix * 1.1 BETWEEN 34 AND 56
;

-- Quels clients ont un prénom contenant 'an' et n'habitent 
-- pas en tunisie.
SELECT *
FROM grocery.client
WHERE prenom LIKE '%an%'
AND pays != 'tunisia'
;

-- Jointure : requête multitable !
SELECT *
FROM greta.prof -- 5
;

SELECT *
FROM greta.module -- 5
;

SELECT id_mod, titre, prenom
FROM greta.prof, greta.module -- Produit cartésien
;

-- Jointure dans le WHERE (à l'ancienne)
SELECT id_mod, titre, prenom
FROM greta.prof, greta.module 
WHERE id_prof = code_prof -- Jointure interne
;

-- Jointure interne dans le FROM (JOIN...ON)
SELECT id_mod, titre, prenom
FROM greta.prof INNER JOIN greta.module ON id_prof = code_prof
;

-- Jointure externe dans le FROM
SELECT id_mod, titre, prenom
FROM greta.prof RIGHT OUTER JOIN greta.module ON id_prof = code_prof
;
--
SELECT id_mod, titre, prenom
FROM greta.module LEFT OUTER JOIN greta.prof ON id_prof = code_prof
;
--
SELECT id_mod, titre, prenom
FROM greta.module RIGHT OUTER JOIN greta.prof ON id_prof = code_prof
;
--
SELECT id_mod, titre, prenom
FROM greta.module 
	FULL OUTER JOIN greta.prof ON id_prof = code_prof -- Pas sous MariaDB
;
-- Alternative
SELECT id_mod, titre, prenom
FROM greta.module RIGHT OUTER JOIN greta.prof ON id_prof = code_prof
UNION -- Elimine doublons + Tri
SELECT id_mod, titre, prenom
FROM greta.module LEFT OUTER JOIN greta.prof ON id_prof = code_prof
;

-- Utilisation de noms de corrélation !
SELECT m.id_mod, m.titre, p.prenom
FROM greta.prof p RIGHT OUTER JOIN greta.module m 
	ON p.id_prof = m.code_prof
;

-- #######################################################
-- Challenges 2
-- #######################################################

-- Nom et prix des produits fournis par des sociétés domiciliées
-- en grèce, turquie, espagne ou portugal et dont le prix est
-- inférieur à 35 EUR ou supérieur à 57 EUR.
SELECT p.nom_prod, p.prix
FROM grocery.produit p INNER JOIN grocery.fournisseur f 
	ON p.code_four = f.code_four
WHERE (f.pays IN ('greece','turkey','spain','portugal'))
-- AND (p.prix < 35 OR p.prix > 57)
AND (p.prix NOT BETWEEN 35 AND 57)
;

-- Nom des produits et le numéro de commande des produits commandés
-- hier.
SELECT p.nom_prod, o.no_comm
FROM grocery.produit p
	INNER JOIN grocery.concerner c
		ON p.id_prod = c.id_prod
	INNER JOIN grocery.commande o
		ON o.no_comm = c.no_comm
-- WHERE o.date_comm = '2025-02-27'
WHERE o.date_comm = DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)
ORDER BY o.no_comm
;
-- Plus précis : no des commandes passées hier
SELECT no_comm
FROM grocery.commande o
WHERE o.date_comm = DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)
;

-- Prénom et ville des clients qui ont passé une commande lundi ou
-- mercredi et qui habitent en France ou en Suisse.
SELECT DISTINCT c.prenom, c.ville
FROM grocery.client c 
	INNER JOIN grocery.passer p
		ON p.id_cli = c.id_cli
	INNER JOIN grocery.commande o
		ON o.no_comm = p.no_comm
-- WHERE (o.date_comm = '2025-02-24') OR (o.date_comm = '2025-02-26')
WHERE (o.date_comm IN ('2025-02-24','2025-02-26'))
;