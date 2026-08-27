# Início rápido

O wireops possui um servidor central e um ou mais workers remotos. O servidor guarda a configuração e despacha comandos; os workers executam `docker compose` e containers agendados nos hosts atribuídos.

## Requisitos

- Host Linux `amd64` ou `arm64`.
- Docker Engine 25.0+ e Docker Compose v2.24.1+.
- Diretório de dados gravável para o container do servidor.
- Acesso de rede de cada worker ao servidor; use TLS ou rede privada para workers remotos.

Mantenha servidor e workers na mesma release. Consulte [compatibilidade](../operations/compatibility.md) antes de atualizar.

## 1. Inicie o servidor

Gere a chave de criptografia:

```bash
openssl rand -hex 32
```

Use essa saída em `SECRET_KEY`, defina um `BOOTSTRAP_TOKEN` forte de uso único, e inicie o servidor.

O container do servidor roda como UID/GID `1000`, não root. No Linux, crie o diretório de dados e ceda a posse antes, ou o servidor falha com `permission denied` ao criar `pb_data`:

```bash
mkdir -p data
sudo chown -R 1000:1000 data
```

```bash
docker run -d --name wireops \
  -p 8090:8090 -p 8443:8443 \
  -v "$(pwd)/data:/data" \
  -e SECRET_KEY=cole-a-chave-gerada \
  -e BOOTSTRAP_TOKEN=um-token-forte-de-uso-unico \
  -e APP_URL=http://localhost:8090 \
  ghcr.io/wireops/server:1.0.0
```

`APP_URL=http://localhost:8090` só funciona se você abrir a interface na mesma máquina onde o servidor roda. Se for acessar de outro host, defina `APP_URL` com esse endereço alcançável (ex.: `http://192.168.1.100:8090`), ou sua origem `https://` depois de colocar TLS na frente.

Prefere Compose? Veja o [`docker-compose.yml` de exemplo](https://github.com/wireops/wireops/blob/main/example/docker-compose.yml). Copie `example/.env.example` para `example/.env`, preencha as mesmas variáveis e rode `docker compose up -d wireops` dentro de `example/`. Veja [solução de problemas](../operations/troubleshooting.md) se o container continuar sem conseguir escrever em `data/`.

Abra `http://localhost:8090/setup`, informe o token e crie o primeiro administrador. Não existem credenciais padrão.

## 2. Conecte um worker

Na interface, abra **Workers → Add Worker** e copie o token. No host do worker:

```bash
docker run -d --name wireops-worker \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --group-add "$(stat -c '%g' /var/run/docker.sock)" \
  -e SERVER_URL=http://host-do-seu-servidor:8443 \
  -e WORKER_TOKEN=cole-o-token \
  -e WORKER_TAGS=prod,eu-west-1 \
  ghcr.io/wireops/worker:1.0.0
```

Fixe o worker exatamente na mesma versão do servidor (`1.0.0` acima); veja [compatibilidade](../operations/compatibility.md) pra entender por que uma dupla divergente não é suportada. A URL `http://` acima só serve numa rede privada ou no mesmo host Docker do servidor; para um worker em outra rede, use `https://` com [TLS habilitado](../operations/production.md#rede-e-acesso) no servidor.

`--group-add` (ou `DOCKER_GID` no Compose) só é necessário no Linux, quando o socket do Docker não é acessível por padrão. Veja [solução de problemas](../operations/troubleshooting.md) se o worker reportar erro de permissão. O mesmo [`docker-compose.yml` de exemplo](https://github.com/wireops/wireops/blob/main/example/docker-compose.yml) tem um serviço `wireops-worker` caso prefira rodar via Compose.

Tags selecionam os workers elegíveis para stacks e jobs. Confirme que o worker fica `ACTIVE` na interface.

## 3. Adicione a primeira stack

1. Adicione o repositório e suas credenciais, se privado.
2. Crie uma stack que aponta para o arquivo Compose no repositório.
3. Atribua o worker e as variáveis de ambiente necessárias.
4. Dispare a sincronização ou ative a sincronização automática.

O worker recebe o Compose renderizado e o implanta localmente. Leia as orientações de [produção](../operations/production.md) antes de expor uma carga real.

Quer um assistente de IA operando o wireops? Configure o [servidor MCP](../reference/mcp-server.md).

