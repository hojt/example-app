# example-frontend

Minimal Vite, React, and TypeScript frontend for the Example App.

## Development

Run these commands from this directory:

```bash
npm install
task dev
task verify
```

The development server is available at `http://localhost:5173` by default.

`Taskfile.yml` exposes `dev`, `build`, `test`, `check`, and `verify` commands.

## Container Image

The frontend is built into `dist/` and packaged as an `example-frontend` OCI
image using an unprivileged Nginx runtime. The image serves the application on
port 8080.

```bash
task image:build
task image:push
task image:release
```

Development image tags include the current Git commit and dirty state. Release
images use the package version and require an exact matching Git tag.
