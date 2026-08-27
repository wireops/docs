# Compatibilidade e suporte

Servidor e worker devem executar a **mesma release exata** do wireops. O protocolo entre eles é tratado como interno e pode mudar antes da versão 1.0.

- Linux `amd64` e `arm64` são as plataformas suportadas para workers.
- Use Docker Engine 25.0+ e Docker Compose v2.24.1+.
- Navegadores modernos com JavaScript habilitado são necessários para a interface.
- Vault, Infisical, S3, OIDC e integrações exigem as versões e credenciais compatíveis dos respectivos serviços.

O projeto está em pré-1.0 e é mantido em ritmo de projeto comunitário. Priorize as releases atuais e abra uma issue com versões, logs redigidos e ambiente reproduzível quando precisar de ajuda.

