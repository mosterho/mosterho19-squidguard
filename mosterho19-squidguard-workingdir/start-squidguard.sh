#!/bin/bash
# To restart just the proxy
docker compose restart squidguard

# To restart just the web server
docker compose restart httpd
