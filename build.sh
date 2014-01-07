#!/bin/bash
BASEDIR=$(dirname $(readlink -f $0))

set -e
echo "===== Building The Container ====="
docker build -t docker/container $BASEDIR/build/