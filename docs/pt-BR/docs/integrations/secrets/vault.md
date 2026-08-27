# HashiCorp Vault

A integração Vault resolve variáveis de ambiente secretas no mecanismo **KV v2** do Vault durante o deploy. O wireops armazena a referência, não o valor do segredo.

## Configurar

Habilite **Vault** em **Settings → Integrations**.

| Campo | Obrigatório | Descrição |
| --- | --- | --- |
| Vault Address | Sim | URL base do Vault, como `https://vault.example.com:8200`. |
| Token | Sim | Token com leitura nos caminhos KV v2 necessários. |
| Limit to Mount | Não | Limita o navegador da interface a um mount KV v2, como `secret`. |

Use **Test Connection** antes de adotar o token em produção.

## Usar um segredo

Ao criar uma variável secreta, selecione o provedor `vault` e use uma referência neste formato:

```
<mount>/data/<path>#<field>
```

Por exemplo, `secret/data/apps/api#DATABASE_URL` busca o campo `DATABASE_URL` durante o deploy.

## Segurança

Use uma policy limitada ao menor mount e conjunto de caminhos possível. Rotacione o token pelo Vault e não conceda privilégios administrativos do Vault ao wireops.
