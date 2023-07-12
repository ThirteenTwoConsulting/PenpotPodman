#!/bin/bash

if [ "$1" == "stop" ]; then
    echo "Stopping containers..."
    podman stop penpot-mailcatch
    podman stop penpot-redis
    podman stop penpot-postgres
    podman stop penpot-exporter
    podman stop penpot-backend
    podman stop penpot-frontend
    exit 0
fi

echo "Creating Penpot network if it does not exist..."
podman network create --ignore penpot

podman run --rm --name=penpot-mailcatch --network=penpot --expose=1025 -p 1080:1080 -d sj26/mailcatcher:latest
podman run --rm --name=penpot-redis --network=penpot -d redis:7
podman run --rm --name=penpot-postgres --network=penpot --user 1000 --volume=./db:/var/lib/postgresql/data:rw --env-file=./pod.env -d postgres:15
podman run --rm --name=penpot-exporter --network=penpot --env-file=./pod.env -d penpotapp/exporter:latest
podman run --rm --name=penpot-backend --network=penpot --env-file=./pod.env --env-file=./pod.secrets.env --volume=./assets:/opt/data/assets:rw --requires=penpot-postgres,penpot-redis -d penpotapp/backend:latest
podman run --rm --name=penpot-frontend --network=penpot --env-file=./pod.env --volume=./assets:/opt/data/assets:rw -p 9001:80 --requires=penpot-backend,penpot-exporter -d penpotapp/frontend:latest
