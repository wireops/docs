Home: [[Home]]

# Scheduled Jobs

Beyond keeping stacks in sync, wireops can run one-off Docker containers on a cron schedule: nightly database backups, log rotation, cleanup scripts, health-check pings, anything you'd otherwise put in a host crontab. Jobs are driven entirely by a `job.yaml` file committed to a repository, so there's no separate UI config that can drift out of sync with it.

## The `job.yaml` file

```yaml
name: "Database Backup"
description: "Nightly backup of the postgres database"
cron: "0 2 * * *"
image: "postgres:15-alpine"
command: ["pg_dump", "-h", "db", "-U", "postgres", "mydb"]
tags: ["backup", "prod"]
group: "database"
mode: "once" # once or once_all
volumes:
  - "/opt/backups:/backups"
network: "prod_network"
resources:
  cpu: "0.5"        # required
  memory: "512m"    # required
  timeout: "15m"    # required
configs:
  - name: "backup-script"
    path: "scripts/backup.sh"
    target: "/scripts/backup.sh"
    mode: "0755"    # optional, defaults to read-only
```

| Field | Required | Description |
|---|---|---|
| `name` | Yes | Display name. Synced from Git on every run, so renaming it in the UI has no effect; edit the file instead. |
| `description` | No | Shown alongside the job in the UI. |
| `cron` | Yes | Standard 5-field cron expression, evaluated in the server's timezone. |
| `image` | Yes | Docker image to run. Subject to the same [worker policy](policies.md) checks as a stack's images. |
| `command` | No | Accepts either a single string (split on whitespace) or a YAML list. Use the list form if any argument contains a space. |
| `tags` | No | Selects which workers are eligible to run the job (see [Dispatch](#dispatch-modes) below). Empty means any worker. |
| `group` | No | Free-form label for organizing related jobs in the UI. Purely cosmetic. |
| `mode` | No | `once` (default) or `once_all`, see below. |
| `volumes` | No | Bind mounts or named volumes, same syntax as Compose. Subject to worker policy (`BlockHostVolumes`, `AllowedVolumes`). |
| `network` | No | Docker network to attach the job container to. Subject to worker policy (`AllowedNetworks`). |
| `resources.cpu` / `.memory` / `.timeout` | **Yes, all three** | Mandatory so a runaway job can't quietly eat a host's resources. `timeout` cancels the container if it runs longer. |
| `configs` | No | Git-committed files resolved server-side and bind-mounted read-only (or per `mode`) into the container at `target`. Jobs have no compose file, so target and mode are spelled out explicitly here, unlike a stack's native `configs:` element. |

## Dispatch modes

- **`once`**: the job runs on exactly one matching worker, chosen round-robin across workers whose tags satisfy the job's `tags`. Use this for anything that shouldn't run twice (a backup, a database migration).
- **`once_all`**: the job runs concurrently on *every* matching worker. Use this for fleet-wide maintenance (pruning dangling images on every host, rotating logs everywhere).

## What happens on each scheduled tick

1. wireops resolves which workers match the job's `tags`.
2. It creates a `job_runs` record per dispatch and loads the effective [worker policy](policies.md) for the target worker.
3. The job's image, volumes, and network are validated against that policy. A violation fails the run immediately (`error` status) without ever reaching the worker; this is the same fail-closed check a stack deploy goes through.
4. The worker runs the container (`docker run --rm`) and reports back the exit code and output once it finishes.
5. wireops marks the run `success` or `failed`. If a run gets stuck, running for over an hour with no result and typically because the worker dropped mid-execution, a periodic sweep marks it `stalled` so it doesn't linger forever.

`job_runs` records expire and are cleaned up automatically after 30 days.

## Ad hoc runs and the API/MCP surface

Jobs don't have to wait for their cron tick. You can trigger a run on demand from the UI or API, and everything about a job is also readable programmatically:

- REST: list jobs and their recent runs, fetch a job's raw `job.yaml`, browse a repository for candidate `job.yaml` files before scheduling one.
- [MCP server](mcp-server.md): `list_jobs`, `get_job_definition`, `list_repo_job_files`, and `generate_job_yaml` expose the same data (and a scaffolding helper) to an AI assistant, read-only and RBAC-scoped to whatever API key it's given.

## Related

- [Policies](policies.md): what a job's image, volumes, and network are actually checked against before it's allowed to run.
- [Business flows](business-flows.md): where scheduled jobs fit alongside stack sync and worker onboarding.
