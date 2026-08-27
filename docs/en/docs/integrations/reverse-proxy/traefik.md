# Traefik

The Traefik integration reads HTTP router host rules from a container and adds an **Open** action in wireops. It does not configure Traefik or expose ports; Traefik must already route the application.

## Configure

In **Settings → Integrations → Traefik**, enable the integration and set:

| Field | Required | Description |
| --- | --- | --- |
| Scheme | No | URL scheme for generated links. Defaults to `https`. |
| Port | No | Port appended to generated links. Leave empty for the scheme default; `80` and `443` are omitted. |

## Label a service

wireops reads `traefik.http.routers.<router>.rule` and recognizes `Host(...)` values.

```yaml
services:
  app:
    image: ghcr.io/example/app:1.0
    labels:
      traefik.enable: "true"
      traefik.http.routers.app.rule: Host(`app.example.com`)
```

After the stack is deployed, open the container details and use **Open**. Use a host reachable from the browser running wireops; the label is not a DNS or TLS configuration.

## Check and secure

- Test with a known HTTPS host first.
- A rule may contain multiple hosts; wireops adds an action for each valid host.
- Keep Traefik's dashboard and Docker socket permissions separately protected.
