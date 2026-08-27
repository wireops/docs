Home: [[Home]]

# Architecture

wireops is split into two things that run separately: a **server** and one or more **workers**. This split exists for a simple reason — the server, which holds your Git credentials, secrets, and the web UI, should never need direct access to the Docker socket on every machine you're deploying to. Instead, the server tells a worker *what* to deploy, and the worker — running on the actual host — is the only thing that touches Docker there.

## The server

The server is the brain. It's a single binary that bundles:

- A web UI and REST API (what you actually click around in).
- A **sync scheduler** that periodically checks your Git repos for new commits.
- A **job scheduler** that fires off cron-based one-shot containers (see [[Business-Flows]]).
- A **worker connection hub** — a WebSocket endpoint that every worker stays connected to.

The server never runs `docker compose` or `docker run` itself. Every deployment and every scheduled job is dispatched as a command over that WebSocket connection to whichever worker owns the stack.

## The worker

The worker is a small, standalone agent you install on each host where you want stacks to run. It connects *out* to the server (so you don't need to open inbound ports to your Docker hosts), authenticates with a token, and then just waits for instructions: "deploy this compose file," "tear this down," "run this job." It executes the Docker command locally and reports the result back.

Because the worker initiates the connection, a host behind NAT or a firewall works fine — there's nothing for the server to reach into.

## How they talk

```
┌──────────────────────────────────────────────────┐
│                wireops Server                    │
│  ┌────────────┐  ┌──────────────┐  ┌──────────┐ │
│  │ Web UI/API │  │ Sync         │  │ Job      │ │
│  │            │  │ Scheduler    │  │ Scheduler│ │
│  └────────────┘  └──────────────┘  └──────────┘ │
│  ┌────────────────────────────────────────────┐  │
│  │        Worker connection hub                │  │
│  └────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────┘
              ↑ persistent, token-authenticated ↑
  ┌──────────────────────────────┐
  │   Worker (on your host)      │
  │   runs docker compose / run  │
  └──────────────────────────────┘
```

A worker registers once with a token, then keeps a long-lived, authenticated connection open. Over that connection the server pushes typed commands and the worker pushes back results and periodic heartbeats — so the server always knows which workers are online and healthy.

## Where Git and Docker fit in

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│   Frontend  │────▶│   Web UI/API │────▶│  Scheduler  │
└─────────────┘     └──────────────┘     └──────┬──────┘
                                                 │
                                                 ▼
                    ┌──────────────┐     ┌─────────────┐
                    │ Git Repos    │◀────│  Reconciler │
                    │ (cloned)     │     │  (compares  │
                    └──────────────┘     │   commits)  │
                                                 │
                                                 ▼
                                         ┌─────────────┐
                                         │   Worker →  │
                                         │   Docker    │
                                         └─────────────┘
```

The scheduler wakes up periodically, the reconciler clones/fetches each configured repo and checks if the latest commit differs from what's deployed, and if it does, the change flows down to a worker as a deploy command. The full step-by-step version of this is in [[Business-Flows]].

## The frontend

The web UI is a static single-page app — it's pre-built and shipped as plain files served directly by the server, not run as its own service. That keeps the deployable footprint to one server binary and one worker binary.
