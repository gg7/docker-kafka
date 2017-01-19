FROM ubuntu:16.04

RUN echo '2017-01-19' && \
    apt-get -qq update && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq install openjdk-8-jre-headless wget supervisor dnsutils && \
    rm -rf /var/lib/apt/lists/* /var/cache/*

ARG SCALA_VERSION=2.11
ARG KAFKA_VERSION=0.10.1.1
ENV KAFKA_HOME=/opt/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION"

RUN wget -q http://apache.mirrors.spacedump.net/kafka/"$KAFKA_VERSION"/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -O /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz && \
    tar xfz /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -C /opt && \
    ln -s "/opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION}" "/opt/kafka" && \
    rm /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz && \
    mkdir /tmp/kafka-logs

ENV ENV PATH="$PATH:/opt/kafka/bin"

ADD scripts/start-kafka.sh /usr/bin/start-kafka.sh

# Supervisor config
ADD supervisor/kafka.conf supervisor/zookeeper.conf /etc/supervisor/conf.d/

# 2181 is zookeeper, 9092 is kafka
EXPOSE 2181 9092

VOLUME /tmp/kafka-logs

CMD ["supervisord", "--nodaemon"]
