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

function parseDir {
 for file in $(ls $1); do
   if [ -f $file ]; then
     parseFile $file;
   fi
 done
}

function parseFile {
  if [ ${1: -4} == ".yml" ]; then
    parseYml $1;
  fi
  if [ ${1: -4} == ".json" ]; then
    parseJson $1;
  fi
}

function parseYml {
   python -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout, indent=4)' < $1 > tmp.json
   parseJson tmp.json;
   rm tmp.json;
}

function parseJson {
   cat $1 | jsonpipe | grep -v "{}" | grep -v "\[\]" | sed 's/"//g' | sed "s/\s/=/g"
}

for i in $@; do
  if [ -f $i ]; then
    parseFile $i;
  else 
    parseDir $i;
  fi
done

