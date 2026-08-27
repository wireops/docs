<div class="hero" markdown>
<div class="hero__grid" markdown>
<div markdown>

<div class="hero__eyebrow">GitOps for Docker Compose</div>

# Docker Compose, driven by Git.

wireops is a self-hosted GitOps controller that keeps Docker Compose stacks in sync across the hosts you own. Bring Git-driven deployment to a homelab or small fleet without Kubernetes-level control-plane complexity.

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
## Compose, not a new manifest

Deploy the Compose files you already keep in Git. wireops renders and applies them through your connected workers.
</div>
<div markdown>
## One server, many hosts

Workers connect outward using authenticated WebSockets. Target stacks and scheduled jobs using worker tags.
</div>
<div markdown>
## Guardrails included

Use RBAC, audit trails, deploy policy, encrypted secrets, SSO, backups, and static Compose linting from one place.
</div>
</div>

## Start where you are

- New installation? Follow the [quick start](docs/getting-started/quickstart.md).
- Preparing a production instance? Read the [production checklist](docs/operations/production.md).
- Looking for an endpoint or setting? Browse the [reference](docs/reference/architecture.md).

!!! note "Project scope"

    wireops is built for developers, homelabs, and self-hosters using plain Docker Compose. It is not a Kubernetes or Swarm replacement. For internet-facing or enterprise-scale workloads that require high availability, multi-node scheduling, autoscaling, or compliance-grade controls, use Kubernetes with Flux or Argo CD instead.
