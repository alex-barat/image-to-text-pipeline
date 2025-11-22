#!/bin/bash
# process_images.sh - Script principal pour traiter les images avec AWS Textract

set -e  # Arrêter en cas d'erreur

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_PATH="$SCRIPT_DIR/scripts"
AWS_PROFILE="kiiro-form"

echo "======================================"
echo "   TRAITEMENT COMPLET DES IMAGES"
echo "======================================"
echo "Profil AWS: $AWS_PROFILE"
echo ""

# Étape 1 : Encodage des images
echo ">>> Étape 1/4 : Encodage des images en base64"
echo "--------------------------------------"
bash "$SCRIPTS_PATH/encode_images.sh"
if [ $? -eq 0 ]; then
    echo "✓ Encodage terminé avec succès"
else
    echo "✗ Erreur lors de l'encodage"
    exit 1
fi
echo ""

# Étape 2 : Traitement Textract
echo ">>> Étape 2/4 : Traitement AWS Textract"
echo "--------------------------------------"
bash "$SCRIPTS_PATH/textract_images.sh"
if [ $? -eq 0 ]; then
    echo "✓ Textract terminé avec succès"
else
    echo "✗ Erreur lors du traitement Textract"
    exit 1
fi
echo ""

# Étape 3 : Extraction du texte
echo ">>> Étape 3/4 : Extraction du texte brut"
echo "--------------------------------------"
bash "$SCRIPTS_PATH/extract_text.sh"
if [ $? -eq 0 ]; then
    echo "✓ Extraction terminée avec succès"
else
    echo "✗ Erreur lors de l'extraction"
    exit 1
fi
echo ""

# Étape 4 : Préparation pour l'IA
echo ">>> Étape 4/4 : Nettoyage et préparation pour l'IA"
echo "--------------------------------------"
bash "$SCRIPTS_PATH/ai_ready_text_extractor.sh"
if [ $? -eq 0 ]; then
    echo "✓ Préparation IA terminée avec succès"
else
    echo "✗ Erreur lors de la préparation IA"
    exit 1
fi
echo ""

echo "======================================"
echo "   TRAITEMENT TERMINÉ AVEC SUCCÈS"
echo "======================================"
echo ""
echo "Les fichiers finaux sont disponibles dans : outputs/ai_ready_text/"
