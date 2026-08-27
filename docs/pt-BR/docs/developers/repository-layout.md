# Estrutura do repositório

O servidor Go inicia em `main.go` e `cmd/serve.go`; o worker é um binário independente em `worker/`. A lógica de domínio está em `internal/`: sincronização, Compose, política, segredos, jobs, rotas, auditoria e integrações. Migrações PocketBase ficam em `pb_migrations/` e a SPA Nuxt em `frontend/`.

Antes de alterar um fluxo, encontre o handler, serviço e teste que o usam. Preserve a regra de que somente workers executam Docker.

