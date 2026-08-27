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
## Compose, sem manifesto novo

Implante os arquivos Compose que já vivem no Git. O wireops renderiza e aplica a configuração pelos workers conectados.
</div>
<div markdown>
## Um servidor, vários hosts

Workers se conectam de saída por WebSocket autenticado. Direcione stacks e jobs pelos seus tags.
</div>
<div markdown>
## Proteções incluídas

Use RBAC, auditoria, política de deploy, segredos criptografados, SSO, backups e lint estático do Compose em um só lugar.
</div>
</div>

## Comece de onde está

- Instalação nova: siga o [início rápido](docs/getting-started/quickstart.md).
- Instância de produção: leia o [checklist de produção](docs/operations/production.md).
- Endpoint ou configuração: consulte a [referência](docs/reference/architecture.md).

!!! note "Escopo do projeto"

    wireops atende desenvolvedores, homelabs e auto-hospedagem com Docker Compose. Não substitui Kubernetes ou Swarm. Para workloads expostas à internet ou em escala corporativa que exigem alta disponibilidade, agendamento em múltiplos nós, escalonamento automático ou controles de conformidade, use Kubernetes com Flux ou Argo CD.
