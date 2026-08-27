# Recuperação de desastre

O backup do wireops protege dados de controle, não os volumes de aplicação. Faça backup independente de bancos, volumes e dados das suas cargas.

## Rotina

Crie backups regularmente e espelhe-os para armazenamento S3 compatível fora do host. Proteja o `SECRET_KEY` separadamente: sem ele os segredos cifrados não podem ser recuperados.

## Restaurar em um novo servidor

1. Instale a mesma release do wireops e preserve o `SECRET_KEY` original.
2. Pare o servidor e restaure o backup pelo fluxo suportado.
3. Inicie o servidor, valide administradores, repositórios, stacks e integrações.
4. Registre novamente workers que não sobreviveram ao incidente.
5. Execute uma sincronização controlada antes de ativar auto-sync.

Teste o procedimento periodicamente. Um backup não verificado não é um plano de recuperação.

