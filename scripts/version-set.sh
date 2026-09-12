#!/usr/bin/env bash

set -euo pipefail

version="${1:-}"

if [[ -z "${version}" ]]; then
  echo "VERSION is required. Usage: task version:set VERSION=MAJOR.MINOR.PATCH" >&2
  exit 1
fi

if [[ ! "${version}" =~ ^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$ ]]; then
  echo "Invalid version: ${version}. Use MAJOR.MINOR.PATCH." >&2
  exit 1
fi

workspace_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
backend_dir="${workspace_root}/services/backend"
frontend_dir="${workspace_root}/apps/frontend"

if ! (cd "${backend_dir}" && ./mvnw --quiet -Dexpression=revision -DforceStdout help:evaluate >/dev/null); then
  echo "Unable to read the backend Maven revision." >&2
  exit 1
fi

(
  cd "${frontend_dir}"
  npm version "${version}" --no-git-tag-version --allow-same-version
)

(
  cd "${backend_dir}"
  ./mvnw --quiet \
    versions:set-property \
    -Dproperty=revision \
    -DnewVersion="${version}" \
    -DgenerateBackupPoms=false
)

"${workspace_root}/scripts/version-check.sh"
