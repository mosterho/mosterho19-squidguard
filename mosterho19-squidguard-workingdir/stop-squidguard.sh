#!/bin/bash
sudo docker container stop httpd
sudo docker container rm httpd
sudo docker container stop squidguard
sudo docker container rm squidguard
