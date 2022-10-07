### Adding another service

You can add other services to your `docker-compose.yml` file [as described in Docker's documentation](https://docs.docker.com/compose/compose-file/#service-configuration-reference). However, if you want anything running in this service to be available in the container on localhost, or want to forward the service locally, be sure to add this line to the service config:

```yaml
# Runs the service on the same network as the database container, allows "forwardPorts" in devcontainer.json function.
network_mode: service:[$SERVICE_NAME]
```

### Using Conda

This dev container and its associated anaconda image includes [the `conda` package manager](https://aka.ms/vscode-remote/conda/about). Additional packages installed using Conda will be downloaded from Anaconda or another repository if you configure one. To reconfigure Conda in this container to access an alternative repository, please see information on [configuring Conda channels here](https://aka.ms/vscode-remote/conda/channel-setup).

Access to the Anaconda repository is covered by the [Anaconda Terms of Service](https://aka.ms/vscode-remote/conda/terms), which may require some organizations to obtain a commercial license from Anaconda. **However**, when this dev container or its associated image is used with GitHub Codespaces or GitHub Actions, **all users are permitted** to use the Anaconda Repository through the service, including organizations normally required by Anaconda to obtain a paid license for commercial activities. Note that third-party packages may be licensed by their publishers in ways that impact your intellectual property, and are used at your own risk.

#### Installing a different version of Python

As covered in the [user FAQ](https://docs.anaconda.com/anaconda/user-guide/faq) for Anaconda, you can install different versions of Python than the one in this image by running the following from a terminal:

```bash
conda install python=3.6
```

Or in a Dockerfile:

```Dockerfile
RUN conda install -y python=3.6
```

### [Optional] Adding the contents of environment.yml to the image

For convenience, this template will automatically install dependencies from the `environment.yml` file in the parent folder when the container is built. You can change this behavior by altering this line in the `.devcontainer/Dockerfile`:

```Dockerfile
RUN if [ -f "/tmp/conda-tmp/environment.yml" ]; then /opt/conda/bin/conda env update -n base -f /tmp/conda-tmp/environment.yml; fi \
    && rm -rf /tmp/conda-tmp
```

## Running Jupyter notebooks

Use this container to run Jupyter notebooks.

1. Edit the `./.devcontainer/devcontainer.json` file and add `8888` in the `forwardPorts` array:

    ```json
    // Use 'forwardPorts' to make a list of ports inside the container available locally.
	"forwardPorts": [8888],
    ```
.
1. Edit the `./.devcontainer/devcontainer.json` file and add a `postStartCommand` command to start the Jupyter notebook web app after the container is created. Use nohup so it isn't killed when the command finishes. Logs will appear in `nohup.out`.

    ```json
	// Use 'postStartCommand' to run commands after the container is created.
	"postStartCommand": "nohup bash -c 'jupyter notebook --ip=0.0.0.0 --port=8888 --allow-root &'",
    ```

1. View the terminal output to see the correct URL including the access token:

    ```bash
     http://127.0.0.1:8888/?token=1234567
    ```

1. Open the URL in a browser. You can edit and run code from the web browser.

1. If you have the [Jupyter extension](https://marketplace.visualstudio.com/items?itemName=ms-toolsai.jupyter) installed, you can also edit and run code from VS Code. 