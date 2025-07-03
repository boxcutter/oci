# valkey

This image builds source from https://github.com/valkey-io/valkey

## How to use this image

### start a valkey instance

```
docker run --name some-valkey --detach docker.io/boxcutter/valkey:8.1-noble
```

### start with persistent storage

```
docker run \
  --name some-valkey
  --detach \
  docker.io/boxcutter/valkey:8.1-noble valkey-server --save 60 1 --loglevel warning
```

There are several different persistence strategies to choose from. This one
will save a snapshot of the DB every 60 seconds if at least 1 write operation
was performed (it will also lead to more logs, so the `loglevel` option may be
desirable). If persistence is enabled, data is stored in the `VOLUME /data`,
which can be used with `--volumes-from some-volume-container` or
`-v /docker/host/dir:/data` (see [docs.docker volumes](https://docs.docker.com/storage/volumes/)).

For more about Redis Persistence, see [http://redis.io/topics/persistence](http://redis.io/topics/persistence)..
