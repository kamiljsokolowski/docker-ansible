FROM ubuntu:14.04
LABEL maintainer="KamilSokolowski@finastra.com"

ARG ansible_version="2.3.0.0"

RUN set -ex; \
    apt-get update -q && apt-get install -y \
      curl \
      build-essential \
      libssl-dev \
      libffi-dev \
      python \
      python-dev \
      python-setuptools \
 && rm -rf /var/lib/apt/lists/*

RUN easy_install pip

RUN pip install --no-cache ansible==$ansible_version

RUN mkdir -p /etc/ansible/

RUN echo "[local]" |tee -a /etc/ansible/hosts && \
    echo "localhost" |tee -a /etc/ansible/hosts

RUN mkdir -p /ansible/
WORKDIR /ansible
