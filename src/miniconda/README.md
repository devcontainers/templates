
# Miniconda (Python 3) (miniconda)

Develop Miniconda applications in Python 3. Installs dependencies from your environment.yml file and the Python extension.



This template references an image that was [pre-built](https://containers.dev/implementors/reference/#prebuilding) to automatically include needed devcontainer.json metadata.

* **Image**: mcr.microsoft.com/devcontainers/miniconda ([source](https://github.com/devcontainers/images/tree/main/src/miniconda))
* **Applies devcontainer.json contents from image**: Yes ([source](https://github.com/devcontainers/images/blob/main/src/miniconda/.devcontainer/devcontainer.json))

### Using Conda
This dev container and its associated image includes [the `conda` package manager](https://aka.ms/vscode-remote/conda/about). Additional packages installed using Conda will be downloaded from Anaconda or another repository if you configure one. To reconfigure Conda in this container to access an alternative repository, please see information on [configuring Conda channels here](https://aka.ms/vscode-remote/conda/channel-setup).

Access to the Anaconda repository is covered by the [Anaconda Terms of Service](https://aka.ms/vscode-remote/conda/terms), which may require some organizations to obtain a commercial license from Anaconda. **However**, when this dev container or its associated image is used with GitHub Codespaces or GitHub Actions, **all users are permitted** to use the Anaconda Repository through the service, including organizations normally required by Anaconda to obtain a paid license for commercial activities. Note that third-party packages may be licensed by their publishers in ways that impact your intellectual property, and are used at your own risk.

#### Installing or updating Python utilities

This container installs all Python development utilities using [pipx](https://pipxproject.github.io/pipx/) to avoid impacting the global Python environment. You can use this same utility add additional utilities in an isolated environment. For example:

```bash
pipx install prospector
```

Note that if you change the version of Python from the default, you'll need to run a few commands to update the utilities and `pipx`. More on that next.

#### Installing a different version of Python

As covered in the [user FAQ](https://docs.anaconda.com/anaconda/user-guide/faq) for Anaconda, you can install different versions of Python than the one in this image by running the following from a terminal:

```bash
conda install python=3.6
pip install --no-cache-dir pipx
pipx uninstall pipx
pipx reinstall-all
```

Or in a Dockerfile:

```Dockerfile
RUN conda install -y python=3.6 \
    && pip install --no-cache-dir pipx \
    && pipx uninstall pipx \
    && pipx reinstall-all
```

See the [pipx documentation](https://pipxproject.github.io/pipx/docs/) for additional information.

### [Optional] Adding the contents of environment.yml to the image

For convenience, this definition will automatically install dependencies from the `environment.yml` file in the parent folder when the container is built. You can change this behavior by altering this line in the `.devcontainer/Dockerfile`:

```Dockerfile
RUN if [ -f "/tmp/conda-tmp/environment.yml" ]; then /opt/conda/bin/conda env update -n base -f /tmp/conda-tmp/environment.yml; fi \
    && rm -rf /tmp/conda-tmp
```


---

_Note: This file was auto-generated from the [devcontainer-template.json](https://github.com/devcontainers/templates/blob/main/src/miniconda/devcontainer-template.json).  Add additional notes to a `NOTES.md`._
