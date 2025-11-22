#!/bin/bash
# ai_ready_text_extractor.sh

clean_text_for_ai() {
    local input_file="$1"
    local output_file="$2"
    
    echo "Nettoyage du texte pour IA : $input_file"
    
    # Ajouter les métadonnées et le contenu
    {
        echo "=== DOCUMENT: $(basename "$input_file" .txt) ==="
        echo "=== EXTRACTION DATE: $(date '+%Y-%m-%d %H:%M:%S') ==="
        echo ""
        cat "$input_file" | sed 's/[[:space:]]\+/ /g' | sed 's/^[[:space:]]*//g' | sed 's/[[:space:]]*$//g' | grep -v '^[[:space:]]*$'
        echo ""
        echo "=== FIN DU DOCUMENT ==="
    } > "$output_file"
    
    # Statistiques
    local line_count=$(wc -l < "$output_file")
    local word_count=$(wc -w < "$output_file")
    echo "  → $line_count lignes, $word_count mots extraits"
}

# Configuration
INPUT_DIR="${1:-outputs/extracted}"
OUTPUT_DIR="${2:-outputs/ai_ready_text}"

mkdir -p "$OUTPUT_DIR"

echo "=== EXTRACTION DE TEXTE POUR IA ==="
echo "Dossier source: $INPUT_DIR"
echo "Dossier destination: $OUTPUT_DIR"
echo ""

# Traiter tous les fichiers
total_files=0
processed_files=0

for json_file in "$INPUT_DIR"/*.txt; do
    if [ -f "$json_file" ]; then
        total_files=$((total_files + 1))
        filename=$(basename "$json_file" .txt)
        output_file="$OUTPUT_DIR/${filename}_clean.txt"
        
        if clean_text_for_ai "$json_file" "$output_file"; then
            processed_files=$((processed_files + 1))
        fi
    fi
done

echo ""
echo "=== RÉSUMÉ ==="
echo "Fichiers traités: $processed_files/$total_files"
echo "Fichiers texte générés dans: $OUTPUT_DIR"
