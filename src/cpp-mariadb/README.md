
# C++ & MariaDB (cpp-mariadb)

Develop C++ applications on Linux. Includes Debian C++ build tools.

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| imageVariant | Debian / Ubuntu version (use Debian 11, Ubuntu 18.04/22.04 on local arm64/Apple Silicon): | string | debian-11 |
| reinstallCmakeVersionFromSource | Install CMake version different from what base image has already installed. | string | none |

### Using Vcpkg

This dev container and its associated image includes a clone of the [`Vcpkg`](https://github.com/microsoft/vcpkg) repo for library packages, and a bootstrapped instance of the [Vcpkg-tool](https://github.com/microsoft/vcpkg-tool) itself.

The minimum version of `cmake` required to install packages is higher than the version available in the main package repositories for Debian (<=11) and Ubuntu (<=21.10).  `Vcpkg` will download a compatible version of `cmake` for its own use if that is the case (on x86_64 architectures), however you can opt to reinstall a different version of `cmake` globally by replacing `${templateOption:reinstallCmakeVersionFromSource}` with version (say 3.21.5) in `.devcontainer/Dockerfile`. This will install `cmake` from its github releases.

Most additional library packages installed using Vcpkg will be downloaded from their [official distribution locations](https://github.com/microsoft/vcpkg#security). To configure Vcpkg in this container to access an alternate registry, more information can be found here: [Registries: Bring your own libraries to vcpkg](https://devblogs.microsoft.com/cppblog/registries-bring-your-own-libraries-to-vcpkg/).

To update the available library packages, pull the latest from the git repository using the following command in the terminal:

```sh
cd "${VCPKG_ROOT}"
git pull --ff-only
```

> Note: Please review the [Vcpkg license details](https://github.com/microsoft/vcpkg#license) to better understand its own license and additional license information pertaining to library packages and supported ports.

## Using the MariaDB Database

You can connect to MariaDB from an external tool when using VS Code by updating `.devcontainer/devcontainer.json` as follows:

```json
"forwardPorts": [ "3306" ]
```

Once the MariaDB container has port forwarding enabled, it will be accessible from the Host machine at `localhost:3306`. The [MariaDB Documentation](https://mariadb.com/docs/) has:

1. [An Installation Guide for MySQL](https://mariadb.com/kb/en/mysql-client/), a CLI tool to work with a MariaDB database.
2. [Tips on populating data](https://mariadb.com/kb/en/how-to-quickly-insert-data-into-mariadb/) in the database. 

If needed, you can use `postCreateCommand` to run commands after the container is created, by updating `.devcontainer/devcontainer.json` similar to what follows:

```json
"postCreateCommand": "g++ --version && git --version"
```

### Adding another service

You can add other services to your `docker-compose.yml` file [as described in Docker's documentation](https://docs.docker.com/compose/compose-file/#service-configuration-reference). However, if you want anything running in this service to be available in the container on localhost, or want to forward the service locally, be sure to add this line to the service config:

```yaml
# Runs the service on the same network as the database container, allows "forwardPorts" in devcontainer.json function.
network_mode: service:[$SERVICENAME]
```

### Debugging Security

To allow C++ based debuggers to run within the Docker Containers, the [docker-compose.yml](.devcontainer/docker-compose.yml) contains the following lines which can be uncommented::

```yaml
    security_opt:
      - seccomp:unconfined
    cap_add:
      - SYS_PTRACE
```

As these can create security vulnerabilities, it is advisable to not use this unless needed. This should only be used in a Debug or Dev container, not in Production.

---

_Note: This file was auto-generated from the [devcontainer-template.json](https://github.com/devcontainers/templates/blob/main/src/cpp-mariadb/devcontainer-template.json).  Add additional notes to a `NOTES.md`._
