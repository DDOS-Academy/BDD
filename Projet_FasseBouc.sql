CREATE TABLE Utilisateur(
   loginUser VARCHAR(20),
   PRIMARY KEY(loginUser)
);

CREATE TABLE Message(
   idMessage INT,
   dateMessage DATE NOT NULL,
   contenu VARCHAR(50) NOT NULL,
   loginUser VARCHAR(20) NOT NULL,
   loginUser_1 VARCHAR(20) NOT NULL,
   PRIMARY KEY(idMessage),
   FOREIGN KEY(loginUser) REFERENCES Utilisateur(loginUser),
   FOREIGN KEY(loginUser_1) REFERENCES Utilisateur(loginUser)
);

CREATE TABLE Etre_ami(
   loginUser VARCHAR(20),
   loginUser_1 VARCHAR(20),
   PRIMARY KEY(loginUser, loginUser_1),
   FOREIGN KEY(loginUser) REFERENCES Utilisateur(loginUser),
   FOREIGN KEY(loginUser_1) REFERENCES Utilisateur(loginUser)
);

CREATE TABLE Repondre(
   loginUser VARCHAR(20),
   idMessage INT,
   messageReponse VARCHAR(50) NOT NULL,
   dateMessage DATE NOT NULL,
   PRIMARY KEY(loginUser, idMessage),
   FOREIGN KEY(loginUser) REFERENCES Utilisateur(loginUser),
   FOREIGN KEY(idMessage) REFERENCES Message(idMessage)
);

COMMIT;


select * from utilisateur;

SET SERVEROUTPUT ON;

EXECUTE ajouterUtilisateur('gabin');
EXECUTE PACKFASSEBOUC.connexion('gabin');
EXECUTE PACKFASSEBOUC.deconnexion;
EXECUTE PACKFASSEBOUC.supprimerutilisateur;

CREATE SEQUENCE seq_message_id
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;