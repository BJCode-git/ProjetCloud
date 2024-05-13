#!/bin/bash

# download docker image
docker pull jbunistra/cloud-backend:latest

# Run the worker
docker run -d --rm --name cloud-backend jbunistra/cloud-backend:latest