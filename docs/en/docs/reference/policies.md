Home: [[Home]]

# Deploy Policy

Having the right RBAC role doesn't mean any Compose file should be deployable as-is. Someone could commit a stack that mounts the Docker socket or runs a privileged container. Worker policy is the guardrail that catches that, independent of who's allowed to click "deploy."

Policy is enforced on both paths that ship containers: a stack's rendered Compose file at deploy time, and a [scheduled job](jobs.md)'s image/volumes/network at dispatch time. Both checks are fail-closed, so a violation blocks the action instead of warning and proceeding.

## Global policy and per-worker overrides

There's one global policy, plus an optional override per worker:

- If a worker has no override for a given setting and `policy_inherit` is `true` (the default), it uses the global value.
- If `policy_inherit` is `false`, an unset local value falls back to "no restriction" for that setting instead of the global one.
- A per-worker override **replaces**, not merges with, the global value for that resource. Setting a local `allowed_images` list means only that list applies to the worker, not global-plus-local.
- Overrides applied at render time (see [Business flows](business-flows.md)) still pass through the same policy checks, so they can't be used to sneak past a block.

Policy can be disabled entirely (global `enabled: false`), in which case every check below is skipped everywhere.

## Allowlists

Six resource types can be restricted to an explicit allowlist: **images**, **volumes**, **networks**, plus **added capabilities**, **devices**, and **security-opt** entries.

- An empty list means open policy, so everything of that type is permitted.
- The moment at least one entry is present, only what's listed is allowed; everything else is rejected.
- **Images** match by glob pattern (e.g. `ghcr.io/myorg/*`), so you can allow a whole registry namespace without listing every tag.
- **Volumes** match by prefix for bind-mounts (the host path must start with an allowed prefix) or by exact name for named volumes.
- **Networks**, **capabilities**, **devices**, and **security-opt** entries all match exactly.

## Boolean flags

These block a specific dangerous setting outright, independent of the allowlists:

| Flag | Blocks |
|---|---|
| `prevent_latest_images` | Images with no tag or tagged `:latest`. Nudges toward pinned, reproducible deploys. |
| `block_host_volumes` | Any bind-mount (absolute path, `./`, `../`, `~`). Named volumes are unaffected. |
| `block_privileged` | Services with `privileged: true`. |
| `block_host_network` | Services with `network_mode: host`. |
| `block_host_pid` | Services with `pid: host`. |
| `block_host_ipc` | Services with `ipc: host`. |
| `block_docker_socket` | Mounting `/var/run/docker.sock` or `/run/docker.sock` into a container. |
| `allow_render_overrides` | *(inverted, defaults to `false`)* Whether a worker accepts render-time image/port/network/scale overrides at all. Unlike the `block_*` flags, this capability must be explicitly opted into per worker. |

Per-worker flag overrides are stored as a nullable map. `null` for a flag means "inherit from global," while `true`/`false` overrides it explicitly, so a worker can loosen or tighten a single flag without having to restate every other one.

## Seeing violations before you deploy

Policy violations aren't just a deploy-time surprise. wireops's static Compose linter folds the effective worker policy into its report, so lint output shows every policy violation a file would hit at deploy time, all at once, before you commit. With no policy configured (or policy globally disabled), the linter falls back to its own advisory rules instead.

The [`scaffold_stack` MCP tool](mcp-server.md) can also validate a freshly generated Compose file against a specific worker's policy before handing it back, so an AI assistant doesn't scaffold something that would be rejected on the first deploy.

## Related

- [Access control and audit](../security/access-control-and-audit.md): how policy fits alongside RBAC roles and the audit log.
- [Scheduled jobs](jobs.md): how the same policy checks apply to job images, volumes, and networks.
