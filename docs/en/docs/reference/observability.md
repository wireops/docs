Home: [[Home]]

# Observability

Wireops exposes a single **operational port** (`PORT`, default `8090`) for the UI, REST API, and Prometheus metrics. Remote workers connect on a separate **worker port** (`TLS_WORKER_PORT`, default `8443`) — scrapers should not target that port.

| Port | Purpose |
|---|---|
| `PORT` (8090) | UI, `/api/custom/*`, `GET /metrics` |
| `TLS_WORKER_PORT` (8443) | Worker WebSocket and registration only |

## Metrics

| Endpoint | Description |
|---|---|
| `GET /metrics` | Aggregated worker metrics (canonical scrape path) |
| `GET /api/custom/metrics` | Alias of `/metrics` |
| `GET /api/custom/workers/{id}/metrics` | Metrics from a single connected worker |

**Authentication:** create a **service account** with role `monitoring` (Settings → Service Accounts), generate an **API key**, and send it on every scrape via the `X-Wireops-Api-Key` header. Requests without a valid key receive `401`; keys tied to roles below `monitoring` receive `403`.

**Quick test:**

```bash
curl -H "X-Wireops-Api-Key: wireops_sk_..." http://localhost:8090/metrics
```

### Prometheus (`prometheus.yml`)

Prometheus must send `X-Wireops-Api-Key` (not `Authorization: Bearer`). Use `http_headers` (Prometheus **2.45+**):

```yaml
scrape_configs:
  - job_name: wireops
    metrics_path: /metrics
    scheme: http
    scrape_interval: 30s
    static_configs:
      - targets:
          - wireops-host:8090   # PORT — same host/port as the UI
    http_headers:
      X-Wireops-Api-Key:
        values:
          - wireops_sk_your_api_key_here

    # Optional: skip TLS verification only when APP_URL uses a self-signed cert
    # tls_config:
    #   insecure_skip_verify: true
```

When `APP_URL` uses HTTPS, set `scheme: https` and point `targets` at the same host/port users open in the browser (for example `wireops.example.com:443`).

Prefer injecting the API key from your secrets manager or an env-expanded config file instead of committing it to git.

### Grafana Agent / Alloy (alternative)

```hcl
prometheus.scrape "wireops" {
  targets      = [{ __address__ = "wireops-host:8090" }]
  forward_to   = [prometheus.remote_write.default.receiver]
  metrics_path = "/metrics"
  scheme       = "http"

  authorization {
    type             = "Header"
    credentials_file = "/etc/wireops/api-key"
  }
}
```

Store the header line in `credentials_file`:

```text
X-Wireops-Api-Key: wireops_sk_...
```
