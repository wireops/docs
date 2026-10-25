# Referência da API

As rotas customizadas usam o prefixo `/api/custom/`; o PocketBase também expõe CRUD das coleções conforme as regras de acesso.

Principais grupos: stacks (sync, rollback, logs, serviços, revisões e overrides), repositórios e credenciais, workers e políticas, jobs e execuções, lint, auditoria, métricas, backups e integrações de segredos.

Use o controle de acesso do servidor, uma chave de serviço apropriada ou uma sessão autenticada. Nunca exponha tokens em URLs, logs ou documentação de exemplo. A lista exata de endpoints acompanha a release atual no [repositório](https://github.com/wireops/wireops).

## Observabilidade de stacks

| Método | Rota | Descrição |
|---|---|---|
| `GET` | `/api/custom/stacks/{id}/health` | Saúde Docker sob demanda da revisão implantada; não dispara sync |
| `GET` | `/api/custom/stacks/{id}/resources` | Volumes nomeados, binds e redes ligados aos containers; `partial`/`warnings` deixam coleta incompleta explícita (`503` para despacho, `502` para erro/resposta do worker) |
| `GET` | `/api/custom/inventory` | Inventário compacto paginado de stacks/workers/serviços/saúde/recursos; filtros `worker`, `group`, `page`, `per_page` (50 padrão, 200 máximo) |
| `GET` | `/api/custom/stacks/{id}/container/{cid}/logs` | Logs limitados; filtros `tail`, `pattern`, `since`, `until`; resposta informa filtros aplicados e truncamento |
| `POST` | `/api/custom/stacks/{id}/exec` | Execução avulsa não interativa, com streams separados, código de saída e timeout; requer `exec_one_shot_v1` |
| `POST` | `/api/custom/stacks/{id}/resync-definition` | Busca e relê a definição `x-wireops`/`wireops.yaml` commitada, atualiza os campos gerenciados e retorna o diff; não faz deploy |

