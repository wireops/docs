# Caddy

The Caddy integration discovers routes managed by Caddy Docker Proxy and adds an **Open** action for their configured hosts. It only creates links; Caddy remains responsible for routing and certificates.

## Configure

Enable **Caddy** in **Settings → Integrations** and choose:

| Field | Default | Description |
| --- | --- | --- |
| Scheme | `https` | Scheme used in generated links. |
| Port | empty | Optional port. Standard `80` and `443` are omitted. |
| Wildcard Hosts | off | Allow hosts such as `*.example.com` to become links. |
| Local Hosts | on | Allow `localhost`, `.local` and private/local addresses. Turn it off when operators should not receive local-network links. |

## Label a service

Use standard Caddy Docker Proxy site labels. The integration examines `caddy`, `caddy_0`, `caddy_1`, and so on.

```yaml
services:
  app:
    image: ghcr.io/example/app:1.0
    labels:
      caddy: app.example.com
      caddy.reverse_proxy: "{{upstreams 8080}}"
```

Deploy the stack and select **Open** on the container. If there are several site labels, wireops can add several actions.

## Check and secure

- Keep wildcard hosts disabled unless an operator can resolve and safely use them.
- Disable local hosts for a shared control plane exposed outside your private network.
- Validate the link after Caddy has loaded the route; this integration does not inspect Caddy's runtime state.
