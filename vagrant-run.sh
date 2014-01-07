#!/bin/bash
BASEDIR=$(dirname $(readlink -f $0))

CONTAINER_NAME='pass'

if docker inspect $CONTAINER_NAME 2> /dev/null | grep --quiet 'IPAddress' ; then
  if docker inspect $CONTAINER_NAME | grep 'IPAddress' | grep -E --quiet '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' ; then
    echo "Stopping $CONTAINER_NAME"
    docker stop $CONTAINER_NAME > /dev/null
  else
    echo "$CONTAINER_NAME is not running"
  fi
  echo "Removing old $CONTAINER_NAME"
  docker rm $CONTAINER_NAME > /dev/null
else
  echo "$CONTAINER_NAME does not exist"
fi

CONTAINER_NAME='fail'

if docker inspect $CONTAINER_NAME 2> /dev/null | grep --quiet 'IPAddress' ; then
  if docker inspect $CONTAINER_NAME | grep 'IPAddress' | grep -E --quiet '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' ; then
    echo "Stopping $CONTAINER_NAME"
    docker stop $CONTAINER_NAME > /dev/null
  else
    echo "$CONTAINER_NAME is not running"
  fi
  echo "Removing old $CONTAINER_NAME"
  docker rm $CONTAINER_NAME > /dev/null
else
  echo "$CONTAINER_NAME does not exist"
fi

set -e
docker run -name pass -d \
-v /vagrant/pass_mountpoint:/mountpoint \
-v /home/vagrant/pass_other_mountpoint:/other_mountpoint \
docker/container
echo "==== Pass Container Running ===="


docker run -name fail -d \
-v /vagrant/fail_mountpoint:/mountpoint \
-v /home/vagrant/fail_other_mountpoint:/other_mountpoint \
-v /home/vagrant/fail_subdir:/mountpoint/subdir \
docker/container
echo "==== Fail Container Running ===="