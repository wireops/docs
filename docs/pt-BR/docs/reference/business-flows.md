# Fluxos principais

## Sincronização GitOps

O agendador consulta cada stack, busca o commit mais recente, resolve o Compose, executa lint, aplica rótulos e revisões renderizadas e envia o resultado ao worker atribuído. O worker executa o Compose e devolve o resultado; o servidor registra logs, estado e notificações. Se o worker estiver offline, a reconciliação fica pendente e é reproduzida quando ele reconectar.

## Workers

Um administrador gera o token, o worker registra seu hostname e fingerprint, abre o WebSocket e envia heartbeats. O servidor só entrega comandos ao worker autenticado e ativo.

## Jobs agendados

Um `job.yaml` no repositório define cron, imagem, comando, tags, modo, recursos e timeout. Na execução, o servidor escolhe workers pelas tags, valida imagem/volumes/rede contra a [política do worker](policies.md), cria o registro de execução e o worker roda um container temporário, informando saída e código de retorno. Veja [Jobs agendados](jobs.md) para o esquema completo do arquivo, os modos de despacho e o ciclo de vida de uma execução.

## Init containers

Um serviço feito para rodar uma vez e sair — migração de banco, script de seed, qualquer job "one-shot" — não é a mesma coisa que um serviço de longa duração que travou, mas o wireops não distingue os dois por conta própria: qualquer container esperado que não esteja `running` normalmente conta como ausente, o que joga o status da stack inteira para degraded. Adicione o rótulo `customization.init: "true"` a esse serviço e o wireops passa a tratá-lo como exceção: sair com código 0 (ou simplesmente não existir mais, depois que o Docker limpar o container) conta como estado saudável e esperado. Ainda assim, o serviço continua contando contra a stack se sair com código diferente de zero ou entrar em loop de restart.

```yaml
services:
  migrate:
    image: myapp:1.4.0
    command: ["./migrate", "up"]
    restart: "no"
    labels:
      - "customization.init=true"
```

Só rotule serviços que realmente devem terminar sozinhos — colocar esse rótulo num serviço de longa duração esconderia uma falha real em vez de detectá-la.

