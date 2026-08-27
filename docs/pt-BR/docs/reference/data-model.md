# Modelo de dados

As coleções PocketBase relacionam repositórios, stacks, workers, variáveis, revisões e logs. Repositórios possuem stacks; stacks possuem variáveis, serviços, revisões e logs de sync; jobs agendados pertencem a repositórios e produzem execuções ligadas a workers.

Valores secretos, como chaves Git e variáveis internas, são cifrados com AES-GCM usando `SECRET_KEY`. Backends Vault e Infisical guardam referências/configurações separadas. O banco SQLite faz parte do backup do servidor.

