# Implantação em produção

O início rápido prova a instalação; produção exige uma versão de imagem fixada, TLS para workers remotos, backup externo e um teste de restauração.

## Antes do go-live

- Fixe `WIREOPS_VERSION`; nunca use `latest`.
- Guarde `SECRET_KEY` fora do diretório de dados. Perdê-la impede descriptografar os segredos armazenados.
- Use um `BOOTSTRAP_TOKEN` forte apenas durante a criação do primeiro administrador e remova-o depois.
- Garanta que o diretório de dados e o socket Docker tenham as permissões esperadas pelo usuário do container.

## Rede e acesso

Use TLS nativo ou uma rede privada entre servidor e workers. O servidor não executa Docker: cada worker deve ter acesso ao seu daemon local e só recebe comandos autenticados pelo WebSocket.

Configure RBAC, uma política de deploy restritiva, auditoria e SSO antes de conceder acesso a operadores. Consulte [controle de acesso](../security/access-control-and-audit.md).

## Dados e recuperação

Faça backup regular do banco PocketBase, revisões renderizadas e configurações. Espelhe cópias em S3 compatível quando possível e realize uma restauração em ambiente separado. Veja [recuperação de desastre](disaster-recovery.md).

## Verificação de go-live

1. Faça login como administrador e como operador.
2. Registre um worker remoto com TLS.
3. Implante uma stack de teste e confira logs, métricas e auditoria.
4. Crie e restaure um backup de teste.
5. Confirme alertas de erro e documentação de escalonamento.

