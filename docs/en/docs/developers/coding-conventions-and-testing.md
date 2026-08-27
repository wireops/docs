Home: [[Home]]

# Coding Conventions & Testing

This page is for anyone contributing code to wireops — what patterns to follow and how quality gets maintained.

## How the codebase is organized

The backend groups things by responsibility: API handlers live together by domain (stacks, workers, jobs, users), so if you're changing how a stack behaves, there's one obvious place to look. The database schema evolves through an append-only series of migration files — once a migration is written, it's never edited again; a schema change always means adding a new one. That keeps history honest: you can always tell what the database looked like at any point by replaying migrations in order.

The frontend follows Nuxt's own convention — pages map to files, and logic that's shared across pages lives in composables rather than being copy-pasted around.

## A few rules worth knowing

- **Secrets never touch disk unencrypted.** Anything sensitive gets encrypted before it's stored, full stop.
- **Any file path that comes from user input gets validated before it's used**, to rule out path traversal (someone trying to read or write outside where they should be able to).
- **Test names are readable, not snake_case** — `TestUserCanRollback`, not `Test_user_can_rollback`.
- **Test doubles for the frontend avoid inline HTML template strings.** It's not a style preference — the static analysis tooling (Codacy) flags any raw HTML string as a potential XSS risk even in test-only mock components with zero real user input, so writing stubs a different way avoids a false alarm entirely rather than fighting with it every time.

## Philosophy on tests

wireops runs at hobby/side-project pace, so testing here isn't about hitting an arbitrary number — it's about making sure the logic that's easy to get subtly wrong (parsing, reconciliation, permission checks, encryption) actually has something exercising it. Thin glue code — routes wiring, migrations — isn't expected to carry the same weight.

Coverage is tracked and reported (uploaded to Codacy on every change) but isn't a merge gate — it's informational, a signal rather than a wall. The backend sits around a quarter statement coverage overall, unevenly: some packages are essentially fully covered, others thin. The frontend sits noticeably higher, closer to two-thirds.

The expectation isn't "go backfill everything to some percentage" — it's that coverage should trend upward over time, not just avoid getting worse. In practice that means: when you're already touching a piece of code, it's a good moment to also cover a nearby branch that isn't tested yet, especially the error paths and edge cases that are easy to skip when writing the happy path. And when you write something genuinely new — a handler, a composable, a component with real logic in it — it should ship with at least one test covering its main path and one obvious edge case, in the same change rather than as a follow-up that may never happen.
