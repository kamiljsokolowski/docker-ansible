FROM ubuntu:14.04
LABEL maintainer="KamilSokolowski@finastra.com"

RUN set -ex; \
    apt-get update -q && apt-get install -y \
      build-essential \
      libssl-dev \
      libffi-dev \
      python \
      python-dev \
      python-setuptools

RUN rm -rf /var/lib/apt/lists/*
