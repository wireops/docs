Home: [[Home]]

# MCP Server

wireops ships a separate, optional server that lets AI coding assistants (Claude Code, Cursor, and similar tools) talk to your wireops instance directly. Ask "what stacks are failing right now," "show me the sync logs for this stack," or even "scaffold a new stack for this app," instead of copy-pasting things back and forth manually.

## How it fits together

It's a small standalone binary (`wireops-mcp`) that sits between your AI assistant and your wireops server. It doesn't hold any credentials of its own: every request carries your own wireops API key, so whatever that key is allowed to do in wireops is exactly what the assistant can do. Give it a read-only "viewer" key if you just want it answering questions, or give it more if you want it acting on your behalf.

Most of what it exposes is read-only: stacks, workers, [scheduled jobs](jobs.md) and their run history, repositories, revision history, audit logs, which secret keys exist (never their values), and general system info. A handful of tools generate a manifest for you to review, such as a `wireops.yaml`, a `job.yaml`, or a scaffolded stack (compose file + manifest pair), but none of them write anything to disk or commit anything to Git on their own. You always stay the one who reviews and commits.

Generated stacks aren't just handed back blind, either. Pass a `worker_id` to the scaffolding tool and it validates the generated compose file against that worker's effective [deploy policy](policies.md) first, so you don't get handed something that would just be rejected on the first real deploy.

## Setting it up

Run it as its own small container:

```bash
docker run -d --name wireops-mcp -p 8091:8091 \
  -e SERVER_URL=http://wireops-host:8090 \
  ghcr.io/wireops/wireops-mcp:1.0.0
```

Then create a service account in wireops (Settings → Service Accounts) with whatever role you're comfortable an assistant having, and generate an API key for it.

## Connecting Claude Code

```bash
claude mcp add --transport http wireops http://localhost:8091/mcp \
  --header "X-Wireops-Api-Key: wireops_sk_your_api_key_here"
```

The command above writes the key in plain text to Claude Code's config file (`.mcp.json`) and to your shell history. Prefer exporting `WIREOPS_API_KEY` from a secrets manager and referencing it as `${WIREOPS_API_KEY}` in `.mcp.json` instead of pasting the literal key, especially if that file is checked into a repository.

Run `claude mcp list` to confirm it's connected, then just ask Claude things like "list my stacks" or "why did the last sync on X fail." It discovers the available tools on its own.

Other MCP-compatible clients (Cursor, Windsurf, the MCP Inspector, custom integrations) can connect the same way, pointing at the wireops-mcp URL with the same API key header. Most of them use the same config shape shown above, with only minor naming differences. `http://` is fine on localhost or a private network; if the client reaches wireops-mcp over an untrusted network, put TLS in front of it (e.g. a reverse proxy) and connect over `https://` instead, since the API key travels in a plain header.

As with any API key, keep it out of anything that lands in Git. Pull it from a secrets manager or an env var at runtime instead.

## Fleet observation and compatibility

`get_stack_status` combines the persisted stack record with an **on-demand** `health` observation. These are deliberately different signals: `status` is the result of the most recent sync/deploy, while `health` is what Docker reports for the deployed revision now. A health read never starts a reconcile, polling loop, external probe or alert.

Health is `healthy`, `degraded`, `unhealthy`, `starting`, or `unknown`, and includes the observation time plus counts of unhealthy, missing and starting services. It evaluates the services expected by the deployed revision, ignores scale-zero services, and treats a completed init service (the `customization.init` label, exit code 0) as healthy. An offline worker, a missing deployed revision, or an inspection failure produces `unknown` with a reason instead of an optimistic result.

For a compact fleet-wide view, use `get_inventory`. It pages stacks (50 by default, 200 maximum) and accepts a worker id/hostname and group filter. Each item includes its worker version and capabilities, current services, health and resources. It limits worker commands to five in parallel, five seconds each and 25 seconds for the whole collection, so one unreachable worker leaves an annotated item instead of hiding every other result. Network identity is `(worker_id, network.id)`; equal Docker network names on different workers are not a shared network.

`get_stack_resources` and inventory resources include named volumes, bind mounts and networks attached to the actual containers, including externally-managed networks. An empty result with `partial: false` is a confirmed empty inventory. `partial: true` and `warnings` mean that some inspection was unavailable; retain the returned data, but do not infer that missing resources do not exist. A worker without `resource_inventory_v1` is always reported as partial until updated. Bind mounts and external networks have been discovered since v1.0.8, but this capability is the worker's explicit confirmation that the complete inventory contract is supported.

Workers advertise capabilities in their normal heartbeat. `resource_inventory_v1` confirms complete resource inventory, `container_logs_filter_v1` enables server-validated temporal/container log filtering, and `exec_one_shot_v1` enables one-shot execution. During a rolling upgrade, basic resource/log reads continue to work where possible; time-bounded logs and one-shot exec return a clear `409` naming the capability required rather than silently changing semantics.

## Logs, aliases, and execution

`get_container_logs` accepts `since` and `until` as RFC3339 timestamps with a timezone, Unix timestamps, or a positive relative duration such as `30m`. The server resolves relative values against one reference time, validates the interval and regex, then selects the time window and tail before applying `pattern`. It examines at most 1 MiB and returns at most 64 KiB; `truncated` and `truncation_reason` say when either limit was hit. There is intentionally no log-level filter because Docker container logs do not have a uniform level format.

For ergonomic calls, every stack-targeting tool accepts `stack` as an alias for `stack_id`. Container tools accept `container_name` for the real Docker container name inside that stack; `service_name` remains a service selector and cannot choose among multiple replicas. Log tools also accept `lines` for `tail` and `search` for `pattern`. Passing a canonical field and its alias with the same value is fine; conflicting values are rejected. Unknown fields remain rejected.

## Refreshing a stack definition from Git

For a stack created from a compose file's `x-wireops` block (or the legacy standalone `wireops.yaml`), edit and commit the definition first, then call `resync_stack_definition`. The server fetches that exact repository revision, validates the definition, and returns `changed_fields` with the persisted before/after values. It never accepts configuration values from the MCP request and does **not** deploy containers; call `deploy_stack` when you are ready to apply the new compose revision.

This is the supported way to change a file-managed stack's `timeout` after creation. `timeout` is a Go duration such as `3m`; when omitted, the stack uses the server's `DEPLOY_TIMEOUT` default (five minutes). It bounds only `docker compose up`; image pulling has the independent `PULL_TIMEOUT` budget (30 minutes by default). Generic stack updates remain unable to alter Git-managed definition fields.

`exec_in_container` is one predictable operation: it returns `cmd`, `stdout`, `stderr`, `exit_code`, and `timed_out`. It does not open a terminal, poll a transcript, or add a marker-command fallback. If the worker lacks `exec_one_shot_v1` (available since v1.0.13), the `409` response tells you to update it. On timeout, partial output is preserved and `exit_code` is unknown (`null`).

## Commit and secret diagnostics

Stack diagnostics expose `deployed_commit`, `desired_commit`, `last_error_commit`, and the expanded repository's `last_commit_sha`. They answer different questions: `deployed_commit` is the revision successfully running; `desired_commit` is the last revision rendered for that stack; `last_commit_sha` is the most recently known repository head; and `last_error_commit` is the specific attempted revision that failed. Historical errors are intentionally left without a guessed commit. A later success clears the last-error fields.

`list_secrets` is a key-name inventory, never a value reader. `stack_secrets` contains direct stack env-var records flagged `secret`; `global_secrets` contains secret global env vars bound to this stack; and `sops_secrets` contains only the keys parsed from the repository's SOPS `secrets.yaml` when available. `secret_count` counts the first two record groups only, not SOPS keys. `non_secret_keys` and `non_secret_count` cover only direct, non-secret stack env vars; they do not represent repository `.env`, global non-secret bindings, or decrypted SOPS values.
