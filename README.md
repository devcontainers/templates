# Development Container Templates

<table style="width: 100%; border-style: none;"><tr>
<td style="width: 140px; text-align: center;"><a href="https://github.com/devcontainers"><img width="128px" src="https://raw.githubusercontent.com/microsoft/fluentui-system-icons/78c9587b995299d5bfc007a0077773556ecb0994/assets/Cube/SVG/ic_fluent_cube_32_filled.svg" alt="devcontainers organization logo"/></a></td>
<td>
<strong>Development Container Templates</strong><br />
A simple set of dev container 'templates' to help get you up and running with a containerized environment.
</td>
</tr></table>


A **development container** is a running [Docker](https://www.docker.com) container with a well-defined tool/runtime stack and its prerequisites. It allows you to use a container as a full-featured development environment which can be used to run an application, to separate tools, libraries, or runtimes needed for working with a codebase, and to aid in continuous integration and testing.

This repository contains a set of **dev container templates** which are source files packaged together that encode configuration for a complete development environment. A 'template' can be used in a new or existing project, and a [supporting tool](https://containers.dev/supporting) will use the configuration from the Template to build a development container.

⚠️ Development container 'templates' are a
[**proposed**](https://github.com/devcontainers/spec/blob/main/proposals/devcontainer-templates.md) addition to the
[development container specification](https://containers.dev/implementors/spec/). **Please note that 'templates' are in
preview and subject to breaking changes**.

Once the [**proposed**](https://github.com/devcontainers/spec/blob/main/proposals/devcontainer-templates.md)
specification is accepted, implementation details will be published at
[https://containers.dev](https://containers.dev/).

## Contents
 
-   [`src`](src) - A collection of subfolders, each declaring a template. Each subfolder contains at least a
    `devcontainer-template.json` and a [devcontainer.json](https://containers.dev/implementors/json_reference/).
-   [`test`](test) - Mirroring `src`, a folder-per-template with at least a `test.sh` script. These tests are executed by the [CI](https://github.com/devcontainers/templates/blob/main/.github/workflows/test-pr.yaml).

## Contributions

### Creating your own collection of templates

The [template distribution specification](https://github.com/devcontainers/spec/blob/main/proposals/devcontainer-templates-distribution.md) outlines a pattern for community members and organizations to self-author templates in repositories they control.

[GitHub Action](https://github.com/devcontainers/action) is available to help bootstrap self-authored templates.

We are eager to hear your feedback on self-authoring!  Please provide comments and feedback on [spec issue #70](https://github.com/devcontainers/spec/issues/70).

### Contributing to this repository

This repository will accept improvement and bug fix contributions related to the
[current set of maintained templates](./src).

## Feedback

Issues related to these templates can be reported in [an issue](https://github.com/devcontainers/templates/issues) in this repository.

# License
Copyright (c) Microsoft Corporation. All rights reserved. <br />
Licensed under the MIT License. See [LICENSE](LICENSE).