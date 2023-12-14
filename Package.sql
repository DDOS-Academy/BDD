create or replace 
PACKAGE PACKFASSEBOUC IS

-- PROCEDURE publique
PROCEDURE ajouterUtilisateur(idUtilisateur IN VARCHAR);
PROCEDURE connexion(idUtilisateur IN VARCHAR);
PROCEDURE deconnexion;
PROCEDURE supprimerUtilisateur;
PROCEDURE ajouterAmi(idAmi IN VARCHAR);
PROCEDURE supprimerAmi(idAmi IN VARCHAR);
PROCEDURE afficherMur(idUtilisateur IN VARCHAR);

-- Varaible publique
utilisateurConnecte varchar(20);


END PACKFASSEBOUC;