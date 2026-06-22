# Documentação Técnica

## Objetivo

A documentação técnica descreve como o sistema foi construído, quais tecnologias utiliza, como está organizado internamente e quais dependências são necessárias para seu funcionamento.

Ela deve permitir que um desenvolvedor compreenda rapidamente a estrutura da solução e consiga realizar manutenção, evolução ou correção do sistema.

A pergunta principal respondida por este tipo de documentação é:

> "Como este sistema foi construído?"

---

## Quando criar

Crie documentação técnica quando o projeto:

* Possui código que será mantido por outras pessoas.
* Possui dependências externas relevantes.
* Utiliza banco de dados.
* Possui configuração própria.
* Será evoluído ao longo do tempo.
* Faz parte de um ambiente produtivo.

Exemplos:

* APIs.
* Aplicações web.
* Aplicações mobile.
* Microsserviços.
* Lambdas.
* Bibliotecas compartilhadas.
* Ferramentas internas.

---

## Quando pode ser simplificada

A documentação técnica pode ser reduzida quando o projeto:

* É um experimento temporário.
* É uma prova de conceito descartável.
* Possui poucas centenas de linhas de código.
* É utilizado apenas pelo autor.

Mesmo nesses casos, recomenda-se ao menos documentar:

* Tecnologias utilizadas.
* Dependências relevantes.
* Como executar localmente.

---

## Público-alvo

A documentação técnica é destinada principalmente para:

* Desenvolvedores.
* Engenheiros de software.
* Equipes de manutenção.
* Equipes de suporte técnico.
* Novos integrantes do time.

Não deve ser escrita pensando em usuários finais.

---

## O que deve conter

Dependendo da complexidade do sistema, a documentação técnica pode incluir:

### Tecnologias Utilizadas

Principais tecnologias adotadas.

Exemplo:

* Java 21
* Spring Boot
* PostgreSQL
* Redis
* Docker

O objetivo não é listar todas as dependências do projeto, mas destacar as tecnologias relevantes para compreensão da solução.

---

### Estrutura do Projeto

Explicação da organização do código.

Exemplo:

```text
src/
├── controller/
├── service/
├── repository/
├── model/
└── config/
```

Deve explicar a responsabilidade de cada diretório ou módulo importante.

---

### Dependências Externas

Serviços necessários para funcionamento.

Exemplo:

* Banco PostgreSQL.
* Redis.
* Firebase Auth.
* AWS S3.
* APIs de terceiros.

Também pode incluir requisitos mínimos para desenvolvimento local.

---

### Configurações

Configurações importantes para execução.

Exemplo:

* Variáveis de ambiente.
* Arquivos de configuração.
* Perfis de execução.
* Secrets necessárias.

Não devem ser armazenados segredos reais na documentação.

---

### Banco de Dados

Quando aplicável, documentar:

* Entidades principais.
* Relacionamentos.
* Regras relevantes de persistência.

Não é necessário reproduzir integralmente o esquema do banco se já existir documentação específica para isso.

---

### Interfaces Expostas

Quando o sistema disponibiliza interfaces para consumo.

Exemplos:

* Endpoints REST.
* Eventos publicados.
* Eventos consumidos.
* Mensagens de fila.
* Comandos CLI.

A documentação deve focar no contrato técnico.

---

### Fluxos Técnicos Relevantes

Explicação de comportamentos internos importantes.

Exemplo:

1. Requisição chega ao Controller.
2. Service valida os dados.
3. Repository persiste informações.
4. Evento é publicado na fila.

Esses fluxos ajudam novos desenvolvedores a compreender o funcionamento interno do sistema.

---

### Convenções e Padrões

Padrões adotados pelo projeto.

Exemplo:

* Clean Architecture.
* Repository Pattern.
* Event Driven.
* CQRS.
* Nomenclatura de arquivos.

O objetivo é tornar decisões de implementação previsíveis.

---

## O que NÃO deve conter

### Objetivos de Negócio

Evitar explicações extensas sobre:

* Problemas de negócio.
* Justificativas comerciais.
* Necessidades dos usuários.

Essas informações pertencem à documentação funcional.

---

### Diagramas de Arquitetura Corporativa

Evitar:

* Contexto organizacional.
* Dependências entre domínios.
* Diagramas de sistemas corporativos.
* Fluxos entre aplicações.

Essas informações pertencem à documentação arquitetural.

---

### Procedimentos Operacionais

Evitar:

* Deploy.
* Rollback.
* Alertas.
* Monitoramento.
* Resposta a incidentes.

Essas informações pertencem à documentação operacional.

---

### Histórico de Decisões

Evitar registrar longas justificativas sobre escolhas realizadas.

Exemplo:

"Escolhemos PostgreSQL porque..."

Essas informações pertencem aos registros de decisão (ADR).

A documentação técnica deve registrar que PostgreSQL é utilizado, não necessariamente o motivo da escolha.

---

## Relação com outras documentações

Para entender a divisão de escopo e a relação da documentação técnica com os demais níveis de documentação do projeto, consulte a **[Matriz de Responsabilidades](../SKILL.md#matriz-de-responsabilidades)** no guia principal.

---

## Sinais de que a documentação está errada

Considere revisar a documentação técnica quando:

* Explica regras de negócio em excesso.
* Descreve processos organizacionais.
* Contém instruções de operação e suporte.
* Possui diagramas corporativos complexos.
* Mistura implementação com justificativas históricas.

---

## Critério de qualidade

Uma documentação técnica é considerada adequada quando um desenvolvedor consegue responder:

* Quais tecnologias o sistema utiliza?
* Como o código está organizado?
* Quais dependências externas existem?
* Como os dados são armazenados?
* Quais interfaces o sistema expõe?
* Como os principais fluxos internos funcionam?

Sem precisar explorar o código-fonte por conta própria.
