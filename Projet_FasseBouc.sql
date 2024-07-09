CREATE TABLE Utilisateur(
   loginUtilisateur VARCHAR(50),
   PRIMARY KEY(loginUtilisateur)
);

CREATE TABLE Message(
   id_message NUMBER(3),
   dateMessage DATE,
   message VARCHAR(50),
   loginUtilisateur VARCHAR(50) NOT NULL,
   loginUtilisateur_1 VARCHAR(50) NOT NULL,
   PRIMARY KEY(id_message),
   FOREIGN KEY(loginUtilisateur) REFERENCES Utilisateur(loginUtilisateur) ON DELETE CASCADE,
   FOREIGN KEY(loginUtilisateur_1) REFERENCES Utilisateur(loginUtilisateur) ON DELETE CASCADE
);

CREATE TABLE être_ami(
   loginUtilisateur VARCHAR(50),
   loginUtilisateur_1 VARCHAR(50),
   PRIMARY KEY(loginUtilisateur, loginUtilisateur_1),
   FOREIGN KEY(loginUtilisateur) REFERENCES Utilisateur(loginUtilisateur) ON DELETE CASCADE,
   FOREIGN KEY(loginUtilisateur_1) REFERENCES Utilisateur(loginUtilisateur) ON DELETE CASCADE
);

CREATE TABLE Repondre(
   loginUtilisateur VARCHAR(50),
   id_message NUMBER(3),
   MessageReponse VARCHAR(50) NOT NULL,
   PRIMARY KEY(loginUtilisateur, id_message),
   FOREIGN KEY(loginUtilisateur) REFERENCES Utilisateur(loginUtilisateur) ON DELETE CASCADE,
   FOREIGN KEY(id_message) REFERENCES Message(id_message) ON DELETE CASCADE
);