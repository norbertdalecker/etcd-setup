#!/bin/bash

docker-compose up -d etcd0;

docker build -t --no-cache norbertdalecker/etcd-setup:latest ../.;

docker-compose up etcd-setup;
