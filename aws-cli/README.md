# aws-cli

Command-line interface v2 for Amazon Web Services

Source location: https://github.com/boxcutter/oci/tree/main/aws-cli

Based on https://github.com/aws/aws-cli/blob/v2/docker/Dockerfile

Installing past releases of the AWS CLI version 2:
- https://docs.aws.amazon.com/cli/latest/userguide/getting-started-version.html
- https://github.com/aws/aws-cli/blob/v2/CHANGELOG.rst

## Getting started with the command-line interface

Obtain an AWS Access Key and Secret Key.

It's probably easiest to share credentials and configuration from host system
to the container. Configure

```
docker run -it --rm \
  --mount type=bind,source="$HOME/.aws",target=/root/.aws \
  docker.io/boxcutter/aws-cli configure --profile default
AWS Access Key ID [None]: ABC123
AWS Secret Access Key [None]: superseekret
Default region name [None]: us-east-1
Default output format [None]:
```

You can test that the credentials are valid by using the `aws s3 ls` command:

```
docker run --rm \
  --mount type=bind,source="$HOME/.aws",target=/root/.aws,readonly \
  docker.io/boxcutter/aws-cli s3 ls --profile default
```