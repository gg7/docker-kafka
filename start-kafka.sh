#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

set_setting() {
	name=$1
	value=$2
	file="$KAFKA_HOME/config/server.properties"

	sed -r -i "s/^[#\\s]*($name)[\\s]*=.*/\\1=$value/" "$file"
	if grep -Pq "^$name=$value\$" "$file"; then
		echo "$name: updated to '$value'"
	else
		echo "$name=$value" >> "$file";
		echo "$name: added and set to '$value'"
	fi
}

env | grep -Po '(?<=^KAFKA_CONFIG_).*' | while IFS='=' read -r name value; do
  set_setting "$(echo "${name//_/.}" | tr '[:upper:]' '[:lower:]')" "$value"
done

# reasonable default setting
set_setting "auto.create.topics.enable" "true"

exec "$KAFKA_HOME/bin/kafka-server-start.sh" "$KAFKA_HOME/config/server.properties"
