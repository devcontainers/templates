## Description

Dev containers can be useful for all types of applications including those that also deploy into a container based-environment. While you can directly build and run the application inside the dev container you create, you may also want to test it by deploying a built container image into your local Docker Desktop instance without affecting your dev container.

In many cases, the best approach to solve this problem is by bind mounting the docker socket, as demonstrated in [/containers/docker-from-docker](../docker-from-docker). This template demonstrates an alternative technique called "Docker in Docker".

This template's approach creates pure "child" containers by hosting its own instance of the docker daemon inside this container.  This is compared to the forementioned "docker-_from_-docker" method (sometimes called docker-outside-of-docker) that bind mounts the host's docker socket, creating "sibling" containers to the current container.

Running "Docker in Docker" requires the parent container to be run as `--privileged`.  This template also adds a `/usr/local/share/docker-init.sh` ENTRYPOINT script that, spawns the `dockerd` process.