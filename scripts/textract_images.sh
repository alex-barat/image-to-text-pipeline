#!/bin/bash

# Script pour invoquer AWS Textract sur tous les fichiers encodés
# Répertoire contenant les fichiers encodés en base64
ENCODED_DIR="inputs/encoded"
OUTPUT_DIR="outputs/textract"
AWS_PROFILE="${AWS_PROFILE:-kiiro-form}"

# Créer le répertoire de sortie s'il n'existe pas
mkdir -p "$OUTPUT_DIR"

# Compteurs
total=0
success=0
failed=0

echo "Début du traitement Textract..."
echo "Profil AWS: $AWS_PROFILE"
echo "================================"

# Parcourir tous les fichiers .txt du répertoire encoded
for encoded_file in "$ENCODED_DIR"/*.txt; do
    # Vérifier si le fichier existe
    if [ ! -f "$encoded_file" ]; then
        echo "Aucun fichier trouvé dans $ENCODED_DIR"
        exit 1
    fi
    
    # Extraire le nom de base du fichier (sans le chemin et l'extension)
    filename=$(basename "$encoded_file" .txt)
    output_file="$OUTPUT_DIR/${filename}_textract.json"
    
    echo "Traitement de: $filename"
    
    # Incrémenter le compteur total
    ((total++))
    
    # Appeler AWS Textract
    if aws textract detect-document-text \
        --document '{"Bytes":"'$(cat "$encoded_file")'"}' \
        --profile "$AWS_PROFILE" \
        --output json > "$output_file" 2>/dev/null; then
        
        echo "  ✓ Succès - Résultat sauvegardé dans: $output_file"
        ((success++))
    else
        echo "  ✗ Échec du traitement"
        ((failed++))
        # Supprimer le fichier de sortie vide en cas d'échec
        rm -f "$output_file"
    fi
    
    echo ""
done

echo "================================"
echo "Traitement terminé!"
echo "Total: $total fichier(s)"
echo "Succès: $success"
echo "Échecs: $failed"
