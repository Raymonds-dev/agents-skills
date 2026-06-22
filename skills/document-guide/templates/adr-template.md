<!-- TEMPLATE: adr -->
# ADR (Architecture Decision Record)

> Cada ADR deve registrar UMA decisão arquitetural relevante.
> Não reescrever ADRs existentes — apenas adicionar novos sequencialmente.

---

# Identificação

## ID
<!-- INICIO:ID (OBRIGATÓRIO) -->
ADR-001
<!-- FIM:ID -->

## Título
<!-- INICIO:TITULO (OBRIGATÓRIO) -->
[Ex: Escolha do banco de dados principal]
<!-- FIM:TITULO -->

## Status
<!-- INICIO:STATUS (OBRIGATÓRIO) -->
Proposto
<!-- FIM:STATUS -->

---

# Contexto
<!-- INICIO:CONTEXTO (OBRIGATÓRIO) -->
Descreva o problema ou requisito técnico que motivou a necessidade de tomar essa decisão:
* [Ex: Necessidade de armazenar dados transacionais complexos com garantia de ACID.]
<!-- FIM:CONTEXTO -->

---

# Decisão
<!-- INICIO:DECISAO (OBRIGATÓRIO) -->
Descreva de forma clara e objetiva qual foi a alternativa escolhida:
> [Ex: Foi decidido utilizar o banco de dados PostgreSQL.]
<!-- FIM:DECISAO -->

---

# Alternativas Consideradas
<!-- INICIO:ALTERNATIVAS (OBRIGATÓRIO) -->
Liste as principais alternativas válidas que foram avaliadas:
* [Ex: MongoDB (NoSQL) - Descartado por falta de transações nativas robustas.]
* [Ex: MySQL - Descartado por menor suporte a JSON nativo.]
<!-- FIM:ALTERNATIVAS -->

---

# Justificativa
<!-- INICIO:JUSTIFICATIVA (OBRIGATÓRIO) -->
Explique os motivos técnicos e de negócio para a escolha da alternativa em relação às outras:
* [Ex: PostgreSQL oferece suporte avançado a dados relacionais e tipos JSONB, permitindo flexibilidade.]
* [Ex: Maturidade e experiência técnica da equipe de desenvolvimento.]
<!-- FIM:JUSTIFICATIVA -->

---

# Consequências
<!-- INICIO:CONSEQUENCIAS (OBRIGATÓRIO) -->
Impactos e desdobramentos causados pela decisão:

### Positivas
* [Ex: Garantia de integridade referencial dos dados.]
* [Ex: Facilidade de encontrar profissionais de mercado.]

### Negativas / Custos
* [Ex: Necessidade de gerenciar backups e atualizações de infraestrutura.]
<!-- FIM:CONSEQUENCIAS -->

---

# Riscos
<!-- INICIO:RISCOS (OPCIONAL) -->
Riscos associados e planos de contingência:
* [Ex: Bloqueio de vendor lock-in com o provedor de nuvem selecionado.]
<!-- FIM:RISCOS -->

---

# Referências

## Documentação Relacionada
* [Documentação Funcional](../funcional.md)
* [Documentação Técnica](../tecnica.md)
* [Documentação Arquitetural](../arquitetural.md)
