#!/usr/bin/env bash

export PATH=$HOME/git/bin:$PATH

repo_url=$1
repo_version=$2

if type apt-get >/dev/null 2>&1; then
    apt-get update
    apt-get install -y \
        build-essential \
        g++ \
        flex \
        bison \
        gperf \
        ruby \
        perl \
        libsqlite3-dev \
        libfontconfig1-dev \
        libicu-dev \
        libfreetype6 \
        libssl-dev \
        libpng-dev \
        libjpeg-dev \
        python \
        libx11-dev \
        libxext-dev \
        git
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
