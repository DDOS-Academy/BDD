create or replace 
PACKAGE BODY PACKFASSEBOUC IS
 
/* Procédures privées */
PROCEDURE deleteAllFriends
  IS
  BEGIN
    EXECUTE IMMEDIATE 'DELETE FROM etre_ami WHERE loginUser='''||utilisateurConnecte||''' OR loginUser_1='''||utilisateurConnecte||'''';
    dbms_output.put_line('Tout les amis de : '||utilisateurConnecte||' sont supprimés');
END deleteAllFriends;
      
PROCEDURE deleteAllMessages --Procédure de suppression de tous les messages de l'utilisateur connecté
  IS
  BEGIN
    EXECUTE IMMEDIATE 'DELETE FROM message WHERE loginUser='''||utilisateurConnecte||''' OR loginUser_1='''||utilisateurConnecte||''''; --Suppression des messages envoyés et recus par l'utilisateur connecté
    EXECUTE IMMEDIATE 'DELETE FROM repondre WHERE loginUser='''||utilisateurConnecte||''''; -- Suppression des message auxquels l'utilisateur a répondu
    dbms_output.put_line('Tout les messages à destination et provenant de : '||utilisateurConnecte||' ont été supprimés');
END deleteAllMessages;



/* Procédures publiques */
  PROCEDURE ajouterUtilisateur (idUtilisateur IN VARCHAR)--Procédure de d'ajout d'ajout d'un utilisateur
    IS
    BEGIN
      IF idUtilisateur IS NULL THEN
        dbms_output.put_line('Erreur login utilisateur'); -- Si le nom d'utilisateur n'est pas saisis 
      ELSE
        EXECUTE IMMEDIATE  'INSERT INTO utilisateur values ('''||idUtilisateur||''')'; -- Créer l'utilisateur 
        dbms_output.put_line('Nouvel utilisateur : ' || idUtilisateur);
      END IF;    
      EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
        dbms_output.put_line('Utilisateur déjà existant'); -- Exception si l'utilisateur existe déjà
  END ajouterUtilisateur;
  
  PROCEDURE connexion (idUtilisateur IN VARCHAR) --Procédure de connexion à un utilisateur
    IS
      nbUser NUMBER(1); -- Vérification qu'il y a des utilisateurs d'enregistrés
    BEGIN
      IF idUtilisateur IS NULL THEN
        dbms_output.put_line('Erreur login utilisateur'); -- Si le nom d'utilisateur n'est pas saisis 
      ELSE
        IF utilisateurConnecte IS NULL THEN
          SELECT COUNT(loginUser) INTO nbUser FROM utilisateur WHERE loginUser = idUtilisateur;
          IF nbUser <> 0 THEN -- Vérifier que le login correspond à un utilisateur existant 
            utilisateurConnecte := idUtilisateur; -- Se connecter à l'utilisateur choisit
            dbms_output.put_line('Utilisateur connecté : ' || utilisateurConnecte);
          ELSE
          dbms_output.put_line('L"utilisateur "' || idUtilisateur || '" n"existe pas' ); -- L'utilisateur n'existe pas
          END IF;
        ELSE
          dbms_output.put_line('Utilisateur ' || utilisateurConnecte || ' déjà connecté'); -- Déjà connecté à l'utilisateur
        END IF;       
      END IF;
  END connexion;
  
  PROCEDURE deconnexion  -- Procédure de deconnexion
    IS
    BEGIN
      IF utilisateurConnecte IS NULL THEN
        dbms_output.put_line('Aucun utilisateur de connecté'); -- Personne n'est connecté
      ELSE
        dbms_output.put_line('Utilisateur : ' || utilisateurConnecte || ' déconnecté'); -- Déconnecte l'utilisateur
        utilisateurConnecte := NULL; -- Retour de la valeur de connexion à null
      END IF;
  END deconnexion;
  
  PROCEDURE supprimerUtilisateur --Procédure de suppression d'un utilisateur
    IS
    BEGIN
      IF utilisateurConnecte IS NULL THEN
        dbms_output.put_line('Aucun utilisateur de connecté'); -- Personne n'est connecté
      ELSE
        deleteAllFriends; --utilisation de la procédure de suppression des amis
        deleteAllMessages;--utilisation de la procédure de suppression des messages
        EXECUTE IMMEDIATE 'DELETE FROM utilisateur WHERE loginUser='''||utilisateurConnecte||''''; -- Suppression de l'utilisateur 
        dbms_output.put_line('Utilisateur : ' ||utilisateurConnecte|| ' supprimé'); 
        deconnexion; --utilisation de la procédure de déconnexion
      END IF;
  END supprimerUtilisateur;

  PROCEDURE ajouterAmi(idAmi IN VARCHAR) --Procédure d'ajout d'un amis 
    IS
    nbUser NUMBER(1);
    BEGIN 
      IF utilisateurConnecte IS NULL THEN -- Personne n'est connecté
        dbms_output.put_line('Aucun utilisateur de connecté'); 
      ELSE
        IF idAmi IS NULL OR idAmi = utilisateurConnecte THEN
          dbms_output.put_line('Veuillez entrer un nom d utilisateur correct'); -- L'utilisateur n'existe pas ou le lien n'est pas faisable 
        ELSE 
          SELECT COUNT(loginUser) INTO nbUser FROM utilisateur WHERE loginUser = idAmi;
          IF nbUser <> 0 THEN -- Vérifier que l'amis existe
            EXECUTE IMMEDIATE  'INSERT INTO etre_ami values ('''||utilisateurConnecte||''','''||idAmi||''')'; -- Ajout de l'ami 
            dbms_output.put_line('Vous êtes désormais ami avec '||idAmi|| ' !');
          END IF;
         END IF;
        END IF;
    END ajouterAmi; 
    
    PROCEDURE supprimerAmi(idAmi IN VARCHAR) -- Procédure de suppression de lien d'amitié
      IS
      nbUser NUMBER(1);
      BEGIN
        IF utilisateurConnecte IS NULL THEN -- Personne n'est connecté
          dbms_output.put_line('Aucun utilisateur de connecté');
        ELSE
          IF idAmi IS NULL THEN -- L'utilisateur n'existe pas
            dbms_output.put_line('Veuillez entrer un nom d utilisateur correcte');
          ELSE
          SELECT COUNT(idAmi) INTO nbUser FROM etre_ami WHERE loginUser = utilisateurConnecte AND loginUser_1 = idAmi;
            IF nbUser <> 0 THEN -- Vérifier que l'utilisateur a des amis
              EXECUTE IMMEDIATE  'DELETE FROM etre_ami WHERE loginUser='''||utilisateurConnecte||''' AND loginUser_1='''||idAmi||''''; -- Suppression des liens d'amitié
              dbms_output.put_line('Vous n''êtes désormais plus ami avec '||idAmi|| ' !');
            END IF;
          END IF;
        END IF;
      END supprimerAmi;
      
      
      PROCEDURE afficherMur(idUtilisateur IN VARCHAR) --Procédure d'affichage du mur
        IS
        nbUser NUMBER(1); -- Variable locale
        nbMessage NUMBER(1); -- Variable locale
        BEGIN
          IF idUtilisateur IS NULL THEN -- Personne n'est connecté
            dbms_output.put_line('Veuillez entrer un nom d utilisateur correct');
          END IF;
            SELECT COUNT(loginUser) INTO nbUser FROM utilisateur WHERE loginUser = idUtilisateur; -- Vérification que l'utilisateur existe
            SELECT COUNT(idMessage) INTO nbMessage FROM message WHERE loginUser_1 = idUtilisateur; -- Vérification que le mur contient des messages
              IF nbUser <> 0 AND nbMessage <> 0 THEN -- Si le nombre d'utilisateur et de message est différent de 0, 
                EXECUTE IMMEDIATE 'SELECT * FROM message WHERE loginUser_1='''||idUtilisateur||''' ORDER BY dateMessage'; -- Séléction des messages reçus par l'utilisateur et affichage de ceux ci
              ELSE 
                dbms_output.put_line('Aucun message reçu par '||idUtilisateur||'');
              END IF;
      END afficherMur;


       PROCEDURE ajouterMessageMur(idAmi IN VARCHAR, message IN VARCHAR)
        IS
        v_idMessage INT;
        nbUser NUMBER(1);
        BEGIN
        SELECT seq_message_id.NEXTVAL INTO v_idMessage FROM DUAL;
          IF idAmi IS NULL OR message IS NULL THEN 
            dbms_output.put_line('Veuillez remplir tout les champs');
          END IF;
          SELECT COUNT(loginUser) INTO nbUser FROM utilisateur WHERE loginUser = idAmi;
          IF nbUser <> 0 THEN
            EXECUTE IMMEDIATE 'INSERT INTO Message VALUES('''||v_idMessage||''', '''||SYSDATE||''', '''||message||''', '''||utilisateurConnecte||''', '''||idAmi||''')';
            DBMS_OUTPUT.PUT_LINE('Le message a été ajouté avec succès.');
          ELSE 
            dbms_output.put_line('Veuillez entrer un nom d utilisateur correct');
          END IF;
        v_idMessage := message_id.nextval;
      END ajouterMessageMur;


      PROCEDURE supprimerMessageMur(message_id IN VARCHAR)
      IS
        nbMessage NUMBER := 0;
        nbUser NUMBER := 0;
      BEGIN
        IF utilisateurConnecte IS NULL THEN -- Personne n'est connecté
          dbms_output.put_line('Veuillez vous connecter');
        END IF;
        SELECT COUNT(loginUser) INTO nbUser FROM utilisateur WHERE loginUser = utilisateurConnecte; -- Vérification que l'utilisateur existe
        SELECT COUNT(message_id) INTO nbMessage FROM message WHERE loginUser = utilisateurConnecte; -- Vérification que le mur contient des messages
        SELECT COUNT(contenu) INTO nbMessage FROM message WHERE idmessage = message_id;
          IF nbMessage <> 0 THEN
            EXECUTE IMMEDIATE 'DELETE FROM Mur WHERE idmessage = message_id AND loginUser='||utilisateurConnecte||'';
            dbms_output.put_line('Votre message a été supprimé du mur.');
          ELSE
            dbms_output.put_line('Aucun message correspondant trouvé dans le mur.');
          END IF;
      END supprimerMessageMur;

      PROCEDURE afficherAmi(idUtilisateur IN VARCHAR)
      IS
      nbUser NUMBER(1);
      BEGIN
      IF idUtilisateur IS NULL THEN
        dbms_output.put_line('Entrez un utilisateur');
      END IF;

        SELECT COUNT(loginUser) INTO nbUser FROM utilisateur WHERE loginUser = idUtilisateur;
      IF nbUser <> 0 THEN
        EXECUTE IMMEDIATE 'SELECT * FROM etre_ami WHERE loginUser = '''||idUtilisateur||''' OR loginUser_1 = '''||idUtilisateur||'''';
      ELSE  
        dbms_output.put_line('Veuillez entrer un utilisateur valide');
      END IF;
      END afficherAmi;

      PROCEDURE compterAmi(idUtilisateur IN VARCHAR)
      IS
      nbUser NUMBER(1);
      BEGIN
      IF idUtilisateur IS NULL THEN
        dbms_output.put_line('Entrez un utilisateur');
      END IF;
        SELECT COUNT(loginUser) INTO nbUser FROM utilisateur WHERE loginUser = idUtilisateur;
        IF nbUser <> 0 THEN
          SELECT COUNT (loginUser) INTO nbUser FROM etre_ami WHERE loginUser = idUtilisateur OR loginUser_1 = idUtilisateur;
          dbms_output.put_line('Vous avez '||nbUser||' ami(s)');
        ELSE  
          dbms_output.put_line('Veuillez entrer un utilisateur valide');
        END IF;
      END compterAmi;

      PROCEDURE repondreMessageMur (idMessage1 IN NUMBER, messageReponse IN VARCHAR, idUtilisateur IN VARCHAR)
      IS
      a_idMessage INT;
      nbMessage NUMBER(1);
      IdUser VARCHAR(20);
      nbUser NUMBER(1);
      BEGIN
      IF idUtilisateur IS NULL THEN
        dbms_output.put_line('Entrez un utilisateur');
      END IF;

      SELECT COUNT(idMessage) INTO nbMessage FROM message WHERE idMessage = idMessage1;
      SELECT loginUser INTO IdUser FROM message WHERE idMessage = idMessage1;
        IF nbMessage <> 0 THEN
          IF messageReponse IS NULL THEN 
            dbms_output.put_line('Veuillez remplir tout les champs');
          END IF;
            INSERT INTO repondre(loginUser, idMessage, messageReponse, dateMessage)
            VALUES (IdUser, idMessage1, messageReponse, SYSDATE);
            DBMS_OUTPUT.PUT_LINE('Le message a été ajouté avec succès.');
        END IF;
      END repondreMessageMur;

     PROCEDURE chercherMembre(prefixeUtilisateur IN VARCHAR)
     IS
      BEGIN
          IF prefixeUtilisateur IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('Veuillez utiliser un préfixe pris en charge');
          END IF;
          EXECUTE IMMEDIATE 'SELECT loginUser FROM Utilisateur WHERE loginUser LIKE CONCAT('''||prefixeUtilisateur||',%';
      END chercherMembre; 

END PACKFASSEBOUC;