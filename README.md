# Portfolio — Amar Hammour

Site portfolio one-page développé en Flutter (cible web), fidèle à la maquette
HTML fournie : palette crème / terracotta, polices Fraunces + Manrope + Caveat,
et une version desktop pensée pour les grands écrans.

## Lancer le projet

```bash
flutter pub get
flutter run -d chrome        # développement
flutter build web --release  # build de production (dossier build/web)
```

## Architecture

```
lib/
├── main.dart                      # point d'entrée : choisit le repository
├── app.dart                       # MaterialApp, thème, chargement du contenu
├── core/
│   ├── animation/reveal.dart      # apparition des sections au défilement
│   ├── layout/breakpoints.dart    # mobile / tablette / desktop + conteneur centré
│   ├── theme/                     # couleurs, typographies, icônes, thème
│   ├── utils/launcher.dart        # ouverture des liens (mailto, site)
│   └── widgets/hover_region.dart  # état de survol (web)
├── data/
│   ├── models/portfolio_content.dart      # modèles + `fromJson`
│   └── repositories/
│       ├── portfolio_repository.dart      # interface
│       └── static_portfolio_repository.dart # contenu embarqué (maquette)
└── presentation/
    ├── home/home_page.dart        # page unique + navigation par ancres
    ├── home/sections/             # header, hero, projets, skills, avis, footer
    └── widgets/                   # cartes, boutons, barres, grille du hero
```

### Modifier le contenu

Tant que le back n'est pas branché, tout le contenu (textes, projets,
compétences, témoignages, coordonnées) se trouve dans
`lib/data/repositories/static_portfolio_repository.dart`.

### Brancher le back plus tard

Les modèles exposent déjà `fromJson`. Il suffira de créer un
`ApiPortfolioRepository implements PortfolioRepository` qui appelle l'API et
renvoie `PortfolioContent.fromJson(...)`, puis de le passer à `PortfolioApp`
dans `main.dart`. Aucune modification de l'UI ne sera nécessaire.

## Design

Les tokens de la maquette sont repris à l'identique dans
`lib/core/theme/app_colors.dart` :

| Token             | Valeur    |
|-------------------|-----------|
| cream             | `#F2EBDD` |
| cream-2           | `#E9E0CE` |
| terracotta        | `#C15A34` |
| terracotta-deep   | `#9E4A1E` |
| terracotta-light  | `#E08A57` |
| ink               | `#20201C` |
| ink-soft          | `#5B554B` |
| card              | `#FBF7EE` |

Les polices sont embarquées dans `assets/fonts` (versions statiques extraites
de la maquette), donc aucun appel réseau n'est nécessaire au chargement.

## Tests

```bash
flutter test
```
