## Using this template

This template enables running containers inside a dev container using Podman. It's a daemonless alternative to Docker-in-Docker, ideal for container development and CI/CD workflows.

### What's Included

- **Podman**: Daemonless container engine, Docker CLI compatible
- **Buildah** (optional): Build OCI container images without a daemon
- **Skopeo** (optional): Inspect and copy container images
- **fuse-overlayfs**: Overlay filesystem for rootless containers
- **slirp4netns**: User-mode networking for rootless containers

### Podman Version Options

| Input | Actual Tag | Description |
|-------|------------|-------------|
| `latest` | `latest` | Latest Podman image (default) |
| `5.7.1` | `v5.7.1` | Podman 5.7.1 (full version) |
| `5.7` | `v5.7` | Podman 5.7.x (minor version) |
| `5` | `v5` | Podman 5.x (major version) |
| `v5.7.1` | `v5.7.1` | Podman 5.7.1 (with 'v' prefix) |

All variants use the [official Podman image](https://quay.io/repository/podman/stable) from `quay.io/podman/stable` with the specified tag format:
- `latest` maps to `quay.io/podman/stable:latest`
- Version tags use the `v` prefix format: `quay.io/podman/stable:v5.7.1`, `v5.7`, `v5`, etc.
- The `v` prefix is optional in input and will be added automatically if missing
- You can use any available version tag from the repository

### How It Works

The template configures a privileged container that can run nested containers:

1. **Privileged mode**: `--privileged` flag allows nested container operations
2. **SELinux disabled**: `--security-opt label=disable` for compatibility
3. **Persistent storage**: Volume mounted at `/var/lib/containers`
4. **Rootless config**: Configured for non-root container operations

### Example Usage

```bash
# Run a container
podman run --rm alpine echo "Hello from nested container!"

# Build an image
podman build -t myapp .

# Use Docker commands (via podman-docker)
docker ps
docker build -t myapp .
```

### Using Buildah

```bash
# Build from Containerfile
buildah bud -t myapp .

# Interactive build
container=$(buildah from fedora)
buildah run $container dnf install -y httpd
buildah commit $container myapp
```

### Using Skopeo

```bash
# Inspect remote image
skopeo inspect docker://docker.io/library/alpine:latest

# Copy image between registries
skopeo copy docker://source/image docker://dest/image
```

### Troubleshooting

**Permission denied errors:**
Ensure the container is running with `--privileged`. The devcontainer.json should include:
```json
"runArgs": ["--privileged", "--security-opt", "label=disable"]
```

**Storage issues:**
The template uses a named volume for `/var/lib/containers`. To reset:
```bash
podman volume rm devcontainer-podman-var-lib-<id>
```

### Related Resources

- [Podman Documentation](https://docs.podman.io/)
- [Official Podman Image](https://quay.io/repository/podman/stable)
- [Buildah Documentation](https://buildah.io/)
- [Podman in Podman](https://www.redhat.com/sysadmin/podman-inside-container)
