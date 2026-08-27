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
  ghcr.io/wireops/wireops-mcp:latest
```

Then create a service account in wireops (Settings → Service Accounts) with whatever role you're comfortable an assistant having, and generate an API key for it.

## Connecting Claude Code

```bash
claude mcp add --transport http wireops http://localhost:8091/mcp \
  --header "X-Wireops-Api-Key: wireops_sk_your_api_key_here"
```

Run `claude mcp list` to confirm it's connected, then just ask Claude things like "list my stacks" or "why did the last sync on X fail." It discovers the available tools on its own.

Other MCP-compatible clients (Cursor, Windsurf, the MCP Inspector, custom integrations) can connect the same way, pointing at the wireops-mcp URL with the same API key header. Most of them use the same config shape shown above, with only minor naming differences. `http://` is fine on localhost or a private network; if the client reaches wireops-mcp over an untrusted network, put TLS in front of it (e.g. a reverse proxy) and connect over `https://` instead, since the API key travels in a plain header.

As with any API key, keep it out of anything that lands in Git. Pull it from a secrets manager or an env var at runtime instead.
