USE grocery
;

UPDATE produit
SET nom_prod = REPLACE(nom_prod, 'Pepsi', 'ペプシ')
WHERE nom_prod LIKE '%Pepsi%'
;

UPDATE client
SET prenom = 'محمد'
WHERE prenom IS NULL
;