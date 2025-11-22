# Dossiers de sortie

Ce dossier contient tous les résultats générés par le pipeline de traitement.

## Structure

```
outputs/
├── textract/          # Résultats JSON d'AWS Textract
├── extracted/         # Texte brut extrait des JSON
└── ai_ready_text/     # Texte nettoyé et formaté pour l'IA
```

## Description

### `textract/`

Fichiers JSON retournés par AWS Textract contenant :

- Les blocs de texte détectés
- Les coordonnées de position
- Les niveaux de confiance
- La structure du document

### `extracted/`

Fichiers texte contenant uniquement le texte extrait des blocs de type "LINE".

### `ai_ready_text/`

Fichiers texte nettoyés et formatés avec :

- Métadonnées (nom du document, date d'extraction)
- Texte normalisé (espaces, lignes vides supprimées)
- Délimiteurs pour faciliter le parsing par l'IA

⚠️ Ces dossiers sont automatiquement créés et remplis par le pipeline. Ne pas modifier manuellement.
