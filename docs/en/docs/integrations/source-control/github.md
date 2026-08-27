# GitHub OAuth

GitHub OAuth lets an authenticated wireops operator browse and select repositories while adding one. It does not replace repository deploy credentials: wireops still uses the configured repository access method to clone and sync.

## Configure the server

Create a GitHub OAuth App and set its callback URL to your wireops instance. Then configure these server environment variables and restart wireops:

| Variable | Required | Description |
| --- | --- | --- |
| `GITHUB_OAUTH_CLIENT_ID` | Yes | OAuth App client ID. |
| `GITHUB_OAUTH_CLIENT_SECRET` | Yes | OAuth App client secret. |

The GitHub card becomes available automatically once both variables are set. It is managed by server configuration, so it cannot be toggled in the UI.

## Connect and validate

1. Open **Settings → Integrations → GitHub**.
2. Select **Connect GitHub** and approve only the organization/repository access needed.
3. Confirm the connected GitHub account, then select **Test Connection**.
4. Add a repository and confirm it appears in the picker.

## Security

Use a dedicated OAuth App for each wireops environment. Keep the callback URL exact, protect the client secret, and review organization access regularly. Revoke the GitHub authorization if the operator or wireops instance should no longer browse repositories.
