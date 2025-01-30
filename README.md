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

- Le méchant a de la vie
- Il faut sortir de l'automate (etats finaux)
- il faut accomplir un but (ex: tuer le boss) pour sortir
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

### Actions Etats:
- Attaquer un boss
- Gagner de la vide
- Augmenter son maximum de vie
- Débloquer une arrêtes / Récupérer une clé
- Remonter dans le temps (revenir en arrière de 3-4 mots)
- creation d'un robot avec le mot courant crée

### Passer dans un niveau suivant
- les états acceptants permettent de passer au prochain niveau
- débloque l'automate précédent qui devient libre
- fog of war sur tous les autres automates

ACTION : attaquer | générer de la vie | ajouter une transition | débloquer porte


## Level Design Idea
- niveau que l'on peut enchainer
- niveau avec beaucoup beaucoup de transitions

## Editeur de map
- Avoir un éditeur de map -> juste
- format textuel pour décrire un automate.

# LeaderBoard - End of the Game
- the game is supposed to be able to be finished is less than 2 hours for the
first playthrough

When finishing there will be 3 stats that give 3 different leaderboard :
- number of node alive at the end of the game
- number of transition taken at the end of the game
- time taken to complete the game

Other idea at the end of the game is to create your own level (or entire game)
that other can play.

# Lore:
Les humains et les automates peuvent vivre ensemble !
Mais certains personnes ne voit pas la beauté des automates dans toutes leur
facètes. Ces extrémistes appliquent des alogithmes d'une grande violence pour
systématique couper, simplifier et même tuer des automates.

Aider [inserer nom] à venir à bout de ces extrémistes en parcourant le monde des
automates.

# TODO

- [ ] basic projectile
- [ ] red node (with movement) when picking the wrong transition
- [ ] Automata editor
- [ ] Boss
  - [ ] boos qui bouge débilement

- [ ] Art style
  - [ ] player custom style (very basic shapes)
  - [ ] boss custom

