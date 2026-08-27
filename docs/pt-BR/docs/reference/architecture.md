# Arquitetura

O wireops possui dois componentes: um servidor central e workers remotos. O servidor executa PocketBase, guarda o estado, acompanha repositórios Git, agenda tarefas e despacha comandos. Ele **não** executa `docker compose` nem `docker run` diretamente.

Workers se registram por token e mantêm uma conexão WebSocket autenticada. Cada worker recebe comandos tipados para implantar, remover, consultar ou executar jobs no Docker local. A interface Nuxt é estática e é servida pelo servidor, consumindo REST e realtime do PocketBase.

Essa separação permite que hosts remotos iniciem a conexão de saída sem expor seus daemons Docker ao servidor.

