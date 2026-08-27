Home: [[Home]]

# Business Flows

This page walks through what actually happens, end to end, for the three things wireops does: syncing a stack from Git, bringing a new worker online, and running a scheduled job.

## Syncing a stack from Git

This is the core loop. Once you point a stack at a Git repo, here's the lifecycle of every deploy:

1. **Wireops checks in on your repo periodically.** By default every 10 seconds, though you can set a slower interval per-stack in your `wireops.yaml` if you don't need that frequency.
2. **It looks for new commits.** It fetches the repo and compares the latest commit against whatever it last deployed. No new commit, nothing happens.
3. **If there's a new commit, it renders the compose file.** wireops reads your `docker-compose.yml`, tags the containers with its own labels (so it can track them later), and saves a numbered snapshot of that rendered file — so you always have a history of exactly what was deployed at each version.
4. **The deploy gets handed to a worker.** The server sends the rendered compose file to whichever worker is assigned to that stack and waits (up to 5 minutes) for it to finish.
5. **The worker runs `docker compose up`.** That's the actual deploy — pulling new images, recreating changed containers, and so on.
6. **The result gets recorded.** Success or failure, wireops logs it, updates the stack's status in the UI, and — if you've set up [[Notifications]] — fires off a webhook, Discord message, Slack message, or ntfy push.

**What if the worker is offline when a change lands?** The change isn't lost — it's queued, and replayed automatically the moment that worker reconnects.

## Bringing a worker online

Workers don't register themselves silently — there's a deliberate handshake:

1. An admin generates a registration token from the UI.
2. That token is handed to the worker (typically as an environment variable when you start it).
3. The worker connects to the server and presents the token. The server validates it and activates the worker.
4. The worker then opens a persistent connection back to the server and stays on it.
5. From here on, the server can push commands (deploy, teardown, run a job) down that connection at any time, and the worker sends a heartbeat every 30 seconds so the server knows it's still alive.

If a worker goes quiet (misses heartbeats), it shows as offline in the UI, and any pending deploys for its stacks queue up until it comes back.

## Scheduled jobs

Beyond keeping stacks in sync, wireops can run one-off Docker containers on a schedule — useful for things like nightly database backups or cleanup scripts. This is driven entirely by a `job.yaml` file you commit to your repo:

```yaml
title: "Database Backup"
description: "Nightly backup of the postgres database"
cron: "0 2 * * *"
image: "postgres:15-alpine"
command: ["pg_dump", "-h", "db", "-U", "postgres", "mydb"]
tags: ["backup", "prod"]
mode: "once" # once or once_all
volumes:
  - "/opt/backups:/backups"
network: "prod_network"
resources:
  cpu: "0.5"        # required
  memory: "512m"    # required
  timeout: "15m"    # required
```

The job file is the single source of truth — there's no separate UI config to drift out of sync with it. `resources` (cpu/memory/timeout) is mandatory, so a runaway job can't quietly eat a host's resources.

Here's what happens on each scheduled tick:

1. wireops finds workers matching the job's `tags` (this is how you route a GPU job to a GPU-tagged worker, for example).
2. It creates a run record and sends the job to a matching worker.
3. The worker runs the container (`docker run --rm`), then reports back the exit code and output once it finishes.
4. wireops marks the run as success or failure. If a run gets stuck (running for over an hour with no result), a periodic sweep marks it stalled so it doesn't linger forever.

## Two smaller conveniences worth knowing about

**Render overrides** — sometimes you want to swap a service's image, ports, or network without committing anything to Git (e.g. testing a hotfix image). You can do that from the stack's detail page; it only affects what gets deployed, never what's in your repo, and it's off by default until an admin enables the "Allow render overrides" policy.

**Container icons** — if you want a nicer icon next to your containers in the UI instead of a generic default, add a `customization.image.slug` label to a service in your compose file (matching an identifier from the [selfh.st/icons](https://selfh.st/icons/) catalog) and wireops will pick it up automatically.
