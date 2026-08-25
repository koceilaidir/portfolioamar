# Portfolio — Amar Hammour

> **Nouveau sur le projet ?** Lis `GUIDE.txt` à la racine : il explique pas à pas
> comment récupérer le code, le lancer, administrer le contenu et publier le site.

Site portfolio one-page développé en Flutter (cible web), fidèle à la maquette
HTML fournie : palette crème / terracotta, polices Fraunces + Manrope + Caveat,
et une version desktop pensée pour les grands écrans.

## Lancer le projet

```bash
flutter pub get
flutter run -d chrome        # développement (contenu embarqué)
flutter build web --release  # build de production (dossier build/web)
```

Avec Supabase branché :

```bash
flutter run -d chrome --dart-define-from-file=env.json
flutter build web --release --dart-define-from-file=env.json
```

## Back — Supabase

1. Créer un projet sur [supabase.com](https://supabase.com).
2. Dashboard → **SQL Editor** → coller le contenu de `supabase/schema.sql` → **Run**.
   Cela crée les tables, les règles de sécurité (RLS), le bucket d'images et
   insère le contenu actuel du site.
3. Dashboard → **Project Settings → API** : copier `Project URL` et la clé
   `anon public`, puis créer à la racine un fichier `env.json` (déjà ignoré par
   Git) :

```json
{
  "SUPABASE_URL": "https://xxxxxxxx.supabase.co",
  "SUPABASE_ANON_KEY": "eyJhbGciOi..."
}
```

Sans ce fichier, le site fonctionne quand même : il affiche le contenu
embarqué dans `StaticPortfolioRepository`.

### Gérer le contenu

Tout se fait depuis **Table Editor** dans Supabase :

| Table           | Contenu                                                        |
|-----------------|----------------------------------------------------------------|
| `site_settings` | Tous les textes du site (hero, titres de sections, contact)     |
| ↳ `hero_sentence` | La grande phrase du hero. Deux marqueurs : `*texte*` met en terracotta, `•` insère un rond terracotta animé |
| ↳ `about_*`     | La section À propos : `about_visible`, `about_kicker`, `about_title`, `about_quote`, `about_body`, `about_tags` (séparées par des virgules). `*texte*` met en avant, une ligne vide sépare deux paragraphes |
| `about_steps`   | Les étapes numérotées de la section À propos (`position` = ordre) |
| `projects`      | Les projets (`position` = ordre, `published` = visible ou non)  |
| `skills`        | Les barres de compétences (`level` de 0 à 100)                  |
| `features`      | Les 4 arguments (`icon_key` : user, code, responsive, performance, design, star) |
| `testimonials`  | Les avis (`status` : pending / approved / rejected)             |

**Images de projet** : Storage → bucket `project-images` → uploader le fichier,
puis renseigner son nom dans la colonne `image_path` du projet (ex :
`studio-form.jpg`). Sans image, la vignette garde le dégradé de la maquette.

**Modération des avis** : un visiteur peut déposer un avis via le bouton
« Laisser un avis ». Il arrive en `status = 'pending'` et n'apparaît sur le site
qu'une fois passé à `approved` dans Table Editor. La clé `anon` ne peut ni
modifier ni supprimer un avis.

## Architecture

```
lib/
├── main.dart                      # point d'entrée : choisit le repository
├── app.dart                       # MaterialApp, thème, chargement du contenu
├── core/
│   ├── animation/reveal.dart      # apparition des sections au défilement
│   ├── config/app_config.dart     # clés Supabase (--dart-define)
│   ├── layout/breakpoints.dart    # mobile / tablette / desktop + conteneur centré
│   ├── theme/                     # couleurs, typographies, icônes, thème
│   ├── utils/launcher.dart        # ouverture des liens (mailto, site)
│   └── widgets/hover_region.dart  # état de survol (web)
├── data/
│   ├── models/portfolio_content.dart      # modèles + `fromJson`
│   └── repositories/
│       ├── portfolio_repository.dart          # interface
│       ├── static_portfolio_repository.dart   # contenu embarqué (maquette)
│       └── supabase_portfolio_repository.dart # contenu Supabase + dépôt d'avis
└── presentation/
    ├── home/home_page.dart        # page unique + navigation par ancres
    ├── home/sections/             # header, hero, projets, skills, avis, footer
    └── widgets/                   # cartes, boutons, barres, grille du hero
```

### Où vit le contenu

- **Avec Supabase configuré** (`env.json` présent) : tout vient de la base, et
  le site se rabat sur le contenu embarqué pour chaque champ vide.
- **Sans Supabase** : tout vient de
  `lib/data/repositories/static_portfolio_repository.dart`.

L'UI ne dépend que de l'interface `PortfolioRepository` : aucun widget ne sait
d'où vient le contenu.

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
