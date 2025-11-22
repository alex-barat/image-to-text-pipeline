#!/bin/bash
# extract_text.sh

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Fonction pour traiter un seul fichier JSON
process_textract_json() {
    local input_file="$1"
    local output_file="$2"
    
    echo -e "${CYAN}Traitement de${NC} $input_file..."
    
    # Extraire seulement les blocs de type LINE et leur texte
    jq -r '.Blocks[] | select(.BlockType == "LINE") | .Text' "$input_file" > "$output_file"
    
    echo -e "${GREEN}✓ Texte extrait dans${NC} ${YELLOW}$output_file${NC}"
}

# Traiter un seul fichier
if [ $# -eq 2 ]; then
    process_textract_json "$1" "$2"
    exit 0
fi

# Traiter tous les fichiers JSON dans un dossier
INPUT_DIR="${1:-outputs/textract}"
OUTPUT_DIR="${2:-outputs/extracted}"

# Créer le dossier de sortie
mkdir -p "$OUTPUT_DIR"

# Traiter tous les fichiers JSON
for json_file in "$INPUT_DIR"/*.json; do
    if [ -f "$json_file" ]; then
        filename=$(basename "$json_file" .json)
        output_file="$OUTPUT_DIR/${filename}.txt"
        process_textract_json "$json_file" "$output_file"
    fi
done

echo -e "${GREEN}Traitement terminé.${NC} Fichiers texte dans ${YELLOW}$OUTPUT_DIR${NC}"
