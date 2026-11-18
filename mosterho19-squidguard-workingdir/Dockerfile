##  Use the folowing to create my personalized image
FROM ubuntu/squid:6.6-24.04
#FROM ubuntu/squid:latest

RUN apt update
RUN apt -y full-upgrade

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    squid-openssl squidguard openssl && \
    rm -rf /var/lib/apt/lists/*

RUN apt -y install nano wget squidguard tzdata
RUN chown -R proxy:proxy /var/lib/squidguard

#ENTRYPOINT ["squid"]
#CMD ["-sNY"]
CMD ["squid", "-sNY"]

