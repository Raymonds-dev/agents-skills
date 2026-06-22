<!-- TEMPLATE: operacional -->
# Documentação Operacional

> Utilize apenas as seções relevantes para o projeto.
> Este documento deve ser orientado a ações práticas e execução em ambiente real.
> Evite explicações conceituais — foque no que fazer e como fazer.

---

# Visão Geral Operacional

## Objetivo
<!-- INICIO:OBJETIVO (OBRIGATÓRIO) -->
Descreva sucintamente como o sistema é mantido e operado no dia a dia em produção.
<!-- FIM:OBJETIVO -->

---

# Ambientes

## Ambientes Disponíveis
<!-- INICIO:AMBIENTES (OBRIGATÓRIO) -->
Descreva os ambientes disponíveis e suas finalidades:
* **Desenvolvimento (Dev):** Local de testes locais e integração inicial.
* **Homologação (Staging):** Ambiente idêntico a produção para validação pré-release.
* **Produção (Prod):** Ambiente final com usuários reais.
<!-- FIM:AMBIENTES -->

---

# Deploy

## Processo de Deploy
<!-- INICIO:DEPLOY (OBRIGATÓRIO) -->
Descreva passo a passo o processo para implantação de uma nova versão:
1. Merge da branch `main` dispara pipeline de CI/CD automaticamente no GitHub Actions.
2. Execução dos testes e build da imagem Docker.
3. Deploy da imagem no cluster ECS da AWS.
4. Validação do Health Check pós-deploy.
<!-- FIM:DEPLOY -->

---

# Rollback

## Processo de Rollback
<!-- INICIO:ROLLBACK (OBRIGATÓRIO) -->
Procedimento passo a passo para reverter uma versão em caso de falha grave:
1. Acessar o console do GitHub Actions.
2. Selecionar o workflow de Deploy.
3. Executar o rollback manual inserindo a tag da versão estável anterior.
4. Validar o Health Check do ambiente.
<!-- FIM:ROLLBACK -->

---

# Monitoramento e Alertas

## Ferramentas e Dashboards
<!-- INICIO:MONITORAMENTO (OPCIONAL) -->
Ferramentas de telemetria e links para dashboards principais:
* **Grafana:** Link para o dashboard de latência e consumo de CPU/Memória.
* **CloudWatch:** logs e monitoramento da infraestrutura ECS.
<!-- FIM:MONITORAMENTO -->

## Principais Alertas
<!-- INICIO:ALERTAS (OPCIONAL) -->
Principais alarmes que exigem ação do operador:
| Alerta | Significado | Ação Recomendada |
| ------ | ----------- | ---------------- |
| `HTTP 5XX High Rate` | Erros 500 elevados | Verificar logs da aplicação no CloudWatch buscando por exceções. |
<!-- FIM:ALERTAS -->

---

# Logs

## Acesso a Logs
<!-- INICIO:LOGS (OPCIONAL) -->
Instruções para localizar e filtrar logs do sistema:
* logs da aplicação estão centralizados no CloudWatch sob o grupo `/ecs/app-prod`.
<!-- FIM:LOGS -->

---

# Incidentes

## Procedimento de Resposta a Incidentes Comuns
<!-- INICIO:INCIDENTES (OBRIGATÓRIO) -->
Como proceder diante de problemas operacionais críticos:
1. **Banco Inacessível:** Verificar status do banco no painel RDS da AWS. Se estiver travado, reiniciar a instância RDS.
2. **Consumo 100% CPU:** Escalar manualmente o número de tarefas no ECS pelo console AWS.
<!-- FIM:INCIDENTES -->

---

# Health Checks

## Endpoints e Critérios
<!-- INICIO:HEALTH_CHECKS (OBRIGATÓRIO) -->
Como testar o estado de saúde da aplicação:
```text
GET /health
```
Resposta esperada:
```json
{
  "status": "UP",
  "database": "CONNECTED"
}
```
<!-- FIM:HEALTH_CHECKS -->

---

# Referências

## Documentação Relacionada
* [Documentação Funcional](./funcional.md)
* [Documentação Técnica](./tecnica.md)
* [Documentação Arquitetural](./arquitetural.md)
