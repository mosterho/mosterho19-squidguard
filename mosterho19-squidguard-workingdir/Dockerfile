## Use the following to create my personalized image
FROM ubuntu/squid:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt -y full-upgrade && \
    apt -y install --no-install-recommends \
    nano \
    wget \
    squidguard \
    tzdata

RUN chown -R proxy:proxy /var/lib/squidguard 

CMD ["squid", "-sNY"]
