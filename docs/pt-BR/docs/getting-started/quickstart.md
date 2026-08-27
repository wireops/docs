# Início rápido

O wireops possui um servidor central e um ou mais workers remotos. O servidor guarda a configuração e despacha comandos; os workers executam `docker compose` e containers agendados nos hosts atribuídos.

## Requisitos

- Host Linux `amd64` ou `arm64`.
- Docker Engine 25.0+ e Docker Compose v2.24.1+.
- Diretório de dados gravável para o container do servidor.
- Acesso de rede de cada worker ao servidor; use TLS ou rede privada para workers remotos.

Mantenha servidor e workers na mesma release. Consulte [compatibilidade](../operations/compatibility.md) antes de atualizar.

## 1. Inicie o servidor

Gere a chave de criptografia e configure o ambiente de exemplo:

```bash
openssl rand -hex 32
cp example/.env.example example/.env
cd example
docker compose up -d wireops
```

Defina `SECRET_KEY` com a saída do comando e um `BOOTSTRAP_TOKEN` forte, de uso único. Abra `http://localhost:8090/setup`, informe o token e crie o primeiro administrador. Não existem credenciais padrão.

## 2. Conecte um worker

Na interface, abra **Workers → Add Worker** e copie o token. No host do worker:

```bash
WORKER_TOKEN=cole-o-token WORKER_TAGS=prod,eu-west-1 docker compose up -d wireops-worker
```

Tags selecionam os workers elegíveis para stacks e jobs. Confirme que o worker fica `ACTIVE` na interface.

## 3. Adicione a primeira stack

1. Adicione o repositório e suas credenciais, se privado.
2. Crie uma stack que aponta para o arquivo Compose no repositório.
3. Atribua o worker e as variáveis de ambiente necessárias.
4. Dispare a sincronização ou ative a sincronização automática.

O worker recebe o Compose renderizado e o implanta localmente. Leia as orientações de [produção](../operations/production.md) antes de expor uma carga real.

