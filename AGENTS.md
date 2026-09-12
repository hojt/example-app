# Agent Instructions

This repository contains a complete application workspace.

## Responsibilities

Application source code, tests, build tooling, and application-level
documentation belong in this repository.

Kubernetes desired state belongs in `local-environments`.

Platform implementation belongs in `local-platform`.

Do not introduce platform or environment configuration into this repository.

## Development

Use repository Task commands as the preferred development interface when
available.

Keep independently deployable components independently buildable and testable.

Changes may span multiple application components when required by a feature.

Validate changes before considering work complete.

## Git

Never create Git commits.

The developer always owns staging, commits, tags, and pushes.

Do not rewrite Git history.

## Architecture

Prefer the smallest useful implementation.

Do not introduce abstractions, shared packages, services, or repository
boundaries for speculative future requirements.

Components remain in this workspace until a demonstrated need for independent
ownership or evolution justifies extracting them.
