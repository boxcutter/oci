# cinc-auditor

Cinc Auditor is a free distribution of Chef InSpec built from the same
source. Cinc Auditor is 100% compatible with its upstream Chef Inspec
counterpart. Chef Inspec is an open-source framework for testing
infrastructure, applications and container images.

This image packages releases from https://cinc.sh/

# Using cinc-auditor

The two most commonly-used subcommands are `init` and `exec`

## init command

You can use the `init` command to create the boilerplate for a new test profile.

```bash
# Create an InSpec profile called 'example
% mkdir example && cd example
% docker container run --rm --interactive --tty \
    --mount type=bind,source="$(pwd)",target=/share \
    docker.io/boxcutter/cinc-auditor init profile example
```

## exec command

You can use the `exec` command to run an InSpec profile to test infrastructure.

In its general form, you bind mount the profile source into `/share` like so:

```bash
% cd <profile_dir>
% docker container run --rm --interactive --tty \
    --mount type=bind,source="$(pwd)",target=/share \
    docker.io/boxcutter/cinc-auditor exec .
```

The exit codes return test result status:
```
exit codes:
    0  normal exit, all tests passed
    1  usage or general error
    2  error in plugin system
    3  fatal deprecation encountered
  100  normal exit, at least one test failed
  101  normal exit, at least one test skipped but none failed
  172  chef license not accepted
```

The only issue with using the above is the test environment would be container,
which is usually not the environment in which you want to test. You will
typically use subcommands so that cinc-auditor will run the profile against
remote environments.

### Testing against a remote machine via ssh

```bash
docker container run --rm --interactive --tty \
  --mount type=bind,source="$(pwd)",target=/share \
  docker.io/boxcutter/cinc-auditor exec example \
    --key-files /path/keys/ssh.key \
    --target ssh://root@192.168.1.12
```

### Testing a container image

If you need to run an InSpec profile against a container image, make sure you
start the other image first, sitting at a shell prompt, detached. Then also bind 
mount `/var/run/docker.sock` so the docker tools in the container work when you
run cinc-auditor in a container:

```bash
# Easiest to save the container ID that is returned, as you'll need to destroy it.
# You could use a pre-defined name, but it should be unique so that it's possible to perform multiple cinc-auditor runs
# with the same image, so best to just use the returned container ID.
# We're using the nginx container image here as an example - you would typically use the name of some locally built image:
% CONTAINER_ID=$(docker container run --detach nginx)

# Verify the container is actually running with docker ps
% docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS     NAMES
dd6e9a9ce3df   nginx     "/docker-entrypoint.…"   14 seconds ago   Up 14 seconds   80/tcp    suspicious_shtern

# Run the inspec profile against the container ID - need to mount /var/run/docker.sock for the docker tools inside the
# container image to work
% docker container run --rm --interactive --tty \
  --env=CONTAINER_ID \
  --mount type=bind,source="$(pwd)",target=/share \
  --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock \
  docker.io/boxcutter/cinc-auditor exec . -t docker://${CONTAINER_ID}
  
# Stop the container under test - give a chance for PID 1 to clean up processes
% docker container stop ${CONTAINER_ID}
dd6e9a9ce3df1b6cf8164ed093da6fcd309d411f5a45ddcc2cbebb518de3ad40
# Fully clean up and remove the container image
% docker container rm ${CONTAINER_ID}
dd6e9a9ce3df1b6cf8164ed093da6fcd309d411f5a45ddcc2cbebb518de3ad40
```

# CLI

```bash
% docker container run -it --rm docker.io/boxcutter/cinc-auditor --help
Commands:
  cinc-auditor archive PATH                                  # archive a prof...
  cinc-auditor automate SUBCOMMAND or compliance SUBCOMMAND  # Cinc Dashboard...
  cinc-auditor check PATH                                    # verify all tes...
  cinc-auditor clear_cache                                   # clears the InS...
  cinc-auditor detect                                        # detect the tar...
  cinc-auditor env                                           # Output shell-a...
  cinc-auditor exec LOCATIONS                                # Run all tests ...
  cinc-auditor export PATH                                   # read the profi...
  cinc-auditor habitat SUBCOMMAND                            # Manage Habitat...
  cinc-auditor help [COMMAND]                                # Describe avail...
  cinc-auditor init SUBCOMMAND                               # Generate InSpe...
  cinc-auditor json PATH                                     # read all tests...
  cinc-auditor plugin SUBCOMMAND                             # Manage Cinc Au...
  cinc-auditor shell                                         # open an intera...
  cinc-auditor sign SUBCOMMAND                               # Manage Cinc Au...
  cinc-auditor supermarket SUBCOMMAND ...                    # Supermarket co...
  cinc-auditor vendor PATH                                   # Download all d...
  cinc-auditor version                                       # prints the ver...

Options:
  l, [--log-level=LOG_LEVEL]                         # Set the log level: info (default), debug, warn, error
      [--log-location=LOG_LOCATION]                  # Location to send diagnostic log messages to. (default: $stdout or Inspec::Log.error)
      [--diagnose], [--no-diagnose]                  # Show diagnostics (versions, configurations)
      [--color], [--no-color]                        # Use colors in output.
      [--interactive], [--no-interactive]            # Allow or disable user interaction
      [--disable-user-plugins]                       # Disable loading all plugins that the user installed.
      [--enable-telemetry], [--no-enable-telemetry]  # Allow or disable telemetry
      [--chef-license=CHEF_LICENSE]                  # Accept the license for this product and any contained products: accept, accept-no-persist, accept-silent


About Cinc Auditor:
  Patents: chef.io/patents
```
