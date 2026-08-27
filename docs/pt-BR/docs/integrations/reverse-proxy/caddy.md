# Caddy

A integração Caddy descobre rotas gerenciadas pelo Caddy Docker Proxy e adiciona uma ação **Open** para os hosts configurados. Ela só cria links; roteamento e certificados continuam sendo responsabilidade do Caddy.

## Configurar

Habilite **Caddy** em **Settings → Integrations** e escolha:

| Campo | Padrão | Descrição |
| --- | --- | --- |
| Scheme | `https` | Esquema usado nos links. |
| Port | vazio | Porta opcional; `80` e `443` são omitidas. |
| Wildcard Hosts | desligado | Permite que hosts como `*.example.com` virem links. |
| Local Hosts | ligado | Permite `localhost`, `.local` e endereços privados/locais. Desligue em um control plane compartilhado. |

## Adicionar label ao serviço

Use as labels de site do Caddy Docker Proxy. A integração examina `caddy`, `caddy_0`, `caddy_1` e assim por diante.

```yaml
services:
  app:
    image: ghcr.io/example/app:1.0
    labels:
      caddy: app.example.com
      caddy.reverse_proxy: "{{upstreams 8080}}"
```

Faça o deploy e selecione **Open** no container. Várias labels de site podem gerar várias ações.

## Conferir e proteger

- Deixe wildcard hosts desligado, salvo quando os operadores puderem usar esses hosts com segurança.
- Desligue hosts locais em uma instância compartilhada ou exposta à internet.
- Confira o link depois de o Caddy carregar a rota; esta integração não consulta o estado de execução do Caddy.
