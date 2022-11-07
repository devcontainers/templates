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