#!/bin/bash
set -e

IMAGE_PREFIX=argussecurity
IMAGE_NAME=cassandra
NUMBER_OF_IMAGES=4
declare -a DIRS=( "cassandra-base" "cassandra" "cassandra-cluster" "cassandra-cluster-prometheus" )
declare -a TAGS=( "base"           "latest"    "cluster"           "cluster-prometheus" )

for (( i = 0; i < $NUMBER_OF_IMAGES; i++ ));
do
  dir=${DIRS[$i]}
  tag=${TAGS[$i]}

  docker push $IMAGE_PREFIX/$IMAGE_NAME:$tag
done

echo "Done"
