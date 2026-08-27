# Nginx Proxy Manager

O Nginx Proxy Manager (NPM) não expõe labels de rota nos containers de aplicação como o Traefik. Adicione uma dica de proxy do wireops para gerar **Open**. Opcionalmente, informe a URL da interface NPM para gerar **NPM Admin**.

## Configurar

Habilite **Nginx Proxy Manager** em **Settings → Integrations**.

| Campo | Padrão | Descrição |
| --- | --- | --- |
| Scheme | `https` | Esquema padrão para hosts sem dica de esquema. |
| Port | vazio | Porta opcional; `80` e `443` são omitidas. |
| Admin URL | vazio | URL de administração do NPM; adiciona **NPM Admin**. |
| Local Hosts | ligado | Permite hosts privados/locais nas ações. |

## Adicionar label ao serviço

Use um host ou uma lista separada por vírgulas. Os prefixos `npm` e `proxy` são aceitos.

```yaml
services:
  app:
    image: ghcr.io/example/app:1.0
    labels:
      dev.wireops.npm.host: app.example.com
      # Ou: dev.wireops.proxy.hosts: app.example.com,admin.example.com
      # Opcional: dev.wireops.npm.scheme: http
```

O label registra um host que já está configurado no NPM; ele não cria um Proxy Host.

## Conferir e proteger

- Informe Admin URL apenas se os usuários do wireops puderem alcançar a administração do NPM.
- Desligue hosts locais em instâncias compartilhadas ou expostas à internet.
- Mantenha o label sincronizado com a configuração do Proxy Host para evitar links desatualizados.
