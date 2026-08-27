# Adding an integration

Integrations are registered Go packages configured from **Settings → Integrations**. They can provide container actions, notifications, secret backends, storage backends, or source-control configuration.

## Build the integration

1. Create a package under `internal/integrations/<slug>` and register the implementation in `init()`.
2. Give it a stable slug, name, category, and any container actions it resolves from labels.
3. Add configuration handling only when it needs it: sensitive keys must be masked, encrypted keys must remain a subset of sensitive keys, and required keys must be validated before enablement.
4. Add a numbered PocketBase migration only when a default integration record must be seeded.
5. Add a UI icon, metadata, configuration modal, connection test, and user-facing documentation when appropriate.
6. Add package and route tests. Do not log credentials or make test fixtures depend on a live external service.

## Integration-specific behavior

- **Notifications** must validate their endpoint and implement delivery using the shared event payload.
- **Secret backends** implement the secret provider contract, validate references, and load configuration lazily.
- **Storage backends** implement the remote backup storage/key-management contract.
- **Container actions** must validate URLs derived from labels before exposing a clickable action.

Read the [repository layout](repository-layout.md), [coding conventions](coding-conventions-and-testing.md), and [integrations guide](../integrations/index.md) before opening a pull request. The current source of truth for implementation details is the [wireops repository](https://github.com/wireops/wireops/tree/main/internal/integrations).

