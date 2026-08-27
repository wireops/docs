# Solução de problemas

Comece pelos logs de sincronização da stack, pelo status do worker e pelo endpoint `/api/health` do servidor. Nunca publique tokens, chaves privadas ou valores de segredos em issues ou logs compartilhados.

| Sintoma | Verifique primeiro |
| --- | --- |
| Worker offline | URL/TLS do servidor, token e conectividade na porta de worker |
| Deploy falha | saída do `docker compose`, política do worker e permissões do socket Docker |
| Stack não sincroniza | acesso Git, caminho do Compose, intervalo e logs de sync |
| Segredo indisponível | `SECRET_KEY`, integração Vault/Infisical e permissões do backend |
| Backup falha | diretório de dados, armazenamento remoto e credenciais S3 |

Para erros de TLS, compare o esquema e a porta configurados no servidor e no worker. Para permissões, confira a identidade do processo e o grupo numérico do socket Docker. Para erros de Compose, valide primeiro o arquivo e depois os achados de lint/política.

