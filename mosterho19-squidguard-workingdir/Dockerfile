FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    squid-openssl \
    squidguard \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Create directories with proper ownership and permissions
RUN mkdir -p /var/log/squid /var/log/squidguard /var/spool/squid /etc/squid/certs /var/lib/squidguard && \
    chown -R proxy:proxy /var/log/squid /var/log/squidguard /var/spool/squid /etc/squid/certs /var/lib/squidguard && \
    chmod 750 /var/log/squid /var/log/squidguard /var/spool/squid /etc/squid/certs

# Bake configs and SquidGuard lists into the image
COPY squid.conf /etc/squid/squid.conf
COPY squidGuard.conf /etc/squidguard/squidGuard.conf
COPY squidguard/ /var/lib/squidguard/

# Compile SquidGuard databases and ensure proxy user owns them
RUN  chown -R proxy:proxy /var/lib/squidguard

EXPOSE 3128 3129

CMD ["squid", "-N", "-d", "1"]
