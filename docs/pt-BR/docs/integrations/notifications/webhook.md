# Webhook

Webhook é a integração de notificação genérica. Ela envia um HTTP POST para um endpoint sob seu controle em cada evento selecionado.

## Configurar

Habilite **Webhook** em **Settings → Integrations**.

| Campo | Obrigatório | Descrição |
| --- | --- | --- |
| Webhook URL | Sim | Endpoint HTTPS que recebe os eventos do wireops. |
| HMAC Secret | Não | Segredo compartilhado para assinar o payload com HMAC-SHA256. |
| Headers | Não | Cabeçalhos extras, como de roteamento ou API. |
| Events | Sim | Eventos a entregar. Veja [eventos de notificação](../notifications.md). |

## Validar e proteger

Salve e selecione **Send Test**. Confirme que o receptor registra a requisição e, quando configurado, valida a assinatura antes de aceitá-la. Prefira HTTPS e um segredo longo e único; não coloque credenciais na URL.
