# Dozzle

O Dozzle é um visualizador de logs Docker no navegador. Quando habilitado, o wireops acrescenta **Dozzle Logs** para cada container, apontando para ele na sua instância Dozzle.

## Configurar

Habilite **Dozzle** em **Settings → Integrations** e informe a **Dozzle URL** obrigatória, por exemplo `https://logs.example.com`.

Não são necessárias labels no Compose. O link de cada container é `{Dozzle URL}/container/{container ID}`.

## Validar

1. Abra a URL do Dozzle e confirme que o host Docker aparece.
2. Faça deploy ou atualize uma stack no wireops.
3. Abra um container e selecione **Dozzle Logs**.

Se a ação abre mas não há logs, corrija a conectividade Docker/agente remoto do próprio Dozzle. O wireops apenas monta o link.

## Segurança

O Dozzle pode revelar saída de aplicações, inclusive dados sensíveis. Proteja-o com autenticação, restrinja a rede e não grave segredos em logs.
