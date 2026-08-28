# Baseline Gap Map — Auditoria das 8 skills MDPE

> **Tarefa de origem:** `tasks-v1.md` → Fase 1 → 1.1 (Auditar o estado atual das 8 skills e mapear lacunas).
> **Objetivo:** levantar, por skill, entradas/saídas, artefatos gerados, campos obrigatórios vs opcionais
> e pontos de acoplamento; e consolidar um mapa de lacunas que cruza cada pergunta do usuário com
> **evidência em arquivo** (com trecho citado).
> **Regra de aceite aplicada:** toda lacuna aqui cita arquivo (e trecho/linha) e tem um critério observável.
> Nenhuma lacuna é opinião genérica.

## Método

1. Leitura integral dos 8 `SKILL.md`, de todos os templates (`assets/templates/*`) e schemas
   (`assets/schemas/*`), dos docs (`docs/mdpe-flow.md`, `docs/mapping-commands-to-skills.md`) e do
   `README.md`/`INSTALL.md`.
2. Verificação de existência dos artefatos referenciados via busca no repositório
   (`tools/mdpe-status.py`, `.github/`, `aggregated-learnings.yml`).
3. Contagem de campos obrigatórios vs opcionais a partir dos arrays `required`/`minItems` dos schemas
   e da estrutura dos templates YAML.

---

## Seção A — Auditoria por skill (entradas, saídas, artefatos, acoplamento)

| Skill | Entradas | Saídas / artefatos | Acoplamento (consome ← / alimenta →) | Assets que acompanham |
|-------|----------|--------------------|--------------------------------------|-----------------------|
| **mdpe-router** (`skills/mdpe-router/SKILL.md`) | Situação do usuário (texto livre) | Decisão de roteamento (nenhum arquivo) | → todas as skills; sem passo de leitura de memória | nenhum |
| **mdpe-discovery** (`skills/mdpe-discovery/SKILL.md`) | Visão, problema, mercado, objetivos, participantes | `docs/discovery/00..05-*.yml` (+ `hypotheses/`, `risks/`, `validation/`) | → `mdpe-backlog` | `discovery-session-template.yml`, `validation-risks-template.yml`, `discovery-session.schema.json` |
| **mdpe-backlog** (`skills/mdpe-backlog/SKILL.md`) | `docs/discovery/01..05-*.yml` | `docs/backlog/backlog-index.yml`, `features/feat-XXX.yml`, `roadmap.yml` | ← discovery; → `mdpe-transformation` | `cognitive-backlog-template.yml`, `cognitive-backlog.schema.json` |
| **mdpe-transformation** (`skills/mdpe-transformation/SKILL.md`) | `feat-XXX.yml`, "technical context" (texto livre) | `microtasks/`, `dependencies/*.yml`, `validation/*.yml`, `prioritization/*.yml`, `docs/tasks.md` | ← backlog; → `mdpe-execution-context` | 6 templates + `mdpe-microtask.schema.json` |
| **mdpe-execution-context** (`skills/mdpe-execution-context/SKILL.md`) | `mt-XXX-YYY.yml`, `feat-XXX.yml`, "aggregated learnings" | `docs/execution/{id}-context.yml`, `{id}-setup.yml` | ← transformation; → `mdpe-coding` | `execution-context-template.yml`, `environment-setup-template.yml` |
| **mdpe-coding** (`skills/mdpe-coding/SKILL.md`) | `{id}-context.yml`, `{id}-setup.yml`, branch | código, `{id}-validation-report.yml`, `{id}-code-review.yml` | ← execution-context; → `mdpe-learnings` | **só** `validation-report-template.yml` |
| **mdpe-learnings** (`skills/mdpe-learnings/SKILL.md`) | context, setup, validation, code-review | `{id}-learnings.yml`, `learning-loops/aggregated-learnings.yml` | ← coding; → discovery/transformation/execution-context | **só** `mdpe-tracking.yml` |
| **mdpe-tasks** (`skills/mdpe-tasks/SKILL.md`) | Texto livre / `feat-XXX.yml` | `docs/mdpe-tasks/{item}.md` (um arquivo) | atalho: substitui `T → EC`; → `mdpe-coding` | `mdpe-tasks-template.md` |

**Pontos de acoplamento frágeis identificados (evidência):**

- **"Technical context" entra como texto livre** em transformation e execution-context, sem origem
  rastreável. `skills/mdpe-transformation/SKILL.md` (seção *Inputs*): *"Technical context: architecture,
  backend/frontend stack, database, infrastructure, code patterns, conventions."* Nada define de onde
  vem essa arquitetura → acopla a decisão arquitetural ao improviso do agente.
- **execution-context-template chumba a arquitetura**: `execution-context-template.yml`
  → `technical_context.architecture.overall_pattern: "Clean Architecture with DDD"` está fixo no
  template como valor de exemplo, não derivado de uma decisão.
- **Descontinuidade de caminho de saída** entre skills (ver Seção E, inconsistência #2).

---

## Seção B — Campos obrigatórios vs opcionais por template/schema

Nos **schemas JSON** a obrigatoriedade é formal (`required`/`minItems`). Nos **templates YAML** não há
marcação de opcional: todo campo é apresentado como preenchível — o que é, por si, uma lacuna (Fase 8).

| Artefato | Obrigatórios | Opcionais | Observação (evidência) |
|----------|--------------|-----------|------------------------|
| `discovery-session.schema.json` | 5 seções raiz (`metadata`, `participants`, `agenda`, `outputs`, `next_steps`); ~26 campos exigidos na árvore; `agenda` `minItems:1`; `metadata` 8 obrigatórios | `facilitator_notes`, `participant_feedback`, `attachments`, `stakeholders`, `technical_team` | `"required": ["metadata","participants","agenda","outputs","next_steps"]` |
| `cognitive-backlog.schema.json` (feature) | **13** no root (`id,name,description,category,priority,functionalities,value_criteria,personas_served,hypotheses,dependencies,risks,acceptance_criteria,metadata`); `value_criteria`/`personas_served`/`acceptance_criteria` `minItems:1`; `priority` com 5 obrigatórios | `discovery_notes`; `rice` | `hypotheses`/`risks` `minItems:0` (chave exigida, lista pode ser vazia) |
| `mdpe-microtask.schema.json` (microtask) | **14** no root; `estimate` 6 obrigatórios; `metadata` 7 obrigatórios; `aert_validation` 4 (cada um exige `validated`+`justification`); `output.generated_artifacts` `minItems:1`; `input.technical_knowledge`/`tools` `minItems:1` | `risks`, `technical_notes`, `external_resources`, `non_functional` (`minItems:0`) | Aninhamento obrigatório profundo → forte indutor de preenchimento (Fase 8) |
| `discovery-session-template.yml` | — (sem marcação) | — | 8 seções, **0 marcadas como opcionais** |
| `validation-risks-template.yml` | — | — | 10 arquivos-modelo, **0 opcionais** |
| `cognitive-backlog-template.yml` | — | — | 3 artefatos (index/feature/roadmap), **0 opcionais** |
| `mdpe-microtask-template.yml` | — | — | espelha o schema (16 seções), **0 opcionais** |
| `execution-context-template.yml` | — | — | 8 dimensões/seções, **0 opcionais** |
| `environment-setup-template.yml` | — | — | 7 seções, **0 opcionais** |
| `dependencies-template.yml` | — | — | 7 arquivos-modelo, **0 opcionais** |
| `validation-report-template.yml` | — | — | 6 dimensões + summary, **0 opcionais** |
| `mdpe-tracking.yml` | — | — | métricas + graph, **0 opcionais**; promete cálculo automático inexistente |
| `tasks-template.yml` / `mdpe-tasks-template.md` | — | — | estrutura de saída, **0 opcionais** |

---

## Seção C — Artefatos referenciados que NÃO existem no repositório

Confirmado por busca (`file_search`/`grep_search`): os itens abaixo são citados como se existissem, mas
não há arquivo correspondente. São "referências fantasma".

| Referenciado | Onde é citado (evidência) | Existe? |
|--------------|---------------------------|---------|
| `tools/mdpe-status.py` | `mdpe-tracking.yml` → *USAGE INSTRUCTIONS* (`python3 tools/mdpe-status.py update/report`) e `config.auto_calculations` | **Não** (busca `mdpe-status` → 0 resultados) |
| `.github/workflows/mdpe-tracking-update.yml` | `mdpe-tracking.yml` → *"CI/CD INTEGRATION … See: .github/workflows/mdpe-tracking-update.yml"* e `config.integrations.github` | **Não** (busca `.github` → 0 resultados) |
| `aggregated-learnings.yml` (template/schema) | `skills/mdpe-learnings/SKILL.md` (*Outputs* e *Quality gate*), `docs/mdpe-flow.md`, `docs/mapping-commands-to-skills.md` | **Output prometido sem template**: os assets de learnings só contêm `mdpe-tracking.yml` |
| `{id}-learnings.yml` (template) | `skills/mdpe-learnings/SKILL.md` → *"Per task: `docs/execution/{microtask-id}-learnings.yml`"* | **Sem template** |
| `{id}-code-review.yml` (template) | `skills/mdpe-coding/SKILL.md` → *"Output: `docs/execution/{microtask-id}-code-review.yml`"* | **Sem template** (assets de coding só têm `validation-report-template.yml`) |
| `docs/architecture/decision.md`, `docs/adr/ADR-005-user-schema.md` | `mdpe-microtask-template.yml` (input de exemplo) e `mdpe-tracking.yml` (artifact de exemplo) | **Nenhuma skill os produz** (não há skill de arquitetura) |

---

## Seção D — Mapa de lacunas: perguntas do usuário × evidência

Cada pergunta tem ≥1 lacuna, com arquivo/trecho e critério observável. A coluna *Fase* liga à fase que
deve fechar a lacuna (conforme o mapa de `tasks-v1.md`).

### Pergunta 7 — "O que os frameworks atuais têm de forte que não temos" → **Fase 1**

- **Lacuna 7.1 — Não há benchmark competitivo nem rubrica de avaliação.**
  Evidência: `docs/` contém apenas `mapping-commands-to-skills.md` e `mdpe-flow.md`; não existe
  `docs/analysis/competitive-analysis.md` nem `evaluation-rubric.md`.
  Critério observável: arquivos ausentes no repo (esta própria Fase 1 os cria).

### Pergunta 2 — "Já temos código: mínimo para seguir via discovery do código existente" → **Fase 2**

- **Lacuna 2.1 — Discovery é greenfield-only.**
  Evidência: `skills/mdpe-discovery/SKILL.md` (*When to use*): *"Use when: Starting a new product or a
  major new cycle"*; exige *"20-30 unique features"*, *"At least 2 personas"* e MoSCoW (ver *Quality gate*).
  Critério observável: não há modo/gatilho para "repositório com código existente"; busca por
  `brownfield`/`existing code` no repo → 0 ocorrências fora de `tasks-v1.md`.
- **Lacuna 2.2 — Router não tem rota para código existente.**
  Evidência: `skills/mdpe-router/SKILL.md` (*Routing table*) só cobre "Starting a new product/project";
  nenhuma linha para inventário de repo.
  Critério observável: tabela de roteamento sem entrada de brownfield.
- **Lacuna 2.3 — Fast-path (`mdpe-tasks`) ainda enquadra por invenção, não por leitura de código.**
  Evidência: `skills/mdpe-tasks/SKILL.md` Phase 1 pede *Objective/Problem/Value* derivados do texto,
  não do código existente.
  Critério observável: nenhuma instrução de inventariar stack/módulos a partir do repo.

### Pergunta 1 — "Como definir padrões de arquitetura a partir do backlog (`mdpe-architecture`)" → **Fase 3**

- **Lacuna 1.1 — Arquitetura só existe como dimensão de review, não como decisão.**
  Evidência: `skills/mdpe-coding/SKILL.md` Fase 3, dimensão 2: *"Architecture — respects patterns,
  boundaries, and dependency direction"* — avalia, mas não decide.
  Critério observável: não há skill/passo que produza decisões arquiteturais.
- **Lacuna 1.2 — Arquitetura entra como texto livre sem origem.**
  Evidência: `skills/mdpe-transformation/SKILL.md` (*Inputs*): *"Technical context: architecture … code
  patterns, conventions"*; `execution-context-template.yml` chumba `overall_pattern: "Clean Architecture
  with DDD"`.
  Critério observável: nenhum artefato `architecture-decisions`/ADR é gerado; ADRs só aparecem como
  exemplos em `mdpe-microtask-template.yml`/`mdpe-tracking.yml` sem produtor.

### Pergunta 3 — "Fidelidade de implementação + engenharia de loop" → **Fase 4**

- **Lacuna 3.1 — O loop depende do agente e não força evidência de execução.**
  Evidência: `skills/mdpe-coding/SKILL.md` Fase 2: *"If any dimension fails, return to Phase 1"* —
  sem obrigação de rodar build/testes. `validation-report-template.yml` traz `validated: false` /
  `status: "pending"` por dimensão e permite `summary.overall_status: approved` sem preencher
  `commands_executed`/`evidence`.
  Critério observável: é possível marcar `decision: ready_for_review` sem nenhuma saída de comando.
- **Lacuna 3.2 — Sem critério de parada / contador de iterações.**
  Evidência: `validation-report-template.yml` não tem campo de "iterações até verde"; `mdpe-coding`
  não define limite de tentativas nem diagnóstico de causa-raiz.
  Critério observável: ausência de campo de iteração/limite → risco de loop sem fim ou "pronto" sem prova.

### Pergunta 4 — "Como medir o processo de execução" → **Fase 5**

- **Lacuna 4.1 — Tracking promete automação inexistente.**
  Evidência: `mdpe-tracking.yml` cita `tools/mdpe-status.py`, `.github/workflows/mdpe-tracking-update.yml`
  e `config.auto_calculations` — **nenhum existe** (Seção C).
  Critério observável: buscas retornam 0 resultados para `mdpe-status` e `.github`.
- **Lacuna 4.2 — Métricas sem fonte derivável clara.**
  Evidência: `mdpe-tracking.yml` seção `metrics` (throughput, cycle/lead time, rejection_rate) sem
  ligação a campo de artefato que o MDPE já gera.
  Critério observável: nenhuma métrica aponta o campo de `validation-report`/`code-review`/`learnings`
  de onde é derivada.

### Pergunta 5 — "Visualizar a relação entre tarefas/features (grafos)" → **Fase 6**

- **Lacuna 5.1 — Dados de grafo gerados mas nunca unificados nem renderizados.**
  Evidência: `skills/mdpe-transformation/SKILL.md` Fase 2 gera `dependencies/full-graph.yml`,
  `waves.yml`, `critical-path.yml`, `parallelizable.yml` (por feature); `mdpe-tracking.yml` tem
  `dependency_graph: nodes/edges`. Nenhum passo os unifica ou desenha.
  Critério observável: não existe artefato de grafo unificado; os Mermaid presentes
  (`docs/mdpe-flow.md`, `mdpe-router/SKILL.md`) são diagramas de roteamento **chumbados**, não gerados
  a partir dos YAMLs de dependência.
- **Lacuna 5.2 — Rastreabilidade só cobre microtask↔microtask.**
  Evidência: `dependencies-template.yml` liga apenas micro-tasks entre si; não há aresta
  discovery→feature→microtask→arquitetura→artefato→aprendizado.
  Critério observável: ausência de tipos de nó/aresta transversais nos templates.

### Pergunta 6 — "Como construir memória" → **Fase 7**

- **Lacuna 6.1 — Memória é só de escrita; ninguém a lê antes de agir.**
  Evidência: `skills/mdpe-router/SKILL.md` não tem passo "consultar memória"; `mdpe-learnings` grava
  `aggregated-learnings.yml`, mas discovery/transformation/coding não têm contrato de leitura.
  Critério observável: nenhuma skill de entrada instrui ler memória antes de decidir/rotear.
- **Lacuna 6.2 — `aggregated-learnings.yml` não tem template.**
  Evidência: assets de `mdpe-learnings` contêm apenas `mdpe-tracking.yml` (Seção C).
  Critério observável: output prometido sem artefato-modelo.

### Pergunta 8 — "Reduzir conteúdo gerado por IA / opcional vs obrigatório / anti-alucinação" → **Fase 8**

- **Lacuna 8.1 — Mínimos rígidos forçam volume.**
  Evidência: `mdpe-discovery/SKILL.md` *"20-30 unique features"*; `mdpe-transformation/SKILL.md`
  *"15-25 atomic micro-tasks"*; `mdpe-execution-context/SKILL.md` 6 dimensões sempre.
  Critério observável: quality gates exigem essas contagens independentemente do tamanho do item.
- **Lacuna 8.2 — Schemas com obrigatoriedade profunda.**
  Evidência: `mdpe-microtask.schema.json` 14 campos obrigatórios no root + `estimate` (6) + `metadata`
  (7) + `aert_validation` (4×2).
  Critério observável: contagem de `required` (Seção B).
- **Lacuna 8.3 — Templates sem marcação de opcional e sem diretriz anti-alucinação.**
  Evidência: todos os `*.yml` em `assets/templates` têm 0 campos marcados como opcionais; nenhum
  `SKILL.md` contém uma frase "não invente para preencher".
  Critério observável: busca por "opcional/optional"/"não invente" nos templates → ausente.

### Pergunta 9 — "Melhorias no que será produzido" → **Fase 9**

- **Lacuna 9.1 — Caminhos de saída inconsistentes entre skills.**
  Evidência: `mdpe-execution-context/SKILL.md` salva `docs/execution/{id}-context.yml`, mas
  `tasks-template.yml` e `validation-report-template.yml` (*directory_structure*) usam
  `docs/transformation/{feature-id}/execution/`.
  Critério observável: os links gerados em `tasks.md` apontam para pasta diferente da que a skill grava.
- **Lacuna 9.2 — Fórmula de score divergente entre documentos.**
  Evidência: `mdpe-discovery/SKILL.md` *"Score = Value × (10 - Effort)"* vs
  `docs/mapping-commands-to-skills.md` *"score `Value × (11 - Effort)`"*.
  Critério observável: dois valores diferentes para a mesma fórmula.
- **Lacuna 9.3 — `$id` de schema inconsistente (origem de cópia exposta).**
  Evidência: `cognitive-backlog.schema.json` e `mdpe-microtask.schema.json` usam
  `https://hubturismo.com/...`; `discovery-session.schema.json` usa `https://mdpe.dev/...`.
  Critério observável: domínios diferentes entre schemas do mesmo framework.

---

## Seção E — Inconsistências transversais (evidência para a Fase 9)

1. **Caminho de saída de execução divergente** — ver Lacuna 9.1.
2. **Fórmula Value×(10-Effort) vs Value×(11-Effort)** — ver Lacuna 9.2.
3. **Domínios de `$id` de schema misturados (`hubturismo.com` vs `mdpe.dev`)** — ver Lacuna 9.3.
4. **Outputs sem template** (`aggregated-learnings.yml`, `{id}-learnings.yml`, `{id}-code-review.yml`) —
   ver Seção C.

---

## Resumo

- **9/9 perguntas** do usuário têm ≥1 lacuna mapeada com referência a arquivo específico e critério
  observável (Seção D).
- **Contagem obrigatório vs opcional** consolidada por template/schema (Seção B).
- **Referências fantasma** explicitamente identificadas (Seção C): `tools/mdpe-status.py`,
  `.github/workflows/mdpe-tracking-update.yml`, e três outputs sem template.

| Pergunta | Fase | # lacunas | Evidência-chave |
|----------|------|-----------|-----------------|
| 7 Benchmark | 1 | 1 | ausência de `docs/analysis/*` |
| 2 Brownfield | 2 | 3 | `mdpe-discovery` greenfield-only; router sem rota |
| 1 Arquitetura | 3 | 2 | arquitetura só como review + texto livre |
| 3 Fidelidade/loop | 4 | 2 | `validation-report` aprova sem evidência |
| 4 Métricas | 5 | 2 | `tools/mdpe-status.py` inexistente |
| 5 Grafos | 6 | 2 | grafo por-feature nunca unificado/renderizado |
| 6 Memória | 7 | 2 | memória só de escrita; sem template |
| 8 Anti-alucinação | 8 | 3 | mínimos rígidos + schemas pesados + 0 opcionais |
| 9 Saída | 9 | 3 | caminhos/fórmula/`$id` inconsistentes |

> Conteúdo redigido a partir da leitura direta dos arquivos do repositório. Trechos citados foram
> parafraseados/curtos para referência; consultar os arquivos originais para o texto completo.
