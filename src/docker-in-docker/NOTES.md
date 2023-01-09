## Using this template

Dev containers can be useful for all types of applications including those that also deploy into a container based-environment. While you can directly build and run the application inside the dev container you create, you may also want to test it by deploying a built container image into your local Docker Desktop instance without affecting your dev container.

In many cases, the best approach to solve this problem is by bind mounting the docker socket, as demonstrated in [../docker-outside-of-docker](../docker-outside-of-docker). This template demonstrates an alternative technique called "Docker in Docker".

This template's approach creates pure "child" containers by hosting its own instance of the docker daemon inside this container.  This is compared to the forementioned "docker-_outside-of_-docker" method (sometimes called docker-outside-of-docker) that bind mounts the host's docker socket, creating "sibling" containers to the current container.

For this technique to work, the "Docker in Docker" Feature included in this template automatically forces the parent container to be run as `--privileged` and adds a `/usr/local/share/docker-init.sh` ENTRYPOINT script that, spawns the `dockerd` process.

The included `.devcontainer.json` can be altered to work with other Debian/Ubuntu-based container images such as `node` or `python`. For example, to use `mcr.microsoft.com/devcontainers/javascript-node`, update the `image` proprty as follows:

```json
"image": "mcr.microsoft.com/devcontainers/javascript-node:18"
```