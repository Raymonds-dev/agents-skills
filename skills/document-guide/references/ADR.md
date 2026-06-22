# ADR (Architecture Decision Records)

## Objetivo

ADR (Architecture Decision Record) é um registro de uma decisão relevante tomada durante o desenvolvimento ou evolução de um sistema.

Seu objetivo é preservar o contexto, as alternativas avaliadas, a decisão escolhida e suas consequências.

A pergunta principal respondida por um ADR é:

> "Por que decidimos fazer desta forma?"

---

## Quando criar

Crie um ADR quando uma decisão:

* Possuir impacto arquitetural.
* Influenciar a manutenção futura do sistema.
* Envolver trade-offs relevantes.
* Possuir alternativas válidas.
* Afetar múltiplos componentes.
* Alterar a direção técnica do projeto.

Exemplos:

* Escolha de banco de dados.
* Escolha de provedor de autenticação.
* Adoção de microsserviços.
* Adoção de arquitetura orientada a eventos.
* Escolha de framework principal.
* Definição de estratégia de deploy.
* Escolha de mensageria.

---

## Quando NÃO criar

Não criar ADR para decisões triviais.

Exemplos:

* Nome de variável.
* Nome de endpoint.
* Organização de pequenos diretórios.
* Escolha de biblioteca sem impacto relevante.
* Ajustes de implementação localizados.

Regra geral:

Se a decisão dificilmente será questionada no futuro, provavelmente não precisa de um ADR.

---

## Público-alvo

Os ADRs são destinados principalmente para:

* Desenvolvedores.
* Arquitetos.
* Líderes técnicos.
* Novos membros da equipe.
* Equipes responsáveis pela evolução do sistema.

---

## O que deve conter

Todo ADR deve registrar:

### Contexto

Qual problema precisava ser resolvido.

Exemplo:

```text
Precisamos implementar autenticação para usuários.
```

O contexto deve explicar a necessidade da decisão.

---

### Alternativas Consideradas

Quais opções foram avaliadas.

Exemplo:

```text
- Firebase Auth
- Auth0
- Keycloak
- Implementação própria
```

Nem todas as alternativas precisam ser profundamente analisadas, mas devem ser registradas.

---

### Decisão

Qual alternativa foi escolhida.

Exemplo:

```text
Firebase Auth
```

A decisão deve ser objetiva.

---

### Justificativa

Por que a alternativa foi escolhida.

Exemplo:

```text
- Menor custo inicial.
- Facilidade de integração.
- Menor esforço operacional.
```

A justificativa é o coração do ADR.

---

### Consequências

Quais impactos a decisão gera.

Exemplo:

Positivos:

```text
- Implementação rápida.
- Menor custo de manutenção.
```

Negativos:

```text
- Dependência de fornecedor externo.
- Menor controle sobre autenticação.
```

Toda decisão possui vantagens e desvantagens.

---

### Status

Estado atual da decisão.

Valores recomendados:

```text
Proposto
Aceito
Substituído
Obsoleto
```

Isso permite acompanhar a evolução do projeto.

---

## O que NÃO deve conter

### Explicação Completa da Implementação

Evitar:

* Código.
* Estruturas de diretório.
* Configurações detalhadas.

Essas informações pertencem à documentação técnica.

---

### Fluxos de Negócio

Evitar:

* Jornadas do usuário.
* Casos de uso.
* Regras de negócio.

Essas informações pertencem à documentação funcional.

---

### Procedimentos Operacionais

Evitar:

* Deploy.
* Rollback.
* Monitoramento.

Essas informações pertencem à documentação operacional.

---

### Diagramas Complexos

ADRs devem ser simples.

Quando necessário, utilizar diagramas pequenos apenas para contextualização.

A compreensão da decisão deve ocorrer principalmente através do texto.

---

## Estrutura Recomendada

Cada ADR deve possuir um arquivo próprio.

Exemplo:

```text
docs/
└── adr/
    ├── ADR-001-escolha-postgresql.md
    ├── ADR-002-firebase-auth.md
    ├── ADR-003-arquitetura-monolitica.md
    └── ADR-004-eventos-assincronos.md
```

---

## Convenção de Numeração

Utilizar numeração sequencial.

Exemplo:

```text
ADR-001
ADR-002
ADR-003
```

A numeração nunca deve ser reutilizada.

Mesmo ADRs obsoletos devem permanecer registrados.

---

## Boas Práticas

### Registrar no momento da decisão

Quanto mais tempo passa, maior a chance de perder o contexto real.

---

### Registrar alternativas rejeitadas

Muitas vezes o maior valor do ADR está em explicar por que algo NÃO foi escolhido.

---

### Registrar trade-offs

Toda decisão relevante envolve ganhos e perdas.

Evitar justificativas como:

```text
Escolhemos porque era melhor.
```

Preferir:

```text
Escolhemos porque reduz esforço operacional, apesar de aumentar dependência externa.
```

---

### Manter ADRs imutáveis

Após aceito, um ADR não deve ser reescrito para refletir a realidade atual.

Caso uma nova decisão substitua a anterior:

* Criar um novo ADR.
* Marcar o antigo como substituído.

O histórico de decisões deve ser preservado.

---

## Relação com outras documentações

Para entender a divisão de escopo e a relação do ADR com os demais níveis de documentação do projeto, consulte a **[Matriz de Responsabilidades](../SKILL.md#matriz-de-responsabilidades)** no guia principal.

---

## Sinais de que um ADR é necessário

Considere criar um ADR quando alguém fizer perguntas como:

* Por que usamos essa tecnologia?
* Por que escolhemos esse banco?
* Por que não utilizamos outra abordagem?
* Por que esse componente existe?
* Por que essa arquitetura foi adotada?

Se a resposta depender da memória de alguém da equipe, provavelmente um ADR deveria existir.

---

## Critério de qualidade

Um ADR é considerado adequado quando uma pessoa consegue responder:

* Qual problema existia?
* Quais alternativas foram consideradas?
* Qual decisão foi tomada?
* Por que ela foi tomada?
* Quais consequências ela trouxe?

Mesmo anos após a decisão original ter sido realizada.
