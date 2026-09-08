Home: [[Home]]

# Business Flows

This page walks through what actually happens, end to end, for the three things wireops does: syncing a stack from Git, bringing a new worker online, and running a scheduled job.

## Syncing a stack from Git

This is the core loop. Once you point a stack at a Git repo, here's the lifecycle of every deploy:

1. **Wireops checks in on your repo periodically.** By default every 10 seconds, though you can set a slower interval per-stack in your `wireops.yaml` if you don't need that frequency.
2. **It looks for new commits.** It fetches the repo and compares the latest commit against whatever it last deployed. No new commit, nothing happens.
3. **If there's a new commit, it renders the compose file.** wireops reads your `docker-compose.yml`, tags the containers with its own labels (so it can track them later), and saves a numbered snapshot of that rendered file, so you always have a history of exactly what was deployed at each version.
4. **The deploy gets handed to a worker.** The server sends the rendered compose file to whichever worker is assigned to that stack and waits (up to 5 minutes) for it to finish.
5. **The worker runs `docker compose up`.** That's the actual deploy: pulling new images, recreating changed containers, and so on.
6. **The result gets recorded.** Success or failure, wireops logs it, updates the stack's status in the UI, and, if you've set up [notifications](../integrations/notifications.md), fires off a webhook, Discord message, Slack message, or ntfy push.

**What if the worker is offline when a change lands?** The change isn't lost. It's queued, and replayed automatically the moment that worker reconnects.

## Bringing a worker online

Workers don't register themselves silently. There's a deliberate handshake:

1. An admin generates a registration token from the UI.
2. That token is handed to the worker (typically as an environment variable when you start it).
3. The worker connects to the server and presents the token. The server validates it and activates the worker.
4. The worker then opens a persistent connection back to the server and stays on it.
5. From here on, the server can push commands (deploy, teardown, run a job) down that connection at any time, and the worker sends a heartbeat every 30 seconds so the server knows it's still alive.

If a worker goes quiet (misses heartbeats), it shows as offline in the UI, and any pending deploys for its stacks queue up until it comes back.

## Scheduled jobs

Beyond keeping stacks in sync, wireops can run one-off Docker containers on a cron schedule: nightly database backups, cleanup scripts, health-check pings, driven entirely by a `job.yaml` file committed to a repo, with no separate UI config to drift out of sync with it. See [Scheduled Jobs](jobs.md) for the full field reference, dispatch modes, and how policy enforcement fits in.

## A few smaller conveniences worth knowing about

**Render overrides.** Sometimes you want to swap a service's image, ports, or network without committing anything to Git (e.g. testing a hotfix image). You can do that from the stack's detail page. It only affects what gets deployed, never what's in your repo, and it's off by default until an admin enables the "Allow render overrides" [policy](policies.md) flag.

**Container icons.** If you want a nicer icon next to your containers in the UI instead of a generic default, add a `customization.image.slug` label to a service in your compose file (matching an identifier from the [selfh.st/icons](https://selfh.st/icons/) catalog) and wireops will pick it up automatically.

**Init containers.** A service that's meant to run once and exit — a database migration, a seed script, any one-shot job — isn't the same as a crashed long-running service, but wireops can't tell the difference on its own: any expected container that isn't `running` normally counts as missing, which drags the whole stack's status to degraded. Add a `customization.init: "true"` label to that service and wireops exempts it from that rule: exiting with code 0 (or being gone entirely once Docker cleans it up) is treated as a healthy, expected end state. It still counts against the stack if the container exits with a non-zero code or gets stuck in a restart loop.

```yaml
services:
  migrate:
    image: myapp:1.4.0
    command: ["./migrate", "up"]
    restart: "no"
    labels:
      - "customization.init=true"
```

Only label services that are genuinely expected to exit on their own — putting it on a long-running service would hide a real crash instead of catching it.
