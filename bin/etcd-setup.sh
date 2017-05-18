#!/bin/bash

# Init

if [ -z ${ETCD_URL+x} ]; then
  ETCD_URL="http://etcd:2378"
fi

# Functions

function store {
  curl -sL -XPUT "$ETCD_URL/v2/$1" --data-urlencode value="$2"
}


for var in $(env | grep KEYS); do
    # 'foo/bar' <- 'FOO_BAR'
    etcd_key=$(echo $var | awk -F '=' '{print $1}' | tr '[:upper:]' '[:lower:]' | tr _ /)
    etcd_value=$(echo $var | awk -F '=' '{print $2}')

    echo "key: $etcd_key"
    echo "value: $etcd_value"

    store $etcd_key $etcd_value
done
