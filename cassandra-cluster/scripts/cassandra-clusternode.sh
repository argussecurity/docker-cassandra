#!/usr/bin/env bash

# Get running container's IP
IP=${IP:-`hostname --all-ip-addresses | cut -f 1 -d ' '`}

# HOST should be available, but just in case
HOST=${HOST:-$IP}

# Public IP (default: $IP)
PUBLIC_IP=$(dig +short ${HOST} @8.8.8.8)
PUBLIC_IP=${PUBLIC_IP:-$IP}

if [ $# == 1 ]; then SEEDS="$1,$IP"; 
else SEEDS="$IP"; fi

# Setup cluster name
if [ -z "$CASSANDRA_CLUSTERNAME" ]; then
        echo "No cluster name specified, preserving default one"
else
        sed -i -e "s/^cluster_name:.*/cluster_name: $CASSANDRA_CLUSTERNAME/" $CASSANDRA_CONFIG/cassandra.yaml
fi


# Dunno why zeroes here
sed -i -e "s/^rpc_address.*/rpc_address: 0.0.0.0/" $CASSANDRA_CONFIG/cassandra.yaml

# Listen on IP:port of the container
sed -i -e "s/^listen_address.*/listen_address: $IP/" $CASSANDRA_CONFIG/cassandra.yaml

sed -i -e "s/# broadcast_address.*/broadcast_address: $HOST/" $CASSANDRA_CONFIG/cassandra.yaml

# Configure Cassandra seeds
if [ -z "$CASSANDRA_SEEDS" ]; then
	echo "No seeds specified, being my own seed..."
	CASSANDRA_SEEDS=$SEEDS
fi
sed -i -e "s/- seeds: \"127.0.0.1\"/- seeds: \"$CASSANDRA_SEEDS\"/" $CASSANDRA_CONFIG/cassandra.yaml

# authentication
sed -i -e "s/^authenticator.*/authenticator: PasswordAuthenticator/" $CASSANDRA_CONFIG/cassandra.yaml

echo "JVM_OPTS=\"\$JVM_OPTS -Djava.rmi.server.hostname=${HOST:-$IP}\"" >> $CASSANDRA_CONFIG/cassandra-env.sh

echo "Starting Cassandra on $IP..."

exec cassandra -f
