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
├── apps/       # frontend applications
├── services/   # backend services and workers
├── docs/       # application-level documentation
└── ...
```

The structure is intentionally minimal and will evolve as real application
components are introduced.

## Development

Start or reconnect to the repository development environment:

```bash
./dev.sh
```

List available repository tasks:

```bash
task --list
```

## Architecture

The application workspace model is defined by ADR-0007 in the `homelab`
repository.

Deployment boundaries do not automatically imply repository boundaries.
