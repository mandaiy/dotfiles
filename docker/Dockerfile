# syntax=docker/dockerfile:1.2
FROM linuxbrew/brew:latest
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && \
    apt-get install -y \
        apt-transport-https \
        python3-dev \
        python3-venv \
        python-is-python3 \
    && \
    update-ca-certificates \
    && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /var/log/dpkg.log && \
    rm -f /var/log/alternatives.log && \
    rm -f /var/cache/ldconfig/aux-cache && \
    rm -f /var/cache/apt/pkgcache.bin

RUN useradd -u 1001 -ms /bin/bash builder \
    && \
    groupadd -g 998 robots \
    && \
    mkdir -p /home/builder/.cache /home/builder/.local && \
    chown -R builder:robots /home/builder/.cache && \
    chown -R builder:robots /home/builder/.local && \
    echo 'builder ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN chown -R builder:robots /home/linuxbrew/.linuxbrew

USER builder:robots
RUN brew update
