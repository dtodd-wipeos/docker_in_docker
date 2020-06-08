# Part of Docker in Docker
# Copyright 2020 OceanTech
# Authored by: David Todd <dtodd@oceantech.com>
# License: MIT, refer to `license.md` for more information

# This is a multi-stage docker file, each stage is a different section wrapped in comments
# https://docs.docker.com/develop/develop-images/multistage-build/

FROM alpine:3.11 AS install_base_depends
RUN set -eux; \
    apk --no-cache --update add \
        bash \
        iptables \
        ca-certificates \
        e2fsprogs \
        docker \
        docker-compose

VOLUME /var/lib/docker
VOLUME /overlay

FROM install_base_depends AS install_wrapper
RUN set -eux; \
    wget https://raw.githubusercontent.com/jpetazzo/dind/master/wrapdocker -O /usr/local/bin/wrapper; \
    sed -i '2i # Taken from: https://github.com/jpetazzo/dind/blob/master/wrapdocker' /usr/local/bin/wrapper; \
    sed -i '3i # Copyright 2014 Jerome Petazzoni <jerome.petazzoni@docker.com>' /usr/local/bin/wrapper; \
    chmod a+x /usr/local/bin/wrapper

FROM install_wrapper AS install_containers
# TODO: Get the containers in here...

FROM install_containers AS run_app
ENTRYPOINT ["wrapper"]
#ENTRYPOINT ["docker-compose", "up", "--force-recreate", "--build"]
#ENTRYPOINT ["docker", "run", "-it", "hello-world"]
