#!/bin/bash/

# If a push is required to the webiste, don't forget to login
# Clear any stuck sessions
##docker logout
# Log back in directly to Docker Hub
##docker login -u "YOUR_DOCKERHUB_USERNAME"


sudo docker build -t mosterho19/squidguard .
