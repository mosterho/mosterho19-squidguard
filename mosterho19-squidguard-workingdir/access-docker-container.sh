#!/bin/bash

export $(cat mosterho19-docker-path.env)
my_pwd=$MOSTERHO19SQUIDGUARDPATH

containerid=$(sudo bash capture-containerid.sh)

sudo docker container exec -it $containerid bash