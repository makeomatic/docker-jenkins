#!/bin/bash

set -eo pipefail

# first arg is `-f` or `--some-option`
# or first arg is `something.conf`
if [ "${1#-}" != "$1" ]; then
	set -- java -jar /opt/jenkins/jenkins.war "$@"
fi

# allow the container to be started with `--user`
if [ "$1" = 'java' -a "$(id -u)" = '0' ]; then
	chown -R $JENKINS_USER:$JENKINS_GROUP $JENKINS_VOL $JENKINS_HOME
	exec su-exec $JENKINS_USER "$0" "$@"
fi

exec "$@"
