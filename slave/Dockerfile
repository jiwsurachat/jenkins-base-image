FROM jenkins/jnlp-slave:alpine

LABEL maintainer="joewalker"

USER root

ENV PATH=$PATH:/home/sonar-scanner/bin;/home/dependency-check/bin

COPY . .

RUN apk update && \
    apk add --no-cache \
    ca-certificates \
    zip \
    unzip \
    git \
    wget \
    curl \
    docker \
    openjdk7 \
    maven \
    jq

RUN chmod u+x *.sh && \
    bash ./setup.sh && \
    rm -f setup.sh

VOLUME [ "/var/run/docker.sock" ]