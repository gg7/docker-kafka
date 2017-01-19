# About

Single-broker Kafka + single-node Zookeper in one Docker container.

Why did I fork [spotify/docker-kafka](https://github.com/spotify/docker-kafka)?
Improvements:

* Oracle's JDK over OpenJDK
* No "proxy" or "helios" bloat
* Kafka and Zookeeper logging output shown on stdout/stderr

# Getting the image

To build (the `--build-arg` options are not required):

```bash
docker build --tag gg77/kafka --build-arg SCALA_VERSION=2.11 --build-arg KAFKA_VERSION=0.10.1.1 .
```

Alternatively, pull `latest` from the [gg77/kafka DockerHub repository](https://registry.hub.docker.com/u/gg77/kafka/):

```bash
docker pull gg77/kafka
```

# Using the image

```bash
docker run --rm -it --name kafka --hostname kafka gg77/kafka
```

Using the Kafka utilities:

```bash
docker exec -it kafka /opt/kafka/bin/kafka-topics.sh --create --zookeeper localhost:2181 --partitions 4 --topic harambe
```

From another container:

```bash
docker run --rm -it --link kafka gg77/kafka /opt/kafka/bin/kafka-topics.sh --describe --zookeeper kafka:2181
```
