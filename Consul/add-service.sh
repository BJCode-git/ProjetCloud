#!/bin/bash

# Vérifie qu'il y a au moins le nom de l'image en argument
if [ $# -lt 1 ]; then
	echo "Usage: $0 <container_image> [<container_name>]"
	exit 1
fi

# Récupère l'image du conteneur à partir des arguments
container_image=$1
container_name=${2:-$(echo $container_image | cut -d ':' -f 1)}

# Appel de la fonction de vérification de l'installation de Consul et Docker
source check-install.sh

# Vérifie si le conteneur existe déjà et le supprime le cas échéant
if [ -n "$(docker ps -a -q -f name=$container_name)" ]; then
	docker rm -f $container_name
fi

# Déploiement du conteneur avec Docker
# On récupère l'ID du conteneur créé
container_id=$(docker run -d --name $container_name $container_image)

# Récupération de l'adresse IP du conteneur
ip_address=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $container_id)

# Récupération du port du conteneur
port=$(docker inspect -f '{{(index (index .NetworkSettings.Ports "6379/tcp") 0).HostPort}}' $container_id)

# Enregistrement du service dans Consul
consul services register -name $container_name -address $ip_address -port $port

# Service check - Vérification de l'état du service
consul services register -name ${container_name}-check -address $ip_address -port $port -check "docker ps | grep $container_id"

echo "Service $container_name enregistré dans Consul avec un service check."
