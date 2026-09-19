
# Python 3 (python)

Develop Python 3 applications.

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| imageVariant | Python version (use -trixie, -bookworm, or -bullseye variants on local arm64/Apple Silicon): | string | 3.13-trixie |

This template references an image that was [pre-built](https://containers.dev/implementors/reference/#prebuilding) to automatically include needed devcontainer.json metadata.

* **Image**: mcr.microsoft.com/devcontainers/python ([source](https://github.com/devcontainers/images/tree/main/src/python))
* **Applies devcontainer.json contents from image**: Yes ([source](https://github.com/devcontainers/images/blob/main/src/python/.devcontainer/devcontainer.json))

## Installing or updating Python utilities

This container installs all Python development utilities using [pipx](https://pipxproject.github.io/pipx/) to avoid impacting the global Python environment. You can use this same utility add additional utilities in an isolated environment. For example:

```bash
pipx install prospector
```

See the [pipx documentation](https://pipxproject.github.io/pipx/docs/) for additional information.



---

_Note: This file was auto-generated from the [devcontainer-template.json](https://github.com/devcontainers/templates/blob/main/src/python/devcontainer-template.json).  Add additional notes to a `NOTES.md`._

---

## 🐳 Using this Dev Container with Docker

This template can also be run manually using Docker, without VS Code.

### Option 1 — VS Code Dev Containers
1. Install [Docker](https://docs.docker.com/get-docker/).
2. Install [Visual Studio Code](https://code.visualstudio.com/).
3. Install the **Dev Containers** extension.
4. Open this folder in VS Code.
5. When prompted, select **"Reopen in Container"**.

VS Code will automatically:
- Pull the image `mcr.microsoft.com/devcontainers/python`
- Build the environment
- Install dependencies (if any) from `requirements.txt`

### Option 2 — Run via Docker CLI
You can also launch the container directly using Docker:
```bash
docker run -it -p 9000:9000 mcr.microsoft.com/devcontainers/python
