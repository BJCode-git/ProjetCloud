#!/bin/bash

# Vérifie si consul-template est installé
if ! [ -x "$(command -v consul-template)" ]; then
    echo "Consul-template n'est pas installé. Veuillez l'installer avant de continuer."
    exit 1
fi

# Vérifie si HAProxy est installé
if ! [ -x "$(command -v haproxy)" ]; then
	echo "HAProxy n'est pas installé. Veuillez l'installer avant de continuer."



# Crée un fichier de configuration de template pour HAProxy
cat <<EOF > haproxy.tpl
global
  daemon
  maxconn {{ key "haproxy/config/maxconn" }}

defaults
  balance roundrobin
  timeout client 60s
  timeout connect 60s
  timeout server 60s

frontend stats
  bind *:8404
  mode http
  stats enable
  stats uri /stats
  stats refresh 10s
  stats admin if TRUE

frontend http
  bind *:8080
  mode http
  default_backend web

backend web
  balance roundrobin
  mode http
  {{ range service "web" }}
  server {{ .Name }} {{ .Address }}:{{ .Port }}
  {{ end }}
EOF

# Utilise consul-template pour générer dynamiquement la configuration de HAProxy
consul-template -template="haproxy.tpl:haproxy.cfg:docker kill -s HUP haproxy"
