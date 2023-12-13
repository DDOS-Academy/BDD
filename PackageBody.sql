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
    BEGIN
      IF idUtilisateur IS NULL THEN
        dbms_output.put_line('Erreur login utilisateur');
      ELSE
        IF utilisateurConnecte IS NULL THEN
          utilisateurConnecte := idUtilisateur;
          dbms_output.put_line('Utilisateur connecté : ' || idUtilisateur);
        ELSE
          dbms_output.put_line('Utilisateur ' || utilisateurConnecte || ' déjà connecté');
        END IF;
        
      END IF;
  END connexion;
  


END PACKFASSEBOUC;