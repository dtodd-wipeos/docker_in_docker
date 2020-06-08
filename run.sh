#!/bin/bash
# Part of Docker in Docker
# Copyright 2020 OceanTech
# Authored by: David Todd <dtodd@oceantech.com>
# License: MIT, refer to `license.md` for more information

echo "Running your application"
docker run \
    -it \
    --privileged=true \
    --volume overlay:/overlay \
    docker_in_docker:latest \
    "$@"
