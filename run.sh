#!/bin/bash

if [ "$1" == "stop" ]; then
    echo "Stopping containers..."
    podman stop penpot-mailcatch
    podman stop penpot-redis
    podman stop penpot-postgres
    podman stop penpot-exporter
    podman stop penpot-backend
    podman stop penpot-frontend
    podman pod rm penpot
    podman network rm penpot
    exit 0
fi

echo "Creating Penpot network if it does not exist..."
podman network create penpot

podman pod create --replace --network penpot -p 127.0.0.1:9001:80 -p 127.0.0.1:1080:1080 penpot

podman run --replace --name=penpot-mailcatch --expose=1025 --pod penpot -d sj26/mailcatcher:latest
podman run --replace --name=penpot-redis --pod penpot -d redis:7
podman run --replace --name=penpot-postgres --pod penpot --volume=./db:/var/lib/postgresql/data:rw --env-file=./pod.env -d postgres:15

# Uncommen when need be
podman run --replace --name=penpot-exporter --pod penpot --env-file=./pod.env -d penpotapp/exporter:latest

podman run --replace --name=penpot-backend --pod penpot --env-file=./pod.env --env-file=./pod.secrets.env --volume=./assets:/opt/data/assets:U,rw --user=0:0 --requires=penpot-redis,penpot-postgres -d penpotapp/backend:latest
podman run --replace --name=penpot-frontend --pod penpot --env-file=./pod.env --volume=./assets:/opt/data/assets:rw --requires=penpot-backend -d penpotapp/frontend:latest
