# Improved Docker Jenkins Image based on Alpine

Improved version of https://github.com/cgswong/docker-jenkins
Docs copied over from origin:

## Docs

# Jenkins Docker image

The [Jenkins Continuous Integration and Delivery server](http://jenkins-ci.org/) based on Alpine Linux image with Oracle JDK 8.

<img src="http://jenkins-ci.org/sites/default/files/jenkins_logo.png"/>

# Usage
Simple invocation:

```console
docker run -d --publish 8080:8080 cgswong/jenkins
```

The volume `/var/lib/jenkins` stores plugins, data and configuration. This can be mounted for further customization and/or data backup.
You will probably want to make that a persistent volume (recommended):

## Backing up data
Treat the `/var/lib/jenkins` directory as you would a database, i.e. make sure you do backups to keep your important data safe. You can use `docker cp $PWD:/var/lib/jenkins` to extract the data.

# Attaching build executors
You can run builds on the master (out of the box) but if you want to attach build slave servers: make sure you map the port `--publish 50000:50000` which will be used when you connect a slave agent. A good example Docker build container is [Maestrodev](https://registry.hub.docker.com/u/maestrodev/build-agent), it has lots of good tools installed.

# Passing parameters
You might need to customize the JVM running Jenkins, typically to pass system properties or tweak heap memory settings. Just pass these as parameters on the command line per normal:

```console
docker run --name jenkins --publish 8080:8080 cgswong/jenkins -Dhudson.footerURL=http://mycompany.com
```

The same goes for passing Jenkins launcher parameters:

```console
docker run --name jenkins --publish 8080:8080 cgswong/jenkins --version
```

This will dump Jenkins version, just like when you run Jenkins as an executable war.

# Plugins
This image comes with the following useful plugins installed:

- greenballs
- credentials
- ssh-credentials
- ssh-agent
- git-client
- git
- github
- github-api
- ghprb
- github-oauth
- scm-api
- postbuild-task
