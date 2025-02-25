CREATE TABLE fournisseur(
   code_four INT AUTO_INCREMENT,
   nom VARCHAR(100)  NOT NULL,
   pays VARCHAR(50) ,
   PRIMARY KEY(code_four)
);

CREATE TABLE client(
   id_cli INT AUTO_INCREMENT,
   nom VARCHAR(50)  NOT NULL,
   prenom VARCHAR(50) ,
   naiss DATE,
   ville VARCHAR(50) ,
   pays VARCHAR(50)  NOT NULL,
   PRIMARY KEY(id_cli)
);

CREATE TABLE commande(
   no_comm INT AUTO_INCREMENT,
   date_comm DATETIME NOT NULL,
   PRIMARY KEY(no_comm)
);

CREATE TABLE produit(
   id_prod INT AUTO_INCREMENT,
   nom_prod VARCHAR(50)  NOT NULL,
   prix DECIMAL(7,2)   NOT NULL,
   photo BLOB,
   code_four INT NOT NULL,
   PRIMARY KEY(id_prod),
   FOREIGN KEY(code_four) REFERENCES fournisseur(code_four)
);

CREATE TABLE passer(
   id_cli INT,
   no_comm INT,
   PRIMARY KEY(id_cli, no_comm),
   FOREIGN KEY(id_cli) REFERENCES client(id_cli),
   FOREIGN KEY(no_comm) REFERENCES commande(no_comm)
);

CREATE TABLE concerner(
   id_prod INT,
   no_comm INT,
   qte TINYINT NOT NULL,
   prix DECIMAL(7,2)   NOT NULL,
   PRIMARY KEY(id_prod, no_comm),
   FOREIGN KEY(id_prod) REFERENCES produit(id_prod),
   FOREIGN KEY(no_comm) REFERENCES commande(no_comm)
);
