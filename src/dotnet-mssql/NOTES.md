This template references an image that was [pre-built](https://containers.dev/implementors/reference/#prebuilding) to automatically include needed devcontainer.json metadata.

* **Image**: mcr.microsoft.com/devcontainers/dotnet ([source](https://github.com/devcontainers/images/tree/main/src/dotnet))
* **Applies devcontainer.json contents from image**: Yes ([source](https://github.com/devcontainers/images/blob/main/src/dotnet/.devcontainer/devcontainer.json))

## Using this template

This template creates two containers, one for C# (.NET) and one for Microsoft SQL Server. You will be connected to the Ubuntu or Debian container, and from within that container the MS SQL container will be available on **`localhost`** port 1433. The .NET container also includes supporting scripts in the `.devcontainer/mssql` folder used to configure the database. 

The MS SQL container is deployed from the latest developer edition of Microsoft SQL 2019. The database(s) are made available directly in the Codespace/VS Code through the MSSQL extension with a connection labeled "mssql-container".  The default `sa` user password is set to `P@ssw0rd`. The default SQL port is mapped to port `1433` in `.devcontainer/docker-compose.yml`.

#### Changing the sa password

To change the `sa` user password, change the value in `.devcontainer/docker-compose.yml` and `.devcontainer/devcontainer.json`.

#### Database deployment

By default, a blank user database is created titled "ApplicationDB".  To add additional database objects or data through T-SQL during Codespace configuration, edit the file `.devcontainer/mssql/setup.sql` or place additional `.sql` files in the `.devcontainer/mssql/` folder. *Large numbers of scripts may take a few minutes following container creation to complete, even when the SQL server is available the database(s) may not be available yet.*

Alternatively, .dacpac files placed in the `./bin/Debug` folder will be published as databases in the container during Codespace configuration. [SqlPackage](https://docs.microsoft.com/sql/tools/sqlpackage) is used to deploy a database schema from a data-tier application file (dacpac), allowing you to bring your application's database structures into the dev container easily. *The publish process may take a few minutes following container creation to complete, even when the server is available the database(s) may not be available yet.*

### Adding another service

You can add other services to your `.devcontainer/docker-compose.yml` file [as described in Docker's documentation](https://docs.docker.com/compose/compose-file/#service-configuration-reference). However, if you want anything running in this service to be available in the container on localhost, or want to forward the service locally, be sure to add this line to the service config:

```yaml
# Runs the service on the same network as the database container, allows "forwardPorts" in devcontainer.json function.
network_mode: service:db
```

### Enabling HTTPS in ASP.NET using your own dev certificate

To enable HTTPS in ASP.NET, you can export a copy of your local dev certificate.

1. Export it using the following command:

    **Windows PowerShell**

    ```powershell
    dotnet dev-certs https --trust; dotnet dev-certs https -ep "$env:USERPROFILE/.aspnet/https/aspnetapp.pfx" -p "SecurePwdGoesHere"
    ```

    **macOS/Linux terminal**

    ```powershell
    dotnet dev-certs https --trust; dotnet dev-certs https -ep "${HOME}/.aspnet/https/aspnetapp.pfx" -p "SecurePwdGoesHere"
    ```

2. Add the following in to `.devcontainer/devcontainer.json`:

    ```json
    "remoteEnv": {
        "ASPNETCORE_Kestrel__Certificates__Default__Password": "SecurePwdGoesHere",
        "ASPNETCORE_Kestrel__Certificates__Default__Path": "${containerEnv:HOME}/.aspnet/https/aspnetapp.pfx",
    },
    "portsAttributs": {
        "5001": {
            "protocol": "https"
        }
    }
    ```
    ...where `5001` is the HTTPS port.

3. Finally, make the certificate available in the container as follows:

    1. Start the Dev Container
    2. Copy `.aspnet/https/aspnetapp.pfx` from your local home (`/home/yournamehere`) or user profile (`C:\Users\yournamehere`) folder into your Dev Container. For example, you can drag the file into the root of the File Explorer when using VS Code.
    3. Move the file to the correct place in the container. For example, in VS Code start a terminal and run:
        ```bash
        mkdir -p $HOME/.aspnet/https && mv aspnetapp.pfx $HOME/.aspnet/https
        ```

### Using the forwardPorts property

By default, web frameworks and tools often only listen to localhost inside the container. As a result, we recommend using the `forwardPorts` property to make these ports available locally.

```json
"forwardPorts": [9000]
```

The `ports` property in `docker-compose.yml` [publishes](https://docs.docker.com/config/containers/container-networking/#published-ports) rather than forwards the port. This will not work in a cloud environment like Codespaces and applications need to listen to `*` or `0.0.0.0` for the application to be accessible externally. Fortunately the `forwardPorts` property does not have this limitation.
