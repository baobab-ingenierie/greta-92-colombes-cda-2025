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

-- Rappel : Liste de tous les élèves avec leurs notes
-- pour chaque évaluation et le nom du prof associé
-- au module
SELECT e.prenom,
		FLOOR(DATEDIFF(CURRENT_DATE(), e.naiss)/365.25) AS age,
        s.date_eval,
        s.note AS note_sur_20,
        m.id_mod,
        m.titre,
        p.prenom
FROM eleve e
	INNER JOIN suivre s
		ON e.id_eleve = s.id_eleve
	INNER JOIN module m
		ON m.id_mod = s.id_mod
	INNER JOIN prof p
		ON p.id_prof = m.code_prof
-- ORDER BY e.prenom, s.note DESC -- Très gourmand !
ORDER BY e.prenom, note_sur_20 DESC
-- ORDER BY 1, 4 DESC
;

-- Opérateurs ensemblistes

-- UNION
SELECT prenom, naiss, email, NULL as mobile
FROM greta.eleve
UNION
SELECT prenom, naiss, NULL as email, mobile
FROM greta.prof
;

-- INTERSECTION
SELECT pays
FROM grocery.fournisseur
INTERSECT
SELECT pays
FROM grocery.client
;
-- Alternative
SELECT DISTINCT f.pays
FROM grocery.fournisseur f
WHERE EXISTS (SELECT c.pays
			FROM grocery.client c
            WHERE c.pays = f.pays)
;

-- EXCEPTION
SELECT pays
FROM grocery.fournisseur
EXCEPT
SELECT pays
FROM grocery.client
;
-- Alternative
SELECT DISTINCT c.pays
FROM grocery.client c
WHERE NOT EXISTS (SELECT f.pays
					FROM grocery.fournisseur f
                    WHERE f.pays = c.pays)
;
--
SELECT DISTINCT f.pays
FROM grocery.fournisseur f
WHERE NOT EXISTS (SELECT c.pays
					FROM grocery.client c
                    WHERE f.pays = c.pays)
;

-- Gestion des vues
SELECT *
FROM greta.eleve
;
--
SELECT prenom, 
		FLOOR(DATEDIFF(CURRENT_DATE(),naiss)/365.25) AS age,
        LOWER(email) AS courriel
FROM greta.eleve
;
--
CREATE OR REPLACE VIEW greta.liste_eleve AS
	SELECT prenom, 
			FLOOR(DATEDIFF(CURRENT_DATE(),naiss)/365.25) AS age,
			LOWER(email) AS courriel
	FROM greta.eleve
;
-- Vue protégée ???
SELECT *
FROM liste_eleve
;
--
UPDATE greta.eleve
SET email = LOWER(email)
WHERE 1 = 1 -- Toujours VRAI
;
--
UPDATE greta.liste_eleve
SET courriel = NULL
WHERE 1 = 1
;
--
UPDATE greta.liste_eleve
SET prenom = UPPER(prenom)
WHERE 1 = 1
;

-- Une autre vue !
SELECT prenom,
		m.id_mod,
        m.titre,
        p.mobile
FROM greta.prof p
	LEFT OUTER JOIN greta.module m
		ON p.id_prof = m.code_prof
;
-- 
CREATE OR REPLACE VIEW greta.liste_prof AS
-- SELECT prenom,
-- SELECT REPLACE(p.prenom, '', '') AS prenom,
	SELECT SUBSTR(p.prenom, 1, 50) AS prenom,
			m.id_mod,
			m.titre,
			p.mobile
	FROM greta.prof p
		LEFT OUTER JOIN greta.module m
			ON p.id_prof = m.code_prof
;
-- Lecture
SELECT *
FROM greta.liste_prof
;
-- MàJ
UPDATE greta.liste_prof
SET mobile = '0607080910'
WHERE prenom = 'Lesly'
;
--
UPDATE greta.liste_prof
SET prenom = 'Kevin'
WHERE prenom = 'Lesly'
;

-- Fonctions numériques
SELECT ROUND(12345.67),
		ROUND(12345.67, 1),
		ROUND(12345.67, -2),
        FLOOR(1.00000000000001),
        FLOOR(1.99999999999999),
        CEIL(1.00000000000001),
        CEIL(1.99999999999999),
        TRUNCATE(1.99999999999999, 2)
;

-- Fonctions texte
SELECT SUBSTRING('Sadaf', 2, 3),
		CONCAT('A bas', ' les ', 'profs'),
        LENGTH('Hello World!'),
        TRIM('      Je hais les profs !     '),
        LOCATE('ces', 'Qu''ils sont méchants, ces profs !'),
        REPLACE('Qu''ils sont méchants, ces profs !', 'méchant', 'con')
;

-- Fonctions date et heure
-- https://mariadb.com/kb/en/date_format/
SELECT date_format(curdate(), '%W %e %M %Y')
;

-- Structures de contrôle
SELECT e.prenom,
		s.id_mod,
        s.note,
        IF(s.note > 10, 'Bravo !', 'Dommage !') AS avis,
        CASE
			WHEN s.note < 8 THEN 'NA'
			WHEN s.note < 13 THEN 'ECA'
			ELSE 'ACQ'
        END AS eval
FROM greta.eleve e
	JOIN greta.suivre s
		ON e.id_eleve = s.id_eleve
;

-- Fonctions JSON
SELECT json_object('prenom', prenom, 'naissance', naiss)
FROM greta.eleve
;

-- Fonctions de transtypage
SELECT *
FROM greta.eleve
-- WHERE id_eleve < '5' -- CAST implicite
WHERE id_eleve < 'cinq' -- CAST implicite -> 0
;

-- Fonctions d'agrégation
SELECT AVG(note) AS moyenne, 
		MAX(note), 
        MIN(note), 
        SUM(note), 
        COUNT(*) AS nb
FROM greta.suivre
;

-- Regroupements
SELECT e.prenom, s.note
FROM greta.eleve e
	LEFT OUTER JOIN greta.suivre s
		ON e.id_eleve = s.id_eleve
;
--
SELECT e.prenom, AVG(s.note) AS moyenne
FROM greta.eleve e
	LEFT OUTER JOIN greta.suivre s
		ON e.id_eleve = s.id_eleve
WHERE s.note IS NOT NULL 
-- AND s.note >= 10
GROUP BY e.prenom
-- HAVING AVG(s.note) >= 10
HAVING moyenne >= 10 -- MySQL/MariaDB seulement !!!
ORDER BY moyenne DESC
;

-- #######################################################
-- Challenges 3
-- #######################################################

-- Afficher le prix moyen des produits, par pays et par
-- fournisseur. Trier dans l'ordre décroissant des moyennes
-- Bonus : uniquement les 3 premiers
SELECT f.code_four,
		f.pays,
        p.prix
FROM grocery.produit p
	INNER JOIN grocery.fournisseur f
		ON f.code_four = p.code_four -- Jointure !
;
--
SELECT f.code_four,
		f.pays,
        AVG(p.prix) AS prix_moyen
FROM grocery.produit p
	INNER JOIN grocery.fournisseur f
		ON f.code_four = p.code_four
GROUP BY f.code_four,
		f.pays
;
--
SELECT CONCAT(f.code_four,' - ', f.nom) AS fournisseur,
		f.pays,
        CONCAT(FORMAT(AVG(p.prix), 2, 'fr_FR'), '€') AS prix_moyen
FROM grocery.produit p
	INNER JOIN grocery.fournisseur f
		ON f.code_four = p.code_four
GROUP BY f.code_four,
		f.pays
ORDER BY prix_moyen DESC
LIMIT 3 -- 5, 8
;

-- Afficher le nom du client, le no de commande ainsi que le
-- montant total de la commande. Trier dans l'ordre croissant 
-- des montants
SELECT cl.nom,
		co.no_comm,
        qte,
        prix
FROM grocery.client cl
	INNER JOIN grocery.passer p
		ON cl.id_cli = p.id_cli
	INNER JOIN grocery.commande co
		ON co.no_comm = p.no_comm
	INNER JOIN grocery.concerner cn
		ON co.no_comm = cn.no_comm
;
--
SELECT cl.nom,
		co.no_comm,
        SUM(qte * prix) AS montant
FROM grocery.client cl
	INNER JOIN grocery.passer p
		ON cl.id_cli = p.id_cli
	INNER JOIN grocery.commande co
		ON co.no_comm = p.no_comm
	INNER JOIN grocery.concerner cn
		ON co.no_comm = cn.no_comm
GROUP BY cl.nom,
		co.no_comm
ORDER BY montant
;

-- Dans quel pays se trouve le meilleur client ?
SELECT cl.nom,
		cl.pays,
        SUM(cn.qte * cn.prix) AS montant
FROM grocery.client cl
	INNER JOIN grocery.passer p
		ON cl.id_cli = p.id_cli
	INNER JOIN grocery.commande co
		ON co.no_comm = p.no_comm
	INNER JOIN grocery.concerner cn
		ON co.no_comm = cn.no_comm
GROUP BY cl.nom,
		cl.pays
ORDER BY montant DESC
LIMIT 3 -- 1
;

-- Fonctions de fenêtrage
-- Pays qui génère le plus de commandes

-- Avec regroupement
SELECT cl.pays,
		SUM(cn.qte * cn.prix) AS mt
FROM grocery.concerner cn
	INNER JOIN grocery.commande co
		ON co.no_comm = cn.no_comm
	INNER JOIN grocery.passer p
		ON co.no_comm = p.no_comm
	INNER JOIN grocery.client cl
		ON cl.id_cli = p.id_cli
GROUP BY cl.pays
ORDER BY mt DESC
LIMIT 3
;

-- Avec fonctions de fenêtrage
SELECT cl.id_cli,
		cl.nom,
        cl.pays,
        SUM(cn.qte * cn.prix) OVER(PARTITION BY cl.pays) AS mt
FROM grocery.concerner cn
	INNER JOIN grocery.commande co
		ON co.no_comm = cn.no_comm
	INNER JOIN grocery.passer p
		ON co.no_comm = p.no_comm
	INNER JOIN grocery.client cl
		ON cl.id_cli = p.id_cli
;
--
SELECT DISTINCT cl.pays,
        SUM(cn.qte * cn.prix) OVER(PARTITION BY cl.pays) AS mt
FROM grocery.concerner cn
	INNER JOIN grocery.commande co
		ON co.no_comm = cn.no_comm
	INNER JOIN grocery.passer p
		ON co.no_comm = p.no_comm
	INNER JOIN grocery.client cl
		ON cl.id_cli = p.id_cli
;
--
SELECT cl.id_cli,
		cl.nom,
        cl.pays,
        SUM(cn.qte * cn.prix) OVER(PARTITION BY cl.pays) AS montant,
        cn.qte * cn.prix mt_unitaire,
        RANK() OVER(PARTITION BY cl.pays ORDER BY cn.qte * cn.prix DESC) AS classement,
        PERCENT_RANK() OVER(PARTITION BY cl.pays ORDER BY cn.qte * cn.prix DESC) AS percent
FROM grocery.concerner cn
	INNER JOIN grocery.commande co
		ON co.no_comm = cn.no_comm
	INNER JOIN grocery.passer p
		ON co.no_comm = p.no_comm
	INNER JOIN grocery.client cl
		ON cl.id_cli = p.id_cli
-- WHERE cl.pays = 'france'
;

-- Résumé fonctions de fenêtrage

-- Agrégats
SELECT DISTINCT pays,
		COUNT(id_cli) OVER(PARTITION BY pays) AS nb_cli
FROM grocery.client
ORDER BY nb_cli DESC
;

-- RANK()
SELECT f.nom,
		p.nom_prod,
        p.prix,
		RANK() OVER(PARTITION BY f.nom ORDER BY p.prix DESC) AS rang
FROM grocery.fournisseur f
	INNER JOIN grocery.produit p
		ON f.code_four = p.code_four
;

-- PERCENT_RANK()
-- Renvoie le rang relatif d'une valeur dans un groupe de 
-- valeurs, sous la forme d'un pourcentage compris entre 
-- 0.0 et 1.0
SELECT f.nom,
		p.nom_prod,
        p.prix,
		PERCENT_RANK() OVER(PARTITION BY f.nom ORDER BY p.prix DESC) AS rang
FROM grocery.fournisseur f
	INNER JOIN grocery.produit p
		ON f.code_four = p.code_four
;

-- ROW_NUMBER()
SELECT f.nom,
		p.nom_prod,
        p.prix,
		ROW_NUMBER() OVER(PARTITION BY f.nom) AS row_num
FROM grocery.fournisseur f
	INNER JOIN grocery.produit p
		ON f.code_four = p.code_four
;

-- NTILE()
-- Permet de diviser un ensemble d'enregistrements en 
-- sous-ensembles de taille approximativement égale.
SELECT nom_prod,
        prix,
		NTILE(4) OVER(ORDER BY prix) AS grp
FROM grocery.produit
;

-- LAG()/LEAD()
-- Permet d'accéder à une valeur stockée dans une ligne 
-- différente au-dessus de la ligne actuelle
SELECT id_prod,
		nom_prod,
        prix,
        LAG(prix, 5) OVER(ORDER BY prix) AS val_prec,
        LEAD(prix) OVER(ORDER BY prix) AS val_suiv
FROM grocery.produit
;

-- FIRST_VALUE()
-- Renvoie la première valeur d'une partition ordonnée 
-- d'un ensemble de résultats.
SELECT co.date_comm,
		cn.prix,
        FIRST_VALUE(cn.prix) OVER(ORDER BY co.date_comm) AS first_price,
        LAST_VALUE(cn.prix) OVER(ORDER BY co.date_comm) AS last_price
FROM grocery.concerner cn
	INNER JOIN grocery.commande co
		ON co.no_comm = cn.no_comm
;

-- #######################################################
-- Challenges 4
-- #######################################################

-- Afficher le pourcentage de ventes par pays et par
-- fournisseur (soit agrégé, soit fenêtré).

-- Fonction fenêtrée
SELECT f.pays,
		f.nom,
        c.prix * c.qte AS montant
FROM grocery.concerner c
	INNER JOIN grocery.produit p
		ON p.id_prod = c.id_prod
	INNER JOIN grocery.fournisseur f
		ON f.code_four = p.code_four
;
--
SELECT f.pays,
		f.nom,
        SUM(c.prix * c.qte) OVER() AS total
FROM grocery.concerner c
	INNER JOIN grocery.produit p
		ON p.id_prod = c.id_prod
	INNER JOIN grocery.fournisseur f
		ON f.code_four = p.code_four
;
--
SELECT DISTINCT f.pays,
		f.nom,
        SUM(c.prix * c.qte) OVER(PARTITION BY f.pays, f.nom) AS montant,
        SUM(c.prix * c.qte) OVER() AS total
FROM grocery.concerner c
	INNER JOIN grocery.produit p
		ON p.id_prod = c.id_prod
	INNER JOIN grocery.fournisseur f
		ON f.code_four = p.code_four
;
--
SELECT DISTINCT f.pays,
		f.nom,
        (SUM(c.prix * c.qte) OVER(PARTITION BY f.pays, f.nom) / SUM(c.prix * c.qte) OVER()) * 100 AS pourcent
FROM grocery.concerner c
	INNER JOIN grocery.produit p
		ON p.id_prod = c.id_prod
	INNER JOIN grocery.fournisseur f
		ON f.code_four = p.code_four
;
--
SELECT DISTINCT f.pays,
		f.nom,
        ROUND((SUM(c.prix * c.qte) OVER(PARTITION BY f.pays, f.nom) / SUM(c.prix * c.qte) OVER()) * 100, 2) AS pourcent
FROM grocery.concerner c
	INNER JOIN grocery.produit p
		ON p.id_prod = c.id_prod
	INNER JOIN grocery.fournisseur f
		ON f.code_four = p.code_four
WHERE f.pays IS NOT NULL
ORDER BY pourcent DESC
;

-- Sous-requête dans le SELECT : à ne JAMAIS faire !!!
SELECT f.nom,
		p.nom_prod,
		p.prix,
        (SELECT SUM(prix) FROM grocery.produit WHERE code_four = 11) AS total, -- Sous-requête !
		(p.prix / (SELECT SUM(prix) FROM grocery.produit WHERE code_four = 11)) * 100 AS pourcent
FROM grocery.produit p
	INNER JOIN grocery.fournisseur f
		ON f.code_four = p.code_four
WHERE f.code_four = 11
;

-- Sous-requête dans le FROM
SELECT f.nom,
		p.nom_prod,
        p.prix
FROM grocery.fournisseur f
	INNER JOIN grocery.produit p
		ON f.code_four = p.code_four
;
--
SELECT code_four,
		SUM(prix) AS total
FROM grocery.produit
GROUP BY code_four
;
--
SELECT f.nom,
		p.nom_prod,
        (p.prix / stats.total) * 100 AS pct
FROM grocery.fournisseur f
	INNER JOIN grocery.produit p
		ON f.code_four = p.code_four
	INNER JOIN (SELECT code_four,
						SUM(prix) AS total
				FROM grocery.produit
				GROUP BY code_four) stats -- Sous-requête
		ON f.code_four = stats.code_four
;

-- Sous-requête avec WITH : CTE (Common Table Expression)

-- CTE
WITH stats AS (SELECT code_four,
		SUM(prix) AS total
FROM grocery.produit
GROUP BY code_four)
-- Requête principale
SELECT p.code_four,
		p.nom_prod,
		(p.prix / s.total) * 100 AS pct
FROM grocery.produit p
	INNER JOIN stats s
		ON p.code_four = s.code_four
ORDER BY  p.code_four -- 1
;

-- Sous-requête avec WITH : CTE récursive

WITH RECURSIVE nombres (n) AS (
	SELECT 1 -- Cas de base
	UNION ALL
	SELECT n + 1 FROM nombres WHERE n < 5 -- Partie récursive
)
SELECT * 
FROM nombres;

-- Sous-requête dans le WHERE

-- Liste des produits dont le prix est supérieur 
-- au prix moyen de tous les produits
SELECT AVG(prix) AS moyenne
FROM grocery.produit -- 46.669410
;
--
SELECT *
FROM grocery.produit
WHERE prix > 46.669410 -- Statique
;
--
SELECT *
FROM grocery.produit
WHERE prix > (SELECT AVG(prix) AS moyenne 
			FROM grocery.produit) -- Automatique
;

-- Sous-requête corrélée ou synchronisée

-- Liste des produits dont le prix est supérieur 
-- au prix moyen de tous les produits du même
-- fournisseur
SELECT *
FROM grocery.produit p1
WHERE p1.prix > (SELECT AVG(p2.prix) AS moyenne  
				FROM grocery.produit p2
                WHERE p1.code_four = p2.code_four) -- Synchro
;

-- Plan d'exécution : EXPLAIN
EXPLAIN
	WITH stats AS (SELECT code_four,
			SUM(prix) AS total
	FROM grocery.produit
	GROUP BY code_four)
	-- Requête principale
	SELECT p.code_four,
			p.nom_prod,
			(p.prix / s.total) * 100 AS pct
	FROM grocery.produit p
		INNER JOIN stats s
			ON p.code_four = s.code_four
	ORDER BY  p.code_four -- 1
;
-- vs
EXPLAIN
	SELECT f.nom,
			p.nom_prod,
			(p.prix / stats.total) * 100 AS pct
	FROM grocery.fournisseur f
		INNER JOIN grocery.produit p
			ON f.code_four = p.code_four
		INNER JOIN (SELECT code_four,
							SUM(prix) AS total
					FROM grocery.produit
					GROUP BY code_four) stats -- Sous-requête
			ON f.code_four = stats.code_four
;

-- Création d'un index 
CREATE INDEX idx_pdt_prix
ON grocery.produit(prix)
;