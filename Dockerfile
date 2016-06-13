# Docker file to create Jenkins container.

FROM cgswong/java:orajre8

# Setup environment
ENV JENKINS_VERSION=1.653 \
    JENKINS_USER=jenkins \
    JENKINS_GROUP=jenkins \
    JENKINS_HOME=/opt/jenkins \
    JENKINS_VOL=/var/lib/jenkins \
    JENKINS_PLUGINS="credentials ssh-credentials ssh-agent ssh-slaves git-client git github github-api github-oauth ghprb scm-api postbuild-task greenballs"

# Install software
RUN \
    apk --update upgrade \
    && apk add 'su-exec>=0.2' \
    && mkdir -p $JENKINS_HOME $JENKINS_VOL/plugins $JAVA_BASE \
    && curl -sSL http://mirrors.jenkins-ci.org/war/${JENKINS_VERSION}/jenkins.war --output ${JENKINS_HOME}/jenkins.war \
    && addgroup ${JENKINS_GROUP} \
    && adduser -h ${JENKINS_HOME} -D -s /bin/bash -G ${JENKINS_GROUP} ${JENKINS_USER} \
    && chown -R ${JENKINS_USER}:${JENKINS_GROUP} ${JENKINS_HOME} ${JENKINS_VOL} \
    && for plugins in $JENKINS_PLUGINS; \
      do curl -sSL http://updates.jenkins-ci.org/latest/${plugins}.hpi --output $JENKINS_VOL/${plugins}.hpi; \
    done \
    && rm -rf /var/cache/*

# Listen for main web interface (8080/tcp) and attached slave agents (50000/tcp)
EXPOSE 8080 50000

# Expose volumes
VOLUME ["${JENKINS_VOL}"]

COPY entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["java", "-jar", "/opt/jenkins/jenkins.war"]
