# Discord

A integração Discord publica os eventos selecionados em um canal Discord usando um incoming webhook.

## Configurar

Habilite **Discord** em **Settings → Integrations**.

| Campo | Obrigatório | Descrição |
| --- | --- | --- |
| Discord Webhook URL | Sim | URL do incoming webhook do canal. |
| Username | Não | Nome exibido nas mensagens. |
| Avatar URL | Não | URL da imagem usada como avatar. |
| Mention on Errors | Não | Menciona uma role ao entregar `sync.error`. |
| Role ID | Com menção | ID numérico da role a mencionar. |
| Events | Sim | Eventos enviados ao canal. |

Use **Send Test** depois de salvar. Para menções de erro, teste em um canal não produtivo ou confira a permissão de mencionar a role.

## Segurança

Trate a URL do webhook como credencial: quem a possui pode publicar no canal. Restrinja o público, rotacione URLs vazadas e não encaminhe segredos na saída do deploy.
