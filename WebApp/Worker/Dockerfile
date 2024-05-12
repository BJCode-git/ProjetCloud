# Utiliser une image Python officielle comme base
FROM python:3.9


# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier le fichier pyproject.toml pour installer les dépendances
COPY pyproject.toml poetry.lock /app/

 # Définir l'environnement Poetry
ENV POETRY_HOME='/usr/local'

# Mettre à jour le gestionnaire de paquets et installer les outils nécessaires
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get clean

# Installer Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -


# Installer les dépendances du projet
RUN poetry install 

# Copier le reste des fichiers de l'application
COPY . /app

# Exposer le port 8080 utilisé par l'application Flask
EXPOSE 8080

# Run the celery worker
CMD [ "poetry", "run", "celery", "--app", "image_api.worker.app", "worker" ]

