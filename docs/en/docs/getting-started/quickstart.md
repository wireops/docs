# Quick start

wireops runs a central server and one or more remote workers. The server stores configuration and dispatches commands; workers run `docker compose` and scheduled containers on the hosts you assign.

## Requirements

- Linux host on `amd64` or `arm64`.
- Docker Engine 25.0+ and Docker Compose v2.24.1+.
- A writable data directory for the server container.
- Network access from every worker to the server. Use TLS or a private network for remote workers.

Keep the server and all workers on the exact same release. See [compatibility](../operations/compatibility.md) before upgrading.

## 1. Start the server

Generate a 32-byte encryption key and configure the sample environment:

```bash
openssl rand -hex 32
cp example/.env.example example/.env
```

Set `SECRET_KEY` to that output and set a strong one-time `BOOTSTRAP_TOKEN`. Then start the server:

```bash
cd example
docker compose up -d wireops
```

Open `http://localhost:8090/setup`, enter the bootstrap token, and create the first administrator. There are no default credentials.

## 2. Connect a worker

In the UI, open **Workers → Add Worker** and copy its token. On the worker host, start a worker with its token and tags:

```bash
WORKER_TOKEN=paste-the-token-here WORKER_TAGS=prod,eu-west-1 docker compose up -d wireops-worker
```

Workers are selected by their tags for stacks and scheduled jobs. Confirm that the worker becomes `ACTIVE` in the UI.

## 3. Add your first stack

1. Add a repository and its credentials, if it is private.
2. Create a stack that points to a Compose file in that repository.
3. Assign the connected worker and any required environment variables.
4. Trigger a sync, or enable automatic sync.

The worker receives the rendered Compose configuration and deploys it locally. Continue with [production guidance](../operations/production.md) before exposing a real workload.

