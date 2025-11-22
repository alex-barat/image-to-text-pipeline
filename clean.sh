#!/bin/bash
# clean.sh - Script d'administration pour nettoyer les fichiers générés

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${CYAN}======================================${NC}"
echo -e "${BOLD}${YELLOW}   NETTOYAGE DES FICHIERS GÉNÉRÉS${NC}"
echo -e "${CYAN}======================================${NC}"
echo ""

# Fonction pour compter et afficher les fichiers
count_files() {
    local dir="$1"
    local pattern="$2"
    if [ -d "$dir" ]; then
        local count=$(find "$dir" -type f -name "$pattern" 2>/dev/null | wc -l | tr -d ' ')
        echo "$count"
    else
        echo "0"
    fi
}

# Afficher ce qui va être supprimé
echo -e "${YELLOW}Fichiers à supprimer :${NC}"
echo -e "  ${CYAN}-${NC} Images encodées : ${BOLD}$(count_files "inputs/encoded" "*.txt")${NC} fichier(s)"
echo -e "  ${CYAN}-${NC} Images sources : ${BOLD}$(count_files "inputs/img" "*.jpg") + $(count_files "inputs/img" "*.jpeg") + $(count_files "inputs/img" "*.JPG") + $(count_files "inputs/img" "*.JPEG")${NC} fichier(s)"
echo -e "  ${CYAN}-${NC} Résultats Textract : ${BOLD}$(count_files "outputs/textract" "*.json")${NC} fichier(s)"
echo -e "  ${CYAN}-${NC} Texte extrait : ${BOLD}$(count_files "outputs/extracted" "*.txt")${NC} fichier(s)"
echo -e "  ${CYAN}-${NC} Texte nettoyé : ${BOLD}$(count_files "outputs/ai_ready_text" "*.txt")${NC} fichier(s)"
echo ""

# Demander confirmation
echo -ne "${RED}⚠️  Voulez-vous vraiment supprimer tous ces fichiers ? (o/N)${NC} "
read -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[OoYy]$ ]]; then
    echo -e "${RED}❌ Nettoyage annulé${NC}"
    exit 0
fi

echo ""
echo -e "${CYAN}Nettoyage en cours...${NC}"
echo ""

# Nettoyer inputs/encoded
if [ -d "inputs/encoded" ]; then
    rm -f inputs/encoded/*.txt
    echo -e "${GREEN}✓${NC} inputs/encoded/ nettoyé"
fi

# Nettoyer inputs/img
if [ -d "inputs/img" ]; then
    rm -f inputs/img/*.jpg inputs/img/*.jpeg inputs/img/*.JPG inputs/img/*.JPEG
    echo -e "${GREEN}✓${NC} inputs/img/ nettoyé"
fi

# Nettoyer outputs/textract
if [ -d "outputs/textract" ]; then
    rm -f outputs/textract/*.json
    echo -e "${GREEN}✓${NC} outputs/textract/ nettoyé"
fi

# Nettoyer outputs/extracted
if [ -d "outputs/extracted" ]; then
    rm -f outputs/extracted/*.txt
    echo -e "${GREEN}✓${NC} outputs/extracted/ nettoyé"
fi

# Nettoyer outputs/ai_ready_text
if [ -d "outputs/ai_ready_text" ]; then
    rm -f outputs/ai_ready_text/*.txt
    echo -e "${GREEN}✓${NC} outputs/ai_ready_text/ nettoyé"
fi

echo ""
echo -e "${CYAN}======================================${NC}"
echo -e "${BOLD}${GREEN}   NETTOYAGE TERMINÉ${NC}"
echo -e "${CYAN}======================================${NC}"
echo ""
echo -e "${GREEN}✓${NC} Les dossiers README.md ont été préservés."
echo -e "${YELLOW}→${NC} Vous pouvez maintenant placer de nouvelles images dans ${BOLD}inputs/img/${NC}"
