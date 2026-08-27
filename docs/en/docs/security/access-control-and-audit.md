Home: [[Home]]

# Access Control, Policy & Audit

wireops layers several independent safety mechanisms on top of each other: who's allowed to do what, what a worker is allowed to run, how secrets are protected, and a record of who did what. They're separate systems that each answer a different question.

## Who can do what — roles

There are four roles, each one a superset of the one before it:

- **viewer** — can look, can't touch.
- **operator** — can also sync, rollback, and manage day-to-day stack operations.
- **admin** — full control, including settings, security policy, and user management.
- **monitoring** — a special role scoped only to the metrics endpoint. It doesn't slot into the viewer→admin ladder; it exists purely for scrape/monitoring integrations that shouldn't have any other access.

Every action in the app is gated by a *capability* (e.g. "can view stacks," "can manage security settings") rather than a raw role check — that indirection is what lets the monitoring role exist as a narrow side-door instead of needing to fit into the main hierarchy.

## What a worker is allowed to run — deploy policy

Even with the right role, you might not want *any* compose file to be deployable as-is — someone could commit a stack that mounts the Docker socket or runs privileged containers. Worker policy is the guardrail for that.

There's a global default policy, and each worker can optionally override it. The policy can:

- Block dangerous container settings outright: privileged mode, host networking, host PID/IPC namespaces, mounting the Docker socket, host volume mounts.
- Restrict what's allowed via allowlists — specific volumes, networks, images, added capabilities, devices. Leave a list empty and everything's allowed; add one entry and it becomes a strict allowlist from then on.
- Block "latest" image tags, to nudge toward pinned, reproducible deploys.
- Gate whether render overrides (see [[Business-Flows]]) can be applied at all.

A worker without its own override just inherits the global policy — so you set sane defaults once and only carve out exceptions where you need them. Overrides applied at render time still pass through the same policy checks, so they can't be used to sneak past a block.

## Protecting secrets

Secrets show up in two different shapes in wireops, and they're handled differently:

**Per-variable secrets** — an individual environment variable marked as a secret. You choose where it actually lives when you create it:
- **internal** — encrypted and stored directly in wireops's own database.
- **Vault** or **Infisical** — wireops stores only a reference (like a path and field name); the real value stays in your external secrets manager and gets resolved at deploy time.

Once you've picked a backend for a given secret, it's locked — switching means deleting and recreating it, not editing it in place. And if a stack references a Vault/Infisical secret but that backend gets disabled, wireops catches it before deploying rather than failing partway through.

**SOPS+age secrets** — a completely different, file-based mechanism for when you want secrets to live *in your Git repo* (encrypted) rather than in the wireops database at all. Every repository automatically gets its own encryption keypair the moment it's added. You (or your CI) encrypt a `secrets.yaml` file using that repo's public key and commit it next to your compose file; wireops decrypts it automatically on every sync and layers those values on top of your stack's other env vars. Nobody — not even an admin browsing the UI — ever sees the decrypted values; they're injected straight into the deploy. If a key ever needs rotating, that's a deliberate, explicit action, since it makes any secrets encrypted under the old key unreadable until they're re-encrypted.

## The audit log

Every meaningful action — who did it, what they did, what it affected, whether it succeeded — gets recorded to an audit log, viewable and filterable from the UI (by admins). It's kept for a configurable window and cleaned up automatically after that, so it doesn't grow forever.

## Logging in via SSO

wireops supports logging in through any OIDC provider (Keycloak, Authentik, Okta, etc.) alongside the normal email/password form — see [[SSO]] for setup and an important warning about the initial admin account.

## Backups

Backup/restore is covered in full in [[Disaster-Recovery]] — briefly, it's the same underlying mechanism regardless of role, but *uploading* an existing backup file requires a genuine superuser session (not just a wireops admin role), since accepting an arbitrary file as a restore target is a much bigger trust decision than the everyday admin actions.
