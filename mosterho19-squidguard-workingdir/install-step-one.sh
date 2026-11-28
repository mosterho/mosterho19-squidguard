#!/bin/bash

echo "This program will perform the first step to install mosterho19/squidguard."

# Dynamically resolve the directory where this script lives
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR" || exit 1

while true; do
    read -p "Are you ready? (y/n): " y_n

    case "$y_n" in
    [Yy]*)
        read -p "Enter your local domain name [default: yourdomain.local]: " input_domain
        DOMAIN_NAME="${input_domain:-yourdomain.local}"

        read -p "Enter your WPAD hostname or IP [default: wpad.${DOMAIN_NAME}]: " input_wpad
        WPAD_HOST="${input_wpad:-wpad.${DOMAIN_NAME}}"

        read -p "Enter your Squid Proxy hostname or IP [default: proxy.${DOMAIN_NAME}]: " input_proxy
        PROXY_HOST="${input_proxy:-proxy.${DOMAIN_NAME}}"

        # Update /etc/hosts with FQDN and short hostname
        SHORT_HOST="$(hostname -s)"
        FQDN="${SHORT_HOST}.${DOMAIN_NAME}"
        echo "Updating /etc/hosts for ${FQDN}..."
        if grep -qE "^127\.0\.1\.1\s+" /etc/hosts; then
            sudo sed -i "s/^127\.0\.1\.1\s.*/127.0.1.1\t${FQDN} ${SHORT_HOST}/" /etc/hosts
        else
            echo -e "127.0.1.1\t${FQDN} ${SHORT_HOST}" | sudo tee -a /etc/hosts > /dev/null
        fi

        echo "Creating .env file in $PROJECT_DIR..."
        cat <<EOF > .env
# Domain and host configuration for WPAD and Squid Proxy
DOMAIN_NAME=${DOMAIN_NAME}
WPAD_HOST=${WPAD_HOST}
WPAD_PORT=80
PROXY_HOST=${PROXY_HOST}
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
        echo "Setup complete! Review .env if you need to adjust ports, then run install-step-two.sh."
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
