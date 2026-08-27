# Fluxos principais

## Sincronização GitOps

O agendador consulta cada stack, busca o commit mais recente, resolve o Compose, executa lint, aplica rótulos e revisões renderizadas e envia o resultado ao worker atribuído. O worker executa o Compose e devolve o resultado; o servidor registra logs, estado e notificações. Se o worker estiver offline, a reconciliação fica pendente e é reproduzida quando ele reconectar.

## Workers

Um administrador gera o token, o worker registra seu hostname e fingerprint, abre o WebSocket e envia heartbeats. O servidor só entrega comandos ao worker autenticado e ativo.

## Jobs agendados

Um `job.yaml` no repositório define cron, imagem, comando, tags, modo, recursos e timeout. Na execução, o servidor escolhe workers pelas tags, cria o registro de execução e o worker roda um container temporário, informando saída e código de retorno.

