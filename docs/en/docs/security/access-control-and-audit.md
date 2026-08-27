Home: [[Home]]

# Access Control, Policy & Audit

wireops layers several independent safety mechanisms on top of each other: who's allowed to do what, what a worker is allowed to run, how secrets are protected, and a record of who did what. They're separate systems that each answer a different question.

## Roles: who can do what

There are four roles, each one a superset of the one before it:

- **viewer**: can look, can't touch.
- **operator**: can also sync, rollback, and manage day-to-day stack operations.
- **admin**: full control, including settings, security policy, and user management.
- **monitoring**: a special role scoped only to the metrics endpoint. It doesn't slot into the viewer→admin ladder; it exists purely for scrape/monitoring integrations that shouldn't have any other access.

Every action in the app is gated by a *capability* (e.g. "can view stacks," "can manage security settings") rather than a raw role check. That indirection is what lets the monitoring role exist as a narrow side-door instead of needing to fit into the main hierarchy.

## Deploy policy: what a worker is allowed to run

Even with the right role, you might not want *any* compose file to be deployable as-is. Someone could commit a stack that mounts the Docker socket or runs privileged containers. Worker policy is the guardrail for that: a global default plus optional per-worker overrides, covering both allowlists (volumes, networks, images, capabilities, devices) and outright blocks (privileged mode, host networking/PID/IPC, the Docker socket, "latest" tags). It's enforced on both stack deploys and [scheduled job](../reference/jobs.md) dispatches. See [Deploy Policy](../reference/policies.md) for the full allowlist/flag reference and inheritance rules.

## Protecting secrets

Secrets show up in two different shapes in wireops, and they're handled differently:

**Per-variable secrets**: an individual environment variable marked as a secret. You choose where it actually lives when you create it:
- **internal**: encrypted and stored directly in wireops's own database.
- **Vault** or **Infisical**: wireops stores only a reference (like a path and field name). The real value stays in your external secrets manager and gets resolved at deploy time.

Once you've picked a backend for a given secret, it's locked. Switching means deleting and recreating it, not editing it in place. And if a stack references a Vault/Infisical secret but that backend gets disabled, wireops catches it before deploying rather than failing partway through.

**SOPS+age secrets**: a completely different, file-based mechanism for when you want secrets to live *in your Git repo* (encrypted) rather than in the wireops database at all. Every repository automatically gets its own encryption keypair the moment it's added. You (or your CI) encrypt a `secrets.yaml` file using that repo's public key and commit it next to your compose file, and wireops decrypts it automatically on every sync, layering those values on top of your stack's other env vars. Nobody, not even an admin browsing the UI, ever sees the decrypted values; they're injected straight into the deploy. If a key ever needs rotating, that's a deliberate, explicit action, since it makes any secrets encrypted under the old key unreadable until they're re-encrypted.

## The audit log

Every meaningful action (who did it, what they did, what it affected, whether it succeeded) gets recorded to an audit log, viewable and filterable from the UI (by admins). It's kept for a configurable window and cleaned up automatically after that, so it doesn't grow forever.

## Logging in via SSO

wireops supports logging in through any OIDC provider (Keycloak, Authentik, Okta, etc.) alongside the normal email/password form. See [SSO](../reference/sso.md) for setup and an important warning about the initial admin account.

## Backups

Backup/restore is covered in full in [Disaster Recovery](../operations/disaster-recovery.md). In short, it's the same underlying mechanism regardless of role, but *uploading* an existing backup file requires a genuine superuser session (not just a wireops admin role), since accepting an arbitrary file as a restore target is a much bigger trust decision than the everyday admin actions.
