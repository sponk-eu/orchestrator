# Requires Docker 17.09 or later (multi stage builds)

FROM alpine:3.6

ENV GOPATH=/tmp/go

RUN apk update
RUN apk upgrade
RUN apk add --update libcurl
RUN apk add --update rsync
RUN apk add --update gcc
RUN apk add --update g++
RUN apk add --update go
RUN apk add --update build-base
RUN apk add --update bash
RUN apk add --update git
RUN apk add --update mysql-client

RUN mkdir -p $GOPATH/src/github.com/github/orchestrator
WORKDIR $GOPATH/src/github.com/github/orchestrator
COPY . .
RUN bash build.sh -b
RUN rsync -av $(find /tmp/orchestrator-release -type d -name orchestrator -maxdepth 2)/ /
RUN rsync -av $(find /tmp/orchestrator-release -type d -name orchestrator-cli -maxdepth 2)/ /
RUN cp /usr/local/orchestrator/orchestrator-sample-sqlite.conf.json /etc/orchestrator.conf.json

FROM alpine:3.6

EXPOSE 3000

RUN apk add --update bash
RUN apk add --update mysql-client
RUN apk add --update curl

COPY --from=0 /usr/local/orchestrator /usr/local/orchestrator
#COPY --from=0 /etc/orchestrator.conf.json /etc/orchestrator.conf.json

WORKDIR /usr/local/orchestrator
ADD docker/setup.sh /entrypoint.sh
ADD conf/orchestrator-docker.conf.json /etc/orchestrator-docker.conf.json
CMD /entrypoint.sh
