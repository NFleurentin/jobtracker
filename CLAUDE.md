# CLAUDE.md

## Règles par outil

- Les règles sont dans [.claude/rules/](.claude/rules/)
- `git.md` et `github.md` sont toujours chargées. Les autres, dont `github_actions.md` pour `.github/workflows/`, ne le sont que lorsqu'un fichier de leur périmètre est en jeu.
- Une règle ne contient que ce qui est propre à ce dépôt, s'écarte de la convention de l'outil ou sert de garde-fou : les conventions courantes, que les modèles connaissent, n'y sont pas recopiées. Chaque règle est injectée dans le contexte, et un modèle local en a peu. Ce fichier ne garde que le transverse : ne pas y recopier une règle.

## Conventions

- Documentation, commentaires de code et README **en français** ; identifiants (variables, fonctions, colonnes) en anglais.
- Une décision de conception nouvelle ou modifiée se reporte dans la table « Choix techniques et compromis » du README, et la liste « Avancement » se met à jour en même temps que le code.