create or replace 
PACKAGE PACKFASSEBOUC IS

-- PROCEDURE publique
PROCEDURE ajouterUtilisateur(idUtilisateur IN VARCHAR);
PROCEDURE supprimerUtilisateur;
PROCEDURE connexion(idUtilisateur IN VARCHAR);
PROCEDURE deconnexion;
PROCEDURE ajouterAmi(idAmi IN VARCHAR);
PROCEDURE supprimerAmi(idAmi IN VARCHAR);
PROCEDURE afficherMur(idUtilisateur IN VARCHAR);
PROCEDURE ajouterMessageMur(message IN VARCHAR);
PROCEDURE supprimerMessageMur(message_id IN VARCHAR);
PROCEDURE afficherAmi(loginUtilisateur IN VARCHAR);

-- Varaible publique
utilisateurConnecte varchar(20);


END PACKFASSEBOUC;