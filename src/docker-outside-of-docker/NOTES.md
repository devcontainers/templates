## Using this template

Dev containers can be useful for all types of applications including those that also deploy into a container based-environment. While you can directly build and run the application inside the dev container you create, you may also want to test it by deploying a built container image into your local Docker Desktop instance without affecting your dev container.

This example illustrates how you can do this by running CLI commands and using the [Docker VS Code extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker) right from inside your dev container. It installs the Docker extension inside the container so you can use its full feature set with your project.

The included `.devcontainer.json` can be altered to work with other Debian/Ubuntu-based container images such as `node` or `python`. For example, to use `mcr.microsoft.com/devcontainers/javascript-node`, update the `image` proprty as follows:

```json
"image": "mcr.microsoft.com/devcontainers/javascript-node:18"
```

## Using bind mounts when working with Docker inside the container

> **Note:** If you need to mount folders within the dev container into your own containers using docker-outside-of-docker, so you may find [Docker in Docker](../docker-in-docker) meets your needs better in some cases (despite a potential performance penalty).

In some cases, you may want to be able to mount the local workspace folder into a container you create while running from inside the dev container (e.g. using `-v` from the Docker CLI). The issue is that, with "Docker from Docker", containers are always created on the host. So, when you bind mount a folder into any container, you'll need to use the **host**'s paths.

In GitHub Codespaces, the workspace folder is **available in the same place on the host as it is in the container,** so you can bind workspace contents as you would normally.

However, for Dev Container for most Dev Container spec supporting tools, this is typically not the case. A simple way to work around this is to put `${localWorkspaceFolder}` in an environment variable that you then use when doing bind mounts inside the container.

Add the following to `.devcontainer.json`:

```json
"remoteEnv": { "LOCAL_WORKSPACE_FOLDER": "${localWorkspaceFolder}" }
```

Then reference the env var when running Docker commands from the terminal inside the container.

```bash
docker run -it --rm -v "${LOCAL_WORKSPACE_FOLDER//\\/\/}:/workspace" debian bash
```