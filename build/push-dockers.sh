#!/bin/bash
set -e

IMAGE_PREFIX=argussecurity
IMAGE_NAME=cassandra
NUMBER_OF_IMAGES=3
declare -a DIRS=( "cassandra-base" "cassandra" "cassandra-cluster" )
declare -a TAGS=( "base"           "latest"    "cluster"           )

for (( i = 0; i < $NUMBER_OF_IMAGES; i++ ));
do
  dir=${DIRS[$i]}
  tag=${TAGS[$i]}

  docker tag $IMAGE_PREFIX/$IMAGE_NAME:$tag $DOCKER_REGISTRY/$IMAGE_PREFIX/$IMAGE_NAME:$tag
  docker push $DOCKER_REGISTRY/$IMAGE_PREFIX/$IMAGE_NAME:$tag
  docker rmi $DOCKER_REGISTRY/$IMAGE_PREFIX/$IMAGE_NAME:$tag
done

echo "Done"
