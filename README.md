# ETCD Setup

This a simple docker based application to set up your [etcd](https://github.com/coreos/etcd) properties 
the easiest way.

# Usage

You can use the script without docker but this way you have to some runtime dependencies:

```sh
apt-get install jq python3-pip
pip install jsonpipe pyyaml
```

After simply use the scrip:

```sh
git clone https://github.com/norbertdalecker/etcd-setup.git
cd etcd-setup


#use the test files from repo
$ bin/etcd-setup.sh test/input/
Check input file: test/input/
key: keys/anotherdirectory/anothersubdir/property2
value: value3
key: keys/anotherdirectory/anothersubdir/property
value: value4
key: keys/somedir/subdir/property2
value: this_will_be_overrided
key: keys/somedir/subdir/foo
value: bar
key: keys/somedir/subdir/property2
value: value2
key: keys/somedir/subdir/property
value: value1


```

## Env

You can pass your properties as environment variables with 'KEYS_' prefix.

The variables will be converted to etcd directories and keys.

For example: `KEYS_FOO_BAR` will be converted to `/foo/bar`

### Run

```sh

docker run -e "ETCD_URL=http://etcd:2378" \
-e "KEYS_FOO_BAR=something" \
-e "KEYS_FOO_NOTBAR=nothing" \
norbertdalecker/etcd-setup:latest

```

## Yaml

You can pass your property structure in yml file as well. The script will iterate all of command line arguments. 

If the argument is a directory it will iterate on all files in that.

If the argument is a file then it will push it's content into etcd.

```yml
somedir:
  subdir:
    property: value1
    property2: value2
```

### Run

```sh

docker run -v "yourdir:/yourdir" \
-v "somefile.yml:/somefile.yml" \
-e "ETCD_URL=http://etcd:2378" \
norbertdalecker/etcd-setup:latest /yourdir /somefile.yml

```

## JSON

You can pass your property structure in json file as well. The script will iterate all of command line arguments. 

If the argument is a directory it will iterate on all files in that.

If the argument is a file then it will push it's content into etcd.

```json
{
    "anotherdirectory": {
        "anothersubdir": {
            "property2": "value3", 
            "property": "value4"
        }
    },
    
    "somedir": {
        "subdir": {
            "property2": "this_will_be_overrided", 
            "foo": "bar"
        }
    }
}
```

### Run

```sh

docker run -v "yourdir:/yourdir" \
-v "somefile.yml:/somefile.json" \
-e "ETCD_URL=http://etcd:2378" \
norbertdalecker/etcd-setup:latest /yourdir /somefile.json

```

# Tests

You will find a docker-compose file in the test directory. This is a preconfigured env to validate the workflow. (the compose uses `test` docker network)

As you see you can push multiple files and envs at the same time, the script will handle it.

```yaml
etcd-setup:
  container_name: etcd-setup
  net: "test"
  volumes:
  - "./input:/testfiles"
  command: "/docker-entrypoint.sh /testfiles"
  environment:
  - KEYS_FOO_BAR=something
  - ETCD_URL=http://etcd0:2378
  image: norbertdalecker/etcd-setup:latest
```

### Run tests

```sh
cd tests
docker network create test
./build-and-test.sh
```

# Roadmap

0.1.x - Use env. variables and fix connection errors

0.2.0 - Use yml input files

0.3.0 - Use json as input files

0.4.0 - Handle entrypoint arguments in compose correct way

1.0.0 - SSL, auth and use etcd v3 api
