# Variáveis de ambiente

## Variáveis multilinha da aplicação

Valores de variáveis de stacks, jobs e variáveis globais podem conter várias linhas, incluindo JSON e chaves PEM. Clique em **Expand value** ou cole um conteúdo multilinha no campo de valor para abrir o editor maior. **Done** mantém o valor editado no formulário; use a ação de salvar do formulário para persistir. **Cancel**, dentro do editor expandido, restaura o valor anterior.

Cole o conteúdo original sem adicionar aspas externas, escapar quebras manualmente ou converter para base64. Marque credenciais como **Secret**. Secrets internos salvos ficam ocultos até a revelação por um administrador; deixar a substituição vazia mantém um secret existente. Vault e Infisical continuam usando os seletores de referência e podem fornecer valores multilinha na execução.

Na edição em lote de stacks e na importação de `.env`, coloque o valor multilinha entre aspas. Aspas simples preservam literalmente as barras do JSON:

```dotenv
GCP_SERVICE_ACCOUNT_JSON='{
  "type": "service_account",
  "private_key": "-----BEGIN PRIVATE KEY-----\nCHAVE-FICTICIA-DE-EXEMPLO\n-----END PRIVATE KEY-----\n"
}'
```

Esse fragmento é ilustrativo e não constitui uma credencial utilizável. O editor em lote também aceita valores entre aspas duplas com quebras escapadas. Aspas não fechadas são apontadas antes de salvar.

### Service accounts da GCP

No Compose da stack, exponha a variável ao serviço que a consome:

```yaml
services:
  app:
    image: sua-aplicacao:1.0.0
    environment:
      GCP_SERVICE_ACCOUNT_JSON: ${GCP_SERVICE_ACCOUNT_JSON}
```

`GCP_SERVICE_ACCOUNT_JSON` é um nome de exemplo: use o nome aceito pela sua aplicação. A aplicação precisa interpretar explicitamente o JSON dessa variável. Quebras reais do JSON formatado são preservadas; o `\n` literal de `private_key` continua como escape JSON até a aplicação interpretar o documento. Jobs recebem as variáveis configuradas diretamente no ambiente do container.

**`GOOGLE_APPLICATION_CREDENTIALS` espera um caminho de arquivo, não o conteúdo JSON.** Aplicações que utilizam esse mecanismo ainda precisam disponibilizar o arquivo de credenciais dentro do container e apontar a variável para seu caminho interno. O wireops não cria nem monta automaticamente um arquivo de credenciais a partir de uma variável de ambiente.

Consulte a [sintaxe de arquivos de ambiente do Docker Compose](https://docs.docker.com/compose/how-tos/environment-variables/variable-interpolation/#env-file-syntax) e a [documentação do Google Application Default Credentials](https://docs.cloud.google.com/docs/authentication/application-default-credentials).

Atualize servidor e workers juntos ao adotar valores multilinha, para que a ocultação na saída dos workers inclua os valores decodificados e suas linhas individuais. Os limites de tamanho e as regras de acesso existentes continuam valendo.

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

