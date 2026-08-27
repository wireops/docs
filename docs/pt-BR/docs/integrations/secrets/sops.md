# SOPS + age

SOPS é o mecanismo de segredos por repositório do wireops. Ele está sempre habilitado e não possui configuração em **Integrations**. Cada repositório recebe um par de chaves age; durante o sync, o wireops descriptografa um `secrets.yaml` criptografado com SOPS.

## Adicionar `secrets.yaml`

Coloque `secrets.yaml` junto da configuração da stack, criptografe-o com o recipient público age exibido nos detalhes do repositório e versione apenas o arquivo criptografado.

```yaml
DATABASE_PASSWORD: altere-antes-de-criptografar
API_TOKEN: altere-antes-de-criptografar
```

Os valores em texto puro são sobrepostos no deploy e nunca devem ir para arquivos Compose comuns.

## Conferir e operar

1. Criptografe um valor de teste não produtivo com o recipient do repositório.
2. Faça commit do arquivo criptografado e execute um sync.
3. Confirme que a carga recebe o valor sem expô-lo em logs.

Se a chave age for rotacionada, criptografe novamente os `secrets.yaml` existentes com o novo recipient antes do próximo deploy.
