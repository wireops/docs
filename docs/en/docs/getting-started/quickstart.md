# Quick start

wireops runs a central server and one or more remote workers. The server stores configuration and dispatches commands; workers run `docker compose` and scheduled containers on the hosts you assign.

## Requirements

- Linux host on `amd64` or `arm64`.
- Docker Engine 25.0+ and Docker Compose v2.24.1+.
- A writable data directory for the server container.
- Network access from every worker to the server. Use TLS or a private network for remote workers.

Keep the server and all workers on the exact same release. See [compatibility](../operations/compatibility.md) before upgrading.

## 1. Start the server

Generate a 32-byte encryption key:

```bash
openssl rand -hex 32
```

Use that value for `SECRET_KEY`, pick a strong one-time `BOOTSTRAP_TOKEN`, and start the server.

The server container runs as UID/GID `1000`, not root. On Linux, create the data directory and hand it over first, or the server fails with `permission denied` trying to create `pb_data`:

```bash
mkdir -p data
sudo chown -R 1000:1000 data
```

```bash
docker run -d --name wireops \
  -p 8090:8090 -p 8443:8443 \
  -v "$(pwd)/data:/data" \
  -e SECRET_KEY=paste-the-generated-key \
  -e BOOTSTRAP_TOKEN=a-strong-one-time-token \
  -e APP_URL=http://localhost:8090 \
  ghcr.io/wireops/server:1.0.0
```

`APP_URL=http://localhost:8090` only works if you open the UI from the same machine the server runs on. If you'll reach it from another host, set `APP_URL` to that reachable address instead (e.g. `http://192.168.1.100:8090`), or its `https://` origin once you put TLS in front of it.

Prefer Compose? See the [example `docker-compose.yml`](https://github.com/wireops/wireops/blob/main/example/docker-compose.yml). Copy `example/.env.example` to `example/.env`, fill in the same variables, and run `docker compose up -d wireops` from `example/`. See [troubleshooting](../operations/troubleshooting.md) if the container still can't write to `data/`.

Open `http://localhost:8090/setup`, enter the bootstrap token, and create the first administrator. There are no default credentials.

## 2. Connect a worker

In the UI, open **Workers → Add Worker** and copy its token. On the worker host:

```bash
docker run -d --name wireops-worker \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --group-add "$(stat -c '%g' /var/run/docker.sock)" \
  -e SERVER_URL=http://your-server-host:8443 \
  -e WORKER_TOKEN=paste-the-token-here \
  -e WORKER_TAGS=prod,eu-west-1 \
  ghcr.io/wireops/worker:1.0.0
```

Pin the worker to the exact same version as the server (`1.0.0` above); see [compatibility](../operations/compatibility.md) for why a mismatched pair is unsupported. The `http://` URL above only belongs on a private network or the same Docker host as the server; for a worker on another network, use `https://` with [TLS enabled](../operations/production.md#network-and-tls) on the server.

`--group-add` (or `DOCKER_GID` in Compose) is only needed on Linux, when the Docker socket isn't world-accessible. See [troubleshooting](../operations/troubleshooting.md) if the worker reports a permission error. The same [example `docker-compose.yml`](https://github.com/wireops/wireops/blob/main/example/docker-compose.yml) has a `wireops-worker` service if you'd rather run it via Compose.

Workers are selected by their tags for stacks and scheduled jobs. Confirm that the worker becomes `ACTIVE` in the UI.

## 3. Add your first stack

1. Add a repository and its credentials, if it is private.
2. Create a stack that points to a Compose file in that repository.
3. Assign the connected worker and any required environment variables.
4. Trigger a sync, or enable automatic sync.

The worker receives the rendered Compose configuration and deploys it locally. Continue with [production guidance](../operations/production.md) before exposing a real workload.

Want an AI assistant driving wireops instead? Set up the [MCP server](../reference/mcp-server.md).

