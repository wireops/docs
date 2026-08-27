# Controle de acesso e auditoria

O RBAC do wireops separa capacidades de visualização, operação, administração e monitoramento. Rotas verificam capacidades, não apenas nomes de perfil.

| Perfil | Uso |
| --- | --- |
| Viewer | Consultar stacks e estados permitidos |
| Operator | Operar stacks e jobs dentro das permissões |
| Admin | Configurar usuários, segurança e o sistema |
| Monitoring | Acesso focado em métricas |

## Política de deploy

A política do worker impede configurações perigosas como containers privilegiados, namespaces de host, socket Docker, volumes de host ou imagens `latest`, além de poder limitar imagens, redes, volumes, dispositivos e capacidades. Há uma política global e substituições por worker; uma alteração renderizada e o despacho de [jobs agendados](../reference/jobs.md) continuam sujeitos às mesmas regras. Veja [Política de deploy](../reference/policies.md) para a referência completa de listas de permissão, flags e herança.

## Auditoria

Mudanças e operações relevantes são registradas com ator, origem, recurso, resultado e horário. Restrinja quem consulta esses logs, defina a retenção apropriada e use-os durante incidentes ou revisões de acesso.

