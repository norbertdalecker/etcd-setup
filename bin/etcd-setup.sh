#!/bin/bash

# Init

if [ -z ${ETCD_URL+x} ]; then
  ETCD_URL="http://etcd:2378"
fi

# Functions

function store {
  curl -sL -XPUT "$ETCD_URL/v2/$1" --data-urlencode value="$2"
}

# Iterate the files in directory

function parseDir {
 for file in $( find $1 -type f ); do
     parseFile $file;
 done
}

# Chech file type then store the content in etcd

function parseFile {
  if [ ${1: -4} == ".yml" ]; then
    parseYml $1;
  fi
  if [ ${1: -5} == ".json" ]; then
    parseJson $1;
  fi
}

# Convert yml to json then store the content to etcd

function parseYml {
   python -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout, indent=4)' < $1 > tmp.json
   parseJson tmp.json;
   rm tmp.json;
}

# Store json file's content to etcd 

function parseJson {
   for var in $(cat $1 | jsonpipe | grep -v "null" | grep -v "{}" | grep -v "\[\]" | sed 's/"//g' | sed "s/\s/=/g"); do
     splitAndStoreVariable "keys/$var";
   done
}


function splitAndStoreVariable {
    # 'foo/bar' <- 'FOO_BAR'
    etcd_key=$(echo $1 | awk -F '=' '{print $1}' | tr '[:upper:]' '[:lower:]' | tr _ /)
    etcd_value=$(echo $1 | awk -F '=' '{print $2}')

    echo "key: $etcd_key"
    echo "value: $etcd_value"
    store $etcd_key $etcd_value
}

# Iterate over environment variables

for var in $(env | grep KEYS); do
    splitAndStoreVariable $var;
done

# Iterate over input arguments

for i in $@; do
  echo "Check input file: $i"
  if [ -f $i ]; then
    parseFile $i;
  else 
    parseDir $i;
  fi
done

