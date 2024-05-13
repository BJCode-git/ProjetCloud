#!/bin/bash

# download docker image
docker pull jbunistra/cloud-worker:latest

# Run the worker
docker run -d --rm --name cloud-worker jbunistra/cloud-worker:latest