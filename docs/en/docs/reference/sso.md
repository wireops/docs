Home: [[Home]]

# SSO (OIDC)

wireops supports logging in via any OIDC-compatible identity provider — Keycloak, Authentik, Zitadel, Okta, and others — as an alternative to email/password. Once configured, a **"Continue with [name]"** button appears on the login page next to the standard form.

## Setup

Set these on the **server**:

| Variable | Required | Description |
|---|---|---|
| `OIDC_CLIENT_ID` | **Yes** (to enable) | OAuth2 Client ID from your identity provider |
| `OIDC_CLIENT_SECRET` | **Yes** (to enable) | OAuth2 Client Secret |
| `OIDC_AUTH_URL` | **Yes** (to enable) | Authorization endpoint of your IdP |
| `OIDC_TOKEN_URL` | **Yes** (to enable) | Token endpoint of your IdP |
| `OIDC_USER_INFO_URL` | No | UserInfo endpoint. If omitted, user data is read from the `id_token` claims |
| `OIDC_DISPLAY_NAME` | No | Label shown on the login button (default: `SSO`) |

> **Special characters:** if `OIDC_CLIENT_SECRET` (or any value) contains characters like `$`, `%`, `*`, `!`, wrap it in **single quotes** in your `.env` file — otherwise `godotenv` may try to interpret them:
> ```bash
> OIDC_CLIENT_SECRET='my$ecret!@#%'
> ```

The **redirect/callback URL** to register in your identity provider is:

```
https://your-wireops-domain.com/api/oauth2-redirect
```

## Provider example (Authentik)

```bash
OIDC_CLIENT_ID=wireops
OIDC_CLIENT_SECRET=your-secret
OIDC_AUTH_URL=https://authentik.example.com/application/o/wireops/authorize/
OIDC_TOKEN_URL=https://authentik.example.com/application/o/token/
OIDC_USER_INFO_URL=https://authentik.example.com/application/o/userinfo/
OIDC_DISPLAY_NAME=Authentik
```

The same shape works for Keycloak, Zitadel, Okta, or any other standards-compliant OIDC provider — just swap in that provider's endpoints.

## The one thing to get right before you rely on it

> [!WARNING]
> **SSO and the initial admin account**
>
> If you log in via SSO using the **exact same email address** you used to create wireops's very first admin account, wireops automatically links your local account to that SSO identity.
>
> From that point on, the wireops frontend **forcibly overrides your local role** with whatever role your identity provider assigns you. If your IdP maps that account to something lesser (like `viewer`), you lose admin access inside wireops — the IdP wins, not the local account.
>
> **Before logging in via SSO with your admin email**, make sure that email is mapped to the `admin` role on the IdP side. Otherwise you can lock yourself out of your own instance.

See [[Access-Control-and-Audit]] for how roles and capabilities work more broadly.
