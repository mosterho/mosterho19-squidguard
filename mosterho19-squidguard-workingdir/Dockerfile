##  Use the folowing to create my personalized image
FROM ubuntu/squid:latest

RUN apt update
RUN apt -y full-upgrade
RUN apt -y install nano wget squidguard tzdata

RUN chown -R proxy:proxy /var/lib/squidguard

#ENTRYPOINT ["squid"]
#CMD ["-sNY"]
CMD ["squid", "-sNY"]

