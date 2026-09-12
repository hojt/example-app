# example-app

Example application workspace for developing and validating applications on the
homelab platform.

## Purpose

This repository is the reference application workspace for the homelab.

An application workspace may contain multiple independently buildable and
deployable components, such as frontend applications, backend services, and
workers.

Components remain in the same repository while they normally evolve as one
application. They may be extracted into separate repositories when independent
ownership or evolution creates a concrete reason to do so.

This repository also serves as the primary environment for experimenting with
agentic application development.

## Responsibilities

`example-app` owns:

- application source code
- application tests
- application development tooling
- application build tooling
- OCI image builds and publishing

`example-app` does not own:

- Kubernetes platform lifecycle
- Kubernetes desired environment state
- workload deployment manifests
- platform infrastructure

Those responsibilities belong to `local-platform` and `local-environments`.

## Structure

```text
.
├── apps/               # frontend applications
├── services/
│   └── backend/        # Quarkus backend service
├── docs/               # application-level documentation
└── ...
```

The workspace currently contains one independently buildable and deployable
component:

- `services/backend` builds the `example-backend` application and OCI image.

Additional application components will be introduced incrementally as concrete
needs emerge.

## Development

Start or reconnect to the repository development environment:

```bash
./dev.sh
```

Start the coding-agent environment:

```bash
./agent.sh
```

List available workspace tasks:

```bash
task --list
```

The root `Taskfile.yml` provides the application-workspace interface. Component
specific automation remains close to each component.

Current backend tasks include:

```bash
task backend:dev
task backend:test
task backend:verify
task backend:image:build
```

The backend can also be operated directly from `services/backend` using its own
`Taskfile.yml`.

The backend currently publishes the `example-backend` OCI image. Source layout
and deployment identity are intentionally separate concerns.

## Versioning

`example-app` is versioned as one application workspace.

All components in the repository share the same Git-derived application version.
A Git tag therefore represents the version of the complete application workspace
at that commit, even though its components remain independently buildable and
deployable.

Release tags use the form:

```text
<version>
```

For example:

```text
0.6.1
```

Published component artifacts use the application version as their artifact
version. With multiple components in the workspace, a single application release
may therefore produce artifacts such as:

```text
example-backend:0.6.1
example-frontend:0.6.1
```

Development builds may include the Git commit identifier and dirty-worktree
state in their version so that an artifact can be traced back to the exact
workspace state from which it was built.

A component that requires an independent version or release lifecycle is a
signal that it may no longer belong to the same cohesive application workspace
and should be considered for extraction into a separate repository.

## Architecture

The application workspace model is defined by ADR-0007 in the `homelab`
repository.

Deployment boundaries do not automatically imply repository boundaries.
