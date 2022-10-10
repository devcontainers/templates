
# Python 3 & PostgreSQL (postgres)

Develop applications with Python 3 and PostgreSQL. Includes a Python application container and PostgreSQL server.

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| imageVariant | Python version (use -bullseye variants on local arm64/Apple Silicon): | string | 3-bullseye |
| nodeVersion | Node.js version: | string | lts/* |

### Adding another service

You can add other services to your `docker-compose.yml` file [as described in Docker's documentation](https://docs.docker.com/compose/compose-file/#service-configuration-reference). However, if you want anything running in this service to be available in the container on localhost, or want to forward the service locally, be sure to add this line to the service config:

```yaml
# Runs the service on the same network as the database container, allows "forwardPorts" in devcontainer.json function.
network_mode: service:db
```

### Installing or updating Python utilities

This container installs all Python development utilities using [pipx](https://pipxproject.github.io/pipx/) to avoid impacting the global Python environment. You can use this same utility add additional utilities in an isolated environment. For example:

```bash
pipx install prospector
```

See the [pipx documentation](https://pipxproject.github.io/pipx/docs/) for additional information.

### Using the forwardPorts property

By default, frameworks like Flask only listens to localhost inside the container. As a result, we recommend using the `forwardPorts` property (available in v0.98.0+) to make these ports available locally.

```json
"forwardPorts": [5000]
```

The `ports` property in `docker-compose.yml` [publishes](https://docs.docker.com/config/containers/container-networking/#published-ports) rather than forwards the port, this will not work in a Codespace and applications need to listen to `*` or `0.0.0.0` for the application to be accessible externally. This conflicts with the defaults of some Python frameworks, but fortunately the `forwardPorts` property does not have this limitation.

### [Optional] Building your requirements into the container image

If your requirements rarely change, you can include the contents of `requirements.txt` in the container by adding the following to your `Dockerfile`:

```Dockerfile
COPY requirements.txt /tmp/pip-tmp/
RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
    && rm -rf /tmp/pip-tmp
```

Since `requirements.txt` is likely in the folder you opened rather than the `.devcontainer` folder, be sure to include `context: ..` under `build` in `docker-compose.yml`. This allows the Dockerfile to access everything in the opened folder instead of just the contents of the `.devcontainer` folder.

### [Optional] Allowing the non-root vscode user to pip install globally without sudo

You can opt into using the `vscode` non-root user in the container by adding `"remoteUser": "vscode"` to `devcontainer.json`. However, by default, this you will need to use `sudo` to perform global pip installs.

```bash
sudo pip install <your-package-here>
```

Or stick with user installs:

```bash
pip install --user <your-package-here>
```

If you prefer, you can add the following to your `Dockerfile` to cause global installs to go into a different folder that the `vscode` user can write to.

```Dockerfile
ENV PIP_TARGET=/usr/local/pip-global
ENV PYTHONPATH=${PIP_TARGET}:${PYTHONPATH}
ENV PATH=${PIP_TARGET}/bin:${PATH}
RUN if ! cat /etc/group | grep -e "^pip-global:" > /dev/null 2>&1; then groupadd -r pip-global; fi \
    && usermod -a -G pip-global vscode \
    && umask 0002 && mkdir -p ${PIP_TARGET} \
    && chown :pip-global ${PIP_TARGET} \
    && ( [ ! -f "/etc/profile.d/00-restore-env.sh" ] || sed -i -e "s/export PATH=/export PATH=\/usr\/local\/pip-global:/" /etc/profile.d/00-restore-env.sh )
```

---

_Note: This file was auto-generated from the [devcontainer-template.json](https://github.com/devcontainers/templates/blob/main/src/postgres/devcontainer-template.json).  Add additional notes to a `NOTES.md`._
