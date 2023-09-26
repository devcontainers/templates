
# C# (.NET) (dotnet)

Develop C# and .NET based applications. Includes all needed SDKs, extensions, and dependencies.

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| imageVariant | .NET version: | string | 7.0 |

This template references an image that was [pre-built](https://containers.dev/implementors/reference/#prebuilding) to automatically include needed devcontainer.json metadata.

* **Image**: mcr.microsoft.com/devcontainers/dotnet ([source](https://github.com/devcontainers/images/tree/main/src/dotnet))
* **Applies devcontainer.json contents from image**: Yes ([source](https://github.com/devcontainers/images/blob/main/src/dotnet/.devcontainer/devcontainer.json))

## Enabling HTTPS in ASP.NET using your own dev certificate

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


---

_Note: This file was auto-generated from the [devcontainer-template.json](https://github.com/devcontainers/templates/blob/main/src/dotnet/devcontainer-template.json).  Add additional notes to a `NOTES.md`._
