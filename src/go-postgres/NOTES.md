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