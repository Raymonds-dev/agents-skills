# Documentação Operacional

## Objetivo

A documentação operacional descreve como implantar, monitorar, operar, manter e recuperar o sistema durante sua execução em ambientes reais.

Seu objetivo é permitir que equipes técnicas consigam realizar atividades operacionais de forma segura, previsível e consistente.

A pergunta principal respondida por este tipo de documentação é:

> "Como manter este sistema funcionando?"

---

## Quando criar

Crie documentação operacional quando o projeto:

* Está em produção.
* Possui usuários ativos.
* Requer monitoramento.
* Possui processos de implantação.
* Necessita recuperação em caso de falha.
* É mantido por múltiplas pessoas ou equipes.

Exemplos:

* APIs corporativas.
* Microsserviços.
* Aplicações web.
* Aplicações mobile com backend.
* Sistemas distribuídos.
* Sistemas internos críticos.

---

## Quando pode ser simplificada

A documentação operacional pode ser reduzida quando:

* O projeto é experimental.
* O sistema é utilizado apenas localmente.
* Não existe ambiente produtivo.
* Não há necessidade de monitoramento.
* O projeto possui baixa criticidade.

Nestes casos, instruções simples de execução podem ser suficientes.

---

## Público-alvo

A documentação operacional é destinada principalmente para:

* Equipes DevOps.
* Equipes SRE.
* Desenvolvedores responsáveis pela sustentação.
* Equipes de suporte.
* Equipes de infraestrutura.
* Plantonistas e responsáveis por incidentes.

---

## O que deve conter

Dependendo da complexidade da solução, a documentação operacional pode incluir:

### Ambientes

Descrição dos ambientes disponíveis.

Exemplo:

* Desenvolvimento
* Homologação
* Produção

Documentar:

* Finalidade de cada ambiente.
* Diferenças relevantes.
* Restrições de acesso.

---

### Deploy

Documentação do processo de implantação.

Exemplo:

* Pipeline utilizada.
* Etapas de publicação.
* Aprovações necessárias.
* Dependências para implantação.

A documentação deve permitir que um operador compreenda como uma nova versão chega ao ambiente.

---

### Rollback

Procedimento para retorno a uma versão anterior.

Documentar:

* Quando executar rollback.
* Como executar rollback.
* Impactos esperados.
* Validações após rollback.

Sempre que possível, fornecer passos objetivos.

Exemplo:

```text
1. Selecionar versão anterior.
2. Executar pipeline de rollback.
3. Validar health check.
4. Confirmar estabilização do sistema.
```

---

### Monitoramento

Descrição dos mecanismos de observabilidade.

Documentar:

* Dashboards disponíveis.
* Ferramentas utilizadas.
* Métricas relevantes.
* Indicadores principais.

Exemplos:

* Latência.
* Taxa de erro.
* Consumo de recursos.
* Volume de requisições.

O foco deve ser operacional e não técnico.

---

### Alertas

Documentação dos alertas configurados.

Para cada alerta, informar:

* O que significa.
* Possíveis causas.
* Nível de criticidade.
* Ação recomendada.

Exemplo:

#### Taxa de erro elevada

Possíveis causas:

* Banco indisponível.
* Integração externa falhando.

Ações:

* Verificar logs.
* Verificar integrações.
* Validar conectividade.

---

### Logs

Documentar:

* Onde os logs estão disponíveis.
* Como acessá-los.
* Quais logs são mais relevantes para diagnóstico.

Não é necessário documentar todas as mensagens geradas pelo sistema.

---

### Dependências Operacionais

Serviços necessários para funcionamento.

Exemplo:

* Banco de dados.
* Filas.
* Cache.
* Serviços externos.
* Sistemas corporativos.

O objetivo é facilitar investigações durante incidentes.

---

### Procedimentos de Incidente

Instruções para tratamento de falhas conhecidas.

Exemplo:

#### Fila parada

Sintomas:

* Processamento interrompido.

Verificações:

* Consumidores ativos.
* Quantidade de mensagens acumuladas.

Ações:

* Reiniciar consumidor.
* Validar processamento.

---

### Health Checks

Documentar:

* Endpoints de saúde.
* Critérios de funcionamento.
* Validações básicas.

Exemplo:

```text
GET /health

Status esperado:
200 OK
```

---

## O que NÃO deve conter

### Regras de Negócio

Evitar:

* Casos de uso.
* Fluxos de negócio.
* Objetivos comerciais.

Essas informações pertencem à documentação funcional.

---

### Estrutura de Código

Evitar:

* Classes.
* Interfaces.
* Métodos.
* Estrutura de diretórios.

Essas informações pertencem à documentação técnica.

---

### Diagramas Arquiteturais Detalhados

Evitar:

* Explicações arquiteturais extensas.
* Contextos corporativos.
* Decisões estruturais.

Essas informações pertencem à documentação arquitetural.

---

### Histórico de Decisões

Evitar:

* Justificativas de escolha tecnológica.
* Comparações entre soluções.
* Registros históricos.

Essas informações pertencem aos ADRs.

---

## Boas Práticas

### Priorizar procedimentos executáveis

Prefira:

```text
1. Acessar dashboard.
2. Verificar métrica.
3. Executar ação.
```

Ao invés de descrições genéricas.

---

### Manter informações atualizadas

Documentação operacional desatualizada pode ser mais prejudicial do que sua ausência.

Sempre revisar após:

* Mudanças de deploy.
* Mudanças de monitoramento.
* Mudanças de infraestrutura.
* Alterações de processos operacionais.

---

### Utilizar checklists

Sempre que possível, utilizar listas de verificação.

Exemplo:

#### Pós Deploy

* Aplicação iniciou corretamente.
* Health check respondeu.
* Logs sem erros.
* Métricas normais.
* Alertas não acionados.

---

### Focar em ações

A documentação operacional deve orientar decisões durante atividades reais.

Priorizar:

* O que verificar.
* Onde verificar.
* Como agir.

Evitar explicações excessivamente conceituais.

---

## Relação com outras documentações

Para entender a divisão de escopo e a relação da documentação operacional com os demais níveis de documentação do projeto, consulte a **[Matriz de Responsabilidades](../SKILL.md#matriz-de-responsabilidades)** no guia principal.

---

## Critério de qualidade

Uma documentação operacional é considerada adequada quando uma pessoa consegue responder:

* Como realizar deploy?
* Como realizar rollback?
* Como verificar a saúde do sistema?
* Onde encontrar logs?
* Quais alertas existem?
* Como agir durante incidentes conhecidos?

Sem depender de conhecimento prévio da implementação ou da arquitetura detalhada do sistema.
