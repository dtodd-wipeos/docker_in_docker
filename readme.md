# Docker in Docker

Inspired by Jerome's now defunct [dind](https://github.com/jpetazzo/dind) and actually uses the wrapper script from that repository.

This docker container allows running containers within other containers. It contains docker-compose, so you can launch all the containers at once.

## Usage

1. Pull the container `docker pull dtodd0/docker_in_docker:latest`
1. Optionally mount the overlay fs
1. run a docker container `docker run -it --privileged=true dtodd0/docker_in_docker:latest docker run -it --privileged=true dtodd0/docker_in_docker:latest docker run -it hello-world`


