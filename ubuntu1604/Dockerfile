FROM ubuntu:16.04
LABEL maintainer="KamilSokolowski@finastra.com"

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

RUN pip install --no-cache ansible==2.3.0.0

RUN mkdir -p /etc/ansible/

RUN echo "[local]" |tee -a /etc/ansible/hosts && \
    echo "localhost" |tee -a /etc/ansible/hosts
