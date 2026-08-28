# Field Obligation Audit — Campos obrigatórios vs opcionais

> **Tarefa de origem:** `tasks-v1.md` → Fase 8 → 8.1 (Auditar campos obrigatórios vs opcionais em
> todos os templates/schemas).
> **Entrada:** `docs/analysis/baseline-gap-map.md` (Seção B, Lacunas 8.1-8.3), `docs/analysis/evaluation-rubric.md`
> (Eixo 7 — custo cognitivo/verbosidade, Eixo 8 — risco de alucinação).
> **Objetivo:** classificar cada campo relevante em **essencial** (obrigatório, é a única fonte de
> rastreabilidade/verificação), **condicional** (obrigatório só quando a situação se aplica) ou
> **opcional** (preencher apenas se houver conteúdo real), com justificativa; identificar pontos
> concretos de "forçar preenchimento"; reavaliar mínimos rígidos como faixas orientadas ao tamanho.
> **Saída consumida por:** Fase 8 → 8.2 (aplica esta classificação nos templates/schemas/SKILL.md).

## Método

1. Releitura de todos os `SKILL.md`, templates (`assets/templates/*`) e schemas (`assets/schemas/*`)
   das 11 skills.
2. Duas gerações de artefatos já coexistem no repositório:
   - **Geração 1 (pré-Fase 2-7):** `mdpe-discovery`, `mdpe-backlog`, `mdpe-transformation`,
     `mdpe-execution-context`. Templates sem legenda de obrigação, sem regra anti-fabricação
     explícita, com mínimos numéricos fixos no `SKILL.md` ("20-30 features", "15-25 micro-tasks") e
     seções sempre presentes independentemente do porte do item.
   - **Geração 2 (Fases 2-7, já nascida com a disciplina que esta Fase 8 pede):** `mdpe-architecture`,
     `mdpe-code-discovery`, `mdpe-coding` (validation-report/code-review), `mdpe-graph`,
     `mdpe-learnings`, `mdpe-tasks`. Todos já têm legenda `[E]/[C]/[O]` por campo, bloco "Hard rules"
     citando "no TBD / unknown é uma resposta válida / não invente para preencher", e faixas em vez
     de mínimos fixos ("roughly 3-25", "auto-sizing S/M/L").
3. Esta auditoria foca a **Geração 1**, que é onde as lacunas 8.1-8.3 do gap-map vivem. A Geração 2 é
   citada como padrão de referência (o "nível 5" da rubrica) e não repetida campo a campo.

---

## Seção A — Pontos concretos de "forçar preenchimento" (≥3 exigidos, 6 encontrados)

| # | Onde | Evidência | Efeito |
|---|------|-----------|--------|
| 1 | `skills/mdpe-discovery/SKILL.md`, Stage 3 | *"refine into a consolidated list of **20-30 unique features**"* + Quality gate *"20-30 features identified"* | Produto pequeno é forçado a inventar features até bater 20, ou um produto grande é truncado em 30. |
| 2 | `skills/mdpe-discovery/SKILL.md`, Stage 2 | *"Output: **2-4 primary personas** with mapped critical needs"* | Domínios com 1 persona clara (ou 6 genuinamente distintas) são empurrados para a faixa. |
| 3 | `skills/mdpe-transformation/SKILL.md`, Phase 1 | *"Break the feature into **15-25 atomic micro-tasks**"* + Quality gate *"Feature decomposed into 15-25 atomic micro-tasks"* | Feature pequena (ex.: 4 tarefas reais) é forçada a fragmentar até 15; feature grande é forçada a consolidar até 25 perdendo atomicidade. |
| 4 | `skills/mdpe-transformation/assets/templates/microtasks-index-template.yml`, `validation` e `usage_instructions.quality_criteria` | `estimate_range_validated: true  # 15-25 microtasks` e *"Total of 15-25 micro-tasks per feature"* | O próprio template de validação assume o mínimo rígido como critério de "pronto", mesmo quando o SKILL.md relaxar. |
| 5 | `skills/mdpe-execution-context/SKILL.md`, Phase 1 | *"Produce a self-contained context document covering **all six dimensions**"* — nenhuma menção a dimensão dispensável | Uma microtask trivial (ex.: 1 arquivo de configuração) ainda precisa de 6 blocos de contexto preenchidos, incluindo `risks_and_troubleshooting` e tutoriais externos que podem não existir. |
| 6 | `skills/mdpe-backlog/assets/templates/cognitive-backlog-template.yml`, `usage_instructions.step_2` | *"Each feature should have **5-30 functionalities**"* | Uma feature real com 2 ou 3 funcionalidades é empurrada a inflar a lista até 5. |

Ponto adicional de referência fantasma (ligado a alucinação, não a volume): `environment-setup-template.yml`
→ `usage_instructions.related_command: "11-cd-01-environment-preparation.txt"` e
`next_command: "12-cd-02-implementation.txt"` — arquivos `.txt` de comandos legados que **não existem**
no repositório (mesmo padrão já corrigido nos templates de `mdpe-coding`, que trazem a nota *"Those .txt
command files do not exist in this repository - do not reference them as next steps"*).

---

## Seção B — Classificação por template/schema (Geração 1)

Legenda: **E** = essencial (obrigatório; única fonte de rastreabilidade/verificação) · **C** =
condicional (obrigatório só na situação citada) · **O** = opcional (preencher só com conteúdo real).

### B.1 — `mdpe-discovery`

**`discovery-session-template.yml`** (8 seções, 0 antes marcadas)

| Campo/bloco | Classificação | Justificativa |
|---|---|---|
| `metadata` (id, date, facilitator, product) | **E** | Identifica a sessão; sem isso nada é rastreável. |
| `participants.product_owner` | **E** | O schema já exige (`required`); é quem decide. |
| `participants.stakeholders` / `technical_team` / `optional_guests` | **O** | Schema não exige; sessão pode ter só o PO. |
| `agenda[]` | **E** (≥1) | É o roteiro mínimo da sessão; schema exige `minItems:1`. |
| `agenda[].tools` | **O** | Ferramenta de apoio, não afeta o resultado. |
| `outputs.cognitive_backlog` | **E** | É o elo com `mdpe-backlog`. |
| `outputs.personas_identified` / `critical_hypotheses` / `identified_risks` | **C** — obrigatório só se a sessão de fato produziu personas/hipóteses/riscos | Uma sessão de refinamento (DP-02 apenas) pode não gerar hipóteses novas. |
| `next_steps.required_validations` | **O** | Nem toda sessão tem pendência de validação externa. |
| `facilitator_notes` / `participant_feedback` / `attachments` | **O** | Já ausentes do `required` do schema; eram apresentadas no template como se fossem parte do fluxo padrão. |

**`validation-risks-template.yml`** (10 arquivos-modelo, 0 antes marcados)

| Campo/bloco | Classificação | Justificativa |
|---|---|---|
| `05-validation-risks.yml` (índice) | **E** — só quando existe ≥1 hipótese/risco | É o consolidado; sem hipótese/risco não há o que consolidar. |
| `hypotheses/*.yml` (value/usability/feasibility) | **C** — cada arquivo só existe se houver ≥1 hipótese daquele tipo | Nem toda feature Must-Have gera hipótese de **todos** os três tipos. |
| `risks/*.yml` (technology/regulatory/market/operational) | **C** — idem, por categoria com risco real | Um projeto interno sem dado pessoal pode não ter risco regulatório algum. |
| `risks/risk-matrix.yml` | **C** — só quando há ≥1 risco em qualquer categoria | Matriz vazia não deveria existir. |
| `validation/validation-plans.yml` | **C** — só para hipóteses de confiança baixa/média | Hipótese já validada com alta confiança não precisa de plano. |
| `hypothesis.evidence[]` | **O** | Pode não haver evidência ainda (hipótese recém-levantada) — mas não deve ser inventada. |

**`discovery-session.schema.json`** — já é relativamente enxuto (ver gap-map Seção B): `facilitator_notes`,
`participant_feedback`, `attachments`, `stakeholders`, `technical_team` já são opcionais no schema. O
problema não está no schema, está no **template e no SKILL.md**, que apresentam tudo como fluxo padrão
sem marcar o que o próprio schema já trata como opcional.

### B.2 — `mdpe-backlog`

**`cognitive-backlog.schema.json`** (feature) — 13 campos obrigatórios no root.

| Campo | Classificação | Justificativa |
|---|---|---|
| `id`, `name`, `description`, `category` | **E** | Identidade e propósito da feature; sem isso não há item de backlog. |
| `priority` (moscow, business_value, estimated_effort, priority_score, justification) | **E** | É o critério de sequenciamento; sem ele nada indica o que vem primeiro. |
| `functionalities.list` | **E**, mas **sem piso numérico** | `minItems:0` já no schema — o piso de "5-30" só existe no template (Seção A #6), não no schema. Nenhuma mudança de schema necessária; a correção é só no template. |
| `value_criteria`, `personas_served`, `acceptance_criteria` | **E** (`minItems:1`) | São a única fonte de "o que prova que a feature funciona" e "para quem"; rebaixar a opcional destruiria a rastreabilidade que a rubrica (Eixo 7) exige preservar. |
| `hypotheses`, `risks` | **C** — chave existe, lista pode ser `[]` | Já assim no schema (`minItems:0`); manter. |
| `dependencies.business` / `.technical` | **C** — lista pode ser `[]`, mas a chave é exigida | Feature sem dependência real deve declarar `[]`, não omitir a chave (mantém a estrutura verificável). |
| `discovery_notes` | **O** | Já ausente do `required`; é anotação de contexto. |
| `metadata.changelog` | **E** (`minItems:1`) | Rastreio de versão; sem ao menos a entrada inicial não há histórico algum. |
| `rice` (dentro de `priority`) | **O** | Já ausente do `required`; método alternativo de priorização. |

**Conclusão B.2:** o schema já está bem calibrado (a Fase 8 não precisa tocar nele). O que precisa de
correção é o **template's usage_instructions** (`step_2`, Seção A #6) e o `SKILL.md` (nenhuma frase
anti-alucinação e nenhuma menção de que `functionalities` pode ter qualquer contagem real).

### B.3 — `mdpe-transformation`

**`mdpe-microtask.schema.json`** — 14 campos obrigatórios no root + aninhamento profundo
(`estimate`: 6; `metadata`: 7; `aert_validation`: 4×2).

| Campo | Classificação | Justificativa |
|---|---|---|
| `id`, `title`, `traceability`, `category`, `type`, `architectural_layer`, `description` | **E** | Identidade e propósito; sem isso a microtask não é rastreável nem categorizável. |
| `input.required_artifacts` | **E**, mas `minItems:0` | Chave exigida, lista pode ser vazia (primeira microtask de uma feature não tem artefato prévio). Já correto no schema. |
| `input.technical_knowledge`, `input.tools` | **E** (`minItems:1`) | É o que garante que a microtask é executável por alguém sem contexto adicional (parte do contrato IOQD); rebaixar a opcional quebraria a garantia de executabilidade que a própria skill declara (AERT — Executability). |
| `input.external_resources` | **O** | Só existe se a microtask depender de algo externo de fato. |
| `output.generated_artifacts` | **E** (`minItems:1`) | É o "O" do IOQD — sem saída declarada não há como validar `fidelity.declared_outputs` depois em `mdpe-coding`. |
| `output.system_changes`, `output.expected_metrics` | **O** | Nem toda microtask muda o sistema de forma estruturada (ex.: documentação) nem declara métrica numérica. |
| `quality_criteria.functional` (`minItems:1`) | **E** | É o critério de aceite mínimo; sem ele não há o que `mdpe-coding` dimensão 3 verifica. |
| `quality_criteria.non_functional` (`minItems:0`) | **C** | Só quando a microtask de fato tem exigência não-funcional. Já correto no schema. |
| `quality_criteria.code_quality` (`minItems:1`) | **E** | Padrão mínimo de qualidade verificável; sem ele o code review não tem baliza. |
| `quality_criteria.documentation` | **O** | Nem toda microtask precisa de documentação própria. |
| `dependencies.upstream`/`downstream` | **E**, mas listas podem ser `[]` | A chave é exigida (mapeamento de dependência é parte do AERT-Traceability), a lista pode ser vazia (Wave 1). |
| `dependencies.external` | **O** | Só quando há dependência externa real. |
| `estimate.*` (6 campos) | **E** | É o que impede microtask >8h (limite de atomicidade); sem estimativa não há como aplicar o AERT-Atomicity. |
| `aert_validation.*` (4 blocos) | **E** | É a autoverificação central da Fase 1; sem ela a microtask não passou pelo próprio contrato que a define. |
| `risks[]` | **O** | Já ausente do `required`. |
| `technical_notes[]` | **O** | Já ausente do `required`. |
| `traceability.origin_decisions` | **C** — só quando a microtask nasce de um `derived_work` de `ad-NNN` | Já documentado como condicional no próprio schema/template (comentário `# CONDITIONAL`). |

**Conclusão B.3:** o schema, campo a campo, já é majoritariamente justificável — a exigência profunda
reflete o contrato IOQD/AERT que a própria skill define como necessário para uma microtask ser
executável e verificável sem contexto adicional. **Não há campo essencial candidato a rebaixamento.**
O problema real está fora do schema:
- o **mínimo de contagem** ("15-25 micro-tasks", Seção A #3-4) no `SKILL.md` e no
  `microtasks-index-template.yml`;
- a ausência de uma frase "não invente uma microtask para bater a contagem" no `SKILL.md`.

**`dependencies-template.yml`**, **`microtasks-index-template.yml`**, **`category-index-template.yml`**,
**`transformation-template.yml`**, **`tasks-template.yml`** — nenhum tem legenda `[E]/[C]/[O]`. Blocos
identificáveis como opcionais por conteúdo:

| Template | Bloco | Classificação |
|---|---|---|
| `dependencies-template.yml` | `external_dependencies.dependencies[].notes` | **O** |
| `dependencies-template.yml` | `critical_path.path_comparison.alternative_path_N` | **O** — só quando há caminho alternativo relevante |
| `microtasks-index-template.yml` | `feature_risks[]` | **C** — só quando há risco cruzando múltiplas microtasks |
| `category-index-template.yml` | `category_risks[]`, `required_resources.access[]` | **O** |
| `transformation-template.yml` | `architect_notes[]` | **O** |
| `tasks-template.yml` | `completion_note` (por task) | **C** — só ao marcar `[x]` |

### B.4 — `mdpe-execution-context`

**`execution-context-template.yml`** (8 seções, 0 antes marcadas) — a skill já resolveu corretamente
a arquitetura (`architecture` fica vazia sem `ad-NNN`) e convenções (`code_conventions_source` vazio
sem fonte) via comentários extensos adicionados nas Fases 3/7. O que falta é:

| Bloco | Classificação | Justificativa |
|---|---|---|
| `strategic_context.supported_strategic_objectives[]` | **O** | Só quando a microtask liga a um objetivo estratégico nomeado; não toda microtask tem um. |
| `strategic_context.impacted_personas[]` | **O** | Idem, personas. |
| `input_context.required_knowledge[]`, `.external_resources[]` | **O** | Só quando há conhecimento/recurso externo real. |
| `output_context.system_changes[]` | **C** | Só quando a microtask de fato altera o sistema de forma estrutural. |
| `reference_context.relevant_tutorials[]`, `.external_documentation[]` | **O** | Nem toda microtask tem tutorial/doc externo aplicável — não deve ser inventado só para preencher a seção. |
| `risks_and_troubleshooting` (seção 7 inteira) | **C** — só quando há risco/problema conhecido real | Uma microtask trivial (ex.: mover um arquivo) não tem risco identificável nem troubleshooting conhecido; forçar essa seção é o ponto de alucinação mais direto do template. |
| `execution_instructions` (passo a passo) | **E**, mas **profundidade proporcional** | O guia é essencial (é o que torna a microtask executável sem ambiguidade), mas seu tamanho deve ser proporcional à complexidade real, não seguir os "STEP 1/2/3" do exemplo à risca. |

**`environment-setup-template.yml`** (7 seções, 0 antes marcadas):

| Bloco | Classificação | Justificativa |
|---|---|---|
| `context_review.identified_constraints[]`, `.patterns_to_follow[]` | **O** | Só quando há restrição/padrão real a seguir. |
| `dependency_validation.existing_code[]`, `.interfaces_contracts[]`, `.available_assets[]` | **C** — só quando a microtask de fato reaproveita/depende de código existente | Primeira microtask de uma feature nova não tem nada aqui. |
| `environment_preparation.services[]` | **C** — só quando o projeto usa serviços externos (DB, cache) | Microtask puramente de lógica de domínio pode não precisar de nenhum serviço rodando. |
| `file_structure.files_to_modify[]` | **C** — só quando há arquivo existente a modificar | Microtask que só cria arquivos novos não tem essa lista. |
| `reference_analysis.external_apis[]`, `.reusable_snippets[]` | **O** | Só com API externa ou trecho reaproveitável real. |
| `ready_checklist.additional_risks[]` | **O** | Só com risco adicional real, não coberto em outro lugar. |
| `usage_instructions.related_command` / `.next_command` (`.txt`) | **Remover** | Referências fantasma — apontam para arquivos de comando legados que não existem no repositório (mesmo defeito já corrigido em `mdpe-coding`). |

### B.5 — Gerações já compatíveis com a Fase 8 (referência, sem ação aqui)

`mdpe-architecture`, `mdpe-code-discovery`, `mdpe-graph`, `mdpe-learnings`, `mdpe-tasks`, e os templates
de `mdpe-coding` (`validation-report-template.yml`, `code-review-template.yml`) **já** têm: legenda
`[E]/[C]/[O]` por campo, bloco "Hard rules" com "no TBD"/"unknown é uma resposta válida", criação lazy
de blocos condicionais ("no content → no block"), e faixas em vez de mínimos fixos (`mdpe-tasks`:
"roughly 3-25, do not force a feature-sized item into 15-25 if it is genuinely smaller";
`mdpe-code-discovery`: auto-sizing S/M/L "no minimum number of features"). Nenhuma mudança necessária
aqui — servem de modelo para a Seção C.

---

## Seção C — Mínimos rígidos → faixas orientadas ao tamanho (aplicado na 8.2)

| Onde | Mínimo rígido atual | Faixa proposta |
|---|---|---|
| `mdpe-discovery/SKILL.md`, Stage 3 + Quality gate | "20-30 unique features" | "sized to the product's real scope — commonly 15-30 for a broad product discovery, fewer for a narrow one. Never pad the list to hit a number; a genuinely small product may converge on far fewer." |
| `mdpe-discovery/SKILL.md`, Stage 2 | "2-4 primary personas" | "at least 1, more only if genuinely distinct — do not split one persona into several to hit a count." |
| `mdpe-transformation/SKILL.md`, Phase 1 + Quality gate | "15-25 atomic micro-tasks" | "sized to the feature — commonly 15-25 for a typical Must-Have feature; a narrower feature may need far fewer, a very large one may need to be split into multiple features instead of stretching the range. Never merge unrelated work to hit the floor, and never split atomic work to hit the ceiling." |
| `mdpe-transformation/assets/templates/microtasks-index-template.yml` | `estimate_range_validated: true  # 15-25 microtasks` + *"Total of 15-25 micro-tasks per feature"* | Comentário ajustado para "count matches the feature's real scope, not a fixed range" |
| `mdpe-backlog/assets/templates/cognitive-backlog-template.yml`, `step_2` | "Each feature should have 5-30 functionalities" | "Group as many real functionalities as the feature actually has — there is no floor or ceiling; 2 or 40 are both valid if that is what discovery produced." |
| `mdpe-execution-context/SKILL.md`, Phase 1 | "all six dimensions" sem exceção | Mantém as 6 dimensões como estrutura (são as 6 perguntas que tornam a microtask executável), mas cada uma pode ser preenchida de forma proporcional e seções internas claramente marcadas condicionais/opcionais podem ficar vazias/ausentes. |

Regras que **não** mudam (são âmbito de negócio, não de volume, e continuam justificadas):
- `mdpe-discovery`: "Must Have ≤ ~30% of features" — é uma regra de escassez de priorização, não um
  piso de volume; permanece.
- `mdpe-transformation`: estimativa "< 8h (ideal 2-4h)" por microtask — é o limite de atomicidade
  (AERT), não um forçador de volume; permanece.
- `mdpe-transformation`: "> 85% approved" no quality gate — é o alvo de qualidade da decomposição, não
  contagem de itens; permanece.

---

## Seção D — Resumo de ações para a 8.2

1. **SKILL.md** — adicionar faixa (Seção C) + frase anti-alucinação explícita em:
   `mdpe-discovery`, `mdpe-backlog`, `mdpe-transformation`, `mdpe-execution-context`.
2. **Templates da Geração 1** — adicionar bloco de legenda `[E]/[C]/[O]` + regra anti-fabricação no
   topo (no mesmo formato já usado pela Geração 2) e marcar inline os blocos identificados nas
   Seções B.1-B.4 como `[C]`/`[O]`:
   `discovery-session-template.yml`, `validation-risks-template.yml`, `cognitive-backlog-template.yml`,
   `mdpe-microtask-template.yml`, `dependencies-template.yml`, `microtasks-index-template.yml`,
   `category-index-template.yml`, `transformation-template.yml`, `tasks-template.yml`,
   `execution-context-template.yml`, `environment-setup-template.yml`.
3. **Referência fantasma** — remover `related_command`/`next_command` (`.txt`) de
   `environment-setup-template.yml`, seguindo o padrão de correção já aplicado em `mdpe-coding`.
4. **Schemas** — nenhuma mudança estrutural necessária (Seções B.2 e B.3 concluem que os `required`
   atuais já protegem rastreabilidade/verificação real; o problema estava nos templates e no
   `SKILL.md`, não nos schemas JSON).
