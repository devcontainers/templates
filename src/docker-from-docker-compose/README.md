
# Docker from Docker Compose (docker-from-docker-compose)

Access your host's Docker install from inside a container when using Docker Compose. Installs Docker extension in the container along with needed CLIs.

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| installZsh | Install ZSH? | boolean | true |
| upgradePackages | Upgrade OS packages? | boolean | false |
| dockerVersion | Select or enter a Docker/Moby CLI version. (Availability can vary by OS version.) | string | latest |
| moby | Install OSS Moby build instead of Docker CE | boolean | true |
| enableNonRootDocker | Enable non-root Docker access in container? | boolean | true |



---

_Note: This file was auto-generated from the [devcontainer-template.json](https://github.com/devcontainers/templates/blob/main/src/docker-from-docker-compose/devcontainer-template.json).  Add additional notes to a `NOTES.md`._
