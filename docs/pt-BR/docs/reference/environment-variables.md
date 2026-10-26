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

