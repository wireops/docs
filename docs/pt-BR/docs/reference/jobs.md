# Jobs agendados

Além de manter stacks sincronizadas, o wireops executa containers Docker avulsos em um agendamento cron: backups noturnos de banco de dados, rotação de logs, limpeza, health-checks. Tudo isso é definido por um `job.yaml` versionado no repositório, sem configuração paralela na interface que possa divergir dele.

## O arquivo `job.yaml`

```yaml
name: "Backup do banco de dados"
description: "Backup noturno do postgres"
cron: "0 2 * * *"
image: "postgres:15-alpine"
command: ["pg_dump", "-h", "db", "-U", "postgres", "mydb"]
tags: ["backup", "prod"]
group: "database"
mode: "once" # once ou once_all
volumes:
  - "/opt/backups:/backups"
network: "prod_network"
resources:
  cpu: "0.5"        # obrigatório
  memory: "512m"    # obrigatório
  timeout: "15m"    # obrigatório
configs:
  - name: "backup-script"
    path: "scripts/backup.sh"
    target: "/scripts/backup.sh"
    mode: "0755"    # opcional, padrão somente leitura
```

| Campo | Obrigatório | Descrição |
| --- | --- | --- |
| `name` | Sim | Nome exibido. Sincronizado do Git a cada execução, então renomear pela interface não tem efeito; edite o arquivo. |
| `description` | Não | Exibida junto ao job na interface. |
| `cron` | Sim | Expressão cron padrão de 5 campos, avaliada no fuso horário do servidor. |
| `image` | Sim | Imagem Docker a executar. Sujeita às mesmas checagens da [política do worker](policies.md) aplicadas às stacks. |
| `command` | Não | Aceita uma string única (dividida por espaço) ou uma lista YAML. Use lista se algum argumento contiver espaço. |
| `tags` | Não | Seleciona quais workers são elegíveis para rodar o job (veja [modos de despacho](#modos-de-despacho)). Vazio significa qualquer worker. |
| `group` | Não | Rótulo livre para organizar jobs relacionados na interface. Apenas cosmético. |
| `mode` | Não | `once` (padrão) ou `once_all`, veja abaixo. |
| `volumes` | Não | Bind mounts ou volumes nomeados, mesma sintaxe do Compose. Sujeitos à política (`BlockHostVolumes`, `AllowedVolumes`). |
| `network` | Não | Rede Docker do container do job. Sujeita à política (`AllowedNetworks`). |
| `resources.cpu` / `.memory` / `.timeout` | **Sim, os três** | Obrigatórios para que um job com defeito não consuma os recursos do host indefinidamente. `timeout` cancela o container se ele exceder o tempo. |
| `configs` | Não | Arquivos versionados no Git, resolvidos pelo servidor e montados (somente leitura, ou conforme `mode`) em `target`. Como jobs não têm arquivo Compose, alvo e modo são explícitos aqui, diferente do elemento nativo `configs:` de uma stack. |

## Modos de despacho

- **`once`**: o job roda em exatamente um worker que combine com as `tags`, escolhido por round-robin. Use para tudo que não deve rodar em duplicidade (um backup, uma migração de banco).
- **`once_all`**: o job roda simultaneamente em **todos** os workers que combinem. Use para manutenção de frota (limpar imagens soltas em todos os hosts, girar logs em todo lugar).

## O que acontece a cada disparo agendado

1. O wireops resolve quais workers combinam com as `tags` do job.
2. Cria um registro em `job_runs` por despacho e carrega a [política efetiva do worker](policies.md) de destino.
3. Imagem, volumes e rede do job são validados contra essa política. Uma violação falha a execução imediatamente (status `error`) sem que o job chegue ao worker; é a mesma checagem "fail-closed" que um deploy de stack passa.
4. O worker executa o container (`docker run --rm`) e reporta código de saída e output ao terminar.
5. O wireops marca a execução como `success` ou `failed`. Se uma execução travar, rodando por mais de uma hora sem retorno e geralmente porque o worker caiu no meio, uma varredura periódica a marca como `stalled` para não ficar pendente para sempre.

Registros de `job_runs` expiram e são limpos automaticamente após 30 dias.

## Execuções avulsas e a API/MCP

Um job não precisa esperar o próximo disparo do cron. Dá para disparar uma execução avulsa pela interface ou API, e tudo sobre um job também é legível programaticamente:

- REST: listar jobs e execuções recentes, obter o `job.yaml` bruto de um job, listar arquivos `job.yaml` candidatos em um repositório antes de agendar.
- [Servidor MCP](mcp-server.md): `list_jobs`, `get_job_definition`, `list_repo_job_files` e `generate_job_yaml` expõem os mesmos dados (e um scaffold) a um assistente de IA, sempre somente leitura e limitado pelo RBAC da chave de API usada.

## Relacionado

- [Políticas](policies.md): o que a imagem, os volumes e a rede de um job são checados antes de ele rodar.
- [Fluxos principais](business-flows.md): onde jobs agendados se encaixam junto à sincronização de stacks e à conexão de workers.
