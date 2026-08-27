# Servidor MCP

O wireops oferece um servidor separado e opcional que permite a assistentes de IA (Claude Code, Cursor e ferramentas semelhantes) conversar diretamente com sua instância. Pergunte "quais stacks estão falhando agora", "mostre os logs de sync dessa stack" ou até "monte uma nova stack para essa aplicação", em vez de copiar e colar informações manualmente entre as ferramentas.

## Como se encaixa

É um binário próprio e independente (`wireops-mcp`) que fica entre o assistente de IA e o servidor wireops. Ele não guarda credencial nenhuma: toda requisição carrega sua própria chave de API do wireops, então o que essa chave pode fazer no wireops é exatamente o que o assistente pode fazer. Dê uma chave "viewer" somente leitura se só quiser respostas a perguntas, ou dê mais permissão se quiser que ele aja em seu nome.

A maior parte do que ele expõe é somente leitura: stacks, workers, [jobs agendados](jobs.md) e seu histórico de execuções, repositórios, histórico de revisões, logs de auditoria, quais chaves de segredo existem (nunca os valores) e informações gerais do sistema. Algumas ferramentas geram um manifesto para você revisar, como um `wireops.yaml`, um `job.yaml` ou uma stack completa (compose + manifesto), mas nenhuma delas grava nada em disco ou faz commit no Git por conta própria. Quem revisa e commita continua sendo você.

Stacks geradas também não são entregues "no escuro". Ao passar um `worker_id` para a ferramenta de scaffold, o compose gerado é validado contra a [política de deploy](policies.md) efetiva daquele worker antes de ser devolvido, assim você não recebe algo que seria rejeitado no primeiro deploy real.

## Configurando

Rode como um container próprio, pequeno:

```bash
docker run -d --name wireops-mcp -p 8091:8091 \
  -e SERVER_URL=http://wireops-host:8090 \
  ghcr.io/wireops/wireops-mcp:latest
```

Depois crie uma service account no wireops (**Settings → Service Accounts**) com o perfil que você aceita dar a um assistente, e gere uma chave de API para ela.

## Conectando o Claude Code

```bash
claude mcp add --transport http wireops http://localhost:8091/mcp \
  --header "X-Wireops-Api-Key: wireops_sk_sua_chave_aqui"
```

Rode `claude mcp list` para confirmar a conexão e depois pergunte coisas como "liste minhas stacks" ou "por que o último sync de X falhou". O Claude descobre sozinho as ferramentas disponíveis.

Outros clientes compatíveis com MCP (Cursor, Windsurf, o MCP Inspector, integrações próprias) conectam do mesmo jeito, apontando para `http://<host>:8091/mcp` com o mesmo header de chave de API. A maioria usa o mesmo formato de configuração acima, com pequenas diferenças de nomenclatura.

Como qualquer chave de API, mantenha-a fora de tudo que vá para o Git. Busque-a de um gerenciador de segredos ou de uma variável de ambiente em tempo de execução.

## Relacionado

- [Jobs agendados](jobs.md): os campos e o ciclo de vida por trás das ferramentas `list_jobs`, `get_job_definition` e `generate_job_yaml`.
- [Política de deploy](policies.md): o que valida o compose gerado pela ferramenta `scaffold_stack`.
