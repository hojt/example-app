# example-frontend

Minimal Vite, React, and TypeScript frontend for the Example App.

## Development

From the workspace root, use the workspace tasks:

```bash
task frontend:dev
task frontend:verify
task frontend:image:build
```

From `components/example-frontend`, use the component tasks:

```bash
npm ci
task dev
task verify
```

The development server is available at `http://localhost:5173` by default.

`Taskfile.yml` exposes `dev`, `build`, `test`, `check`, and `verify` commands.

## Container Image

The frontend is built into `dist/` and packaged as an `example-frontend` OCI
image using an unprivileged Nginx runtime. The image serves the application on
port 8080.

From `components/example-frontend`:

```bash
task image:build
task image:push
task image:release
```

Development image tags include the current Git commit and dirty state. Release
images use the package version and require an exact matching Git tag.
