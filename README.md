![Atlassian Crowd](https://www.atlassian.com/dam/wac/legacy/crowd_logo_landing.png)

Crowd provices single sign-on and user identity that's easy to use.

Learn more about Crowd: <https://www.atlassian.com/software/crowd>

# Overview

This Docker container makes it easy to get an instance of Crowd up and running.

# Quick Start

For the `CROWD_HOME` directory that is used to store application data (amongst other things) we recommend mounting a host directory as a [data volume](https://docs.docker.com/engine/tutorials/dockervolumes/#/data-volumes), or via a named volume if using a docker version >= 1.9.

To get started you can use a data volume, or named volumes. In this example we'll use named volumes.

    $> docker volume create --name crowdVolume
    $> docker run -v crowdVolume:/var/atlassian/application-data/crowd --name="crowd" -d -p 8095:8095 dchevell/crowd


**Success**. Crowd is now available on [http://localhost:8095](http://localhost:8095)*

Please ensure your container has the necessary resources allocated to it. See [Supported Platforms](https://confluence.atlassian.com/crowd/supported-platforms-191851.html) for further information.


_* Note: If you are using `docker-machine` on Mac OS X, please use `open http://$(docker-machine ip default):8095` instead._

## Memory / Heap Size

If you need to override Crowd's default memory allocation, you can control the minimum heap (Xms) and maximum heap (Xmx) via the below environment variables.

* `JVM_MINIMUM_MEMORY` (default: 384m)

   The minimum heap size of the JVM

* `JVM_MAXIMUM_MEMORY` (default: 768m)

   The maximum heap size of the JVM

## Reverse Proxy Settings

If Crowd is run behind a reverse proxy server as [described here](https://confluence.atlassian.com/crowd031/integrating-crowd-with-apache-949753124.html), then you need to specify extra options to make Crowd aware of the setup. They can be controlled via the below environment variables.

* `CATALINA_CONNECTOR_PROXYNAME` (default: NONE)

   The reverse proxy's fully qualified hostname.

* `CATALINA_CONNECTOR_PROXYPORT` (default: NONE)

   The reverse proxy's port number via which Crowd is accessed.

* `CATALINA_CONNECTOR_SCHEME` (default: http)

   The protocol via which Crowd is accessed.

* `CATALINA_CONNECTOR_SECURE` (default: false)

   Set 'true' if CATALINA_CONNECTOR_SCHEME is 'https'.

## JVM configuration

If you need to pass additional JVM arguments to Crowd, such as specifying a custom trust store, you can add them via the below environment variable

* `JVM_SUPPORT_RECOMMENDED_ARGS`

   Additional JVM arguments for Crowd

Example:

    $> docker run -e JVM_SUPPORT_RECOMMENDED_ARGS=-Djavax.net.ssl.trustStore=/var/atlassian/application-data/crowd/cacerts -v crowdVolume:/var/atlassian/application-data/crowd --name="crowd" -d -p 8095:8095 dchevell/crowd

# Upgrade

To upgrade to a more recent version of Crowd you can simply stop the `crowd` container and start a new one based on a more recent image:

    $> docker stop crowd
    $> docker rm crowd
    $> docker run ... (See above)

As your data is stored in the data volume directory on the host it will still  be available after the upgrade.

_Note: Please make sure that you **don't** accidentally remove the `crowd` container and its volumes using the `-v` option._

# Backup

For evaluations you can use the built-in database that will store its files in the Crowd home directory. In that case it is sufficient to create a backup archive of the docker volume.

If you're using an external database, you can configure Crowd to make a backup automatically each night. This will back up the current state, including the database to the `crowdVolume` docker volume, which can then be archived. Alternatively you can backup the database separately, and continue to create a backup archive of the docker volume to back up the Crowd Home directory.

Read more about data recovery and backups: [https://confluence.atlassian.com/crowd/backing-up-and-restoring-data-36470797.html](https://confluence.atlassian.com/crowd/backing-up-and-restoring-data-36470797.html)

# Versioning

The `latest` tag matches the most recent release of Atlassian Crowd. Thus `dchevell/crowd:latest` will use the newest version of Crowd available.

Alternatively you can use a specific major, major.minor, or major.minor.patch version of Crowd by using a version number tag:

* `dchevell/crowd:3`
* `dchevell/crowd:3.2`
* `dchevell/crowd:3.2.3`

All versions from 2.2.2+ are available

# Support

This Docker container is unsupported and is intended for illustration purposes only.
