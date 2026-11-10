---
paths:
  - "src/database/jobtracker/apex_apps/**"
  - "dist/releases/apex/**"
---

# Règles APEX

Ces règles couvrent l'application `JobTracker` (ID `1000`). Le schéma et les migrations sont dans `sql.md`, le code PL/SQL dans `plsql.md`.

## Source de vérité

- L'application se modifie dans le Builder du dev, puis passe par `env/local/dev.sh stage` (README, « Faire évoluer l'application APEX »). Jamais d'édition manuelle de `f1000.sql`, des `.apx` ou de `dist/releases/apex/`, jamais `project stage` seul : il retire l'empreinte de `f1000.xml`.
- Le dev n'a qu'une base pour toutes les branches : exporter et committer le travail du Builder avant de changer de branche, sinon il part dans l'export de la branche suivante.
- L'export est public : ni secret, ni donnée réelle dans l'application (substitution strings, fichiers statiques, valeurs par défaut).
- Pas de DDL dans les Supporting Objects : le schéma passe par les migrations (`sql.md`).

## Accès aux données

- Lectures : uniquement par les vues `ui_` (`sql.md`), LOV et rapports compris, chaque région et chaque LOV par la sienne. Une page ne lit ni table ni vue de base et ne porte pas de SQL métier : une condition à changer se change dans la vue.
- Écritures : toutes par les packages. Un formulaire est une Form region sur sa vue `ui_<entité>_form`, avec un process Form - Automatic Row Processing en Target Type « PL/SQL Code » qui appelle le package. Jamais d'Automatic Row Processing sur une table ou une vue : il contournerait les contrôles du package.
- Grille éditable (Interactive Grid) : même principe, process Interactive Grid - Automatic Row Processing en « PL/SQL Code » aiguillé sur `:APEX$ROW_STATUS`. La clé du parent se lit dans l'item du formulaire, pas dans une colonne de la grille : item en Storage « Per Session (Persistent) », jamais dans Page Items to Submit de la grille (l'Advisor signale l'envoi en Ajax d'un item protégé). Avec le Storage par défaut d'un item de Form region, « Per Request », la grille se vide au premier tri (constaté en APEX 26.1). Tout lien vers la page du formulaire en vide le cache (Clear Cache). Une grille enfant d'un formulaire n'a pas son propre bouton Save : elle s'enregistre avec la page. Une grille seule sur sa page (référentiel) garde le bouton Save de sa barre d'outils.
- Colonne `BOOLEAN` dans une grille : type Switch, Session State en `BOOLEAN` (sinon le bind arrive en `VARCHAR2`). Une Checkbox ne s'affiche jamais cochée sur une source `BOOLEAN` (constaté en APEX 26.1). L'Advisor signale alors `PLS-00306` sur l'appel du package : faux positif, il compile les binds en `VARCHAR2` (vérifié à l'exécution en APEX 26.1).
- Ailleurs, `BOOLEAN` s'emploie tel quel (constaté en APEX 26.1) : une condition Item = Value sur un item `BOOLEAN` compare à `TRUE`, un Interactive Report accepte la colonne et `{if COLONNE/}` y traite `false` comme faux. Pour qu'une colonne ajoutée à la vue apparaisse dans l'IR, Synchronize Columns n'a pas suffi : basculer la source en SQL Query, revenir en Table / View, puis Save.
- Validations de page : confort de saisie seulement (champ requis, format). Une règle métier est dans le package, testée sans APEX.
- Un bloc PL/SQL de page (process, action dynamique, calcul) se limite à l'appel d'un package.
- Les données collectées sont externes : jamais d'affichage sans échappement. Dans le SQL et le PL/SQL de page, des bind variables (`:P100_ID`), jamais de substitution (`&P100_ID.`).

## Interface

- Application en français : libellés, messages et langue principale de l'application (`fr`).
- Toutes les pages exigent une authentification, sauf le login (page 9999). Pas d'Authorization Scheme (README, « Choix techniques et compromis ») : l'avertissement de l'Advisor est attendu.
- Chaque Interactive Report et Interactive Grid a une colonne Value Identifies Row (section Accessibility) : un libellé visible qui nomme la ligne, jamais un ID technique.
- Avant un export, l'Advisor ne remonte que les avertissements justifiés par ces règles.

## Nommage

- Pages par domaine, une centaine par domaine et un page group pour chacun, boîtes de dialogue comprises : `1` accueil, `100-199` entreprises, `200-299` offres, `300-399` candidatures. Un domaine nouveau prend la centaine suivante. `9000-9998` : administration et référentiels.
- Une LOV utilisée par plus d'une page est une shared LOV, nommée `<REFERENTIEL>_LOV` (`SECTORS_LOV`), qui lit `ui_<referentiel>_lov`.
- Identifiant d'une région dans la page (`apex.region("...")`, CSS) : propriété HTML DOM ID. Le Static ID est, depuis APEX 26.1, l'identifiant interne du composant dans l'export.

## Garde-fous pour l'agent

- L'agent n'utilise pas le Builder : il lit les `.apx` pour relire et proposer, et décrit les changements à faire dans le Builder.
- Demander une confirmation explicite avant `dev.sh stage` : il écrit en base et réimporte l'application.
