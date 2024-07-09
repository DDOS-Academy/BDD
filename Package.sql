CREATE OR REPLACE
PACKAGE packfassebouc IS
  PROCEDURE ajouterUtilisateur(loginU IN Utilisateur.loginUtilisateur%TYPE);

  PROCEDURE supprimerUtilisateur;

  PROCEDURE connexion(loginU IN utilisateur.loginUtilisateur%TYPE);

  PROCEDURE deconnexion;

  PROCEDURE ajouterAmi(loginAmi IN être_ami.loginUtilisateur_1%TYPE);

  PROCEDURE supprimerAmi(loginAmi IN être_ami.loginUtilisateur_1%TYPE);

  PROCEDURE afficherMur(loginU IN utilisateur.loginUtilisateur%TYPE);

  PROCEDURE ajouterMessageMur(loginAmi IN être_ami.loginUtilisateur_1%TYPE, message IN message.message%TYPE);

  PROCEDURE supprimerMessageMur(id_message IN message.id_message%TYPE);

  PROCEDURE repondreMessageMur(id_message IN message.id_message%TYPE, messageReponse IN repondre.messagereponse%TYPE);

  PROCEDURE afficherAmi(loginU IN utilisateur.loginUtilisateur%TYPE);

  PROCEDURE compterAmi(loginU IN utilisateur.loginUtilisateur%TYPE);

  PROCEDURE chercherMembre(préfixeLoginMembre IN utilisateur.loginUtilisateur%TYPE);
END packfassebouc;