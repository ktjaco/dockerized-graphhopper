FROM java:8
MAINTAINER ktjaco

ADD assets /tmp

VOLUME ["/data"]

EXPOSE 8989

WORKDIR /data

RUN /tmp/init.sh

ENTRYPOINT ["/graphhopper/start.sh", "-d", "--name=graphhopper", "-v ~/tmp/graphhopper/:/data", "-p 8990:8989"]
