# Penpot Podman

While Penpot officially supports Docker (& docker-compose), Podman is a drop-in replacement of sorts for Docker.

While the official Docker support requires docker-compose, Podman doesn't have a native/first-party conversion for compose files yet.

The `./run.sh` file will build out the network, create the containers and mount the necessary volumes.

This is a quick PoC and isn't meant to be the most prettiest solution, but it works.

If you want to kill the containers just run `./run.sh stop`.

Since Penpot will generate a new secret key on boot whenever `PENPOT_SECRET_KEY` is not found in the env vars, it's not a necessity to set one.

However, I would advise if you do to set it in a `pod.secrets.env` file.

All the envs found in `pod.env` are from the official docker-compose.yml set up so change accordingly if you like.
