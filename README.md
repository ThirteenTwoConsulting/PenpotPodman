# Penpot Podman

While Penpot officially supports Docker (& docker-compose), Podman is a drop-in replacement of sorts for Docker.

While the official Docker support requires docker-compose, Podman doesn't have a native/first-party conversion for compose files yet.

The `./run.sh` file will build out the network, create the containers and mount the necessary volumes.

This is a quick PoC and isn't meant to be the most prettiest solution, but it works.

If you want to kill the containers just run `./run.sh stop`.
