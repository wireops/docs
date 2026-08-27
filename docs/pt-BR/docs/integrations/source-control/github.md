# GitHub OAuth

GitHub OAuth permite que um operador autenticado do wireops pesquise e selecione repositórios durante sua inclusão. Ele não substitui as credenciais de deploy do repositório: o wireops continua usando o método de acesso configurado para clonar e sincronizar.

## Configurar o servidor

Crie um GitHub OAuth App e defina a URL de callback para sua instância wireops. Depois configure estas variáveis no servidor e reinicie o wireops:

| Variável | Obrigatória | Descrição |
| --- | --- | --- |
| `GITHUB_OAUTH_CLIENT_ID` | Sim | Client ID do OAuth App. |
| `GITHUB_OAUTH_CLIENT_SECRET` | Sim | Client secret do OAuth App. |

O cartão GitHub fica disponível automaticamente quando ambas estão definidas. Ele é gerenciado pela configuração do servidor e não pode ser ligado/desligado na interface.

## Conectar e validar

1. Abra **Settings → Integrations → GitHub**.
2. Selecione **Connect GitHub** e autorize somente as organizações/repositórios necessários.
3. Confira a conta conectada e use **Test Connection**.
4. Adicione um repositório e confirme que ele aparece no seletor.

## Segurança

Use um OAuth App exclusivo por ambiente wireops. Mantenha a callback URL exata, proteja o client secret e revise o acesso às organizações regularmente. Revogue a autorização GitHub quando o operador ou a instância não puder mais pesquisar repositórios.
