#!/bin/bash
# clean.sh - Script d'administration pour nettoyer les fichiers générés

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "======================================"
echo "   NETTOYAGE DES FICHIERS GÉNÉRÉS"
echo "======================================"
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
echo "Fichiers à supprimer :"
echo "  - Images encodées : $(count_files "inputs/encoded" "*.txt") fichier(s)"
echo "  - Images sources : $(count_files "inputs/img" "*.jpg") + $(count_files "inputs/img" "*.jpeg") + $(count_files "inputs/img" "*.JPG") + $(count_files "inputs/img" "*.JPEG") fichier(s)"
echo "  - Résultats Textract : $(count_files "outputs/textract" "*.json") fichier(s)"
echo "  - Texte extrait : $(count_files "outputs/extracted" "*.txt") fichier(s)"
echo "  - Texte nettoyé : $(count_files "outputs/ai_ready_text" "*.txt") fichier(s)"
echo ""

# Demander confirmation
read -p "⚠️  Voulez-vous vraiment supprimer tous ces fichiers ? (o/N) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[OoYy]$ ]]; then
    echo "❌ Nettoyage annulé"
    exit 0
fi

echo ""
echo "Nettoyage en cours..."
echo ""

# Nettoyer inputs/encoded
if [ -d "inputs/encoded" ]; then
    rm -f inputs/encoded/*.txt
    echo "✓ inputs/encoded/ nettoyé"
fi

# Nettoyer inputs/img
if [ -d "inputs/img" ]; then
    rm -f inputs/img/*.jpg inputs/img/*.jpeg inputs/img/*.JPG inputs/img/*.JPEG
    echo "✓ inputs/img/ nettoyé"
fi

# Nettoyer outputs/textract
if [ -d "outputs/textract" ]; then
    rm -f outputs/textract/*.json
    echo "✓ outputs/textract/ nettoyé"
fi

# Nettoyer outputs/extracted
if [ -d "outputs/extracted" ]; then
    rm -f outputs/extracted/*.txt
    echo "✓ outputs/extracted/ nettoyé"
fi

# Nettoyer outputs/ai_ready_text
if [ -d "outputs/ai_ready_text" ]; then
    rm -f outputs/ai_ready_text/*.txt
    echo "✓ outputs/ai_ready_text/ nettoyé"
fi

echo ""
echo "======================================"
echo "   NETTOYAGE TERMINÉ"
echo "======================================"
echo ""
echo "Les dossiers README.md ont été préservés."
echo "Vous pouvez maintenant placer de nouvelles images dans inputs/img/"
