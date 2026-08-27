# Eventos de notificação

Toda integração de notificação tem um seletor de **Events**. Habilite somente os eventos sobre os quais sua equipe consegue agir:

| Evento | Quando é enviado |
| --- | --- |
| `sync.started` | Uma reconciliação de stack começa. |
| `sync.done` | A reconciliação e o deploy terminam com sucesso. |
| `sync.error` | A reconciliação, validação ou deploy falha. |
| `sync.test` | Você seleciona **Send Test** nas configurações da integração. |

Configure um canal por vez e use **Send Test** antes de depender dele. O teste confirma que o wireops alcança o destino, mas não substitui conferir permissões e regras de alerta do destinatário.

- [Webhook](notifications/webhook.md)
- [Discord](notifications/discord.md)
- [Slack](notifications/slack.md)
- [ntfy](notifications/ntfy.md)
