create or replace 
PACKAGE BODY PACKFASSEBOUC IS


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
  


END PACKFASSEBOUC;