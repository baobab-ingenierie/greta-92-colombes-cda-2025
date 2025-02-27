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

-- Projections : toutes les lignes et toutes/quelques colonnes
USE grocery
;

SELECT *
FROM produit
;

SELECT nom_prod, prix
FROM produit
;

SELECT nom_prod, prix * 1.1 AS PUTTC
FROM produit
;

SELECT 'Lesly the best !', 45 + 14 - 78 * 2
FROM fournisseur
;