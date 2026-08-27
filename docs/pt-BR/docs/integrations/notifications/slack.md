# Slack

A integração Slack envia os eventos selecionados para um canal Slack usando um incoming webhook.

## Configurar

Habilite **Slack** em **Settings → Integrations**.

| Campo | Obrigatório | Descrição |
| --- | --- | --- |
| Slack Webhook URL | Sim | URL do incoming webhook do canal. |
| Mention on Errors | Não | Acrescenta a menção configurada em `sync.error`. |
| Mention Text | Com menção | Sintaxe de menção do Slack, como `<!subteam^S123456|deploys>`. |
| Events | Sim | Eventos enviados ao canal. |

Salve e selecione **Send Test**. Confirme que o app está no canal correto e que uma menção de erro alcança o público esperado.

## Segurança

Mantenha a URL do webhook fora de repositórios e logs. Prefira um canal dedicado, com política de retenção adequada, quando metadados de deploy não puderem ficar amplamente visíveis.
