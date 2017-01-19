# About

Single-broker [Kafka](https://kafka.apache.org/) + single-node
[Zookeper](https://zookeeper.apache.org/) in one Docker container, managed by
[supervisord](http://supervisord.org/).

Forked from [spotify/docker-kafka](https://github.com/spotify/docker-kafka).
Improvements:

* Oracle JDK over OpenJDK (heavily inspired from [cogniteev/docker-oracle-java](https://github.com/cogniteev/docker-oracle-java/blob/a1b3deccb941b0dba75eb81b4067fd69dee23994/oracle-java8/Dockerfile))
* Kafka/Zookeeper output is shown on `stdout`/`stderr` (see [veithen's blog](https://veithen.github.io/2015/01/08/supervisord-redirecting-stdout.html))
* Uses the bundled Zookeeper in Kafka, instead of the one in apt (smaller Docker image)
* The base image can now be easily changed (e.g. to alpine)
* Kafka logs are kept on a VOLUME, giving us better IO performance
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
