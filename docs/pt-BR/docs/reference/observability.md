# Observabilidade

O endpoint Prometheus canônico é `/metrics`; `/api/custom/metrics` é um alias. Usuários de monitoramento podem consultar métricas agregadas e métricas de workers conectados conforme seu papel.

Monitore disponibilidade do servidor, conexão de workers, duração/falha de sincronizações, execuções de jobs e espaço de backup. Use TLS e autenticação em qualquer coletor externo; métricas não substituem logs de sync, auditoria ou um teste de restauração.

