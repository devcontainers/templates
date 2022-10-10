
# Go & PostgreSQL (go-postgres)

Use and develop Go + Postgres applications. Includes appropriate runtime args, Go, common tools, extensions, and dependencies.

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| imageVariant | Go version (use -bullseye variants on local arm64/Apple Silicon): | string | 1-bullseye |
| nodeVersion | Node.js version: | string | lts/* |

### Adding another service

You can add other services to your `.devcontainer/docker-compose.yml` file [as described in Docker's documentation](https://docs.docker.com/compose/compose-file/#service-configuration-reference). However, if you want anything running in this service to be available in the container on localhost, or want to forward the service locally, be sure to add this line to the service config:

```yaml
# Runs the service on the same network as the database container, allows "forwardPorts" in devcontainer.json function.
network_mode: service:[$SERVICENAME]
```

### Installing GO Dependencies

This template includes the popular [PostGres Driver Library for Go](github.com/lib/pq). This is the recommended driver for use with Go, as per [GoLang Documentation](https://golangdocs.com/golang-postgresql-example).

If you wish to change this, you may add additional `RUN` commands in the [Go Dockerfile](.devcontainer/Dockerfile). For example:

```yaml
# This line can be modified to add any needed additional packages
RUN go get -x <github-link-for-package>
```

---

_Note: This file was auto-generated from the [devcontainer-template.json](https://github.com/devcontainers/templates/blob/main/src/go-postgres/devcontainer-template.json).  Add additional notes to a `NOTES.md`._
