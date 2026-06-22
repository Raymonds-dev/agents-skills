# Documentação Arquitetural

## Objetivo

A documentação arquitetural descreve a estrutura do sistema em alto nível, seus componentes, suas responsabilidades, suas integrações e a forma como se relacionam.

Seu objetivo é permitir que uma pessoa compreenda como o sistema se encaixa em um contexto maior e como seus elementos colaboram para atender aos requisitos do negócio.

A pergunta principal respondida por este tipo de documentação é:

> "Como as partes do sistema se relacionam e por que essa estrutura existe?"

---

## Quando criar

Crie documentação arquitetural quando o projeto:

* Possui múltiplos componentes.
* Possui integrações com outros sistemas.
* Utiliza serviços externos.
* Faz parte de um ecossistema maior.
* Possui requisitos de escalabilidade, disponibilidade ou segurança relevantes.
* Será mantido por múltiplas equipes.

Exemplos:

* APIs corporativas.
* Microsserviços.
* Sistemas distribuídos.
* Aplicações em nuvem.
* Plataformas com múltiplos módulos.
* Sistemas integrados a terceiros.

---

## Quando pode ser simplificada

A documentação arquitetural pode ser reduzida quando:

* O sistema é pequeno.
* Possui apenas um único componente.
* Não possui integrações relevantes.
* É uma prova de conceito.
* É um projeto de estudo.

Nestes casos, uma breve seção arquitetural dentro do README ou da documentação técnica costuma ser suficiente.

---

## Público-alvo

A documentação arquitetural é destinada principalmente para:

* Arquitetos de software.
* Desenvolvedores.
* Líderes técnicos.
* Engenheiros de plataforma.
* Novos integrantes da equipe.
* Equipes responsáveis por sistemas integrados.

Ela deve ser compreensível para desenvolvedores sem exigir conhecimento detalhado da implementação.

---

## O que deve conter

Dependendo da complexidade da solução, a documentação arquitetural pode incluir:

### Contexto do Sistema

Descreve onde o sistema se encontra dentro do ecossistema.

Exemplo:

```text
Portal do Cliente
        ↓
API de Agendamentos
        ↓
Sistema Odontológico
        ↓
Sistema Financeiro
```

O objetivo é mostrar quem consome e quem depende do sistema.

---

### Componentes Principais

Identificação dos elementos que compõem a solução.

Exemplo:

* Frontend Web
* Backend
* Banco de Dados
* Serviço de Notificações
* Sistema de Autenticação

Cada componente deve possuir uma responsabilidade claramente definida.

---

### Responsabilidades

Explica o papel de cada componente.

Exemplo:

Frontend:
Responsável pela interação com usuários.

Backend:
Responsável pelas regras de negócio.

Banco de Dados:
Responsável pela persistência das informações.

---

### Fluxos Arquiteturais

Descreve como as informações trafegam entre os componentes.

Exemplo:

```text
Usuário
  ↓
Frontend
  ↓
API
  ↓
Banco de Dados
```

Ou:

```text
Sistema A
  ↓
Fila
  ↓
Lambda
  ↓
Sistema B
```

Os fluxos devem demonstrar a jornada da informação.

---

### Integrações

Documentação das dependências externas.

Exemplo:

* Gateway de pagamento.
* Sistema corporativo.
* Provedor de autenticação.
* APIs de terceiros.
* Serviços internos.

Deve ser documentado:

* Quem consome.
* Quem fornece.
* Finalidade da integração.

---

### Visões Arquiteturais

Quando necessário, apresentar diferentes níveis de detalhamento.

Exemplo:

#### Visão de Contexto

Mostra o sistema dentro do ambiente organizacional.

#### Visão de Containers

Mostra aplicações, bancos e serviços.

#### Visão de Componentes

Mostra divisões internas relevantes.

Nem todos os projetos precisam de todos os níveis.

---

### Requisitos Arquiteturais

Decisões estruturais motivadas por requisitos não funcionais.

Exemplo:

* Alta disponibilidade.
* Escalabilidade.
* Segurança.
* Desempenho.
* Resiliência.

Esses requisitos ajudam a justificar a estrutura adotada.

---

### Restrições Arquiteturais

Limitações relevantes.

Exemplo:

* Deve operar exclusivamente em AWS.
* Deve utilizar autenticação corporativa.
* Não pode armazenar dados sensíveis localmente.

---

## O que NÃO deve conter

### Estrutura Interna de Código

Evitar:

* Classes.
* Interfaces.
* Métodos.
* Pacotes.
* Diretórios.

Essas informações pertencem à documentação técnica.

---

### Procedimentos Operacionais

Evitar:

* Deploy.
* Rollback.
* Alertas.
* Monitoramento.
* Runbooks.

Essas informações pertencem à documentação operacional.

---

### Regras de Negócio Detalhadas

Evitar descrições extensas sobre comportamento funcional.

Exemplo:

* Fluxo completo de cadastro.
* Regras de aprovação.
* Regras comerciais.

Essas informações pertencem à documentação funcional.

---

### Configurações de Ambiente

Evitar:

* Variáveis de ambiente.
* Secrets.
* Configurações de infraestrutura.

Essas informações pertencem à documentação técnica ou operacional.

---

## Relação com outras documentações

Para entender a divisão de escopo e a relação da documentação arquitetural com os demais níveis de documentação do projeto, consulte a **[Matriz de Responsabilidades](../SKILL.md#matriz-de-responsabilidades)** no guia principal.

---

## Diagramas

Diagramas são recomendados, mas não obrigatórios.

Quando utilizados, devem ser acompanhados por explicações textuais.

Um diagrama sem descrição tende a perder valor com o tempo.

Cada diagrama deve responder:

* O que está sendo representado?
* Qual o objetivo da visualização?
* Quais responsabilidades cada elemento possui?
* Como ocorre a comunicação entre os elementos?

refs: [Diretrizes para construir um diagrama](diagramas-diretrizes.md)

---

## Sinais de que a documentação está errada

Considere revisar a documentação arquitetural quando:

* Ela descreve apenas tecnologias.
* Ela contém apenas diagramas sem explicação.
* Ela detalha código-fonte.
* Ela explica deploy e monitoramento.
* Ela não demonstra relações entre componentes.
* Ela não deixa claro o papel de cada elemento.

---

## Critério de qualidade

Uma documentação arquitetural é considerada adequada quando uma pessoa consegue responder:

* Onde este sistema se encaixa?
* Quais são seus principais componentes?
* Quais sistemas se integram com ele?
* Como as informações circulam?
* Quais responsabilidades cada componente possui?
* Quais restrições estruturais existem?

Sem precisar analisar o código-fonte ou a infraestrutura detalhada.
