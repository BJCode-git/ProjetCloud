# Utiliser une image Python officielle comme base
FROM python:3.9

# Définir le répertoire de travail dans le conteneur
WORKDIR /worker

# Copier les fichiers du projet dans le conteneur
COPY . .

# Mettre à jour le gestionnaire de paquets et installer les outils nécessaires
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get clean

# Installer Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# Installer les dépendances du projet
RUN poetry install

# Installer gunicorn (s'il est nécessaire pour le runtime)
RUN pip install gunicorn

# Exposer le port 8080 utilisé par l'application Flask (si nécessaire)
EXPOSE 8080

# Définir la commande par défaut pour exécuter le serveur web avec Gunicorn
CMD ["gunicorn", "--workers", "4", "--bind", "0.0.0.0:8080", "image_api.web:app"]
