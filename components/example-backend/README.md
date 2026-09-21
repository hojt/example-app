# example-backend

A minimal Quarkus backend used to validate the local development platform and its application delivery workflow.

## Purpose

This component provides a small reference backend for exercising the local development and Kubernetes platform.

It currently demonstrates:

- Quarkus
- Java 25
- Maven
- Podman
- Dev Containers
- Task-based automation
- OCI image build and publication
- application health endpoints
- external application configuration
- deployment through the local GitOps environment

The repository is intentionally kept small and focused. It serves both as a working example application and as a reference implementation for future backend services.

Platform infrastructure and environment-specific Kubernetes configuration are maintained separately.

```text
example-backend
      │
      │ application source + container image
      ▼
local container registry
      │
      ▼
local-environments
      │ desired Kubernetes state
      ▼
local-platform
```

## Requirements

Development is performed inside the provided Dev Container.

The developer host only needs the tooling required to start that environment, primarily:

- Podman
- Dev Container CLI

Workspace-specific development tooling is provided by the Dev Container.

## Development

Development is performed inside the provided Dev Container.

Start or reconnect to the workspace development environment from the workspace root with:

```bash
./dev.sh
```

This verifies the required host tooling, starts or reuses a repository-specific tmux session, starts the Dev Container, and opens a shell inside it.

Rebuild the development environment with:

```bash
./dev.sh rebuild
```

Once inside the Dev Container, start the application from the workspace root with:

```bash
task backend:dev
```

Or, from `components/example-backend`, use the component task:

```bash
task dev
```

The application is then available at:

```text
http://localhost:8080/api/greeting
```

Verify it with:

```bash
curl http://localhost:8080/api/greeting
```

By default, the greeting uses the application's configured default value.

### Agent-assisted development

An optional OpenCode-based environment is available for agent-assisted work.

Start or reconnect to it from the host with:

```bash
./agent.sh
```

This uses a separate agent Dev Container profile with reduced access to host resources and launches OpenCode inside a dedicated tmux session.

Rebuild the agent environment with:

```bash
./agent.sh rebuild
```

OpenCode authentication is user-specific and is kept outside the repository and container image.

## Configuration

The greeting is externally configurable through the Quarkus configuration property:

```text
greeting.message
```

Quarkus maps this to the environment variable:

```text
GREETING_MESSAGE
```

For example, the application can be started locally with:

```bash
GREETING_MESSAGE="Hello from config" task dev
```

Then:

```bash
curl http://localhost:8080/api/greeting
```

returns:

```json
{
  "message": "Hello from config"
}
```

In Kubernetes, the environment-specific value is owned by the `local-environments` repository rather than this application repository.

`local-environments` currently generates a ConfigMap using Kustomize and injects it into the application container. The generated ConfigMap name contains a content hash, so configuration changes modify the Pod template and automatically trigger a Kubernetes rollout through GitOps reconciliation.

```text
configuration change
       │
       ▼
Kustomize ConfigMap generator
       │
       ▼
ConfigMap with content hash
       │
       ▼
Deployment reference changes
       │
       ▼
new ReplicaSet / Pod
```

## Health

The application exposes Quarkus health endpoints used by Kubernetes probes.

Liveness:

```text
/q/health/live
```

Readiness:

```text
/q/health/ready
```

When running locally, they can be inspected with:

```bash
curl http://localhost:8080/q/health/live
curl http://localhost:8080/q/health/ready
```

A healthy application returns a status of `UP`.

The Kubernetes liveness and readiness probes themselves are environment configuration and are therefore maintained in `local-environments`.

## Tasks

From the workspace root, list the available workspace tasks with:

```bash
task --list
```

From `components/example-backend`, `task --list` lists the backend component tasks.
Task is the normal developer-facing interface for common operations such as development, testing, packaging, and container image handling.

## Container Image

The application is packaged and built into an OCI container image using Podman.

Image configuration, including the current image tag, is maintained by the repository scripts. The image tag is the deployable container image version and is independent of the Maven project version in `pom.xml`.

From the workspace root, build the image with `task backend:image:build` and publish it with `task backend:image:push`. From `components/example-backend`, use `task image:build` and `task image:push`.

The local Kubernetes platform exposes its development registry at:

```text
localhost:5001
```

A published application image therefore follows the form:

```text
localhost:5001/example-backend:<tag>
```

The exact available commands can always be inspected with:

```bash
task --list
```

## Deployment

This repository owns the application source and its container image. It intentionally does not own the Kubernetes Deployment or environment-specific configuration.

The responsibility boundary is:

```text
example-backend
  ├── application source
  ├── tests
  ├── package build
  └── container image
          │
          ▼
local-environments
  ├── Deployment
  ├── Service
  ├── ConfigMap generation
  ├── health probes
  └── HTTPRoute
          │
          ▼
local-platform
  ├── Kubernetes
  ├── local container registry
  ├── Argo CD
  ├── Envoy Gateway
  ├── certificate management
  └── Gateway API
```

Changes to the desired deployment state are committed to `local-environments` and reconciled into the cluster by Argo CD.

The application can then be reached through the local Gateway, for example:

```bash
curl https://example.local:8443/api/greeting
```

## Project Structure

```text
.
├── scripts/
├── src/
├── Containerfile
├── Taskfile.yml
├── pom.xml
└── README.md
```

The repository follows a simple automation layering:

```text
Task
  │
  ▼
scripts/
  │
  ▼
Maven / Podman
```

Task provides the stable developer-facing interface while reusable or non-trivial operations live in shell scripts under `scripts/`.

This keeps the underlying commands visible and makes the same automation reusable from future CI/CD pipelines.

## Repository Responsibilities

`example-backend` owns:

- application source code
- application tests
- application packaging
- container image construction
- container image publication
- application-level health capabilities
- application configuration properties and defaults

It does not own:

- Kubernetes platform infrastructure
- Kubernetes Deployment configuration
- environment-specific configuration values
- Gateway configuration
- workload routing
- certificate management

Those responsibilities belong to `local-platform` and `local-environments`.

## Status

The current backend reference implementation includes:

- Dev Container development environment
- Quarkus application
- automated tests
- Maven package build
- OCI container image build
- local registry publication
- configurable application greeting
- liveness health endpoint
- readiness health endpoint
- Kubernetes liveness and readiness integration
- ConfigMap-based environment configuration
- automatic rollout on configuration changes through Kustomize-generated ConfigMap hashes
- GitOps deployment through Argo CD
- HTTPS access through the local Gateway API platform
- isolated OpenCode agent development environment

The repository remains intentionally small. Additional capabilities should be introduced incrementally when they exercise a concrete platform or application-development requirement.
