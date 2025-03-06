set role readwrite;

-- usage
use greta;

-- lecture
select *
from greta.module
;
-- mise à jour
update greta.module
-- set id_mod = 'CP01'
set code_prof = 1
where id_mod = 'CP1';

-- insertion
insert into greta.module(id_mod, titre)
values('PSV', 'Préparer ses vacances');

-- suppression
delete from greta.prof
where id_prof = 100;

-- mais...
select *
from grocery.produit;