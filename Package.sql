create or replace 
PACKAGE PACKFASSEBOUC IS

-- PROCEDURE publique
PROCEDURE ajouterUtilisateur(idUtilisateur IN VARCHAR);
PROCEDURE supprimerUtilisateur;
PROCEDURE connexion(idUtilisateur IN VARCHAR);
PROCEDURE deconnexion;
PROCEDURE ajouterAmi(idAmi IN VARCHAR);
PROCEDURE supprimerAmi(idAmi IN VARCHAR);
PROCEDURE compterAmi (idUtilisateur IN VARCHAR);
PROCEDURE afficherAmi(idUtilisateur IN VARCHAR);
PROCEDURE afficherMur(idUtilisateur IN VARCHAR);
PROCEDURE ajouterMessageMur(idAmi IN VARCHAR, message IN VARCHAR);
PROCEDURE supprimerMessageMur(message_id IN VARCHAR);
PROCEDURE repondreMessageMur(idMessage1 IN NUMBER, messageReponse IN VARCHAR, idUtilisateur IN VARCHAR);
PROCEDURE chercherMembre(prefixeUtilisateur IN VARCHAR);


-- Varaible publique
utilisateurConnecte varchar(20);


END PACKFASSEBOUC;