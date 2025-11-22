#!/bin/bash

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Créer le dossier encoded s'il n'existe pas
mkdir -p inputs/encoded

# Compteur pour nommer les fichiers
counter=1

# Encoder tous les fichiers JPEG/JPG du dossier inputs
for file in inputs/img/*.{jpg,jpeg,JPG,JPEG}; do
    # Vérifier si le fichier existe (évite les erreurs si aucun fichier ne correspond)
    [ -e "$file" ] || continue
    
    # Extraire le nom du fichier sans le chemin
    filename=$(basename "$file")
    
    # Encoder en base64 et sauvegarder avec un nom simple
    base64 -i "$file" -o "inputs/encoded/${counter}.txt"
    
    echo -e "${GREEN}✓${NC} Encodé: ${CYAN}$filename${NC} -> ${YELLOW}inputs/encoded/${counter}.txt${NC}"
    
    # Incrémenter le compteur
    counter=$((counter + 1))
done

echo -e "${GREEN}Encodage terminé!${NC}"
