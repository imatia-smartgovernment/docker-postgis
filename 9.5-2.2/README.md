# elcodedocle/docker-postgis

[![Build Status](https://travis-ci.org/elcodedocle/docker-postgis.svg)](https://travis-ci.org/elcodedocle/docker-postgis) [![Join the chat at https://gitter.im/elcodedocle/docker-postgis](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/elcodedocle/docker-postgis?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

The `elcodedocle/docker-postgis` image provides a Docker container running Postgres 9 with [PostGIS 2.2](http://postgis.net/) installed. This image is based on the official [`postgres`](https://registry.hub.docker.com/_/postgres/) image and provides variants for each version of Postgres 9 supported by the base image (9.1-9.5).

This image ensures that the default database created by the parent `postgres` image will have the `postgis` and `postgis_topology` extensions installed.  Unless `-e POSTGRES_DB` is passed to the container at startup time, this database will be named after the admin user (either `postgres` or the user specified with `-e POSTGRES_USER`). For Postgres 9.1+, the `fuzzystrmatch` and `postgis_tiger_geocoder` extensions are also installed.

If you would prefer to use the older template database mechanism for enabling PostGIS, the image also provides a PostGIS-enabled template database called `template_postgis`.

## Usage

In order to run a basic container capable of serving a PostGIS-enabled database, start a container as follows:

    docker run -p 25432:5432 --name elcodedocle-postgis -e POSTGRES_PASSWORD=mysecretpassword -d elcodedocle/docker-postgis

For more detailed instructions about how to start and control your Postgres container, see the documentation for the `postgres` image [here](https://registry.hub.docker.com/_/postgres/).

Once you have started a database container, you can then connect to the database on the docker host machine's port 25432 or locally on the docker container as follows:

    docker exec -it elcodedocle-postgis sh -c 'exec psql -h "$POSTGRES_PORT_5432_TCP_ADDR" -p "$POSTGRES_PORT_5432_TCP_PORT" -U postgres'

See [the PostGIS documentation](http://postgis.net/docs/postgis_installation.html#create_new_db_extensions) for more details on your options for creating and using a spatially-enabled database.
