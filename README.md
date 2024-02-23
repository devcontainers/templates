# Development Container Templates

<table style="width: 100%; border-style: none;"><tr>
<td style="width: 140px; text-align: center;"><a href="https://github.com/devcontainers"><img width="128px" src="https://raw.githubusercontent.com/microsoft/fluentui-system-icons/78c9587b995299d5bfc007a0077773556ecb0994/assets/Cube/SVG/ic_fluent_cube_32_filled.svg" alt="devcontainers organization logo"/></a></td>
<td>
<strong>Development Container Templates</strong><br />
A simple set of dev container 'templates' to help get you up and running with a containerized environment.
</td>
</tr></table>


A **development container** is a running [Docker](https://www.docker.com) container with a well-defined tool/runtime stack and its prerequisites. It allows you to use a container as a full-featured development environment which can be used to run an application, to separate tools, libraries, or runtimes needed for working with a codebase, and to aid in continuous integration and testing.

This repository contains a set of **Dev Container Templates** which are source files packaged together that encode configuration for a complete development environment. A Template can be used in a new or existing project, and a [supporting tool](https://containers.dev/supporting) will use the configuration from the template to build a development container.

## Contents
 
-   [`src`](src) - A collection of subfolders, each declaring a template. Each subfolder contains at least a
    `devcontainer-template.json` and a [devcontainer.json](https://containers.dev/implementors/json_reference/).
-   [`test`](test) - Mirroring `src`, a folder-per-template with at least a `test.sh` script. These tests are executed by the [CI](https://github.com/devcontainers/templates/blob/main/.github/workflows/test-pr.yaml).

## How to use the Templates?

### 1. Using Supporting tools

[Visual Studio Code](https://code.visualstudio.com/) and [GitHub Codespaces](https://docs.github.com/en/codespaces/overview) provide a user-friendly interface to configure the Templates hosted in this repository, as well as the [community-contributed Templates](https://containers.dev/templates). Additionally, you can customize your dev container with additional available [Features](https://containers.dev/features).

For more information, please refer to the following documents for [VS Code](https://code.visualstudio.com/docs/devcontainers/create-dev-container#_automate-dev-container-creation) and [Github Codespaces](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration/introduction-to-dev-containers#using-a-predefined-dev-container-configuration).

### 2. Using Dev Container CLI

The [@devcontainers/cli](https://containers.dev/supporting#devcontainer-cli) offers a `devcontainer templates apply` command to apply a Template hosted in the supported OCI registry.

```
devcontainer templates apply

Apply a template to the project

Options:
      --help              Show help                                                                            [boolean]
      --version           Show version number                                                                  [boolean]
  -w, --workspace-folder  Target workspace folder to apply Template                   [string] [required] [default: "."]
  -t, --template-id       Reference to a Template in a supported OCI registry                        [string] [required]
  -a, --template-args     Arguments to replace within the provided Template, provided as JSON   [string] [default: "{}"]
  -f, --features          Features to add to the provided Template, provided as JSON.           [string] [default: "[]"]
      --log-level         Log level.                               [choices: "info", "debug", "trace"] [default: "info"]
      --tmp-dir           Directory to use for temporary files. If not provided, the system default will be inferred.
                                                                                                                [string]
```

#### Example

```
devcontainer templates apply --workspace-folder . \
    --template-id ghcr.io/devcontainers/templates/cpp:latest \
    --template-args '{ "imageVariant": "debian-12" }' \
    --features '[{ "id": "ghcr.io/devcontainers/features/azure-cli:1", "options": { "version" : "1" } }]'
```

## Contributions

### Creating your own collection of templates

The [Dev Container Template specification](https://containers.dev/implementors/templates-distribution/#distribution) outlines a pattern for community members and organizations to self-author Templates in repositories they control.

A starter repository [devcontainers/template-starter](https://github.com/devcontainers/template-starter) and [GitHub Action](https://github.com/devcontainers/action) are available to help bootstrap self-authored Templates.

We are eager to hear your feedback on self-authoring!  Please provide comments and feedback on [spec issue #71](https://github.com/devcontainers/spec/issues/71).

### Contributing to this repository

This repository will accept improvement and bug fix contributions related to the
[current set of maintained templates](./src).

## Feedback

Issues related to these templates can be reported in [an issue](https://github.com/devcontainers/templates/issues) in this repository.

# License
Copyright (c) Microsoft Corporation. All rights reserved. <br />
Licensed under the MIT License. See [LICENSE](LICENSE).