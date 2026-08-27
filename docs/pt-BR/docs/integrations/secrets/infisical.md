# Infisical

A integração Infisical resolve variáveis de ambiente secretas com uma Machine Identity do Infisical usando Universal Auth. O wireops armazena referências e busca os valores durante o deploy.

## Configurar

Habilite **Infisical** em **Settings → Integrations**.

| Campo | Obrigatório | Descrição |
| --- | --- | --- |
| Site URL | Não | URL da API/interface Infisical. Vazia usa Infisical Cloud. |
| Client ID | Sim | Client ID da Machine Identity. |
| Client Secret | Sim | Client secret da Machine Identity. |
| Limit to Project | Não | Restringe pesquisa e seleção a um project ID. |

Selecione **Test Connection**. A identidade precisa ter leitura do projeto, ambiente e caminhos desejados.

## Usar e proteger

Ao criar uma variável secreta, selecione `infisical` e escolha projeto, ambiente, caminho e chave disponibilizados pela integração. Use uma Machine Identity dedicada e somente leitura, limitada ao projeto/caminho necessário; rotacione o segredo conforme a política do Infisical.
