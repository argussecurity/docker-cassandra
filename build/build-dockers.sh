#!/bin/bash
set -e

IMAGE_PREFIX=argussecurity
IMAGE_NAME=cassandra
BUILD_PROPERTIES_LOCATION=./build.properties
NUMBER_OF_IMAGES=4
declare -a DIRS=( "cassandra-base" "cassandra" "cassandra-cluster" "cassandra-cluster-prometheus" )
declare -a TAGS=( "base"           "latest"    "cluster"           "cluster-prometheus" )

script_dir="$( cd "$( dirname "$0" )" && pwd )"
cd $script_dir/..

echo "Adding some build information..."
echo -e "BUILD_DATE=`date`\nGIT_REVISION=`git rev-parse HEAD`\nGIT_REVISION_NAME=`git rev-parse --abbrev-ref HEAD`" > $BUILD_PROPERTIES_LOCATION

for (( i = 0; i < $NUMBER_OF_IMAGES; i++ ));
do
  dir=${DIRS[$i]}
  tag=${TAGS[$i]}

  echo "Tagging old docker images, if exists (to be removed)..."
  docker tag $IMAGE_PREFIX/$IMAGE_NAME:$tag   $IMAGE_PREFIX/$IMAGE_NAME:old-$tag || true

  echo "Building new docker image..."
  docker build -t $IMAGE_PREFIX/$IMAGE_NAME:$tag $dir

  echo "Removing old docker images..."
  docker rmi -f $IMAGE_PREFIX/$IMAGE_NAME:old-$tag || true
done

echo "Deleting the build information file"
rm $BUILD_PROPERTIES_LOCATION

echo "Done"
