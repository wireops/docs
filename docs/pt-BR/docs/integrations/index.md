# Integrações

As integrações conectam o wireops às ferramentas que já operam ao redor das suas stacks Docker Compose. Configure-as em **Settings → Integrations**. Cada página abaixo detalha os campos, labels, credenciais e a validação de uma integração.

## Proxy reverso e logs

| Integração | Finalidade |
| --- | --- |
| [Traefik](reverse-proxy/traefik.md) | Adiciona a ação **Open** a partir de labels de roteador do Traefik. |
| [Caddy](reverse-proxy/caddy.md) | Adiciona ações **Open** a partir de labels do Caddy Docker Proxy. |
| [Nginx Proxy Manager](reverse-proxy/nginx-proxy-manager.md) | Adiciona **Open** e, opcionalmente, **NPM Admin** a partir de labels de dica do wireops. |
| [Dozzle](logging/dozzle.md) | Adiciona um link direto para os logs Dozzle de cada container. |

## Notificações

Integrações de notificação enviam apenas os eventos selecionados. Consulte [eventos de notificação](notifications.md) para entender cada evento.

| Integração | Finalidade |
| --- | --- |
| [Webhook](notifications/webhook.md) | Envia eventos HTTP assinados para um endpoint sob seu controle. |
| [Discord](notifications/discord.md) | Envia mensagens de deploy para um canal Discord. |
| [Slack](notifications/slack.md) | Envia mensagens de deploy para um canal Slack. |
| [ntfy](notifications/ntfy.md) | Publica notificações push no ntfy.sh ou em um servidor próprio. |

## Segredos, backups e código-fonte

| Integração | Finalidade |
| --- | --- |
| [HashiCorp Vault](secrets/vault.md) | Resolve variáveis secretas a partir do Vault KV v2. |
| [Infisical](secrets/infisical.md) | Resolve variáveis secretas com uma Machine Identity do Infisical. |
| [SOPS + age](secrets/sops.md) | Descriptografa o `secrets.yaml` do repositório; sempre habilitado. |
| [Armazenamento compatível com S3](storage/s3.md) | Espelha backups locais em S3, R2, MinIO, B2 e provedores compatíveis. |
| [GitHub OAuth](source-control/github.md) | Permite pesquisar e selecionar repositórios GitHub pela interface. |

Mantenha segredos e credenciais fora dos arquivos Compose. Limite cada token aos caminhos, projeto, bucket ou canal estritamente necessários.
