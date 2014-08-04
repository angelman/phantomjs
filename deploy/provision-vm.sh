#!/usr/bin/env bash

export PATH=$HOME/git/bin:$PATH

repo_url=$1
repo_version=$2

if type apt-get >/dev/null 2>&1; then
    apt-get update
    apt-get install -y \
        build-essential \
        git-core \
        libssl-dev \
        libfontconfig1-dev \
        binutils-gold  \
        openssl \
        chrpath \
        libssl-dev \
        libfontconfig1-dev \
        libglib2.0-dev \
        libx11-dev \
        libxext-dev \
        libfreetype6-dev \
        libxcursor-dev \
        libxrandr-dev \
        libxv-dev \
        libxi-dev \
        libgstreamermm-0.10-dev \
        xvfb
fi

echo "Building from $repo_url with $repo_version"

if [[ ! -d phantomjs ]]; then
    mkdir phantomjs
    cd phantomjs
    git clone $repo_url .
else
    cd phantomjs
fi

git fetch origin
git reset --hard
git checkout $repo_version

deploy/build-and-package.sh

cp deploy/*.tar.bz2 /vagrant
