# Integrations

Integrations connect wireops to the tools already operating around your Docker Compose stacks. Configure them in **Settings → Integrations**. Each page below documents the exact fields, labels, credentials and validation steps for one integration.

## Reverse proxies and logs

| Integration | Purpose |
| --- | --- |
| [Traefik](reverse-proxy/traefik.md) | Adds an **Open** action from Traefik router labels. |
| [Caddy](reverse-proxy/caddy.md) | Adds **Open** actions from Caddy Docker Proxy labels. |
| [Nginx Proxy Manager](reverse-proxy/nginx-proxy-manager.md) | Adds **Open** and optional **NPM Admin** actions from wireops proxy-hint labels. |
| [Dozzle](logging/dozzle.md) | Adds a direct link to each container's Dozzle logs. |

## Notifications

Notification integrations deliver the events selected in their configuration. See [notification events](notifications.md) for the event meanings.

| Integration | Purpose |
| --- | --- |
| [Webhook](notifications/webhook.md) | Sends signed HTTP event payloads to an endpoint you control. |
| [Discord](notifications/discord.md) | Sends deployment messages to a Discord channel. |
| [Slack](notifications/slack.md) | Sends deployment messages to a Slack channel. |
| [ntfy](notifications/ntfy.md) | Publishes push notifications to ntfy.sh or a self-hosted ntfy server. |

## Secrets, backups and source control

| Integration | Purpose |
| --- | --- |
| [HashiCorp Vault](secrets/vault.md) | Resolves environment-variable secrets from Vault KV v2. |
| [Infisical](secrets/infisical.md) | Resolves environment-variable secrets through an Infisical Machine Identity. |
| [SOPS + age](secrets/sops.md) | Decrypts a repository's encrypted `secrets.yaml`; always enabled. |
| [S3-compatible storage](storage/s3.md) | Mirrors local backups to S3, R2, MinIO, B2, and compatible providers. |
| [GitHub OAuth](source-control/github.md) | Lets an operator browse and select GitHub repositories in the UI. |

Secrets and credentials entered here are kept out of Compose files. Limit every token to only the paths, project, bucket or channel it needs.
