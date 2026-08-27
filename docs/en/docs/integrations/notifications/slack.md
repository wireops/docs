# Slack

The Slack integration sends selected wireops events to a Slack channel through an incoming webhook.

## Configure

Enable **Slack** in **Settings → Integrations**.

| Field | Required | Description |
| --- | --- | --- |
| Slack Webhook URL | Yes | Incoming webhook URL for the target channel. |
| Mention on Errors | No | Add the configured mention when `sync.error` is sent. |
| Mention Text | With mentions | Slack mention syntax, such as `<!subteam^S123456|deploys>`. |
| Events | Yes | Events delivered to the channel. |

Save and select **Send Test**. Confirm the app is installed in the intended channel and that an error mention reaches the expected audience.

## Security

Keep the webhook URL out of repositories and logs. Use a dedicated channel with an explicit retention policy when deployment metadata must not be broadly visible.
