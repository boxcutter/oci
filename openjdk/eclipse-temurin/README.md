# eclipse-temurin

Eclipse Temurin is the open source Java SE build from the Eclipse Adoptium project, based on OpenJDK.

This image packages releases from: https://github.com/adoptium/containers

Image source: https://github.com/boxcutter/oci/tree/main/openjdk/eclipse-temurin

## Tags

| Tag | Contents |
| --- | --- |
| `8-jdk`, `8-jdk-resolute`, `8u504-b01-jdk`, `8u504-b01-jdk-resolute` | Java 8 Development Kit |
| `8-jre`, `8-jre-resolute`, `8u504-b01-jre`, `8u504-b01-jre-resolute` | Java 8 Runtime Environment |

Use the JDK to compile code and the smaller JRE to run it.

## Using Eclipse Temurin

### Compiling and running a Java program

```
docker run -it --rm \
  --mount type=bind,source="$(pwd)",target="/usr/src/app" \
  --workdir /usr/src/app \
  docker.io/boxcutter/eclipse-temurin:8-jdk \
    bash -c "javac Main.java && java Main"
```

### Running a JAR

```
docker run -it --rm \
  --mount type=bind,source="$(pwd)",target="/usr/src/app" \
  --workdir /usr/src/app \
  docker.io/boxcutter/eclipse-temurin:8-jre \
    java -jar app.jar
```

## Adding CA certificates

Set `USE_SYSTEM_CA_CERTS=1` and mount your certificates (`*.crt` files) on
`/certificates`. On startup, the entrypoint adds them, along with the system CA
certificates, to the JVM truststore:

```
docker run -it --rm \
  --mount type=bind,source="$(pwd)/certs",target=/certificates \
  --env USE_SYSTEM_CA_CERTS=1 \
  docker.io/boxcutter/eclipse-temurin:8-jre \
    java -jar app.jar
```

When the container runs as root, the certificates are also added to the system
CA store so tools like `curl` and `wget` trust them.
