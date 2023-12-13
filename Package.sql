CREATE OR REPLACE 
PACKAGE PACKFASSEBOUC IS

-- PROCEDURE publique
PROCEDURE ajouterUtilisateur(idUtilisateur IN VARCHAR);
PROCEDURE connexion(idUtilisateur IN VARCHAR);

-- Varaible publique
utilisateurConnecte varchar(20);


END PACKFASSEBOUC;
