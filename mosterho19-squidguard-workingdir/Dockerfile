## Use the following to create my personalized image
FROM ubuntu/squid:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt -y full-upgrade && \
    apt -y install --no-install-recommends \
    nano \
    wget \
    squid-openssl \
    squidguard \
    ca-certificates \
    tzdata && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/squid/certs && \
    chown -R proxy:proxy /var/lib/squidguard /etc/squid/certs && \
    chmod 750 /etc/squid/certs

#ENTRYPOINT ["squid"]
#CMD ["-sNY"]
#CMD ["squid", "-sNY"]


COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["-f", "/etc/squid/squid.conf"]
