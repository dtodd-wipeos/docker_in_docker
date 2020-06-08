#!/bin/bash
# Part of Docker in Docker
# Copyright 2020 OceanTech
# Authored by: David Todd <dtodd@oceantech.com>
# License: MIT, refer to `license.md` for more information

IMGNAME=docker_in_docker
BUILD_TARGET=run_app

function show_help() {
    echo "build-container.sh - Generates a local docker image called ${IMGNAME}"
    echo ""
    echo "Advanced Usage: $0 OPTIONS"
    echo ""
    echo "Available Options:"
    echo "  ?|-h|--help (optional), Shows this screen"
    echo "  -s|--stage (optional), Selects a particular stage to stop a build at"
    echo "      See the Dockerfile for all of the stages, default is run_app"
}

# Command line arguments
while [[ $# > 0 ]]; do
    key="$1"
    case $key in
        ?|-h|--help)
            show_help
            shift
            exit 0
        ;;
        # Give the ability to define which target to build (see the Dockerfile)
        -s|--stage)
            if [[ ! -z "$2" ]]; then
                BUILD_TARGET="$2"
            else
                echo "Invalid Argument: $1"
                show_help
                exit 1
            fi
            shift
        ;;
        *)
            echo "Invalid Argument: $1"
            show_help
            shift
            exit 1
        ;;
    esac
    shift
done

# Download the wrapper at build, rather than bundle it
rm wrapper > /dev/null
wget https://raw.githubusercontent.com/jpetazzo/dind/master/wrapdocker -O wrapper
sed -i '2i # Taken from: https://github.com/jpetazzo/dind/blob/master/wrapdocker' wrapper
sed -i '3i # Copyright 2014 Jerome Petazzoni <jerome.petazzoni@docker.com>' wrapper
chmod a+x wrapper

# This step is to remove the stopped container from local docker inventory
# Required if we want to remove the image the container depends on
docker ps -a | grep ${IMGNAME} > /dev/null
if [[ $? -eq 0 ]]; then
    echo "Removing previous container"
    docker ps -a | grep ${IMGNAME} | awk '{print $1}' | xargs docker rm
fi

# This step is to remove the image the above container depends on
# We remove the image because every subsequent build will generate
# a new image. This can quickly reduce your available disk space
# if you are making a lot of builds (such as when testing)
docker images | grep ${IMGNAME} > /dev/null
if [[ $? -eq 0 ]]; then
    echo "Removing previous build"
    docker images | grep ${IMGNAME} | awk '{print $3}' | xargs docker rmi
fi

echo "Building container"
docker build --target ${BUILD_TARGET} --tag ${IMGNAME} .
