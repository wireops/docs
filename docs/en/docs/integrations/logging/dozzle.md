# Dozzle

Dozzle provides a browser-based Docker log viewer. When enabled, wireops adds a **Dozzle Logs** action for each container, linking to that container in your Dozzle instance.

## Configure

Enable **Dozzle** in **Settings → Integrations** and provide the required **Dozzle URL**, for example `https://logs.example.com`.

No Compose labels are needed. The link generated for a container is `{Dozzle URL}/container/{container ID}`.

## Validate

1. Open the Dozzle URL directly and confirm the same Docker host is visible.
2. Deploy or refresh a stack in wireops.
3. Open a container and select **Dozzle Logs**.

If the action opens but no logs are shown, correct Dozzle's own Docker/remote-agent connectivity. wireops only builds the browser link.

## Security

Dozzle can reveal application output, which may contain sensitive values. Protect it with authentication, restrict network access, and avoid logging secrets.
