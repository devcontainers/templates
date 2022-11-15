
# Node.js & Mongo DB (javascript-node-mongo)

Develop applications in Node.js and Mongo DB. Includes Node.js, eslint, and yarn in a container linked to a Mongo DB.

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| imageVariant | Node.js version (use -bullseye variants on local arm64/Apple Silicon): | string | 16-bullseye |

## Using this template

This template creates two containers, one for Node.js and one for MongoDB. VS Code will attach to the Node.js container, and from within that container the MongoDB container will be available on on **`localhost`** port 27017 The MongoDB instance can be managed in VS Code via the automatically installed MongoDB extension. Database options can be configured in `.devcontainer/docker-compose.yml` and data is persisted in a volume called `mongo-data`.

It uses the `mcr.microsoft.com/devcontainers/javascript-node` image which includes `git`, `eslint`, `zsh`, [Oh My Zsh!](https://ohmyz.sh/), a non-root `vscode` user with `sudo` access, and a set of common dependencies for development.

You also can connect to MongoDB from an external tool when using VS Code by updating `.devcontainer/devcontainer.json` as follows:

```json
"forwardPorts": [ "27017" ]
```

### Adding another service

You can add other services to your `.devcontainer/docker-compose.yml` file [as described in Docker's documentaiton](https://docs.docker.com/compose/compose-file/#service-configuration-reference). However, if you want anything running in this service to be available in the container on localhost, or want to forward the service locally, be sure to add this line to the service config:

```yaml
# Runs the service on the same network as the database container, allows "forwardPorts" in devcontainer.json function.
network_mode: service:db
```

---

_Note: This file was auto-generated from the [devcontainer-template.json](https://github.com/devcontainers/templates/blob/main/src/javascript-node-mongo/devcontainer-template.json).  Add additional notes to a `NOTES.md`._
