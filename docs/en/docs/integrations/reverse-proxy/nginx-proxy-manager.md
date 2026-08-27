# Nginx Proxy Manager

Nginx Proxy Manager (NPM) does not expose route labels on application containers in the same way as Traefik. Add a wireops proxy hint to generate an **Open** action. Optionally configure the NPM UI URL to add an **NPM Admin** action.

## Configure

Enable **Nginx Proxy Manager** in **Settings → Integrations**.

| Field | Default | Description |
| --- | --- | --- |
| Scheme | `https` | Default scheme for hosts without a scheme hint. |
| Port | empty | Optional port for generated links; standard `80`/`443` are omitted. |
| Admin URL | empty | NPM administration URL; adds an **NPM Admin** action. |
| Local Hosts | on | Allow local/private hosts in generated actions. |

## Label a service

Use one host or a comma-separated list. Both `npm` and generic `proxy` prefixes are supported.

```yaml
services:
  app:
    image: ghcr.io/example/app:1.0
    labels:
      dev.wireops.npm.host: app.example.com
      # Or: dev.wireops.proxy.hosts: app.example.com,admin.example.com
      # Optional: dev.wireops.npm.scheme: http
```

Deploy, then select **Open** on the container. The hint documents the host already configured in NPM; it does not create an NPM proxy host.

## Check and secure

- Set an Admin URL only if users of wireops are allowed to reach NPM's administration UI.
- Disable local hosts on shared or internet-facing wireops instances.
- Keep the host label aligned with the NPM proxy-host configuration to avoid stale links.
