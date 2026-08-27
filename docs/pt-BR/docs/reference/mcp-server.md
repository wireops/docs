# Servidor MCP

O `wireops-mcp` é um binário separado que oferece ferramentas de leitura e geração/scaffold para clientes MCP. Ele não possui uma credencial própria: repassa a autorização do cliente ao wireops e respeita as capacidades RBAC.

Use a URL do servidor, uma chave de API limitada e o transporte indicado pela sua integração MCP. Evite conceder uma chave acima do papel necessário e trate saídas de logs como potencialmente sensíveis.

