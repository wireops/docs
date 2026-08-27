# ntfy

The ntfy integration publishes selected wireops events to an ntfy topic. It works with the public `ntfy.sh` service or a self-hosted ntfy server.

## Configure

Enable **ntfy** in **Settings → Integrations**.

| Field | Required | Description |
| --- | --- | --- |
| Server URL | Yes | ntfy server URL, for example `https://ntfy.sh`. |
| Topic | Yes | Topic to publish to. |
| Username | No | Username for an authenticated server. |
| Password | No | Password or access token for that user. |
| Custom Template | No | Go-template text for the message body. |
| Events | Yes | Events delivered to the topic. |

Select **Send Test** after saving, then subscribe to the topic on the intended device. A private topic needs matching server access controls and subscriber credentials.

## Security

Use an unguessable topic and authentication for non-public notifications. Treat topic names and message content as potentially observable metadata; do not include secrets in templates or sync logs.
