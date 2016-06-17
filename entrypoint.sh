#!/bin/sh

set -e

# set the DEBUG env variable to turn on debugging
[[ -n "$DEBUG" ]] && set -x

# default location
JENKINS_WAR=${JENKINS_WAR:-"${JENKINS_HOME}/jenkins-${JENKINS_VERSION}.war"}

if [ ! -f "$JENKINS_WAR" ]; then
	curl -sSL http://mirrors.jenkins-ci.org/war/${JENKINS_VERSION}/jenkins.war --output "$JENKINS_WAR"
fi

for plugins in ${JENKINS_PLUGINS}
do
	name="${JENKINS_HOME}/${plugins}.hpi"
	if [ ! -f "$name" ]; then
		curl -sSL http://updates.jenkins-ci.org/latest/${plugins}.hpi --output $name
	fi
done

# first arg is `-f` or `--some-option`
# or first arg is `something.conf`
if [ "${1#-}" != "$1" ]; then
	set -- java -jar "$JENKINS_WAR" "$@"
fi

if [ -n "$DOCKER_GID" -a "$(id -u)" = '0' ]; then
	existing_group="$(cat /etc/group | grep "${DOCKER_GID}" | awk -F: '{print $1}')"
	if [ -n "$existing_group" ]; then
		addgroup -S "${JENKINS_USER}" "${existing_group}"
	else
		addgroup -g "${DOCKER_GID}" docker
		addgroup -S "${JENKINS_USER}" docker
	fi
fi

# allow the container to be started with `--user`
if [ "$1" = 'java' -a "$(id -u)" = '0' ]; then
	chown -R ${JENKINS_USER}:${JENKINS_GROUP} ${JENKINS_HOME}
	exec su-exec ${JENKINS_USER} "$0" "$@"
fi

exec "$@"
