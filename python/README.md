# python

The Python programming language.

This image packages releases from https://github.com/docker-library/python

For best practices on using Python container images, refer to https://pythonspeed.com/docker/

## Using python

### Running the Python Read-Eval-Print Loop (REPL)

The Python interpreter is the default command running in this image. Typing an end-of-file character (`Control-D` on Linux, `Control-Z` on Windows) causes the interpreter to exit. You can also exit the interpret by typing in the command: `quit()`.

```
docker run -it --rm \
  docker.io/boxcutter/python:3.11-jammy
```

### Run a single Python script

For single file projects, you can run a Python script by using the container image directly:

```
docker run -it --rm \
  --mount type=bind,source="$(pwd)",target=/usr/src/myapp \
  --workdir /usr/src/myapp \
  docker.io/boxcutter/python:3.11-jammy python your-script.py
```

### Create a Containerfile in your Python app project

```
FROM docker.io/polymathrobotics/python:3.11-jammy

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "python", "./your-daemon-or-script.py" ]
```