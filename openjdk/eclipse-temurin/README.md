# eclipse-temurin

Eclipse Temurin is the open source Java SE build from the Eclipse Adoptium project, based on OpenJDK.

This image packages releases from: https://github.com/adoptium/containers

Image source: https://github.com/boxcutter/oci/tree/main/openjdk/eclipse-temurin

This is an unofficial repackaging of the unmodified Eclipse Temurin binaries
and is not produced, endorsed or supported by the Eclipse Adoptium project or
the Eclipse Foundation. The official images are at
https://hub.docker.com/_/eclipse-temurin, and more about Temurin is at
https://adoptium.net/.

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

## License

Eclipse Temurin is licensed under the GNU General Public License, version 2,
with the Classpath Exception. The license, the assembly exception, and the
notices for the bundled third-party code ship in the image under
`/opt/java/openjdk` (`LICENSE`, `ASSEMBLY_EXCEPTION`, `NOTICE` and
`THIRD_PARTY_README`).

The binaries in this image are built by Eclipse Adoptium from this source:

| Release | Source |
| --- | --- |
| `jdk8u504-b01` | https://github.com/adoptium/jdk8u/tree/jdk8u504-b01 |

The Containerfiles, entrypoints, bake files and tests in this repository are
licensed under the Apache License, Version 2.0.

## Trademarks

Eclipse Temurin is a trademark of the Eclipse Foundation. Eclipse and the
Eclipse logo are registered trademarks of the Eclipse Foundation. See the
[Eclipse Foundation Trademark Usage Policy](https://www.eclipse.org/legal/logo-guidelines/).

Java and all Java-based trademarks are trademarks of Oracle Corporation in
the United States, other countries, or both.
