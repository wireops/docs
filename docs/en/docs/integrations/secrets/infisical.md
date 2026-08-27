# Infisical

The Infisical integration resolves secret environment variables using an Infisical Machine Identity with Universal Auth. wireops stores secret references and retrieves the values during deployment.

## Configure

Enable **Infisical** in **Settings → Integrations**.

| Field | Required | Description |
| --- | --- | --- |
| Site URL | No | Infisical API/UI URL. Leave empty for Infisical Cloud. |
| Client ID | Yes | Machine Identity client ID. |
| Client Secret | Yes | Machine Identity client secret. |
| Limit to Project | No | Restricts browsing and selection to one project ID. |

Select **Test Connection** after entering the identity. The identity must be allowed to read the target project, environment and paths.

## Use a secret

When adding a secret environment variable, select the `infisical` provider and select the project, environment, path, key and optional field made available by the integration.

## Security

Use a dedicated Machine Identity for wireops and grant read-only access to a limited project/path. Rotate its secret according to your Infisical policy and avoid using a personal user token.
