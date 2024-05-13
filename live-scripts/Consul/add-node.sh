#!/bin/bash


# On vérifie les arguments
if [ $# -lt 1 ]; then
	echo "Usage: $0 <new_node_ip>"
	exit 1
fi


# Étape 4: Ajouter un second nœud au cluster Consul/Nomad
add_node() {
    new_node_ip=$1

    consul join $new_node_ip
    nomad server-join $new_node_ip
}


add_node $1
