##  Use the folowing to create my personalized image
FROM ubuntu:24.04

# Install Squid with OpenSSL support and any needed helpers
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y squid-openssl squidguard openssl nano wget tzdata && rm -rf /var/lib/apt/lists/*

# Initialize the SSL certificate database directory for SSL-Bump
RUN /usr/lib/squid/security_file_certgen -c -s /var/spool/squid/ssl_db -M 4MB

RUN apt update
RUN apt -y full-upgrade

RUN chown -R proxy:proxy /var/lib/squidguard
RUN chown -R proxy:proxy /var/spool/squid/ssl_db

#ENTRYPOINT ["squid"]
#CMD ["-sNY"]
CMD ["squid", "-sNY"]
