#!/bin/bash

# Appel de la fonction de vérification de l'installation de Consul et Docker
source check-install.sh

# Vérifie qu'il y a au moins le nom du service en argument
if [ $# -lt 1 ]; then
	echo "Usage: $0 <service> "
	exit 1
fi

service=$1

# Récupération de l'adresse IP de Redis depuis Consul
ip_address=$(consul catalog services | grep $service | awk '{print $2}')
# Récupération du port de Redis depuis Consul
port=$(consul catalog services | grep $service | awk '{print $3}')

# Vérification de l'adresse IP du service
if [ -z "$ip_address" ]; then
	echo "L'adresse IP du service n'a pas été trouvée dans Consul. Assurez-vous que le service est enregistré dans Consul."
	exit 1
fi

# Déploiement des deux autres services avec Docker
docker run -d --name service1 -e CELERY_BROKER_URL="$service://$ip_address:$port/0" -e CELERY_RESULT_BACKEND="redis://$ip_address:$port/1" <image1>
docker run -d --name service2 -e CELERY_BROKER_URL="$service://$ip_address:$port/0" -e CELERY_RESULT_BACKEND="redis://$ip_address:$port/1" <image2>

echo "Les services ont été lancés avec succès."
