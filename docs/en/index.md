<div class="hero" markdown>
<div class="hero__grid" markdown>
<div markdown>

<div class="hero__eyebrow">GitOps for Docker Compose</div>

# Docker Compose, driven by Git.

Self-hosted GitOps controller that keeps Docker Compose stacks in sync across the hosts you own. Bring Git-driven deployment to a homelab or small fleet without Kubernetes-level control-plane complexity.

[Get started](docs/getting-started/quickstart.md){ .md-button .md-button--primary }
[View on GitHub](https://github.com/wireops/wireops){ .md-button }

</div>
<div class="hero__art" markdown>
![wireops logo](assets/images/logo.png){ .hero__logo }
<div class="brand-wordmark">wireops</div>
</div>
</div>
</div>

<div class="feature-grid" markdown>
<div markdown>
## :fontawesome-brands-docker: Compose, not a new manifest

Deploy the Compose files you already keep in [Git](docs/reference/business-flows.md), no new format to learn.
</div>
<div markdown>
## :material-lan: One server, many hosts

Workers connect outward over authenticated WebSockets, targeted by [tags](docs/reference/architecture.md).
</div>
<div markdown>
## :material-clock-outline: Scheduled jobs

Run cron containers for backups and cleanup, defined by a [`job.yaml`](docs/reference/jobs.md) in Git.
</div>
<div markdown>
## :material-shield-check-outline: Deploy policy

Block privileged containers, host mounts, and unpinned images, [fail-closed](docs/reference/policies.md) per worker.
</div>
<div markdown>
## :material-key-variant: Secrets & audit

Encrypted secrets, RBAC roles, and a full [audit trail](docs/security/access-control-and-audit.md), out of the box.
</div>
<div markdown>
## :material-robot-outline: MCP server

Let Claude, Cursor, and other [AI assistants](docs/reference/mcp-server.md) query stacks, jobs, and logs.
</div>
</div>

## Start where you are

- New installation? Follow the [quick start](docs/getting-started/quickstart.md).
- Preparing a production instance? Read the [production checklist](docs/operations/production.md).
- Looking for an endpoint or setting? Browse the [reference](docs/reference/architecture.md).
- Want an AI assistant driving it? Set up the [MCP server](docs/reference/mcp-server.md).

!!! note "Project scope"

    wireops is built for developers, homelabs, and self-hosters using plain Docker Compose. It is not a Kubernetes or Swarm replacement. For internet-facing or enterprise-scale workloads that require high availability, multi-node scheduling, autoscaling, or compliance-grade controls, use Kubernetes with Flux or Argo CD instead.
