#!/bin/bash

# download docker image
docker pull jbunistra/cloud-frontend:latest

# Run the worker
docker run -d --rm --name cloud-worker jbunistra/cloud-frontend:latest