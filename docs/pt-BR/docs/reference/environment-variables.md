# Variáveis de ambiente

## Valores com várias linhas

Você pode usar valores com várias linhas em variáveis de stacks, jobs e variáveis globais, como credenciais JSON, certificados e chaves privadas.

1. Crie ou edite uma variável com o nome exigido pela sua aplicação.
2. Clique em **Expand value** e cole o conteúdo completo, sem alterá-lo. Colar várias linhas também abre o editor automaticamente.
3. Marque valores sensíveis como **Secret**.
4. Clique em **Done** e depois salve a variável no formulário.

Não é necessário adicionar aspas nem alterar as quebras de linha no campo de valor. **Cancel**, dentro do editor expandido, restaura o valor anterior. Ao editar um secret existente, deixe o valor vazio para mantê-lo como está.

### Usar o valor em uma stack

Adicione a variável ao serviço da aplicação no seu arquivo Compose. Por exemplo:

```yaml
environment:
  GCP_SERVICE_ACCOUNT_JSON: ${GCP_SERVICE_ACCOUNT_JSON}
```

Substitua `GCP_SERVICE_ACCOUNT_JSON` pelo nome de variável aceito pela aplicação. Jobs recebem automaticamente as variáveis configuradas.

### Credenciais da GCP

Se a aplicação aceita o JSON de uma service account em uma variável de ambiente, cole o arquivo JSON inteiro no campo de valor e marque como **Secret**.

Se a aplicação pede **`GOOGLE_APPLICATION_CREDENTIALS`**, informe o **caminho do arquivo de credenciais dentro do container**. Colar o JSON nessa variável não funciona. Disponibilize o arquivo no container conforme o guia de configuração da sua aplicação.

### Importar um arquivo `.env` ou editar em lote

Coloque valores com várias linhas entre aspas simples. Por exemplo:

```dotenv
SETTINGS='{
  "language": "pt-BR",
  "timezone": "America/Sao_Paulo"
}'
```

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
| `ALLOWED_PRIVATE_IP_RANGES` | IPs ou faixas CIDR privadas, separados por vírgula, permitidos nos testes de conexão de registries e na varredura de chaves SSH. Sem esta variável, endereços privados, loopback, link-local e não especificados são bloqueados. |

### Testes de conexão com registry privado

As credenciais de registry são selecionadas automaticamente pelo host e porta
exatos das imagens no Compose final de cada stack. Quando o registry só é
acessível na sua rede privada, o servidor bloqueia deliberadamente o botão
**Testar conexão** até que o endereço seja liberado explicitamente. Defina
`ALLOWED_PRIVATE_IP_RANGES` no servidor, por exemplo:

```bash
ALLOWED_PRIVATE_IP_RANGES=10.0.0.0/8,192.168.1.0/24
```

Reinicie o wireops após a alteração. Esta configuração libera somente o teste
feito pelo servidor; ela não configura o Docker dos workers. Para HTTP simples
ou certificado autoassinado, marque a credencial como **Registry inseguro** e
configure o registry em `insecure-registries` no daemon Docker de cada worker.

## Worker

| Variável | Finalidade |
| --- | --- |
| `SERVER_URL` | Obrigatória; URL HTTPS do servidor |
| `WORKER_TOKEN` | Obrigatória; autorização do worker |
| `WORKER_TAGS` | Obrigatória; tags separadas por vírgula para roteamento de jobs |

Defina URLs, SMTP, OIDC e provedores de segredo somente no ambiente seguro da sua instalação. Nunca versione valores secretos.

