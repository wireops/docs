# Traefik

A integração Traefik lê regras de host de roteadores HTTP de um container e adiciona uma ação **Open** no wireops. Ela não configura o Traefik nem publica portas: a rota já deve existir.

## Configurar

Em **Settings → Integrations → Traefik**, habilite a integração e defina:

| Campo | Obrigatório | Descrição |
| --- | --- | --- |
| Scheme | Não | Esquema das URLs geradas. O padrão é `https`. |
| Port | Não | Porta acrescentada às URLs. Deixe vazia para o padrão; `80` e `443` são omitidas. |

## Adicionar label ao serviço

O wireops lê `traefik.http.routers.<router>.rule` e reconhece valores `Host(...)`.

```yaml
services:
  app:
    image: ghcr.io/example/app:1.0
    labels:
      traefik.enable: "true"
      traefik.http.routers.app.rule: Host(`app.example.com`)
```

Depois do deploy, abra os detalhes do container e use **Open**. O host precisa ser alcançável pelo navegador do operador; a label não configura DNS ou TLS.

## Conferir e proteger

- Teste primeiro com um host HTTPS conhecido.
- Uma regra pode ter vários hosts; o wireops cria uma ação para cada host válido.
- Proteja separadamente o dashboard e as permissões do socket Docker do Traefik.
