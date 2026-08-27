# Adicionar uma integração

Uma integração implementa a interface registrada em `internal/integrations/`, declara slug, nome, categoria e ações de container quando aplicável. Registre-a com `init()`, adicione campos de configuração apenas quando necessários, inclua migração para configurações padrão e cubra comportamento com testes.

Não misture credenciais em rótulos de Compose nem altere integrações existentes sem manter compatibilidade. Atualize a interface e esta documentação quando o usuário precisar de nova configuração.

