## Using this template

This template creates a development container based on Red Hat Universal Base Image (UBI). UBI provides a freely redistributable, RHEL-compatible base for enterprise development.

### What is UBI?

[Universal Base Image (UBI)](https://www.redhat.com/en/blog/introducing-red-hat-universal-base-image) is a freely redistributable subset of Red Hat Enterprise Linux that can be used as a base for containers without requiring a RHEL subscription.

### UBI Version Options

| Version | Based On | Support |
|---------|----------|---------|
| `10` | RHEL 10 | Current |
| `9` | RHEL 9 | Maintenance |
| `8` | RHEL 8 | Extended |

### UBI Variant Options

| Variant | Package Manager | Description |
|---------|-----------------|-------------|
| `ubi` | dnf | Standard UBI with full package set |
| `ubi-minimal` | microdnf | Reduced footprint, minimal packages |
| `ubi-init` | dnf | Includes systemd for services |

### Using with Podman

This template is optimized for use with Podman. Configure VS Code:

```json
{
    "dev.containers.dockerPath": "podman"
}
```

### Adding EPEL Packages

To access additional packages from EPEL (Extra Packages for Enterprise Linux):

```json
"postCreateCommand": "sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm && sudo dnf install -y <package>"
```

### Multi-Architecture Support

UBI images are available for multiple architectures:
- `x86_64` (amd64)
- `aarch64` (arm64/Apple Silicon)
- `s390x`
- `ppc64le`

### Official Documentation

- [Red Hat UBI Documentation](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/building_running_and_managing_containers/assembly_types-of-container-images_building-running-and-managing-containers)
- [UBI Images on Red Hat Container Catalog](https://catalog.redhat.com/software/containers/search?q=ubi)

