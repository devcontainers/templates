## Using this template

Dev containers can be useful for all types of applications including those that also deploy into a container based-environment. While you can directly build and run the application inside the dev container you create, you may also want to test it by deploying a built container image into a local minikube or remote [Kubernetes](https://kubernetes.io/) cluster without affecting your dev container.

This example illustrates how you can do this by using CLIs ([kubectl](https://kubernetes.io/docs/reference/kubectl/overview/), [Helm](https://helm.sh), Docker), the [Kubernetes extension](https://marketplace.visualstudio.com/items?itemName=ms-kubernetes-tools.vscode-kubernetes-tools), and the [Docker extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker) right from inside your dev container.  This definition builds up from the [docker-in-docker](../docker-in-docker) container definition along with a [minikube](https://minikube.sigs.k8s.io/docs/) installation that can run right inside the container. It installs the Docker and Kubernetes extensions inside the container so you can use its full feature set with your project.

The included `.devcontainer.json` can be altered to work with other Debian/Ubuntu-based container images such as `node` or `python`. For example, to use `mcr.microsoft.com/devcontainers/javascript-node`, update the `image` proprty as follows:

```json
"image": "mcr.microsoft.com/devcontainers/javascript-node:18"
```


## Ingress and port forwarding

When configuring [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) for your Kubernetes cluster, note that by default Kubernetes will bind to a specific interface's IP rather than localhost or all interfaces. This is why you need to use the Kubernetes Node's IP when connecting - even if there's only one Node as in the case of Minikube.