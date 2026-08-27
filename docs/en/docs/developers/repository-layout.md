Home: [[Home]]

# Repository Layout

```
.
├── main.go                       # Entrypoint — delegates to cmd/serve.go
├── cmd/serve.go                  # Server bootstrap & dependency wiring
├── go.mod                        # Go module (go 1.25)
├── worker/                       # Standalone remote-worker binary
│   ├── main.go
│   ├── api/client.go             # Token-authenticated HTTP client (register)
│   ├── executor/runner.go        # Executes deploy / teardown / job commands
│   └── sync/websocket.go         # Persistent WebSocket connection to server
├── internal/
│   ├── worker/                   # Server-side worker management
│   │   ├── server.go             # Token-authenticated WebSocket server on :8443
│   │   └── service.go            # Worker CRUD, registration tokens, health tracking
│   ├── compose/                  # Docker Compose helpers
│   │   ├── config.go             # Compose YAML parsing
│   │   ├── runner.go             # RunUp / RunDown / RunForceUp / RunPs
│   │   └── status.go             # Container status, stats, volumes, networks
│   ├── config/config.go          # APP_URL, webhook URL resolution
│   ├── crypto/encrypt.go         # AES-GCM encryption for secrets at rest
│   ├── docker/client.go          # Docker Engine API client wrapper
│   ├── git/                      # Clone, fetch, SSH/Basic auth
│   ├── hooks/pb_hooks.go         # PocketBase lifecycle hooks
│   ├── integrations/             # Plugin registry (Traefik, Caddy, Nginx Proxy Manager, Dozzle, Webhook, Discord, Slack, Ntfy, SOPS)
│   ├── job/parser.go             # job.yaml parsing & validation
│   ├── jobscheduler/scheduler.go # Cron scheduler for Docker-based jobs
│   ├── manifest/parser.go        # Parses declarative `.wireops.yml` stack config
│   ├── notify/                   # Outbound notifications (webhook / ntfy) — superseded by integrations/ notification plugins for new work
│   ├── policy/                   # Worker-level deploy security policies (block privileged/host-network/docker.sock/host-PID/host-IPC, allowlists)
│   ├── protocol/messages.go      # WebSocket message types (shared)
│   ├── rbac/rbac.go              # Role definitions (viewer/operator/admin/monitoring) and capability checks
│   ├── audit/audit.go            # Request/system audit log recording + retention purge
│   ├── secrets/                  # Pluggable secret providers: internal (AES-GCM), vault (HashiCorp Vault), infisical; also SOPS+age helpers (keypair gen, decrypt/encrypt secrets.yaml) used by sync/ and hooks/
│   ├── oidc/collection.go        # OIDC PocketBase collection support (client secret hydration)
│   ├── setup/service.go          # First-admin bootstrap (`/setup`) service
│   ├── backup/                   # Backup/restore (create/list/upload/delete/restore) + optional S3 mirroring
│   ├── routes/                   # HTTP route handlers
│   │   ├── routes.go             # Stack / repo / credential / integration routes
│   │   ├── worker.go             # Worker management routes
│   │   ├── jobs.go               # Scheduled job routes
│   │   └── users.go              # User management
│   ├── safepath/                 # Path traversal protection
│   └── sync/
│       ├── scheduler.go          # Per-stack polling scheduler
│       ├── reconciler.go         # Core GitOps reconcile loop
│       ├── renderer.go           # Injects wireops labels into compose YAML
│       └── watcher.go            # File-based change detection
├── pb_migrations/                # PocketBase SQLite schema migrations
├── pb_public/                    # Compiled frontend static assets (served by PocketBase)
├── mcp/                          # Standalone MCP server binary (wireops-mcp) — read-only tools + generate/scaffold tools, pass-through auth
└── frontend/                     # Nuxt 4 SPA (Vue 3, @nuxt/ui v4, Tailwind)
    └── app/
        ├── pages/                # File-based routing
        ├── components/           # Reusable Vue components
        ├── composables/          # useApi, useAuth, useRealtime, …
        ├── layouts/default.vue
        └── plugins/pocketbase.ts # PocketBase JS SDK setup
```

## Tech Stack

| Layer | Technology |
|---|---|
| Backend language | Go 1.25 |
| Backend framework | PocketBase v0.36 (embedded SQLite, REST, realtime SSE) |
| HTTP routing | PocketBase router + Gin (worker server only) |
| Database | SQLite via PocketBase |
| Git operations | `go-git/go-git/v5` |
| Docker client | `docker/docker` (Engine API v28) |
| WebSocket | `gorilla/websocket` |
| Encryption | AES-GCM via `golang.org/x/crypto` |
| Scheduler | `robfig/cron/v3` |
| Frontend | Nuxt 4 (Vue 3), SSR disabled — static SPA |
| UI library | `@nuxt/ui` v4 (Tailwind + Headless UI) |
| Frontend–backend comms | PocketBase JS SDK + custom REST calls |
