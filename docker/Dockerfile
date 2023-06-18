# syntax=docker/dockerfile:1.2
FROM homebrew/brew@sha256:36ea609c1bbc4e3ba1255977ec2c0d05a5768b3fa3a609c1dcd0325a2e89bf8e
ARG DEBIAN_FRONTEND=noninteractive

USER root
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

USER linuxbrew
RUN brew install \
    bat \
    fd \
    fish \
    fzf \
    neovim \
    ripgrep \
    tmux
