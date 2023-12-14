create or replace 
PACKAGE BODY PACKFASSEBOUC IS
 
/* Procédures privées */
PROCEDURE deleteAllFriends
  IS
  BEGIN
    EXECUTE IMMEDIATE 'DELETE FROM etre_ami WHERE loginUser='''||utilisateurConnecte||''' OR loginUser_1='''||utilisateurConnecte||'''';
    dbms_output.put_line('Tout les amis de : '||utilisateurConnecte||' sont supprimés');
END deleteAllFriends;
      
PROCEDURE deleteAllMessages
  IS
  BEGIN
    EXECUTE IMMEDIATE 'DELETE FROM message WHERE loginUser='''||utilisateurConnecte||''' OR loginUser_1='''||utilisateurConnecte||'''';
    EXECUTE IMMEDIATE 'DELETE FROM repondre WHERE loginUser='''||utilisateurConnecte||'''';
    dbms_output.put_line('Tout les messages à destination et provenant de : '||utilisateurConnecte||' ont été supprimés');
END deleteAllMessages;



/* Procédures publiques */
  PROCEDURE ajouterUtilisateur (idUtilisateur IN VARCHAR)
    IS
    BEGIN
      IF idUtilisateur IS NULL THEN
        dbms_output.put_line('Erreur login utilisateur');
      ELSE
        EXECUTE IMMEDIATE  'INSERT INTO utilisateur values ('''||idUtilisateur||''')';
        dbms_output.put_line('Nouvel utilisateur : ' || idUtilisateur);
      END IF;    
      EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
        dbms_output.put_line('Utilisateur déjà existant');
  END ajouterUtilisateur;
  
  PROCEDURE connexion (idUtilisateur IN VARCHAR)
    IS
      nbUser NUMBER(1);
    BEGIN
      IF idUtilisateur IS NULL THEN
        dbms_output.put_line('Erreur login utilisateur');
      ELSE
        IF utilisateurConnecte IS NULL THEN
          SELECT COUNT(loginUser) INTO nbUser FROM utilisateur WHERE loginUser = idUtilisateur;
          IF nbUser <> 0 THEN
            utilisateurConnecte := idUtilisateur;
            dbms_output.put_line('Utilisateur connecté : ' || utilisateurConnecte);
          ELSE
          dbms_output.put_line('L"utilisateur "' || idUtilisateur || '" n"existe pas' );
          END IF;
        ELSE
          dbms_output.put_line('Utilisateur ' || utilisateurConnecte || ' déjà connecté');
        END IF;       
      END IF;
  END connexion;
  
  PROCEDURE deconnexion 
    IS
    BEGIN
      IF utilisateurConnecte IS NULL THEN
        dbms_output.put_line('Aucun utilisateur de connecté');
      ELSE
        dbms_output.put_line('Utilisateur : ' || utilisateurConnecte || ' déconnecté');
        utilisateurConnecte := NULL;
      END IF;
  END deconnexion;
  
  PROCEDURE supprimerUtilisateur
    IS
    BEGIN
      IF utilisateurConnecte IS NULL THEN
        dbms_output.put_line('Aucun utilisateur de connecté');
      ELSE
        deleteAllFriends;
        deleteAllMessages;
        EXECUTE IMMEDIATE 'DELETE FROM utilisateur WHERE loginUser='''||utilisateurConnecte||'''';
        dbms_output.put_line('Utilisateur : ' ||utilisateurConnecte|| ' supprimé');
        deconnexion;
      END IF;
  END supprimerUtilisateur;

  PROCEDURE ajouterAmi(idAmi IN VARCHAR)
    IS
    nbUser NUMBER(1);
    BEGIN 
      IF utilisateurConnecte IS NULL THEN
        dbms_output.put_line('Aucun utilisateur de connecté');
      ELSE
        IF idAmi IS NULL THEN
          dbms_output.put_line('Veuillez entrer un nom d utilisateur');
        ELSE 
          SELECT COUNT(loginUser) INTO nbUser FROM utilisateur WHERE loginUser = idAmi;
          IF nbUser <> 0 THEN
            EXECUTE IMMEDIATE  'INSERT INTO etre_ami values ('''||utilisateurConnecte||''','''||idAmi||''')';
            dbms_output.put_line('Vous êtes désormais ami avec '||idAmi|| ' !');
          END IF;
         END IF;
        END IF;
    END ajouterAmi; 
    
    PROCEDURE supprimerAmi(idAmi IN VARCHAR)
      IS
      nbUser NUMBER(1);
      BEGIN
        IF utilisateurConnecte IS NULL THEN
          dbms_output.put_line('Aucun utilisateur de connecté');
        ELSE
          IF idAmi IS NULL THEN
            dbms_output.put_line('Veuillez entrer un nom d utilisateur');
          ELSE
          SELECT COUNT(idAmi) INTO nbUser FROM etre_ami WHERE loginUser = utilisateurConnecte AND loginUser_1 = idAmi;
            IF nbUser <> 0 THEN
              EXECUTE IMMEDIATE  'DELETE FROM etre_ami WHERE loginUser='''||utilisateurConnecte||''' AND loginUser_1='''||idAmi||'''';
              dbms_output.put_line('Vous n''êtes désormais plus ami avec '||idAmi|| ' !');
            END IF;
          END IF;
        END IF;
      END supprimerAmi;
      
      

END PACKFASSEBOUC;