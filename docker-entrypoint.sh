#!/bin/bash

if [ -z ${ETCD_URL+x} ]; then
  ETCD_URL="http://etcd:2378"
fi

dockerize -wait $(echo $ETCD_URL | sed 's/http/tcp/g') ./etcd-setup.sh "$@"
