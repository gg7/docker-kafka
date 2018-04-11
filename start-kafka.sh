#!/bin/bash

set -o errexit
set -o nounset

server_properties_file="$KAFKA_HOME/config/server.properties"

# ensure there's a trailing newline
echo >> "$server_properties_file"

set_setting() {
	name=$1
	value=$2

	sed -r -i "s/^[#\\s]*($name)[\\s]*=.*/\\1=$value/" "$server_properties_file"
	if grep -Pq "^$name=$value\$" "$server_properties_file"; then
		echo "$name: updated to '$value'"
	else
		echo "$name=$value" >> "$server_properties_file";
		echo "$name: added and set to '$value'"
	fi
}

env | grep -Po '(?<=^KAFKA_CONFIG_).*' | while IFS='=' read -r name value; do
  set_setting "$(echo "${name//_/.}" | tr '[:upper:]' '[:lower:]')" "$value"
done

# reasonable default setting
set_setting "auto.create.topics.enable" "true"

exec "$KAFKA_HOME/bin/kafka-server-start.sh" "$KAFKA_HOME/config/server.properties"
