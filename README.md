# ETCD Setup

This a simple docker based application to set up your [etcd](https://github.com/coreos/etcd) properties 
the easiest way.

# Usage

You can pass your properties as environment variables with 'KEYS_' prefix.

The variables will be converted to etcd directories and keys.

For example: `KEYS_FOO_BAR` will be converted to `/foo/bar`

# Run

```sh

docker run -e "ETCD_URL=http://etcd:2378" \
-e "KEYS_FOO_BAR=something" \
-e "KEYS_FOO_NOTBAR=nothing" \
norbertdalecker/etcd-setup:0.1.0 

```


# Roadmap

0.1.0 - Use env. variables

0.2.0 - Use yml input files

0.3.0 - Use json as input files

1.0.0 - SSL, auth and use etcd v3 api
