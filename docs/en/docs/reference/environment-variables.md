Home: [[Home]]

# Environment Variables

## Server

| Variable | Required | Default | Description |
|---|---|---|---|
| `SECRET_KEY` | **Yes** | — | 32-byte AES key for encrypting credentials and secrets at rest. Generate with `openssl rand -hex 32` |
| `BOOTSTRAP_TOKEN` | **Yes** for first-time setup | — | One-time bootstrap secret required to create the first administrator account from the `/setup` page |
| `APP_URL` | No | `http://localhost:8090` | Base URL used for CORS, webhook URLs, and emails |
| `PORT` | No | `8090` | HTTP port for the UI, REST API, and Prometheus metrics (`/metrics`) |
| `TLS_WORKER_PORT` | No | `8443` | Worker WebSocket/register TLS port — not for Prometheus |
| `DATA_DIR` | No | `./data` | Root runtime data directory |
| `PB_DATA_DIR` | No | `DATA_DIR/pb_data` | Optional override for PocketBase SQLite data directory |
| `REPOS_WORKSPACE` | No | `DATA_DIR/repos` | Optional override for Git clone workspace |
| `STACKS_STORAGE_PATH` | No | `{PB_DATA_DIR}/stacks` | Directory for rendered compose revision files |
| `HEARTBEAT_INTERVAL` | No | `30` | Heartbeat interval in seconds. Remote worker read deadline is 3x this value |
| `ALLOWED_PRIVATE_IP_RANGES` | No | — | Comma-separated CIDR ranges allowed for SSH host key scanning |
| `BACKUP_UPLOAD_MAX_MB` | No | `4096` | Max size (MB) accepted when uploading a backup archive for restore (Settings → Backups) |
| `GITHUB_OAUTH_CLIENT_ID` | No | — | GitHub OAuth App client ID. Enables the native "Connect GitHub" flow on the Add Repository modal |
| `GITHUB_OAUTH_CLIENT_SECRET` | No | — | GitHub OAuth App client secret |

### SMTP (optional)

| Variable | Default | Description |
|---|---|---|
| `SMTP_HOST` | — | SMTP server host. When set, enables PocketBase email delivery |
| `SMTP_PORT` | `587` | SMTP server port |
| `SMTP_USERNAME` | — | SMTP authentication username |
| `SMTP_PASSWORD` | — | SMTP authentication password |
| `SMTP_SENDER` | — | Sender email address |
| `SMTP_TLS` | `false` | Set to `true` to enable TLS for SMTP |

### OIDC / SSO (optional)

wireops supports SSO login via any OIDC-compatible provider. See the dedicated [[SSO]] page for the env vars, provider example, and an important warning about the initial admin account.

### GitHub OAuth (optional)

Want to connect your GitHub account instead of pasting in repo URLs by hand? Set `GITHUB_OAUTH_CLIENT_ID` and `GITHUB_OAUTH_CLIENT_SECRET` and a "Connect GitHub" button shows up on the Add Repository screen — click it, sign in, and pick an org, repo, and branch from a list. Skip this and everything still works exactly as before with manual SSH/HTTPS setup.

**1. Create a GitHub OAuth App**

Head over to GitHub and follow their guide: [Creating an OAuth App](https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/creating-an-oauth-app). When you get to the form, here's what to fill in:

- **Application name** — anything recognizable, e.g. `wireops`
- **Homepage URL** — your wireops `APP_URL` (e.g. `https://wireops.example.com`)
- **Application description** — optional, leave it blank or add a short note for yourself
- **Authorization callback URL** — `<APP_URL>/api/custom/git-providers/github/callback` (e.g. `https://wireops.example.com/api/custom/git-providers/github/callback`). This has to match exactly, no trailing slash — wireops always builds this URL itself from `APP_URL`, so double-check the two agree.

Once you click "Register application", GitHub hands you a **Client ID** right away and lets you generate a **Client Secret** — grab both, you'll need them next.

**2. Tell wireops about it**

Set these two env vars on the server (not the worker):

```bash
GITHUB_OAUTH_CLIENT_ID=your_client_id
GITHUB_OAUTH_CLIENT_SECRET=your_client_secret
```

Restart the server and the "Connect GitHub" button appears.

A few things worth knowing:

- wireops asks for the `repo` and `read:org` scopes — enough to see and clone your repos and list your organizations. Nothing more. See GitHub's [scopes reference](https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/scopes-for-oauth-apps) if you want the details.
- Your token is encrypted at rest the same way SSH keys and git passwords already are (AES-GCM, keyed by your `SECRET_KEY`) — no special handling, same trust model you already have.
- This is a classic OAuth App, not a GitHub App, so the token doesn't expire and there's no refresh dance. Curious about the difference? GitHub explains it [here](https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/differences-between-github-apps-and-oauth-apps).
- Changed your mind, or an account left the team? Delete the connected key from **Settings → Repository Keys** in wireops, and/or revoke it from your [GitHub authorized apps list](https://github.com/settings/applications) — either one cuts access.

## Worker

| Variable | Required | Default | Description |
|---|---|---|---|
| `SERVER_URL` | **Yes** | — | URL of the wireops server (e.g. `https://wireops.example.com:8443`) |
| `WORKER_TOKEN` | **Yes** | — | Worker registration and authentication token |
| `HOSTNAME` | No | System hostname | Worker identifier sent during registration |
| `WORKER_TAGS` | No | — | Comma-separated tags for job routing (e.g. `gpu,us-east`). No spaces or special characters — letters, numbers, `-` and `_` only |
| `HEARTBEAT_INTERVAL` | No | `30` | Interval in seconds between heartbeats sent to the server |
| `WORKER_STACK_DIR` | No | `<os.TempDir()>/wireops` | Directory where the worker writes temporary compose files |
| `WORKER_TLS_SKIP_VERIFY` | No | `false` | Skip TLS certificate verification. Set to `true` when the server uses a self-signed certificate |

## Secret Providers

Every secret-flagged env var (stack, global, or job-scoped) picks a `secret_provider` at creation time: `internal` (default), `vault`, or `infisical`.

| Provider | Where the secret lives | Value stored on the env var |
|---|---|---|
| `internal` | Encrypted at rest in wireops's own DB (AES-GCM, `SECRET_KEY`) | The plaintext secret, encrypted |
| `vault` | HashiCorp Vault (KV v2) | A reference: `<mount>/data/<path>#<field>` |
| `infisical` | Infisical | A reference: `<project-id>/<environment>/<secret-path>#<SECRET_NAME>` |

Vault and Infisical are **not** configured via server env vars — enable and configure them from **Settings → Integrations** (category "Secret Backend"):

- **Vault**: `address`, `token`, optional `allowed_mount` (scopes which mount the picker/resolver may touch). The token is encrypted at rest using the existing `SECRET_KEY`.
- **Infisical**: `site_url` (defaults to `https://app.infisical.com`), `client_id`, `client_secret`, optional `allowed_project_id`. The client secret is encrypted at rest using the existing `SECRET_KEY`.

Once a backend is enabled, its provider option appears in the env var editor; picking `vault` or `infisical` swaps the value field for a guided picker (mount/path/field, or project/environment/path/secret) that resolves against Vault/Infisical server-side — you never type or see a raw reference string by hand, and existing secret values are never displayed in plaintext.

Notes:
- **A secret's provider is locked once saved.** You can't switch an existing secret from `internal` to `vault` (or vice versa) — delete it and recreate it with the new provider instead.
- **Disabled backends are caught before deploy.** If a stack or job references a `vault`/`infisical` env var whose backend integration is disabled or unconfigured, sync/job execution fails fast with an error naming the provider and the affected keys, instead of failing mid-deploy.

## SOPS+age Secrets

SOPS is a fundamentally different model from the per-variable providers above: it's file-based and scoped to a **repository**, not to an individual env var.

- Each repository gets an auto-generated [age](https://github.com/FiloSottile/age) keypair the moment it's added — the private key is encrypted at rest under `SECRET_KEY`, the public key is stored in the clear so you (or CI) can encrypt a `secrets.yaml` for it.
- Commit a SOPS-encrypted `secrets.yaml` next to the stack's `wireops.yaml` in the repo. On every sync, rollback, redeploy, and transfer, wireops decrypts it automatically and overlays its keys on top of the stack's env vars — no provider selection per variable, and decrypted values never reach the UI. (The `sops-encrypt` endpoint below does return ciphertext to the browser so you can download and commit it — that's encrypted content, not plaintext.)
- Registered as an always-enabled "Secret Backend" integration (`sops`) that can't be disabled.
- **Rotate a repo's age key** via `POST /api/custom/repositories/{id}/sops-rotate-key` — this is explicit and destructive-ish: any `secrets.yaml` encrypted for the old public key becomes undecryptable until re-encrypted with the new one.
- **Build a `secrets.yaml`** without the `sops` CLI via `POST /api/custom/repositories/{id}/sops-encrypt` (Secrets page) — it encrypts a key/value map against the repo's public key and hands the result back to you to commit yourself; nothing is persisted server-side.
- View which keys a stack's `secrets.yaml` provides via `GET /api/custom/stacks/{id}/sops-env-vars` — key names only, values are never returned.

## APP_URL Configuration

The `APP_URL` variable is used to:
- Configure CORS for frontend access
- Generate webhook URLs for CI/CD integration
- Serve future image and media assets

**Format**: `scheme://host[:port]` (no trailing slash or path)

**Examples**:
```bash
# Local development
APP_URL=http://localhost:8090

# Production with domain
APP_URL=https://wireops.example.com

# Custom port
APP_URL=http://192.168.1.100:8090
```

**Note**: When using `localhost` or `127.0.0.1`, the application automatically allows common development ports (3000, 5173) for CORS.
