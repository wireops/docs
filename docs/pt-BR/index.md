<div class="hero" markdown>
<div class="hero__grid" markdown>
<div markdown>

<div class="hero__eyebrow">GitOps para Docker Compose</div>

# Docker Compose em sintonia com o Git.

wireops é um controlador GitOps auto-hospedado que mantém stacks Docker Compose sincronizadas nos hosts que você administra. Tenha deploy guiado por Git no homelab ou em uma pequena frota sem a complexidade de um plano de controle Kubernetes.

[Começar agora](docs/getting-started/quickstart.md){ .md-button .md-button--primary }
[Ver no GitHub](https://github.com/wireops/wireops){ .md-button }

</div>
<div class="hero__art" markdown>
![Logo do wireops](assets/images/logo.png){ .hero__logo }
<div class="brand-wordmark">wireops</div>
</div>
</div>
</div>

<div class="feature-grid" markdown>
<div markdown>
## :fontawesome-brands-docker: Compose, sem manifesto novo

Implante os arquivos Compose que já vivem no [Git](docs/reference/business-flows.md), sem formato novo pra aprender.
</div>
<div markdown>
## :material-lan: Um servidor, vários hosts

Workers se conectam de saída por WebSocket autenticado, direcionados por [tags](docs/reference/architecture.md).
</div>
<div markdown>
## :material-clock-outline: Jobs agendados

Rode containers cron para backup e limpeza, definidos por um [`job.yaml`](docs/reference/jobs.md) no Git.
</div>
<div markdown>
## :material-shield-check-outline: Política de deploy

Bloqueia containers privilegiados, volumes de host e imagens sem tag ou com `:latest`, [fail-closed](docs/reference/policies.md) por worker.
</div>
<div markdown>
## :material-key-variant: Segredos & auditoria

Segredos criptografados, perfis de RBAC e [auditoria completa](docs/security/access-control-and-audit.md), prontos de fábrica.
</div>
<div markdown>
## :material-robot-outline: Servidor MCP

Deixe Claude, Cursor e outros [assistentes de IA](docs/reference/mcp-server.md) consultarem stacks, jobs e logs.
</div>
</div>

## Veja em ação

*Clique numa screenshot pra ampliar, depois use as setas pra navegar.*

<div class="screenshot-grid" markdown>
<figure class="screenshot" markdown>
![Visão geral das stacks](assets/images/screenshots/stacks-overview.png){ data-gallery="wireops-desktop" }
<figcaption markdown>**Stacks**: todo deploy Compose, status de sync/deploy e worker atribuído.</figcaption>
</figure>
<figure class="screenshot" markdown>
![Grafo de dependências da stack](assets/images/screenshots/dependency-graph.png){ data-gallery="wireops-desktop" }
<figcaption markdown>**Grafo de dependências**: serviços, redes e volumes de cada stack.</figcaption>
</figure>
<figure class="screenshot" markdown>
![Jobs cron](assets/images/screenshots/jobs.png){ data-gallery="wireops-desktop" }
<figcaption markdown>**Jobs**: containers avulsos agendados por cron, com histórico de execuções.</figcaption>
</figure>
<figure class="screenshot" markdown>
![Integrações](assets/images/screenshots/integrations.png){ data-gallery="wireops-desktop" }
<figcaption markdown>**Integrações**: Traefik, Caddy, Dozzle, Vault, Infisical, SOPS e mais.</figcaption>
</figure>
</div>

<div class="screenshot-grid screenshot-grid--compact" markdown>
<figure class="screenshot" markdown>
![Dashboard mobile](assets/images/screenshots/mobile-dashboard.png){ data-gallery="wireops-mobile" }
<figcaption markdown>**Interface responsiva**: gerencie stacks e segredos pelo celular.</figcaption>
</figure>
<figure class="screenshot" markdown>
![Detalhe da stack no mobile](assets/images/screenshots/mobile-stack-detail.png){ data-gallery="wireops-mobile" }
</figure>
<figure class="screenshot" markdown>
![Gerenciamento de segredos no mobile](assets/images/screenshots/mobile-secrets.png){ data-gallery="wireops-mobile" }
</figure>
</div>

## Comece de onde está

- Instalação nova: siga o [início rápido](docs/getting-started/quickstart.md).
- Instância de produção: leia o [checklist de produção](docs/operations/production.md).
- Endpoint ou configuração: consulte a [referência](docs/reference/architecture.md).
- Quer um assistente de IA operando? Configure o [servidor MCP](docs/reference/mcp-server.md).

!!! note "Escopo do projeto"

    wireops atende desenvolvedores, homelabs e auto-hospedagem com Docker Compose. Não substitui Kubernetes ou Swarm. Para workloads expostas à internet ou em escala corporativa que exigem alta disponibilidade, agendamento em múltiplos nós, escalonamento automático ou controles de conformidade, use Kubernetes com Flux ou Argo CD.
