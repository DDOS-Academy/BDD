create or replace 
PACKAGE BODY packfassebouc IS
  estConnecte NUMBER(1) := 0; 
  utilisateurActuelle VARCHAR2(50);
  dernierMessage NUMBER(3) := 1;
    
  ------------------------------------------------
  --FONCTIONS 
  ------------------------------------------------
  
  FUNCTION loginExiste(loginU IN VARCHAR2) RETURN NUMBER 
  IS
    existe NUMBER(1);
  BEGIN
    SELECT COUNT(*) INTO existe FROM Utilisateur WHERE loginUtilisateur = loginU; -- Test si le login ami existe
    RETURN existe;
  END loginExiste;
  
  FUNCTION messageExiste(messageASupprimer IN VARCHAR2) RETURN NUMBER
  IS
    existe NUMBER(1);
  BEGIN
    SELECT COUNT(*) INTO existe FROM message WHERE id_message = messageASupprimer; 
    RETURN existe;
  END messageExiste;
  
  FUNCTION dejaAmi(loginAmi IN VARCHAR2) RETURN NUMBER 
  IS
    dejaAmi NUMBER(1);
  BEGIN
    SELECT COUNT(*) INTO dejaAmi FROM être_ami WHERE loginUtilisateur = loginAmi AND loginUtilisateur_1 = utilisateurActuelle; -- Test si l'utilsateur n'est pas déjà amis avec la personne
    RETURN dejaAmi;
  END dejaAmi;
  
  FUNCTION getPkFromMessageSeq RETURN NUMBER
  IS
    reponse NUMBER(1);
  BEGIN
    SELECT COUNT(message) INTO reponse FROM message WHERE id_message = dernierMessage;
    IF reponse = 0 THEN 
      RETURN dernierMessage;
    ELSE 
      SELECT COUNT(*) INTO reponse FROM message;
      FOR i IN 0 .. reponse LOOP
        SELECT COUNT(message) INTO reponse FROM message WHERE id_message = (dernierMessage + i);
        IF reponse = 0 THEN
          dernierMessage := dernierMessage + i;
          RETURN dernierMessage;
        END IF;
      END LOOP;
      dernierMessage := dernierMessage +1;
      RETURN dernierMessage;
    END IF;
  END getPkFromMessageSeq;
  
  ------------------------------------------------
  --PROCEDURE
  ------------------------------------------------
  
  
  PROCEDURE ajouterUtilisateur(loginU IN Utilisateur.loginUtilisateur%TYPE) 
  IS
    reponse NUMBER(1);
  BEGIN
    reponse := loginExiste(loginU); 
    IF reponse = 0 THEN 
      INSERT INTO Utilisateur VALUES(loginU);
      dbms_output.put_line(loginU || ' a été ajouté.');
    ELSE 
      dbms_output.put_line(loginU || ' existe déjà.');
    END IF;
  END ajouterUtilisateur;
  

  PROCEDURE supprimerUtilisateur
  IS
  BEGIN
    IF estConnecte = 1 THEN 
      DELETE FROM Utilisateur WHERE loginUtilisateur = utilisateurActuelle;
      dbms_output.put_line(utilisateurActuelle || ' a été supprimé.');
      estConnecte := 0;
    ELSE 
      dbms_output.put_line('Vous n"êtes pas connecté.');
    END IF;    
  END supprimerUtilisateur;


  PROCEDURE connexion(loginU IN utilisateur.loginUtilisateur%TYPE)
  IS
    reponse NUMBER(1);
  BEGIN
    IF estConnecte = 1 THEN
      dbms_output.put_line('Veuillez vous déconnecter de ' || utilisateurActuelle);
    ELSE 
      reponse := loginExiste(loginU);
      IF reponse = 1 THEN 
        utilisateurActuelle := loginU;
        estConnecte := 1;
        dbms_output.put_line('Bienvenue ' || utilisateurActuelle || ' vous êtes connecté');
      ELSE 
        dbms_output.put_line('Cet utilisteur n"existe pas.');
      END IF;
    END IF;
  END connexion;


  PROCEDURE deconnexion
  IS
  BEGIN
    estConnecte := 0;
    dbms_output.put_line('Vous êtes déconnecté');
  END deconnexion;
  

  PROCEDURE ajouterAmi(loginAmi IN être_ami.loginUtilisateur_1%TYPE)
  IS
    reponse NUMBER(1);
  BEGIN
    IF estConnecte = 1 THEN 
      reponse := loginExiste(loginAmi);
      IF reponse = 0 THEN 
        dbms_output.put_line(loginAmi || ' n"existe pas');
      ELSE IF loginAmi = utilisateurActuelle THEN
          dbms_output.put_line('Vous ne pouvez pas être ami avec vous même');
          ELSE 
          reponse := dejaAmi(loginAmi);
          IF reponse = 0 THEN
            INSERT INTO ÊTRE_AMI VALUES(utilisateurActuelle, loginAmi); 
            INSERT INTO ÊTRE_AMI VALUES(loginAmi, utilisateurActuelle);
            dbms_output.put_line('Vous êtes ami avec ' || loginAmi);
          ELSE
            dbms_output.put_line('Vous êtes déjà amis avec ' || loginAmi);
          END IF;
        END IF;
      END IF;
    ELSE 
      dbms_output.put_line('Vous n"êtes pas connecté.');
    END IF;
  END ajouterAmi;
  
  PROCEDURE supprimerAmi(loginAmi IN être_ami.loginUtilisateur_1%TYPE)
  IS
    reponse NUMBER(1);
  BEGIN
    IF estConnecte = 1 THEN 
      reponse := loginExiste(loginAmi); 
      IF reponse = 0 THEN
        dbms_output.put_line(loginAmi || ' n"existe pas');
        ELSE IF loginAmi = utilisateurActuelle THEN
          dbms_output.put_line('Vous ne pouvez pas être ami avec vous même');
          ELSE
          reponse := dejaAmi(loginAmi);
          IF reponse != 0 THEN
            DELETE FROM ÊTRE_AMI WHERE loginUtilisateur = utilisateurActuelle AND loginUtilisateur_1 = loginAmi;
            DELETE FROM ÊTRE_AMI WHERE loginUtilisateur = loginAmi AND loginUtilisateur_1 = utilisateurActuelle;
            dbms_output.put_line('Vous n"êtes plus ami avec ' || loginAmi);
          ELSE 
            dbms_output.put_line('Vous n"êtes pas amis avec ' || loginAmi);
          END IF;
        END IF;
      END IF;
    ELSE 
      dbms_output.put_line('Vous n"êtes pas connecté.');
    END IF;
  END supprimerAmi;


  PROCEDURE afficherMur(loginU IN utilisateur.loginUtilisateur%TYPE)
  IS
    CURSOR curseurafficherMur IS SELECT id_message, message FROM message WHERE loginUtilisateur = utilisateurActuelle AND loginUtilisateur_1 = loginU;
    reponse NUMBER(1);
  BEGIN
    IF estConnecte = 1 THEN
      reponse := loginExiste(loginU);
      IF reponse = 1 THEN
        dbms_output.put_line('Messages reçu de ' || loginU || ' :');
        FOR i IN curseurafficherMur LOOP
          dbms_output.put('N°' || i.id_message || ' ');
          dbms_output.put_line(i.message);
        END LOOP;
      ELSE 
        dbms_output.put_line('Vous n"êtes pas amis avec ' || loginU);
      END IF;
    ELSE 
      dbms_output.put_line('Vous n"êtes pas connecté.');
    END IF;
  END afficherMur;
  
  PROCEDURE ajouterMessageMur(loginAmi IN être_ami.loginUtilisateur_1%TYPE, message IN message.message%TYPE)
  IS
    reponse NUMBER(3);
  BEGIN
    IF estConnecte = 1 THEN
      reponse := loginExiste(loginAmi); 
      IF reponse = 1 THEN
        IF loginAmi = utilisateurActuelle THEN
          reponse := getpkfrommessageseq();
          INSERT INTO message VALUES(reponse, sysdate, message, utilisateurActuelle, loginAmi);
          dbms_output.put_line('Vous avez ajouté "' || message || '" sur votre mur');
        ELSE 
          reponse := dejaAmi(loginAmi);
          IF reponse = 1 THEN
            reponse := getpkfrommessageseq();
            INSERT INTO message VALUES(reponse, sysdate, message, utilisateurActuelle, loginAmi);
            dbms_output.put_line('Vous avez ajouté "' || message || '" sur le mur de ' || loginAmi);
          ELSE 
            dbms_output.put_line('Vous n"êtes pas amis avec ' || loginAmi);
          END IF;
        END IF;
      ELSE 
        dbms_output.put_line('Cet utilisteur n"existe pas.');
      END IF;
    ELSE 
      dbms_output.put_line('Vous n"êtes pas connecté.');
    END IF;
  END ajouterMessageMur;
  

  PROCEDURE supprimerMessageMur(idMessageASupprimer IN message.id_message%TYPE)
  IS
    reponse NUMBER(1);
  BEGIN
    reponse := messageExiste(idMessageASupprimer);
    IF reponse = 1 THEN
      DELETE FROM message WHERE id_message = idMessageASupprimer;
      dernierMessage := idMessageASupprimer;
      dbms_output.put_line('Message supprimé');
    ELSE 
      dbms_output.put_line('Ce message n"existe pas');
    END IF;
  END supprimerMessageMur;
  

  PROCEDURE repondreMessageMur(id_message IN message.id_message%TYPE, messageReponse IN repondre.messagereponse%TYPE)
  IS
  BEGIN
    dbms_output.put_line('TODO');
  END repondreMessageMur;
  

  PROCEDURE afficherAmi(loginU IN utilisateur.loginUtilisateur%TYPE)
  IS
    reponse NUMBER(1);
    CURSOR curseurAmiSelectionne IS SELECT loginUtilisateur_1 FROM être_ami WHERE loginUtilisateur = loginU;
  BEGIN
    IF estConnecte = 1 THEN 
      reponse := loginExiste(loginU);
      IF reponse = 1 THEN
        FOR i IN curseurAmiSelectionne LOOP
          dbms_output.put_line(i.loginUtilisateur_1);
        END LOOP;
      ELSE 
        dbms_output.put_line('Vous n"êtes pas amis avec ' || loginU);
      END IF;
    ELSE 
      dbms_output.put_line('Vous n"êtes pas connecté.');
    END IF;
  END afficherAmi;
  

  PROCEDURE compterAmi(loginU IN utilisateur.loginUtilisateur%TYPE)
  IS
    reponse NUMBER(1);
  BEGIN
    IF estConnecte = 1 THEN 
      reponse := loginExiste(loginU);
      IF reponse = 0 THEN
        dbms_output.put_line(loginU || ' n"existe pas');
      ELSE 
        SELECT COUNT(*) INTO reponse FROM être_ami WHERE loginUtilisateur = loginU;
        dbms_output.put_line(loginU || ' a ' || reponse || ' amis.');
      END IF;
    ELSE 
      dbms_output.put_line('Vous n"êtes pas connecté.');
    END IF;
  END compterAmi;
  

  PROCEDURE chercherMembre(préfixeLoginMembre IN utilisateur.loginUtilisateur%TYPE)
  IS
    CURSOR curseurChercherMembre IS SELECT loginUtilisateur FROM utilisateur WHERE loginUtilisateur LIKE préfixeLoginMembre || '%';
  BEGIN
    IF estConnecte = 1 THEN 
      FOR i IN curseurChercherMembre LOOP
        dbms_output.put_line(i.loginUtilisateur);
      END LOOP;
    ELSE 
      dbms_output.put_line('Vous n"êtes pas connecté.');
    END IF;
  END chercherMembre; 
END packfassebouc;