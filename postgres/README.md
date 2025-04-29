# postgres

PostgreSQL, often simply "Postgres", is an object-relational database management
system (ORDBMS) with an emphasis on extensibility and standards-compliance. As a
database server, its primary function is to store data, securely and supporting
best practices, and retrieve it later, as requested by other software
applications, be it those on the same computer or those running on another
computer across a network (including the Internet). It can handle workloads
ranging from small single-machine applications to large Internet-facing
applications with many concurrent users. Recent versions also provide
replication of the database itself for security and scalability.

PostgreSQL implements the majority of the SQL:2011 standard, is ACID-compliant
and transactional (including most DDL statements) avoiding locking issues using
multiversion concurrency control (MVCC), provides immunity to dirty reads and
full serializability; handles complex SQL queries using many indexing methods
that are not available in other databases; has updateable views and materialized
views, triggers, foreign keys; supports functions and stored procedures, and
other expandability, and has a large number of extensions written by third
parties. In addition to the possibility of working with the major proprietary
and open source databases, PostgreSQL supports migration from them, by its
extensive standard SQL support and available migration tools. And if proprietary
extensions had been used, by its extensibility that can emulate many through
some built-in and third-party open source compatibility extensions, such as for
Oracle.

This image packages releases from https://github.com/docker-library/postgres

Image source: https://github.com/boxcutter/oci/tree/main/postgres

## Basic operation through port forwarding to host

Start an instance

```
docker container run \
  --detach \
  --name db \
  --publish 5432:5432 \
  --env POSTGRES_USER=postgres \
  --env POSTGRES_PASSWORD=superseekret \
  docker.io/boxcutter/postgres:15-noble
```

Create an example database

```
docker container run \
  --interactive --tty \
  --env PGPASSWORD=superseekret \
  docker.io/boxcutter/postgres:15-noble psql -h host.docker.internal -p 5432 -U postgres
psql (15.7 (Ubuntu 15.7-1.pgdg24.04+1))
Type "help" for help.


postgres=# CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    hire_date DATE
);
postgres=# INSERT INTO employees (first_name, last_name, email, hire_date)
VALUES
('John', 'Doe', 'john.doe@example.com', '2023-01-15'),
('Jane', 'Smith', 'jane.smith@example.com', '2023-02-20'),
('Alice', 'Johnson', 'alice.johnson@example.com', '2023-03-10'),
('Bob', 'Brown', 'bob.brown@example.com', '2023-04-05');
postgres=# select * from employees;
 id | first_name | last_name |           email           | hire_date
----+------------+-----------+---------------------------+------------
    1 | John       | Doe       | john.doe@example.com      | 2023-01-15
    2 | Jane       | Smith     | jane.smith@example.com    | 2023-02-20
    3 | Alice      | Johnson   | alice.johnson@example.com | 2023-03-10
    4 | Bob        | Brown     | bob.brown@example.com     | 2023-04-05
(4 rows)

postgres=# \q
```

Stopping container

```
$ docker container stop db
# This will remove data
$ docker container rm db
```

## Basic operation through user defined bridge networking

Create a user defined bridge network

```
$ docker network create database-network
$ docker network ls
NETWORK ID     NAME               DRIVER    SCOPE
52101a1b9849   bridge             bridge    local
05d8de6c671c   database-network   bridge    local
6a3c6e764f31   host               host      local
b343fc5c797c   none               null      local
```

Start an instance on the database network

```
docker container run \
    --detach \
    --name db \
    --network database-network \
    --publish 5432:5432 \
    --env POSTGRES_USER=postgres \
    --env POSTGRES_PASSWORD=superseekret \
    docker.io/boxcutter/postgres:15-noble
```

You'll see the container added to the network in
`docker network inspect database-network`.

```
"Containers": {
    "3ac279eeed5eac25df31113171d6944d67c81a6e871bdc3e7aa0cba1069f70ba": {
        "Name": "db",
        ....
    }
},
 ``

Create an example database

You can refer to the main container by name:

```
docker container run \
    --interactive --tty \
    --network database-network \
    --env PGPASSWORD=superseekret \
    docker.io/boxcutter/postgres:15-noble psql -h db -p 5432 -U postgres
psql (15.7 (Ubuntu 15.7-1.pgdg24.04+1))
Type "help" for help.

postgres=# \q
```

## Persisting data

The `Containerfile` contains this line declaring a volume:

```
VOLUME /var/lib/postgresql/data
```

```
docker volume create pgdata

docker container run \
    --detach \
    --name db \
    --publish 5432:5432 \
    --env POSTGRES_USER=postgres \
    --env POSTGRES_PASSWORD=superseekret \
    --mount source=pgdata,target=/var/lib/postgresql/data \
    docker.io/boxcutter/postgres:15-noble
```

0123456789001234567890012345678900123456789001234567890012345678900123456789001234567890
Use `docker inspect db` to verify that Docker created the volume and it mounted
correctly. Look in the `Mounts` section:

```
"Mounts": [
            {
                "Type": "volume",
                "Name": "pgdata",
                "Source": "/var/lib/docker/volumes/pgdata/_data",
                "Destination": "/var/lib/postgresql/data",
                "Driver": "local",
                "Mode": "z",
                "RW": true,
                "Propagation": ""
            }
        ],
```

You can mount the volume on a ubuntu container and use `ls` to see the content
of your volume.

```
docker run -it --rm \
  --mount source=pgdata,target=/var/lib/postgresql/data \
  docker.io/ubuntu ls /var/lib/postgresql/data
```

```
$ docker container stop db
$ docker container rm db
$ docker volume rm pgdata
```
