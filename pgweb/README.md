# pgweb

## Overview

Pgweb is a web-based database explorer for PostgreSQL, written in Go, and works on Mac, Linux and Windows machines. Distributed as a simple binary with zero dependencies. Very easy to use and packs just the right amount of features.

## Usage

Start server:

```
pgweb
```

You can also provide connection flags:

```
pgweb --host localhost --user myuser --db mydb
```

Connection URL scheme is also supported:

```
pgweb --url postgres://user:password@host:port/database?sslmode=[mode]
pgweb --url "postgres:///database?host=/absolute/path/to/unix/socket/dir"
```
