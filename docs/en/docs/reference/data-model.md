Home: [[Home]]

# Data Model

All collections are defined via Go migrations in `pb_migrations/` — always add a new numbered migration file, never edit an existing one.

| Collection | Key Fields |
|---|---|
| `repositories` | `name`, `git_url`, `branch`, `status`, `last_commit_sha`, `platform`, `sops_age_key`* (auto-generated), `sops_age_public_key` |
| `repository_keys` | `repository`, `auth_type` (none/ssh_key/basic), `ssh_private_key`*, `git_password`* |
| `stacks` | `name`, `repository`, `compose_path`, `auto_sync`, `status`, `worker`, `current_version`, `render_overrides` (JSON, per-service image/ports/networks not committed to git) |
| `stack_env_vars` | `stack`, `key`, `value`*, `secret`, `secret_provider` (internal/vault/infisical) |
| `global_env_vars` | `key`, `value`*, `secret`, `secret_provider` — reusable across stacks/jobs via binding tables |
| `job_env_vars` | `job`, `key`, `value`*, `secret`, `secret_provider` |
| `stack_global_env_vars` / `job_global_env_vars` | Binding tables linking `global_env_vars` rows to stacks/jobs |
| `stack_services` | `stack`, `service_name`, `container_name`, `status` |
| `stack_revisions` | `stack`, `version` — numbered snapshots of rendered compose YAML |
| `stack_pending_reconciles` | `stack`, `trigger`, `commit_sha` — queue for offline worker reconnect |
| `sync_logs` | `stack`, `trigger`, `status`, `output`, `duration_ms` |
| `workers` | `hostname`, `fingerprint`, `status` (ACTIVE/REVOKED), `health_history` |
| `scheduled_jobs` | `repository`, `job_file`, `enabled`, `status` |
| `job_runs` | `job`, `worker`, `status`, `output`, `expires_at` (30-day TTL) |
| `integrations` | `slug`, `enabled`, `config` (JSON) — also stores Vault/Infisical backend config (address/token, site_url/client_id/client_secret, etc.) |

(\* = AES-GCM encrypted at rest via `SECRET_KEY`)

## Relationships

```
repositories ─── 1:N ──→ stacks ─── 1:N ──→ stack_env_vars
                                 └── 1:N ──→ sync_logs
                                 └── 1:N ──→ stack_revisions
                                 └── N:1 ──→ workers
repositories ─── 1:N ──→ scheduled_jobs ─── 1:N ──→ job_runs ─── N:1 ──→ workers
```
