# Notification events

Each notification integration has an **Events** selector. Enable only the events your team can act on:

| Event | When it is sent |
| --- | --- |
| `sync.started` | A stack reconciliation starts. |
| `sync.done` | A reconciliation and deployment finish successfully. |
| `sync.error` | A reconciliation, validation or deployment fails. |
| `sync.test` | You select **Send Test** in an integration's settings. |

Configure delivery one channel at a time, then use **Send Test** before relying on it. A test confirms that wireops can reach the destination; it does not replace checking the recipient's permissions and alert-routing rules.

- [Webhook](notifications/webhook.md)
- [Discord](notifications/discord.md)
- [Slack](notifications/slack.md)
- [ntfy](notifications/ntfy.md)
