# GamAutomata


## Running the game :
For running the automata ""game"" :
```
odin run automata
```

## Idée :
- appliquer pleins de concepts sur les automates
- Plusieurs niveaux
- Etats du joueurs = etats de l'automate

## Méchant:
- Ils appliquent des algorithmes sur les automates
bijection d'automates

## Gameplay:
### Actions d'un état d'un automate :
- gagner de la vie
- débloquer un truc
- remonter dans le temps
### Plusieurs niveaux : (monde ""ouvert"" d'automates)
- chaque niveau est une prison pour un automate.
- une lettre fait bouger une personne d'un état à l'autre.
Appuyer sur la mauvaise letter fait perdre du temps : il faut donc bien réflechir
à ce que l'on fait.
- certains états de l'automates font une action
- epsilon transition te téléporte à la transition suivante (portail)
- automate non déterministe (transition electrique imprévisible)
- automate temporel avec des limitations de temps sur certaines transitions

- score de niveau : nombre de lettres utilisées pour passer le niveau (ou le jeu
  entier).

### Gameplay:
- Le méchant a de la vie
- Il faut sortir de l'automate (etats finaux)
- il faut accomplir un but (ex: tuer le boss) pour sortir
### Passer dans un niveau suivant
- les états acceptants permettent de passer au prochain niveau
- débloque l'automate précédent qui devient libre
- fog of war sur tous les autres automates

ACTION : attaquer | générer de la vie | ajouter une transition | débloquer porte


## Level Design
- niveau que l'on peut enchainer
- niveau avec beaucoup beaucoup de transitions
- niveau application d'une simplification de l'automate

Avoir un éditeur de map => format textuel pour décrire un automate.

# Lore:
Les humains et les automates peuvent vivre ensemble !
Mais certains extrémistes ne voit pas la beauté des automates dans toutes leur
facètes. Ces extrémistes appliquent des alogithmes d'une grande violence pour
systématique couper, simplifier et même tuer des automates.

Aider [inserer nom] à venir à bout de ces extrémistes en parcourant le monde des
automates.

# TODO

- [ ] Automata editor
- [ ] Boss
  - [ ] boos qui bouge débilement

- [ ] Art style
  - [ ] player custom style (very basic shapes)
  - [ ] boss custom

