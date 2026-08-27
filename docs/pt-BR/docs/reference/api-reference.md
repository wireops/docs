# Referência da API

As rotas customizadas usam o prefixo `/api/custom/`; o PocketBase também expõe CRUD das coleções conforme as regras de acesso.

Principais grupos: stacks (sync, rollback, logs, serviços, revisões e overrides), repositórios e credenciais, workers e políticas, jobs e execuções, lint, auditoria, métricas, backups e integrações de segredos.

Use o controle de acesso do servidor, uma chave de serviço apropriada ou uma sessão autenticada. Nunca exponha tokens em URLs, logs ou documentação de exemplo. A lista exata de endpoints acompanha a release atual no [repositório](https://github.com/wireops/wireops).

