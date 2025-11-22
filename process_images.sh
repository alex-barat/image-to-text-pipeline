#!/bin/bash
# process_images.sh - Script principal pour traiter les images avec AWS Textract

set -e  # Arrêter en cas d'erreur

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_PATH="$SCRIPT_DIR/scripts"
AWS_PROFILE="kiiro-form"

echo -e "${CYAN}======================================${NC}"
echo -e "${BOLD}${BLUE}   TRAITEMENT COMPLET DES IMAGES${NC}"
echo -e "${CYAN}======================================${NC}"
echo -e "${YELLOW}Profil AWS:${NC} $AWS_PROFILE"
echo ""

# Étape 1 : Encodage des images
echo -e "${MAGENTA}>>> Étape 1/4 : Encodage des images en base64${NC}"
echo -e "${CYAN}--------------------------------------${NC}"
bash "$SCRIPTS_PATH/encode_images.sh"
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Encodage terminé avec succès${NC}"
else
    echo -e "${RED}✗ Erreur lors de l'encodage${NC}"
    exit 1
fi
echo ""

# Étape 2 : Traitement Textract
echo -e "${MAGENTA}>>> Étape 2/4 : Traitement AWS Textract${NC}"
echo -e "${CYAN}--------------------------------------${NC}"
bash "$SCRIPTS_PATH/textract_images.sh"
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Textract terminé avec succès${NC}"
else
    echo -e "${RED}✗ Erreur lors du traitement Textract${NC}"
    exit 1
fi
echo ""

# Étape 3 : Extraction du texte
echo -e "${MAGENTA}>>> Étape 3/4 : Extraction du texte brut${NC}"
echo -e "${CYAN}--------------------------------------${NC}"
bash "$SCRIPTS_PATH/extract_text.sh"
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Extraction terminée avec succès${NC}"
else
    echo -e "${RED}✗ Erreur lors de l'extraction${NC}"
    exit 1
fi
echo ""

# Étape 4 : Préparation pour l'IA
echo -e "${MAGENTA}>>> Étape 4/4 : Nettoyage et préparation pour l'IA${NC}"
echo -e "${CYAN}--------------------------------------${NC}"
bash "$SCRIPTS_PATH/ai_ready_text_extractor.sh"
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Préparation IA terminée avec succès${NC}"
else
    echo -e "${RED}✗ Erreur lors de la préparation IA${NC}"
    exit 1
fi
echo ""

echo -e "${CYAN}======================================${NC}"
echo -e "${BOLD}${GREEN}   TRAITEMENT TERMINÉ AVEC SUCCÈS${NC}"
echo -e "${CYAN}======================================${NC}"
echo ""
echo -e "${YELLOW}Les fichiers finaux sont disponibles dans :${NC} ${BOLD}outputs/ai_ready_text/${NC}"
