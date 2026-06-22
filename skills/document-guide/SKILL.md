---
name: document-guide
version: 1.1.0
description: Sistema de geração e padronização de documentação técnica baseada em contexto de projeto
principles:
  - "Se a funcional estiver muito grande, o problema não é o template — é a falta de recorte do escopo."
  - "Não deve incentivar preenchimento — deve incentivar recorte e clareza."
  - "O mínimo necessário."
  - "Cada nível de documentação responde uma pergunta diferente."
  - "Evitar redundância entre documentos."
---

# Document Guide Skill

## Objetivo

Esta skill tem como objetivo analisar um repositório ou sistema e gerar apenas a documentação necessária, mantendo clareza, concisão e separação correta de responsabilidades entre os tipos de documentação.

Ela **NÃO** deve gerar documentação completa automaticamente. O objetivo é decidir o que faz sentido existir e criar apenas o necessário.

---

# Princípio Central

Antes de qualquer geração de documentação, sempre valide:
> “Isso ajuda alguém a entender, manter ou operar o sistema sem contexto prévio?”

Se a resposta for não → **não gerar**.

---

# Matriz de Responsabilidades

Para garantir que não haja sobreposição de informações, utilize a tabela abaixo como referência rápida de escopo:

| Tipo de Documento | Pergunta Central | Conteúdo Principal | Público-Alvo |
| :--- | :--- | :--- | :--- |
| **[Funcional](./references/funcional.md)** | O que o sistema faz e por que existe? | Problema, solução, escopo, regras de negócio e fluxos principais. | Stakeholders, POs, Devs |
| **[Técnica](./references/tecnica.md)** | Como o sistema foi construído? | Tecnologias, estrutura de pastas, dependências locais, variáveis e testes. | Desenvolvedores |
| **[Arquitetural](./references/arquitetural.md)** | Como os componentes se relacionam? | Visão de contexto, componentes, integrações e requisitos não-funcionais. | Arquitetos, Devs, SREs |
| **[Operacional](./references/operacional.md)** | Como manter o sistema funcionando? | Deploy, rollback, monitoramento, alertas, runbooks e incidentes. | DevOps, SREs, Suporte |
| **[ADR](./references/ADR.md)** | Por que essa decisão foi tomada? | Contexto do problema, alternativas avaliadas, trade-offs e decisão. | Mantenedores do projeto |

---

# Fluxo de Trabalho Passo a Passo

## Passo 1 — Entender o sistema

Classifique o sistema e identifique seu propósito e complexidade:
- **Tipo de sistema:** Script/automação, biblioteca/SDK, CLI, API simples, aplicação web/mobile, microsserviço, etc.
- **Propósito:** O que ele faz, quem usa, qual problema resolve e se é isolado ou parte de um ecossistema.
- **Complexidade:** Componentes, banco de dados, integrações, dependências e requisitos de produção.

## Passo 2 — Decidir quais documentações devem existir

Consulte a **[Matriz de Uso por Tipo de Sistema](./references/matriz-documentacao.md)**.
- **Regra de Ouro:** Não crie documentação por padrão. Se o sistema for extremamente simples (ex: script ou PoC), um bom README contendo a visão funcional e técnica resumida é suficiente.

## Passo 3 — Gerar visão funcional (se aplicável)
Se o sistema possui regras de negócio complexas ou fluxos de usuário relevantes:
- Siga as diretrizes do **[Guia de Documentação Funcional](./references/funcional.md)**.
- Utilize o **[Template de Documentação Funcional](./templates/funcional-template.md)**.

## Passo 4 — Gerar visão técnica (se aplicável)
Se o código será mantido por outras pessoas ou possui configurações e dependências complexas:
- Siga as diretrizes do **[Guia de Documentação Técnica](./references/tecnica.md)**.
- Utilize o **[Template de Documentação Técnica](./templates/tecnica-template.md)**.

## Passo 5 — Gerar visão arquitetural (se aplicável)
Se o sistema possui múltiplos componentes, integrações externas ou requisitos críticos de infraestrutura:
- Siga as diretrizes do **[Guia de Documentação Arquitetural](./references/arquitetural.md)**.
- Utilize o **[Template de Documentação Arquitetural](./templates/arquitetural-template.md)**.
- **Diagramas:** Devem ser em Mermaid e seguir estritamente as **[Diretrizes para Diagramas](./references/diagramas-diretrizes.md)** (simples, focados e sem excesso de elementos).

## Passo 6 — Gerar visão operacional (se aplicável)
Se o sistema roda em ambiente de produção real com monitoramento e deploy ativo:
- Siga as diretrizes do **[Guia de Documentação Operacional](./references/operacional.md)**.
- Utilize o **[Template de Documentação Operacional](./templates/operacional-template.md)**.
- **Foco:** Prático e executável (passo a passo para incidentes, deploys e alerts).

## Passo 7 — Registrar Decisões Arquiteturais (ADRs) (se aplicável)
Se houveram decisões com trade-offs técnicos significativos (ex: escolha de banco de dados, framework ou arquitetura):
- Siga as diretrizes do **[Guia de ADRs](./references/ADR.md)**.
- Utilize o **[Template de ADR](./templates/adr-template.md)**.

## Passo 8 — Criar ou Atualizar o README.md Principal
O `README.md` na raiz do projeto deve ser tratado como uma página de entrada (overview) leve e de alto nível, pois muda frequentemente à medida que o projeto evolui. Ele não deve duplicar detalhes técnicos profundos para evitar obsolescência rápida:
- Utilize o **[Template de README Principal](./templates/readme-template.md)**.
- **Princípio:** Mantenha obrigatória apenas a **Visão Geral** (propósito e valor do sistema). Seções de pré-requisitos e execução local são opcionais (pois podem não ser aplicáveis para scripts isolados ou funções Lambda).
- **Foco:** Apresentar o projeto de forma conceitual e guiar o leitor para as documentações detalhadas localizadas no diretório `docs/`.

## Passo 9 — Criar o Índice de Documentação (Recomendado)
Sempre que gerar mais de um documento, crie um arquivo central de navegação no diretório de documentação (`docs/README.md`) para facilitar o acesso:
- Utilize o **[Template de Índice de Documentação](./templates/index-template.md)**.

> **Atalho — copiar templates para `docs/`:**
>
> **Bash:**
> ```bash
> # Copiar todos os templates
> bash scripts/bash/copy-templates.sh
>
> # Copiar apenas funcional e adr
> bash scripts/bash/copy-templates.sh --templates funcional,adr
>
> # Copiar para outro projeto
> bash scripts/bash/copy-templates.sh --project-path ../meu-projeto
> ```
> **PowerShell:**
> ```powershell
> # Copiar todos os templates
> powershell -ExecutionPolicy Bypass -File scripts/powershell/copy-templates.ps1
>
> # Copiar apenas funcional e adr
> powershell -ExecutionPolicy Bypass -File scripts/powershell/copy-templates.ps1 -Templates funcional,adr
> ```
> Scripts: **[copy-templates.sh](./scripts/bash/copy-templates.sh)** · **[copy-templates.ps1](./scripts/powershell/copy-templates.ps1)**

---

# Passo 10 — Controle de Qualidade e Eliminação de Excesso

Antes de finalizar qualquer geração de documentação, faça um pente fino:
1. **Sem Redundâncias:** Remova informações que se repetem em múltiplos níveis (ex: não explique regras de negócio na técnica, nem infraestrutura na funcional).
2. **Sem Placeholders:** Certifique-se de que não restaram textos de exemplo, placeholders ou seções vazias dos templates.
3. **Links Ativos:** Garanta que todas as referências cruzadas entre os documentos gerados funcionam corretamente com links markdown relativos.
4. **Validação Automática:** Execute o script de auditoria para validar links e placeholders:

   **Bash:**
   ```bash
   bash scripts/bash/audit-docs.sh ./docs
   ```
   **PowerShell:**
   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts/powershell/audit-docs.ps1 -Path ./docs
   ```
   Scripts: **[audit-docs.sh](./scripts/bash/audit-docs.sh)** · **[audit-docs.ps1](./scripts/powershell/audit-docs.ps1)**

5. **Mapa de Estrutura:** Para gerar uma visão da estrutura de diretórios em formato de árvore Markdown:

   **Bash:**
   ```bash
   # Projeto inteiro
   bash scripts/bash/map-structure.sh

   # Pasta específica
   bash scripts/bash/map-structure.sh ./docs

   # Com limite de profundidade e salvar em arquivo
   bash scripts/bash/map-structure.sh . --max-depth 3 --output ./docs/estrutura.md
   ```
   **PowerShell:**
   ```powershell
   # Projeto inteiro
   powershell -ExecutionPolicy Bypass -File scripts/powershell/map-structure.ps1

   # Pasta específica com profundidade e saída
   powershell -ExecutionPolicy Bypass -File scripts/powershell/map-structure.ps1 -Path ./docs -MaxDepth 3 -Output ./docs/estrutura.md
   ```
   Scripts: **[map-structure.sh](./scripts/bash/map-structure.sh)** · **[map-structure.ps1](./scripts/powershell/map-structure.ps1)**
