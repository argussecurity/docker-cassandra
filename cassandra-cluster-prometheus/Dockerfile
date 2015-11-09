FROM argussecurity/cassandra:cluster

ADD http://central.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.5/jmx_prometheus_javaagent-0.5.jar /usr/app/jmx_prometheus_javaagent.jar
ADD prometheus-config.yml /usr/app/prometheus-config.yml

# CASSANDRA_CONFIG is defined in the image built from
RUN echo 'JVM_OPTS="$JVM_OPTS -javaagent:/usr/app/jmx_prometheus_javaagent.jar=${PROMETHEUS_PORT:-31500}:/usr/app/prometheus-config.yml"' >> $CASSANDRA_CONFIG/cassandra-env.sh
