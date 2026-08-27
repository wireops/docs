# ntfy

A integração ntfy publica os eventos selecionados em um tópico ntfy. Funciona no `ntfy.sh` público ou em um servidor ntfy próprio.

## Configurar

Habilite **ntfy** em **Settings → Integrations**.

| Campo | Obrigatório | Descrição |
| --- | --- | --- |
| Server URL | Sim | URL do servidor ntfy, por exemplo `https://ntfy.sh`. |
| Topic | Sim | Tópico a publicar. |
| Username | Não | Usuário de um servidor autenticado. |
| Password | Não | Senha ou token de acesso desse usuário. |
| Custom Template | Não | Texto em template Go para o corpo da mensagem. |
| Events | Sim | Eventos enviados ao tópico. |

Depois de salvar, selecione **Send Test** e assine o tópico no dispositivo esperado. Um tópico privado precisa de controles de acesso e credenciais de assinante coerentes.

## Segurança

Use um tópico difícil de adivinhar e autenticação em notificações não públicas. Nome e conteúdo do tópico podem ser metadados observáveis; não inclua segredos em templates ou logs de sync.
