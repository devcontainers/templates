
# C# (.NET) and PostgreSQL (Community) (dotnet-postgres)

Develop C# and .NET Core based applications. Includes all needed SDKs, extensions, dependencies and a PostgreSQL container for parallel database development. Adds an additional PostgreSQL container to the C# (.NET Core) container definition.

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| imageVariant | .NET version: | string | 7.0 |
| nodeVersion | Node.js version: | string | lts/* |

## Description

This template creates two containers, one for C# (.NET) and one for PostgreSQL. VS Code will attach to the .NET Core container, and from within that container the PostgreSQL container will be available on **`localhost`** port 5432. By default, the `postgre` user password is `postgre`. Default database parameters may be changed in `.devcontainer/docker-compose.yml` file if desired.

## PostgreSQL Configuration

A secondary container for PostgreSQL is defined in `.devcontainer/devcontainer.json` and `.devcontainer/docker-compose.yml` files. This container is deployed from the latest version available at the time of this commit. `latest` tag is avoided to prevent breaking bugs. The default `postgres` user password is set to `postgres`. The database instance uses the default port of `5432`.

### Changing the postgres user password
To change the `postgres` user password, change the value in `.devcontainer/docker-compose.yml` and `.devcontainer/devcontainer.json`.


---

_Note: This file was auto-generated from the [devcontainer-template.json](https://github.com/devcontainers/templates/blob/main/src/dotnet-postgres/devcontainer-template.json).  Add additional notes to a `NOTES.md`._
