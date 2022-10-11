
# Kubernetes - Local Configuration (kubernetes-helm)

Access a local (or remote) Kubernetes cluster from inside a dev container using your local config. Includes kubectl, Helm, and the Docker CLI.



## Description

> **Note:** If you would prefer to not set up Kubernetes locally, you may find the [Kubernetes - Minikube-in-Docker](../kubernetes-helm-minikube) definition more interesting.

Dev containers can be useful for all types of applications including those that also deploy into a container based-environment. While you can directly build and run the application inside the dev container you create, you may also want to test it by deploying a built container image into a local minikube or remote [Kubernetes](https://kubernetes.io/) cluster without affecting your dev container.

## A note on Minikube or otherwise using a local cluster

While this definition works with Minikube in most cases, if you hit trouble, make sure that your `~/.kube/config` file and Minikube certs reference your host's IP rather than `127.0.0.1` or `localhost` (since `localhost` resolve to the container itself rather than your local machine where Minikube is running).

This should happen by default on Linux. On macOS and Windows, we recommend using the Kuberntes install that comes with Docker Desktop instead of Minikube to avoid these kinds of issues.

## Ingress and port forwarding

When configuring [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) for your Kubernetes cluster, note that by default Kubernetes will bind to a specific interface's IP rather than localhost or all interfaces. This is why you need to use the Kubernetes Node's IP when connecting - even if there's only one Node as in the case of Minikube. Port forwarding in Remote - Containers will allow you to specify `<ip>:<port>` in either the `forwardPorts` property or through the port forwarding UI in VS Code.

---

_Note: This file was auto-generated from the [devcontainer-template.json](https://github.com/devcontainers/templates/blob/main/src/kubernetes-helm/devcontainer-template.json).  Add additional notes to a `NOTES.md`._
