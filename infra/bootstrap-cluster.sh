#!/bin/bash
# AUTEUR: lo
# DESCRIPTION: Provisioning automatisé d'un cluster K3s simulé via Multipass

set -e # Arrête le script en cas d'erreur

echo "  INITIALISATION DE L'INFRASTRUCTURE VIRTUELLE..."

# 1. Création des VMs (Virtual Machines)
# Nous utilisons des specs modestes (1CPU, 1GB RAM) pour simuler des Raspberry Pi
echo " Launching Master Node..."
multipass launch --name edge-master --cpus 1 --mem 1G --disk 5G 2>/dev/null || echo "Master already exists"

echo " Launching Worker Node..."
multipass launch --name edge-worker --cpus 1 --mem 1G --disk 5G 2>/dev/null || echo "Worker already exists"

# 2. Installation de K3s sur le Master
echo " Installing K3s Server on Master..."
# curl sFL : Télécharge le script K3s
# sh -s - : Exécute le script
multipass exec edge-master -- bash -c "curl -sfL https://get.k3s.io | sh -"

# 3. Récupération du Token et de l'IP pour joindre le Worker
echo " Retrieving Cluster Token..."
# On récupère le token secret généré par le master
TOKEN=$(multipass exec edge-master -- sudo cat /var/lib/rancher/k3s/server/node-token)
# On récupère l'IP du master pour que le worker puisse le trouver
MASTER_IP=$(multipass info edge-master | grep IPv4 | awk '{print $2}')

# 4. Jonction du Worker au Cluster
echo " Joining Worker to Cluster..."
# K3S_URL : L'adresse du master
# K3S_TOKEN : Le mot de passe pour entrer dans le cluster
multipass exec edge-worker -- bash -c "curl -sfL https://get.k3s.io | K3S_URL=https://${MASTER_IP}:6443 K3S_TOKEN=${TOKEN} sh -"

echo " CLUSTER READY!"
echo "To access your cluster: multipass shell edge-master"
