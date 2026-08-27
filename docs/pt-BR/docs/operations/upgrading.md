# Atualização

Atualize servidor e workers juntos para a mesma release. Leia o changelog da versão alvo e a [política de compatibilidade](compatibility.md) antes de iniciar.

1. Crie e, de preferência, copie um backup para fora do host.
2. Fixe a nova tag de imagem no Compose do servidor e dos workers.
3. Atualize o servidor; confirme `/api/health` e o login.
4. Atualize cada worker e aguarde o status `ACTIVE`.
5. Execute uma sincronização de uma stack não crítica e confira o log de deploy.

Não descarte o backup nem a imagem anterior até confirmar que uma restauração e um deploy funcionam. Reverter a tag de imagem é a primeira medida em caso de falha; restaure o banco apenas quando necessário.

