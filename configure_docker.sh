#!/bin/bash

# Script de configuration Docker
# Configure les logs, le storage driver et nettoie les réseaux

echo "Configuration de Docker..."

# Créer ou mettre à jour le fichier daemon.json
sudo tee /etc/docker/daemon.json > /dev/null <<EOF
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "storage-driver": "overlay2",
  "default-address-pools": [
    {
      "base": "172.17.0.0/12",
      "size": 24
    }
  ]
}
EOF

echo "Fichier daemon.json créé avec succès"

# Redémarrer Docker pour appliquer les changements
echo "Redémarrage de Docker..."
sudo systemctl restart docker

# Attendre que Docker soit prêt
sleep 3

# Nettoyer les réseaux inutilisés
echo "Nettoyage des réseaux Docker inutilisés..."
sudo docker network prune -f

echo "Configuration terminée avec succès!"
