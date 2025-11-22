# Pipeline d'extraction de texte depuis images avec AWS Textract

Ce projet permet de traiter automatiquement des images (photos de documents, textes manuscrits, etc.) en utilisant AWS Textract pour en extraire le texte et le préparer pour l'analyse par IA.

## 📋 Vue d'ensemble

Le processus complet se déroule en 4 étapes automatisées :

1. **Encodage** : Conversion des images en base64
2. **Textract** : Extraction du texte via AWS Textract
3. **Extraction** : Récupération du texte brut depuis les résultats JSON
4. **Nettoyage** : Préparation du texte pour l'analyse IA

## 🗂 Structure du projet

```
.
├── README.md                      # Ce fichier
├── process_images.sh             # Script principal
├── scripts/                      # Scripts individuels
│   ├── encode_images.sh          # Étape 1 : Encodage
│   ├── textract_images.sh        # Étape 2 : AWS Textract
│   ├── extract_text.sh           # Étape 3 : Extraction
│   └── ai_ready_text_extractor.sh # Étape 4 : Nettoyage
├── inputs/                       # Données d'entrée
│   ├── img/                      # Images sources (JPG/JPEG)
│   └── encoded/                  # Images encodées en base64
└── outputs/                      # Résultats générés
    ├── textract/                 # Résultats JSON d'AWS Textract
    ├── extracted/                # Texte brut extrait
    └── ai_ready_text/            # Texte nettoyé pour l'IA
```

## 🚀 Installation

### Prérequis

1. **AWS CLI** configuré avec les credentials appropriés

   ```bash
   aws configure --profile kiiro-form
   ```

2. **jq** pour le parsing JSON

   ```bash
   # macOS
   brew install jq

   # Linux (Ubuntu/Debian)
   sudo apt-get install jq
   ```

3. **Bash** (version 4.0+)

### Configuration

Modifiez la variable `AWS_PROFILE` dans `process_images.sh` si nécessaire :

```bash
AWS_PROFILE="votre-profil-aws"
```

## 📖 Utilisation

### Traitement complet (recommandé)

1. Placez vos images dans le dossier `inputs/img/`
2. Exécutez le script principal :
   ```bash
   ./process_images.sh
   ```

Les fichiers finaux seront disponibles dans `outputs/ai_ready_text/`

### Exécution étape par étape

Si vous souhaitez exécuter les scripts individuellement :

```bash
# Étape 1 : Encodage
./scripts/encode_images.sh

# Étape 2 : Textract
./scripts/textract_images.sh

# Étape 3 : Extraction
./scripts/extract_text.sh

# Étape 4 : Nettoyage
./scripts/ai_ready_text_extractor.sh
```

## 📝 Détail des scripts

### 1. encode_images.sh

**Fonction** : Encode toutes les images JPG/JPEG en base64

**Entrée** : `inputs/img/*.{jpg,jpeg,JPG,JPEG}`  
**Sortie** : `inputs/encoded/N.txt` (où N = numéro séquentiel)

**Exemple** :

```
inputs/img/photo1.jpg → inputs/encoded/1.txt
inputs/img/photo2.jpg → inputs/encoded/2.txt
```

### 2. textract_images.sh

**Fonction** : Envoie les images encodées à AWS Textract pour extraction de texte

**Entrée** : `inputs/encoded/*.txt`  
**Sortie** : `outputs/textract/N_textract.json`

**Configuration AWS** :

- Profil : Défini par la variable `AWS_PROFILE`
- API : `textract detect-document-text`
- Format : JSON

**Statistiques affichées** :

- Nombre total de fichiers traités
- Succès / Échecs

### 3. extract_text.sh

**Fonction** : Extrait le texte brut des résultats JSON Textract

**Entrée** : `outputs/textract/*.json`  
**Sortie** : `outputs/extracted/N_textract.txt`

**Traitement** :

- Filtre les blocs de type "LINE"
- Extrait uniquement le champ `Text`
- Un fichier texte par document

### 4. ai_ready_text_extractor.sh

**Fonction** : Nettoie et formate le texte pour l'analyse IA

**Entrée** : `outputs/extracted/*.txt`  
**Sortie** : `outputs/ai_ready_text/N_textract_clean.txt`

**Traitements appliqués** :

- Normalisation des espaces multiples
- Suppression des espaces en début/fin de ligne
- Suppression des lignes vides
- Ajout de métadonnées (nom du document, date d'extraction)

**Format de sortie** :

```
=== DOCUMENT: 1_textract ===
=== EXTRACTION DATE: 2025-11-22 12:00:00 ===

[Texte nettoyé du document]

=== FIN DU DOCUMENT ===
```

## 🔧 Personnalisation

### Modifier les formats d'images acceptés

Dans `scripts/encode_images.sh`, ligne 11 :

```bash
for file in inputs/img/*.{jpg,jpeg,JPG,JPEG,png,PNG}; do
```

### Changer les chemins de sortie

Modifiez les variables `INPUT_DIR` et `OUTPUT_DIR` dans chaque script :

```bash
INPUT_DIR="votre/chemin/entree"
OUTPUT_DIR="votre/chemin/sortie"
```

### Ajuster le nettoyage du texte

Dans `scripts/ai_ready_text_extractor.sh`, modifiez la section de nettoyage selon vos besoins.

## ⚠️ Gestion des erreurs

Le script principal (`process_images.sh`) utilise `set -e` pour s'arrêter à la première erreur.

**Codes de sortie** :

- `0` : Succès
- `1` : Erreur durant l'exécution

**Erreurs communes** :

- **AWS credentials invalides** : Vérifiez votre configuration AWS
- **jq non installé** : Installez jq via votre gestionnaire de paquets
- **Permissions insuffisantes** : Rendez les scripts exécutables avec `chmod +x`

## 💰 Coûts AWS

AWS Textract facture par page traitée. Consultez la [tarification AWS Textract](https://aws.amazon.com/textract/pricing/) pour plus de détails.

**Estimation** :

- 1000 pages/mois : ~$1.50 (DetectDocumentText)
- Niveau gratuit : 1000 pages/mois pendant 3 mois

## 📊 Performances

**Temps de traitement approximatifs** :

- Encodage : < 1s par image
- Textract : 1-2s par image (dépend de la complexité)
- Extraction : < 0.1s par fichier
- Nettoyage : < 0.1s par fichier

Pour 100 images : ~3-5 minutes total

## 🤝 Contribution

Pour améliorer ce projet :

1. Ajoutez la gestion de formats supplémentaires (PDF, TIFF)
2. Implémentez le traitement parallèle pour Textract
3. Ajoutez des options de ligne de commande
4. Créez des tests automatisés

## 📄 Licence

Ce projet est fourni tel quel, sans garantie.

---

**Dernière mise à jour** : 22 novembre 2025
