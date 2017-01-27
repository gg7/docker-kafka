[![DockerHub pulls](https://img.shields.io/docker/pulls/gg77/kafka.svg)](https://hub.docker.com/r/gg77/kafka)

# About

Single-broker [Kafka](https://kafka.apache.org/) + single-node
[Zookeper](https://zookeeper.apache.org/) in one Docker container, managed by
[supervisord](http://supervisord.org/).

Forked from [spotify/docker-kafka](https://github.com/spotify/docker-kafka).
Improvements:

* Kafka/Zookeeper output is shown on `stdout`/`stderr` (see [veithen's blog](https://veithen.github.io/2015/01/08/supervisord-redirecting-stdout.html))
* You can override ***any*** broker configuration setting through environment variables
* Uses the bundled Zookeeper in Kafka, instead of the one in apt (smaller Docker image)
* The base image can now be easily changed (e.g. newer ubuntu)
* Kafka logs are kept on a VOLUME, giving us better IO performance
* Simplified and improved Dockerfile, kafka startup script, and supervisord config
* Doesn't run as `root`
* No "proxy" or ["helios"](https://github.com/spotify/helios) bloat

# Getting the image

To build (note: the `--build-arg` options are not actually required):

```bash
docker build --tag gg77/kafka --build-arg SCALA_VERSION=2.11 --build-arg KAFKA_VERSION=0.10.1.1 .
```

Alternatively, pull `latest` from the [gg77/kafka DockerHub repository](https://registry.hub.docker.com/u/gg77/kafka/):

```bash
docker pull gg77/kafka
```

# Using the image

```bash
docker run --rm -it KAFKA_CONFIG_MESSAGE_MAX_BYTES=1337 --name kafka --hostname kafka gg77/kafka
```

Using the Kafka utilities:

```bash
docker exec -it kafka /home/kafka/kafka/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 4 --topic harambe
```

From another container:

```bash
docker run --rm -it --link kafka gg77/kafka /home/kafka/kafka/bin/kafka-topics.sh --describe --zookeeper kafka:2181
```
