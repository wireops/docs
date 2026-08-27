# Variáveis de ambiente

## Servidor

| Variável | Finalidade |
| --- | --- |
| `SECRET_KEY` | Obrigatória; chave AES de 32 bytes para segredos em repouso |
| `APP_URL` | URL pública usada por CORS, webhooks e e-mails |
| `PORT` | Porta da interface, REST e métricas; padrão `8090` |
| `TLS_WORKER_PORT` | Porta de registro/WebSocket de workers; padrão `8443` |
| `DATA_DIR` | Raiz de dados em tempo de execução |
| `PB_DATA_DIR` | Sobrescreve o diretório SQLite do PocketBase |
| `REPOS_WORKSPACE` | Sobrescreve a área de clones Git |
| `COMPOSE_MAX_KB` | Limite do Compose resolvido em memória |

## Worker

| Variável | Finalidade |
| --- | --- |
| `SERVER_URL` | Obrigatória; URL HTTPS do servidor |
| `WORKER_TOKEN` | Obrigatória; autorização do worker |
| `WORKER_TAGS` | Obrigatória; tags separadas por vírgula para roteamento de jobs |

Defina URLs, SMTP, OIDC e provedores de segredo somente no ambiente seguro da sua instalação. Nunca versione valores secretos.

