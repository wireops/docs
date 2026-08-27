Home: [[Home]]

# Custom API Endpoints

All custom routes are prefixed `/api/custom/`. PocketBase also auto-exposes CRUD REST for all collections.

## Stacks

| Method | Path | Description |
|---|---|---|
| `POST` | `/stacks/{id}/sync` | Trigger git sync |
| `POST` | `/stacks/{id}/rollback` | Rollback to a commit SHA |
| `POST` | `/stacks/{id}/force-redeploy` | Force recreate containers/volumes/networks |
| `POST` | `/stacks/{id}/transfer` | Move stack to another worker |
| `DELETE` | `/stacks/{id}` | Teardown & delete stack |
| `GET` | `/stacks/{id}/services` | Live container statuses |
| `GET` | `/stacks/{id}/resources` | Volumes + networks |
| `GET` | `/stacks/{id}/compose` | Read rendered compose YAML |
| `GET` | `/stacks/{id}/revisions/{version}` | Read rendered compose YAML for a specific version |
| `GET` | `/stacks/{id}/render-overrides` | View persisted render-time overrides (+ diff vs git) |
| `PUT` | `/stacks/{id}/render-overrides` | Set per-service image/ports/networks overrides (not committed to git); gated by `allow_render_overrides` worker policy; force-recreates |
| `DELETE` | `/stacks/{id}/render-overrides` | Clear render overrides; force-recreates |
| `GET` | `/stacks/{id}/stream` | SSE log stream |
| `GET` | `/stacks/{id}/container/{cid}/stats` | CPU/mem stats |
| `GET` | `/stacks/{id}/container/{cid}/logs` | Container logs |
| `POST` | `/stacks/{id}/container/stop` | Stop a container |
| `POST` | `/stacks/{id}/container/restart` | Restart a container |
| `GET` | `/stacks/import/discover` | Discover unmanaged Compose projects |
| `POST` | `/stacks/import` | Import a local Compose stack |

## Repositories

| Method | Path | Description |
|---|---|---|
| `GET` | `/repositories/{id}/commits` | Last 5 commits |
| `GET` | `/repositories/{id}/files` | List `.yml`/`.yaml` files |
| `POST` | `/credentials/test` | Test git credentials |
| `POST` | `/credentials/keyscan` | SSH host key scan |

## SOPS (`internal/routes/sops_routes.go`)

| Method | Path | Description |
|---|---|---|
| `GET` | `/api/custom/stacks/{id}/sops-env-vars` | List `secrets.yaml` key names only, never values (`CapViewStacks`) |
| `POST` | `/api/custom/repositories/{id}/sops-rotate-key` | Regenerate the repo's age keypair — old `secrets.yaml` becomes undecryptable until re-encrypted (`CapManageRepos`) |
| `POST` | `/api/custom/repositories/{id}/sops-encrypt` | Encrypt a key/value map into `secrets.yaml` content using the repo's public key; nothing persisted server-side (`CapManageRepos`) |

## Workers (superuser only)

| Method | Path | Description |
|---|---|---|
| `GET` | `/api/custom/workers` | List all workers (including pending tokens) |
| `POST` | `/api/custom/worker/tokens` | Generate worker token |
| `POST` | `/api/custom/workers/{id}/revoke` | Revoke worker or a pending token (using `pending:{tokenRecordId}`) |

## Worker Policy (`CapManageSettings`, not superuser-only)

| Method | Path | Description |
|---|---|---|
| `GET` | `/api/custom/workers/{id}/policy` | Resolved effective deploy security policy for a worker, plus its local overrides |
| `PUT` | `/api/custom/workers/{id}/policy` | Set per-worker policy overrides |
| `DELETE` | `/api/custom/workers/{id}/policy` | Clear per-worker overrides (revert to inherit) |
| `GET` | `/api/custom/settings/worker-policy` | Global `worker_policies` singleton |
| `PUT` | `/api/custom/settings/worker-policy` | Update global `worker_policies` singleton |

## Audit (`admin` capability — `CapViewAuditLogs`)

| Method | Path | Description |
|---|---|---|
| `GET` | `/api/custom/audit-logs` | Filterable audit log query (from/to/actor/action/resource/origin/status) |

## Users

| Method | Path | Description |
|---|---|---|
| `POST` | `/api/custom/users/invite` | Invite a new user (`CapManageUsers`) |

## Metrics (`monitoring` role or higher; API key on service account)

| Method | Path | Description |
|---|---|---|
| `GET` | `/metrics` | Aggregated Prometheus metrics (canonical; same port as UI) |
| `GET` | `/api/custom/metrics` | Alias of `/metrics` |
| `GET` | `/api/custom/workers/{id}/metrics` | Metrics from a single connected worker |

## Scheduled Jobs

| Method | Path | Description |
|---|---|---|
| `GET` | `/jobs` | List jobs with definitions |
| `POST` | `/jobs/{id}/run` | Trigger manual run |
| `POST` | `/job-runs/{runId}/cancel` | Kill running container |
| `DELETE` | `/job-runs/{runId}` | Delete stalled run |

## Secret Backend Browse (superuser only, read-only — never returns raw credentials)

| Method | Path | Description |
|---|---|---|
| `GET` | `/api/custom/integrations/vault/mounts` | List KV v2 mounts |
| `GET` | `/api/custom/integrations/vault/browse` | Browse paths/keys under a mount |
| `GET` | `/api/custom/integrations/vault/fields` | List fields at a path |
| `POST` | `/api/custom/integrations/vault/test` | Test Vault connection |
| `GET` | `/api/custom/integrations/infisical/projects` | List projects |
| `GET` | `/api/custom/integrations/infisical/project` | Project detail (environments) |
| `GET` | `/api/custom/integrations/infisical/browse` | Browse secret paths/keys |
| `POST` | `/api/custom/integrations/infisical/test` | Test Infisical connection |
