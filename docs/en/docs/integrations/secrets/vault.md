# HashiCorp Vault

The Vault integration resolves secret environment variables from a Vault **KV v2** secrets engine at deployment time. wireops stores a reference, not the secret value, in its configuration.

## Configure

Enable **Vault** in **Settings → Integrations**.

| Field | Required | Description |
| --- | --- | --- |
| Vault Address | Yes | Base URL of your Vault server, such as `https://vault.example.com:8200`. |
| Token | Yes | Token with read access to the required KV v2 paths. |
| Limit to Mount | No | Limits the UI browser to one KV v2 mount, for example `secret`. |

Use **Test Connection** before saving the token for production use.

## Use a secret

When creating a secret environment variable, select the `vault` provider and choose or enter a reference in this format:

```
<mount>/data/<path>#<field>
```

For example, `secret/data/apps/api#DATABASE_URL` retrieves the `DATABASE_URL` field at deploy time.

## Security

Use a policy scoped to the smallest mount and paths needed. Rotate the token through Vault and update the integration when it changes. Do not give wireops Vault admin privileges.
