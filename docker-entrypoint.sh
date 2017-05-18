#!/bin/bash

if [ -z ${ETCD_URL+x} ]; then
  ETCD_URL="http://etcd:2378"
fi

dockerize -wait $ETCD_URL ./etcd-setup.sh
