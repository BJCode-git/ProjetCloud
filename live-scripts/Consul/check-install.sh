 # Vérifie si Consul est installé
if ! [ -x "$(command -v consul)" ]; then
	echo "Consul n'est pas installé. Veuillez l'installer avant de continuer."
	exit 1
fi

# Vérifie si Docker est installé
if ! [ -x "$(command -v docker)" ]; then
	echo "Docker n'est pas installé. Veuillez l'installer avant de continuer."
	exit 1
fi