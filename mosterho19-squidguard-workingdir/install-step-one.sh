#!/bin/bash

echo "This program will perform the first step to install mosterho19/squidguard."

# Dynamically resolve the directory where this script lives
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE}")" && pwd)"
cd "$PROJECT_DIR" || exit 1

while true; do
    read -p "Are you ready? (y/n): " y_n

    case "$y_n" in
    [Yy]*)
        read -p "Enter your WPAD/Proxy hostname or IP [default: wpad.yourdomain.local]: " input_host
        WPAD_HOST="${input_host:-wpad.yourdomain.local}"

        echo "Creating .env file in $PROJECT_DIR..."
        cat <<EOF > .env
# Primary hostname or IP for both WPAD and Proxy (e.g., wpad.yourdomain.local or 192.168.1.50)
WPAD_HOST=${WPAD_HOST}
WPAD_PORT=80

# Optional: Only uncomment if your Squid proxy runs on a different host/IP than WPAD
# PROXY_HOST=proxy.yourdomain.local
PROXY_PORT=3128
EOF

        # Safely load .env variables into the current shell
        set -a
        source .env
        set +a

        echo "Docker pull..."
        sudo docker compose pull squidguard httpd

        echo "Docker create..."
        sudo docker compose create squidguard httpd

        sudo docker compose ps -a
        echo "Setup complete! Review .env if you need to adjust ports, then start the stack."
        break
        ;;
    [Nn]*)
        echo "Exiting script."
        exit 0
        ;;
    *)
        echo "Please answer yes or no."
        ;;
    esac
done
