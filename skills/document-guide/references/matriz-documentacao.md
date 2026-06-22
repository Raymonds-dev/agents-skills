# Matriz de uso de documentação por tipo de sistema

| Tipo de sistema                           | Funcional    | Técnica      | Arquitetural | Operacional | ADR            |
| ----------------------------------------- | ------------ | ------------ | ------------ | ----------- | -------------- |
| Biblioteca / SDK                          | Sim          | Sim          | Não          | Não         | Sim (opcional) |
| CLI simples                               | Sim          | Sim          | Não          | Não         | Opcional       |
| Script / automação                        | Sim (mínimo) | Opcional     | Não          | Não         | Não            |
| API simples (CRUD)                        | Sim          | Sim          | Sim          | Opcional    | Sim (opcional) |
| API em produção                           | Sim          | Sim          | Sim          | Sim         | Sim            |
| Aplicação web                             | Sim          | Sim          | Sim          | Sim         | Sim            |
| Aplicação mobile + backend                | Sim          | Sim          | Sim          | Sim         | Sim            |
| Microsserviço                             | Sim          | Sim          | Sim          | Sim         | Sim            |
| Sistema distribuído                       | Sim          | Sim          | Sim          | Sim         | Sim            |
| Lambda isolada                            | Sim          | Sim          | Sim (leve)   | Opcional    | Opcional       |
| Sistema interno simples                   | Sim          | Sim          | Opcional     | Não         | Opcional       |
| Sistema crítico (financeiro, saúde, etc.) | Sim          | Sim          | Sim          | Sim         | Sim            |
| PoC / protótipo                           | Sim (mínimo) | Sim (mínimo) | Não          | Não         | Não            |

---

# Regras derivadas da matriz

## 1. Regra de corte mínimo

Se um sistema não tem usuários ou não produz valor contínuo:

* Funcional → obrigatório (mínimo)
* Técnica → opcional
* Arquitetural → geralmente não
* Operacional → não
* ADR → não

---

# Insight importante

A decisão não deve ser:
> “quais documentos posso criar?”
E sim:
> “quais documentos são necessários para que alguém consiga entender, manter e operar esse sistema sem contexto prévio?”
