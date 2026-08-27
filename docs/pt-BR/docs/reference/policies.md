# Política de deploy

Ter o perfil de RBAC certo não significa que qualquer arquivo Compose deva ser implantável como está. Alguém pode versionar uma stack que monta o socket do Docker ou roda um container privilegiado. A política do worker é a proteção contra isso, independente de quem tem permissão para clicar em "deploy".

A política é aplicada nos dois caminhos que colocam containers no ar: o Compose renderizado de uma stack no deploy, e a imagem/volumes/rede de um [job agendado](jobs.md) no despacho. Ambas as checagens são "fail-closed", ou seja, uma violação bloqueia a ação em vez de apenas avisar e seguir.

## Política global e substituições por worker

Existe uma política global, mais uma substituição opcional por worker:

- Se um worker não tem substituição para determinado ajuste e `policy_inherit` é `true` (padrão), usa o valor global.
- Se `policy_inherit` é `false`, um valor local não definido cai para "sem restrição" naquele ajuste, em vez de usar o global.
- Uma substituição por worker **troca**, não soma, o valor global daquele recurso. Definir uma lista local de `allowed_images` faz só ela valer para o worker, não global-mais-local.
- Alterações renderizadas (veja [fluxos principais](business-flows.md)) continuam passando pelas mesmas checagens de política, então não servem para contornar um bloqueio.

A política pode ser desabilitada por completo (`enabled: false` global), e todas as checagens abaixo são ignoradas em todo lugar.

## Listas de permissão

Quatro tipos de recurso aceitam lista de permissão explícita: **imagens**, **volumes**, **redes**, além de **capabilities adicionadas**, **devices** e entradas de **security-opt**.

- Lista vazia significa política aberta, então tudo daquele tipo é permitido.
- A partir do momento em que há ao menos uma entrada, só o que está listado é permitido; o resto é rejeitado.
- **Imagens** casam por padrão glob (ex.: `ghcr.io/myorg/*`), permitindo liberar um namespace inteiro de registry sem listar cada tag.
- **Volumes** casam por prefixo em bind mounts (o caminho do host precisa começar com um prefixo permitido) ou por nome exato em volumes nomeados.
- **Redes**, **capabilities**, **devices** e **security-opt** casam de forma exata.

## Flags booleanas

Bloqueiam um ajuste perigoso específico, independente das listas de permissão:

| Flag | Bloqueia |
| --- | --- |
| `prevent_latest_images` | Imagens sem tag ou com `:latest`. Incentiva deploys fixados e reproduzíveis. |
| `block_host_volumes` | Qualquer bind mount (caminho absoluto, `./`, `../`, `~`). Volumes nomeados não são afetados. |
| `block_privileged` | Serviços com `privileged: true`. |
| `block_host_network` | Serviços com `network_mode: host`. |
| `block_host_pid` | Serviços com `pid: host`. |
| `block_host_ipc` | Serviços com `ipc: host`. |
| `block_docker_socket` | Montar `/var/run/docker.sock` ou `/run/docker.sock` em um container. |
| `allow_render_overrides` | *(invertida, padrão `false`)* Se um worker aceita alterações renderizadas (imagem/portas/rede/escala) em tempo real. Diferente das flags `block_*`, essa capacidade precisa ser ativada explicitamente por worker. |

Substituições de flag por worker são um mapa anulável. `null` numa flag significa "herdar do global", enquanto `true`/`false` a substitui explicitamente, assim um worker pode afrouxar ou apertar uma única flag sem reafirmar todas as outras.

## Vendo violações antes do deploy

Violações de política não são só uma surpresa no momento do deploy. O linter estático de Compose do wireops incorpora a política efetiva do worker ao seu relatório, então a saída do lint mostra de uma vez, antes de você commitar, cada violação que o arquivo sofreria no deploy. Sem política configurada (ou com a política desabilitada globalmente), o linter volta a usar suas regras próprias, apenas informativas.

## Relacionado

- [Controle de acesso e auditoria](../security/access-control-and-audit.md): como a política se encaixa junto ao RBAC e à auditoria.
- [Jobs agendados](jobs.md): como as mesmas checagens de política valem para imagem, volumes e rede de um job.
