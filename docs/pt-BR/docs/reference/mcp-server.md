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
  ghcr.io/wireops/wireops-mcp:1.0.0
```

Depois crie uma service account no wireops (**Settings → Service Accounts**) com o perfil que você aceita dar a um assistente, e gere uma chave de API para ela.

## Conectando o Claude Code

```bash
claude mcp add --transport http wireops http://localhost:8091/mcp \
  --header "X-Wireops-Api-Key: wireops_sk_sua_chave_aqui"
```

O comando acima grava a chave em texto puro no arquivo de configuração do Claude Code (`.mcp.json`) e no seu histórico de shell. Prefira exportar `WIREOPS_API_KEY` a partir de um gerenciador de segredos e referenciá-la como `${WIREOPS_API_KEY}` no `.mcp.json`, em vez de colar a chave literal — principalmente se esse arquivo for versionado no repositório.

Rode `claude mcp list` para confirmar a conexão e depois pergunte coisas como "liste minhas stacks" ou "por que o último sync de X falhou". O Claude descobre sozinho as ferramentas disponíveis.

Outros clientes compatíveis com MCP (Cursor, Windsurf, o MCP Inspector, integrações próprias) conectam do mesmo jeito, apontando para a URL do wireops-mcp com o mesmo header de chave de API. A maioria usa o mesmo formato de configuração acima, com pequenas diferenças de nomenclatura. `http://` é seguro em localhost ou rede privada; se o cliente acessa o wireops-mcp por uma rede não confiável, coloque TLS na frente (ex.: um reverse proxy) e conecte por `https://`, já que a chave de API viaja num header em texto puro.

Como qualquer chave de API, mantenha-a fora de tudo que vá para o Git. Busque-a de um gerenciador de segredos ou de uma variável de ambiente em tempo de execução.

## Observação da frota e compatibilidade

`get_stack_status` reúne o registro persistido da stack com uma observação de `health` **sob demanda**. Os sinais são propositalmente diferentes: `status` é o resultado do último sync/deploy; `health` é o que o Docker observa agora na revisão implantada. Uma consulta de saúde não inicia reconciliação, polling, sonda externa nem alerta.

`health` pode ser `healthy`, `degraded`, `unhealthy`, `starting` ou `unknown`; inclui horário da observação e contagens de serviços problemáticos, ausentes e iniciando. Ele usa os serviços esperados na revisão implantada, ignora serviços com escala zero e considera saudável um init concluído (`customization.init`, saída 0). Worker offline, revisão implantada ausente ou falha de inspeção retornam `unknown` com um motivo, nunca uma conclusão otimista.

Para uma visão compacta da frota, use `get_inventory`. Ele pagina stacks (50 por padrão, máximo 200) e aceita filtro de worker por ID/hostname e de grupo. Cada item traz versão/capabilities do worker, serviços atuais, saúde e recursos. A coleta limita a cinco comandos simultâneos, cinco segundos por comando e 25 segundos no total: um worker inacessível produz um item anotado, sem esconder os demais. A identidade de rede é `(worker_id, network.id)`; nomes Docker iguais em workers diferentes não formam uma rede compartilhada.

`get_stack_resources` e os recursos do inventário incluem volumes nomeados, bind mounts e redes realmente ligadas aos containers, inclusive redes externas. Resultado vazio com `partial: false` é vazio confirmado. `partial: true` com `warnings` significa que alguma inspeção não foi possível; use os dados retornados, mas não conclua que recursos ausentes não existem. Sem `resource_inventory_v1`, o inventário do worker é sempre marcado parcial até a atualização. Binds e redes externas já são descobertos desde a v1.0.8; a capability é a confirmação explícita do worker para o contrato completo.

Workers anunciam capabilities no heartbeat. `resource_inventory_v1` confirma inventário completo, `container_logs_filter_v1` habilita filtros temporais de logs validados pelo servidor e `exec_one_shot_v1` habilita execução avulsa. Durante atualização gradual, leituras básicas continuam quando possível; logs com janela temporal e exec avulso retornam `409` claro com a capability necessária, sem mudar a semântica silenciosamente.

## Logs, aliases e execução

`get_container_logs` aceita `since` e `until` em RFC3339 com timezone, timestamp Unix ou duração relativa positiva, como `30m`. O servidor resolve durações usando uma única referência de tempo, valida intervalo e regex, seleciona janela e tail e só depois aplica `pattern`. No máximo 1 MiB é examinado e 64 KiB retornam; `truncated` e `truncation_reason` avisam quando algum limite foi atingido. Não existe filtro por nível porque logs de containers não têm formato uniforme.

Para chamadas mais ergonômicas, todas as tools que apontam para stacks aceitam `stack` como alias de `stack_id`. Tools de container aceitam `container_name`, o nome Docker real dentro da stack; `service_name` continua sendo seletor de serviço e não escolhe entre réplicas. Logs também aceitam `lines` para `tail` e `search` para `pattern`. Canonical e alias com o mesmo valor são aceitos; valores conflitantes são recusados. Campos desconhecidos continuam inválidos.

`exec_in_container` tem uma única resposta previsível: `cmd`, `stdout`, `stderr`, `exit_code` e `timed_out`. Ele não abre terminal, não faz polling de transcript e não usa fallback por marcador. Se o worker não tiver `exec_one_shot_v1` (disponível desde a v1.0.13), o `409` orienta a atualizá-lo. Em timeout, a saída parcial é preservada e o `exit_code` é desconhecido (`null`).

## Diagnóstico de commits e segredos

O diagnóstico da stack expõe `deployed_commit`, `desired_commit`, `last_error_commit` e `expand.repository.last_commit_sha`. Eles respondem perguntas distintas: `deployed_commit` é a revisão em execução; `desired_commit` é a última revisão renderizada para a stack; `last_commit_sha` é a última cabeça conhecida do repositório; e `last_error_commit` é a revisão tentada que falhou. Erros históricos ficam sem commit inferido. Um sucesso posterior limpa os campos de último erro.

`list_secrets` é um inventário de nomes de chave, nunca de valores. `stack_secrets` contém registros diretos de variável da stack marcados como secreto; `global_secrets` contém variáveis globais secretas vinculadas a ela; e `sops_secrets` traz somente chaves lidas do `secrets.yaml` SOPS do repositório quando disponível. `secret_count` conta apenas os dois primeiros grupos, não as chaves SOPS. `non_secret_keys` e `non_secret_count` cobrem somente variáveis diretas não secretas da stack; não representam `.env` do repositório, globals não secretos, nem valores SOPS descriptografados.

## Relacionado

- [Jobs agendados](jobs.md): os campos e o ciclo de vida por trás das ferramentas `list_jobs`, `get_job_definition` e `generate_job_yaml`.
- [Política de deploy](policies.md): o que valida o compose gerado pela ferramenta `scaffold_stack`.
