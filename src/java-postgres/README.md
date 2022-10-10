
# Java & PostgreSQL (java-postgres)

Develop applications with Java and PostgreSQL. Includes a Java application container and PostgreSQL server.

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| imageVariant | Java version (use -bullseye variants on local arm64/Apple Silicon): | string | 17-bullseye |
| installMaven | Install Maven, a management tool for Java | boolean | false |
| installGradle | Install Gradle, a build automation tool for multi-language software development | boolean | false |
| nodeVersion | Node.js version: | string | lts/* |

## Using this template

This template creates two containers, one for Java and one for PostgreSQL. VS Code will attach to the Java container, and from within that container the PostgreSQL container will be available on **`localhost`** port 5432. The default database is named `postgres` with a user of `postgres` whose password is `postgres`, and if desired this may be changed in `.devcontainer/docker-compose.yml`. Data is stored in a volume named `postgres-data`.

While the template itself works unmodified, it uses the `mcr.microsoft.com/devcontainers/java` image which includes `git`, a non-root `vscode` user with `sudo` access, and a set of common dependencies and Java tools for development.

You also can connect to PostgreSQL from an external tool when using VS Code by updating `.devcontainer/devcontainer.json` as follows:

```json
"forwardPorts": [ "5432" ]
```

Once the PostgreSQL container has port forwarding enabled, it will be accessible from the Host machine at `localhost:5432`. The [PostgreSQL Documentation](https://www.postgresql.org/docs/14/index.html) has:

1. [An Installation Guide for PSQL](https://www.postgresql.org/docs/14/installation.html) a CLI tool to work with a PostgreSQL database.
2. [Tips on populating data](https://www.postgresql.org/docs/14/populate.html) in the database. 

If needed, you can use `postCreateCommand` to run commands after the container is created, by updating `.devcontainer/devcontainer.json` similar to what follows:

```json
"postCreateCommand": "java -version && git --version && node --version"
```

### Adding another service

You can add other services to your `.devcontainer/docker-compose.yml` file [as described in Docker's documentation](https://docs.docker.com/compose/compose-file/#service-configuration-reference). However, if you want anything running in this service to be available in the container on localhost, or want to forward the service locally, be sure to add this line to the service config:

```yaml
# Runs the service on the same network as the database container, allows "forwardPorts" in devcontainer.json function.
network_mode: service:db
```

---

_Note: This file was auto-generated from the [devcontainer-template.json](https://github.com/devcontainers/templates/blob/main/src/java-postgres/devcontainer-template.json).  Add additional notes to a `NOTES.md`._
