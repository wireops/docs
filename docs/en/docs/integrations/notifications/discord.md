# Discord

The Discord integration posts selected wireops events to a Discord channel through an incoming webhook.

## Configure

Enable **Discord** in **Settings → Integrations**.

| Field | Required | Description |
| --- | --- | --- |
| Discord Webhook URL | Yes | Incoming webhook URL created for the target channel. |
| Username | No | Display name used for messages. |
| Avatar URL | No | Image URL used as the webhook avatar. |
| Mention on Errors | No | Mention a role when `sync.error` is delivered. |
| Role ID | With mentions | Numeric Discord role ID to mention. |
| Events | Yes | Events delivered to the channel. |

Use **Send Test** after saving. For error mentions, test with a non-production channel or verify the role's mention permission first.

## Security

Treat a Discord webhook URL as a credential: anyone who has it can post to the channel. Restrict the channel audience, rotate a leaked webhook, and avoid forwarding secrets in deployment output.
