# Solução de problemas

Comece pelos logs de sincronização da stack, pelo status do worker e pelo endpoint `/api/health` do servidor. Nunca publique tokens, chaves privadas ou valores de segredos em issues ou logs compartilhados.

| Sintoma | Verifique primeiro |
| --- | --- |
| Worker offline | URL/TLS do servidor, token e conectividade na porta de worker |
| Deploy falha | saída do `docker compose`, política do worker e permissões do socket Docker |
| Stack não sincroniza | acesso Git, caminho do Compose, intervalo e logs de sync |
| Segredo indisponível | `SECRET_KEY`, integração Vault/Infisical e permissões do backend |
| Backup falha | diretório de dados, armazenamento remoto e credenciais S3 |
| Imagem privada não carrega | credencial com host/porta exatos, validade da credencial e configuração do daemon Docker do worker |

Para erros de TLS, compare o esquema e a porta configurados no servidor e no worker. Para permissões, confira a identidade do processo e o grupo numérico do socket Docker. Para erros de Compose, valide primeiro o arquivo e depois os achados de lint/política.

## Autenticação de registry privado

O wireops seleciona a credencial automaticamente quando o host e a porta
normalizados dela correspondem exatamente a uma imagem no Compose final. Não
há correspondência por namespace, subdomínio, sufixo ou IP resolvido. Sem uma
credencial correspondente, o pull é anônimo; uma credencial correspondente que
não possa ser lida interrompe o deploy antes de o worker executá-lo.

Se **Testar conexão** informar que um endereço privado ou loopback foi
barrado, adicione o IP ou CIDR indicado a `ALLOWED_PRIVATE_IP_RANGES` no
ambiente do servidor e reinicie-o. Isso controla apenas o teste feito pelo
servidor. Para HTTP simples ou TLS autoassinado, marque **Registry inseguro**
na credencial e configure `insecure-registries` no Docker de cada worker que
fará o pull.

