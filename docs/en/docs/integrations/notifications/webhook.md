# Webhook

Webhook is the general-purpose notification integration. It sends an HTTP POST for each selected event to an endpoint you operate.

## Configure

Enable **Webhook** in **Settings → Integrations**.

| Field | Required | Description |
| --- | --- | --- |
| Webhook URL | Yes | HTTPS endpoint that receives wireops events. |
| HMAC Secret | No | Shared secret used to sign the payload with HMAC-SHA256. |
| Headers | No | Additional request headers, such as a routing or API header. |
| Events | Yes | Lifecycle events to deliver. See [notification events](../notifications.md). |

## Validate

Save the settings and select **Send Test**. Confirm the receiver records the request and, when configured, verifies its HMAC signature before accepting it.

## Security

- Prefer an HTTPS endpoint and a long, unique HMAC secret.
- Verify the signature before parsing or acting on a payload.
- Do not place credentials in the URL or static headers when a signed endpoint can authenticate the request.
