## Using this template

This template creates a Fedora-based development container. Fedora provides cutting-edge packages and is the upstream source for Red Hat Enterprise Linux.

### Fedora Version Options

| Version | Description |
|---------|-------------|
| `43` | Fedora 43 (current stable, October 2025) |
| `42` | Fedora 42 (previous stable) |
| `41` | Fedora 41 (extended support) |
| `latest` | Latest stable Fedora release |
| `rawhide` | Development/unstable version |

### Using with Podman

This template works well with Podman as the container engine. To configure VS Code to use Podman:

```json
{
    "dev.containers.dockerPath": "podman"
}
```

### Adding Development Tools

You can add language-specific tools using [Dev Container Features](https://containers.dev/features). For example, to add Python:

```json
"features": {
    "ghcr.io/devcontainers/features/python:1": {}
}
```

Or install packages directly using `dnf`:

```json
"postCreateCommand": "sudo dnf install -y nodejs golang rust"
```

### Multi-Architecture Support

Fedora images are available for both `x86_64` and `aarch64` (ARM64/Apple Silicon).

