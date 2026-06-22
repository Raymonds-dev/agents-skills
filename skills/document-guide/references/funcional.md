# Documentação Funcional

## Objetivo

A documentação funcional descreve o problema de negócio que o sistema resolve, seu propósito, suas capacidades e seus principais fluxos de utilização.

Ela deve permitir que uma pessoa compreenda o valor e a finalidade do sistema sem precisar conhecer detalhes técnicos de implementação.

A pergunta principal respondida por este tipo de documentação é:

> "O que este sistema faz e por que ele existe?"

---

## Quando criar

Crie documentação funcional quando o projeto:

* Resolve um problema de negócio.
* Possui usuários internos ou externos.
* Implementa processos, fluxos ou regras de negócio.
* Precisa ser compreendido por pessoas não técnicas.
* Possui mais de uma funcionalidade relevante.

Exemplos:

* Sistema de agendamento.
* ERP.
* Aplicativo mobile.
* Plataforma web.
* Microsserviço de negócio.
* Sistema de logística.
* Sistema financeiro.

---

## Quando pode ser simplificada ou omitida

A documentação funcional pode ser reduzida ou até mesmo omitida quando o projeto possui finalidade extremamente simples ou exclusivamente técnica.

Exemplos:

* Biblioteca utilitária.
* CLI simples.
* Script de automação.
* Ferramenta interna de uso restrito.
* Prova de conceito (PoC).

Nestes casos, uma breve descrição no README normalmente é suficiente.

---

## Público-alvo

A documentação funcional é destinada principalmente para:

* Product Owners.
* Analistas de negócio.
* Gestores.
* Stakeholders.
* Novos membros da equipe.
* Desenvolvedores que precisam compreender o domínio do sistema.

Não deve exigir conhecimento de linguagens, frameworks ou infraestrutura.

---

## O que deve conter

Dependendo da complexidade do projeto, a documentação funcional pode incluir:

### Visão Geral

Descrição resumida do sistema.

Exemplo:

"O sistema permite o gerenciamento de consultas odontológicas, incluindo cadastro de pacientes, agendamentos e controle financeiro."

### Problema

Qual problema motivou a criação da solução.

Exemplo:

"A clínica realizava o controle de consultas através de planilhas, dificultando o acompanhamento financeiro e operacional."

### Objetivo

Qual resultado o sistema busca alcançar.

Exemplo:

"Centralizar informações operacionais da clínica em uma única plataforma."

### Funcionalidades Principais

Principais capacidades oferecidas pelo sistema.

Exemplo:

* Cadastro de pacientes.
* Agendamento de consultas.
* Controle financeiro.
* Histórico de atendimentos.

### Fluxos Principais

Descrição dos processos mais importantes.

Exemplo:

1. Recepcionista agenda consulta.
2. Paciente comparece ao atendimento.
3. Consulta é registrada.
4. Pagamento é associado ao atendimento.

### Regras de Negócio

Regras importantes do domínio.

Exemplo:

* Uma consulta pode possuir múltiplas parcelas.
* Um paciente pode possuir múltiplos atendimentos.
* Apenas usuários autorizados podem cancelar consultas.

### Limitações Conhecidas

Restrições funcionais relevantes.

Exemplo:

* Não suporta múltiplas clínicas.
* Não realiza integração com convênios.

---

## O que NÃO deve conter

A documentação funcional não deve incluir:

### Tecnologias

Evitar:

* Java
* Python
* React
* PostgreSQL
* AWS

Essas informações pertencem à documentação técnica.

### Arquitetura

Evitar:

* Diagramas de microsserviços.
* Fluxos de infraestrutura.
* Comunicação entre componentes.

Essas informações pertencem à documentação arquitetural.

### Procedimentos Operacionais

Evitar:

* Como realizar deploy.
* Como executar rollback.
* Como configurar monitoramento.

Essas informações pertencem à documentação operacional.

### Estrutura de Código

Evitar:

* Estrutura de diretórios.
* Classes.
* Interfaces.
* Bibliotecas utilizadas.

Essas informações pertencem à documentação técnica.

---

## Sinais de que a documentação está errada

Considere revisar a documentação funcional quando:

* Ela menciona tecnologias frequentemente.
* Ela exige conhecimento técnico para compreensão.
* Ela descreve implementação ao invés de comportamento.
* Ela explica como algo foi construído ao invés do que ele faz.
* Ela replica informações presentes na documentação técnica.

---

## Critério de qualidade

Uma documentação funcional é considerada adequada quando uma pessoa sem conhecimento técnico consegue responder:

* Qual problema o sistema resolve?
* Quem utiliza o sistema?
* Quais são suas principais funcionalidades?
* Quais processos ele suporta?
* Quais limitações ele possui?

Sem precisar analisar código, infraestrutura ou arquitetura.
