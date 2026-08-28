# ADR-004 — Conjunto mínimo de métricas de execução e fonte de verdade

| Campo | Valor |
|---|---|
| **Status** | Aceito |
| **Data** | 28/08/2026 |
| **Tarefa de origem** | `tasks-v1.md` → Fase 5 → 5.1 |
| **Eixo da rubrica** | Eixo 4 — Mensurabilidade (baseline **1**, meta **4**) |
| **Implementado por** | Tarefa 5.2 (`mdpe-tracking.yml` + `mdpe-learnings/SKILL.md`) · consumido na 6.3 (órfãos, caminho crítico) e na 7.2 (assinaturas recorrentes) · reclassificado na 8.1 · verificado na 9.3 |
| **Adoções associadas** | A9 (métrica derivada de artefato, nunca de tooling inexistente) · A5 (criação preguiçosa) · A12 (curadoria embutida) · A11 (grafo que despacha) |
| **Depende de** | ADR-003 (bloco `loop`, vocabulário de status e contrato de evidência são a fonte primária das métricas) · ADR-002 (`ad-NNN` e `verification` como fonte das métricas de conformidade arquitetural) |

---

## 1. Contexto

O MDPE tem um artefato de tracking com **mais métrica do que fonte**. O problema não é falta de
ambição de medição: é que quase nada do que ele declara pode ser recomputado a partir de algum campo
de algum artefato que o framework realmente produz.

### 1.1 Referências fantasma: automação prometida que não existe

`skills/mdpe-learnings/assets/templates/mdpe-tracking.yml` instrui, na seção *USAGE INSTRUCTIONS*:

- `python3 tools/mdpe-status.py update --task MT-XXX --status done` (§3)
- `python3 tools/mdpe-status.py report --by-executor / --bottlenecks` (§4)
- *"Workflow updates automatically when a PR is merged. See: `.github/workflows/mdpe-tracking-update.yml`"* (§5)
- `config.auto_calculations: [avg_completion_time, velocity_story_points, rejection_rate, blocker_duration]`
- `config.integrations.github.sync_on_pr_merge: true` e `config.integrations.slack.notify_on_events`
- `blocker_duration: "3h"  # calculated automatically` (MT-004)

**Nenhum desses artefatos existe no repositório** (gap-map Seção C: busca por `mdpe-status` → 0
resultados; busca por `.github` → 0 resultados). É a Lacuna 4.1. O efeito prático é pior que a
ausência: um agente que lê o template conclui que existe cálculo automático e **não recomputa nada**,
deixando o bloco de métricas como o template o entregou.

### 1.2 O exemplo do próprio template não reconcilia

Esta é a evidência mais direta da Lacuna 4.2. No mesmo arquivo:

| O que a lista de micro-tasks mostra | O que o bloco `metrics` afirma |
|---|---|
| 6 micro-tasks (MT-001 a MT-006) | `total_tasks: 15` |
| 2 com `status: done` (MT-001, MT-002) | `completed: 5` |
| — | `by_type` soma 15 · `by_priority` soma 15 |
| MT-006 com `validation_attempts: 1`, `rework_count: 1` | `rejection_rate: 0.17  # 1/6` — denominador 6, incompatível com `completed: 5` e com `tasks_approved_first_try: 4 + tasks_rejected: 1 + tasks_rework: 1` |

O template **ensina a escrever agregados que os dados listados não sustentam**. Quem preenche a partir
dele reproduz o padrão: números plausíveis, sem origem conferível.

### 1.3 Números sem fórmula e sem fonte

| Campo | Por que não é métrica |
|---|---|
| `quality_score: 0.90` / `0.95` / `avg_quality_score: 0.88, 0.92, 0.93` | Nenhuma fórmula, nenhum campo de origem, nenhuma escala definida. É opinião com duas casas decimais — o mesmo defeito dos defaults `0` do `validation-report-template.yml` que o ADR-003 (D3.4) removeu. |
| `velocity_story_points: 12` | Nenhum artefato do MDPE registra story point. Não existe em `mdpe-microtask-template.yml`, nem no backlog, nem no índice. |
| `avg_lead_time: "4.5h"` | Lead time exige data de solicitação. Nenhum artefato a registra. |
| `avg_cycle_time: "2.1h"` | Depende de `started_at`/`completed_at`, que nenhuma skill do MDPE grava. |
| `progress_percentage: 60` (MT-003) | Percentual de progresso autodeclarado, sem medição possível. |
| `code_lines_generated: 120` (MT-002) | Sem fonte e com incentivo invertido: mais linha não é mais entrega. |
| `avg_blocker_resolution_time: "6h"` / `longest_blocker: "12h"` | O ADR-003 dá a um bloqueio **rota e causa-raiz**, não duração; nada marca fim de bloqueio. |
| `test_coverage: 0.85` / `test_coverage_avg: 0.82` | Cobertura existe **só quando o projeto mede** — e o ADR-003 (D3.4) proíbe número não medido e recusa cobertura como meta. |

### 1.4 Duplicação do contrato: dois lugares, uma verdade

Por micro-task, o tracking re-declara `id`, `title`, `feature_origin`, `type`, `priority`,
`dependencies`, `artifacts` e `effort_estimated` — todos já presentes em
`docs/transformation/{feature-id}/microtasks/mt-XXX-YYY.yml` e em `microtasks-index.yml`. Duplicação
sem regra de precedência é **deriva garantida**: em duas semanas os dois arquivos discordam e nada diz
qual vale. O mesmo vale para `auto_checks_passed: [linting, unit_tests, coverage_80, security_scan]`
(MT-002), que resume sem evidência as dimensões que o `validation-report` registra **com** evidência, e
para `validation_attempts` / `rework_count`, que hoje competem com o bloco `loop` do ADR-003.

O `dependency_graph: nodes/edges` do tracking é o caso mais claro: duplica
`docs/transformation/{feature-id}/dependencies/full-graph.yml` de forma reduzida e é justamente o dado
que a Fase 6 vai unificar (Lacuna 5.1).

### 1.5 O artefato mede um processo que o MDPE não conduz

`team_members[].autonomy_level` (`L1_supervised`/`L2_assisted`/`L3_monitored`), `sprint`,
`events` com `daily_standup` e `attendance: 5`, `alerts` com severidade atribuída à mão, integração com
Slack: é instrumentação de **gestão de sprint de time**, herdada da origem do artefato
(`framework/12-gestao-paralela-humano-ia.md`, citada no cabeçalho). Nada disso deriva de artefato do
MDPE, e nada disso responde a pergunta da Fase 5 — *como medir o processo de execução*.

### 1.6 Inconsistência de identificadores

O tracking usa `MT-001` e `feature-001`. O resto do framework usa `mt-XXX-YYY` (formato declarado em
`mdpe-microtask-template.yml`: `mt-{feature-number}-{sequence}`) e `feat-XXX`. Métrica agregada por id
que não casa com o id do contrato é métrica que não se liga a nada. A padronização de ids é da tarefa
9.1; a correção **neste arquivo** é da 5.2, por ser o mesmo arquivo reescrito (mesma postura que o
ADR-003 adotou com as referências `.txt` legadas).

### 1.7 O que mudou a favor: agora existe matéria-prima real

O ADR-003 criou, pela primeira vez, campos de artefato que são **medição e não afirmação**:

- `loop.iterations_to_green`, `loop.limit`, `loop.overrun`, `loop.iterations[].outcome`, `loop.iterations[].failed[].dimension`
- `acceptance_criteria.coverage.{declared_in_contract, reported_here, passing, failing, not_verifiable}`
- `fidelity.criteria_coverage_complete`, `fidelity.declared_outputs[].exists`
- `summary.overall_status`, `summary.not_verifiable_count`, `root_cause_diagnosis.route`
- `verification_plan.frozen_at` e `metadata.validated_at` — **dois carimbos de tempo reais**, que
  fecham um intervalo de execução sem depender de `started_at` inventado
- no `code-review`: `verdict.open.{blockers,majors,minors,nitpicks}`, `findings[].severity`,
  `findings[].violates: ad-NNN`, `scope.architecture_decisions_in_scope`,
  `dimensions.architecture.decisions_checked[].result`, `metadata.reviewed_at`

O ADR-003 (D13) já reservou essa lista para a Fase 5. Este ADR a transforma em catálogo com fórmula,
fonte, classe e gatilho — e corta o resto.

Referência externa: OSpec persiste métricas de execução em artefato (`execution-metrics.json`) e faz as
métricas **distinguirem cobertura completa, parcial e ausente** em vez de apresentar um número único
(competitive-analysis 4.4). É a adoção A9: métrica aponta campo de origem; o que exige script é
opcional ou removido.

---

## 2. Decisão

### D1 — O artefato é uma **projeção derivada**; a fonte de verdade são os artefatos de execução

Inversão explícita do modelo atual:

| | Hoje (implícito) | A partir daqui |
|---|---|---|
| Onde a verdade vive | no tracking, atualizado à mão | nos artefatos de execução (`validation`, `code-review`, `learnings`, contrato da micro-task) |
| O que o tracking é | registro primário paralelo | **visão derivada**, recomputável a qualquer momento a partir dos artefatos |
| Em caso de divergência | indefinido | **o artefato vence**; o tracking é corrigido, nunca o contrário |

Consequência dura: **métrica que não pode ser recomputada lendo artefatos não entra no tracking.** Se o
tracking for apagado, ele tem de poder ser reconstruído — exceto pelo bloco declarado (D4, classe C),
que é a única informação que nasce ali.

### D2 — Um arquivo, de projeto, versionado: `docs/tracking/mdpe-tracking.yml`

O tracking é **cross-feature** (é o único lugar que compara features entre si), logo não vive dentro de
`docs/transformation/{feature-id}/`. Um diretório próprio, no mesmo padrão de um-diretório-por-assunto
que o framework já usa para os artefatos de nível de projeto no repositório consumidor:
`docs/architecture/decisions.yml` (ADR-002), `docs/brownfield/inventory.md` (ADR-001),
`docs/backlog/backlog-index.yml` e `docs/learning-loops/aggregated-learnings.yml`
(`mdpe-learnings/SKILL.md`).

Substitui o *"project root or .mdpe/"* do cabeçalho atual, que nunca foi decisão. A padronização de
caminhos da Lacuna 9.1 trata da árvore **por-feature** e não afeta este arquivo.

### D3 — Três classes de métrica, marcadas no próprio artefato

O template atual não distingue medição de afirmação. Passa a distinguir, com a classe escrita ao lado
de cada bloco:

| Classe | Definição | Obrigatoriedade | Como se lê |
|:--:|---|---|---|
| **D** — derivada | recomputável a partir de um campo que é contagem ou está lastreado em evidência (ADR-003 D3) | **obrigatória quando o artefato-fonte existe** | medição |
| **C** — declarada | lida de um campo de artefato que alguém **afirma**, sem evidência que o confira (esforço real, executor) | **opcional** | testemunho, não medição |
| **M** — manual/externa | exige informação que o MDPE não produz (story point, cadência de time, custo) | **fora do escopo**; não figura no artefato | — |

Regra de leitura, escrita no template: **nenhum número de classe C entra em fórmula com número de
classe D.** Média de `effort_actual` não se combina com `iterations_to_green` para produzir um índice —
seria lastrear medição com testemunho.

### D4 — O catálogo mínimo

Cada linha traz fórmula, artefato-fonte e campo. Sem essas três colunas a métrica não existe.
`{id}` = `mt-XXX-YYY`; os caminhos seguem `docs/transformation/{feature-id}/execution/`.

#### Bloco A — Loop e retrabalho · fonte: `{id}-validation.yml` · classe D

| # | Métrica | Fórmula | Campo de origem |
|:--:|---|---|---|
| A1 | `iterations_to_green` | valor literal, por micro-task | `loop.iterations_to_green` |
| A2 | `first_pass` | contagem de micro-tasks fechadas com `iterations_to_green == "i1"`, **sobre** o total de fechadas | `loop.iterations_to_green` |
| A3 | `overrun` | contagem de `loop.overrun: true` | `loop.overrun` |
| A4 | `blocked_by_route` | contagem de `overall_status == blocked`, agrupada por rota | `summary.overall_status` + `root_cause_diagnosis.route` |
| A5 | `environment_aborts` | contagem de iterações com `outcome: environment` | `loop.iterations[].outcome` |
| A6 | `failures_by_dimension` | contagem por dimensão que falhou em qualquer iteração | `loop.iterations[].failed[].dimension` |
| A7 | `repeated_symptom` | contagem de micro-tasks com `root_cause_diagnosis` presente | existência do bloco `root_cause_diagnosis` |

A2 substitui `rejection_rate`; A7 substitui `validation_attempts` e `rework_count`, que passam a ser
**derivados do loop** em vez de contados em paralelo.

#### Bloco B — Fidelidade e cobertura de verificação · fonte: `{id}-validation.yml` · classe D

| # | Métrica | Fórmula | Campo de origem |
|:--:|---|---|---|
| B1 | `criteria_declared` / `criteria_passing` | valores literais, por micro-task | `acceptance_criteria.coverage.declared_in_contract` · `.passing` |
| B2 | `fidelity_complete` | `criteria_coverage_complete == true` **e** todo `declared_outputs[].exists == true` | `fidelity.*` |
| B3 | `not_verifiable` | soma de `not_verifiable_count` | `summary.not_verifiable_count` |
| B4 | `coverage_when_measured` | **opcional**: registrar só quando a evidência trouxe o número | `automated_tests.metrics.line_coverage` |

B3 mede **cobertura de verificação, não qualidade** (ADR-003 D13). Um `not_verifiable` alto é um pedido
de ferramenta ou de autorização, não um defeito de código — e é o sensor que impede
`not_verifiable` de virar escapatória. B4 é a única métrica numérica de qualidade externa admitida, e
é **opcional por construção**: sem medição, a linha não existe (ADR-003 D3, regra 4).

#### Bloco C — Review e conformidade arquitetural · fonte: `{id}-code-review.yml` · classe D

| # | Métrica | Fórmula | Campo de origem |
|:--:|---|---|---|
| C1 | `open_findings` | contagens por severidade, no fecho | `verdict.open.{blockers,majors,minors,nitpicks}` |
| C2 | `review_returns` | contagem de achados `blocker`/`major` com `resolved: true` (cada um consumiu iteração — regra 4 do template de review) | `findings[].severity` + `.resolved` |
| C3 | `architecture_violations` | contagem de achados com `violates` preenchido, agrupada por `ad-NNN` | `findings[].violates` |
| C4 | `scopes_without_decision` | contagem de reviews com `architecture_decisions_in_scope: []` | `scope.architecture_decisions_in_scope` |
| C5 | `decision_checks` | resultados das verificações de decisão, agrupados por `result` | `dimensions.architecture.decisions_checked[].result` |

C4 e C5 são a métrica que faltava ao Eixo 2: C4 diz **quanto do código foi revisado sem baseline
escrito** (gatilho de uma rodada de `mdpe-architecture`), e C5 diz se o campo `verification` das
decisões está sendo de fato executado ou apenas declarado.

#### Bloco D — Fluxo · fonte: carimbos de tempo reais · classe D

| # | Métrica | Fórmula | Campo de origem |
|:--:|---|---|---|
| D1 | `execution_span` | `metadata.validated_at` − `verification_plan.frozen_at` | `{id}-validation.yml` |
| D2 | `closure_span` | `metadata.reviewed_at` − `verification_plan.frozen_at` | `{id}-code-review.yml` + `{id}-validation.yml` |
| D3 | `throughput` | contagem de micro-tasks fechadas por período, datadas por `validated_at` | `{id}-validation.yml` |
| D4 | `status_reconciled` | contagem por status, **derivada da existência e do veredito dos artefatos**, e reconciliada contra o índice (D6) | artefatos + `microtasks-index.yml` → `summary.overall_status` |

D1/D2 substituem `avg_cycle_time` e `avg_lead_time`: medem o intervalo que o processo **realmente
carimba** (plano congelado → verde → review fechado). É tempo de parede, não esforço — e o template
diz isso na linha, para que ninguém o leia como hora-homem.

#### Bloco E — Propagação · fonte: artefatos de learnings · classe D, **condicional**

| # | Métrica | Fórmula | Campo de origem |
|:--:|---|---|---|
| E1 | `learnings_by_target` | contagem de ações recomendadas por alvo (Discovery · Transformation · Next executions) | `{id}-learnings.yml` |
| E2 | `recurring_signatures` | assinatura de `root_cause_diagnosis.symptom` repetida em ≥ 2 micro-tasks | `{id}-validation.yml` + `aggregated-learnings.yml` |

**Condicional por um motivo declarado:** `{id}-learnings.yml` e `aggregated-learnings.yml` são outputs
prometidos por `mdpe-learnings/SKILL.md` que **hoje não têm template** (gap-map Lacuna 6.2 e Seção C).
Declarar E1/E2 como obrigatórias agora repetiria exatamente o erro da Lacuna 4.1 — métrica ancorada em
artefato inexistente. Ficam registradas, condicionadas à existência do artefato, e o fecho dessa lacuna
é da Fase 7 (7.2 / adoção A12). E2 é a matéria-prima da lição `candidate → confirmed`.

#### Bloco F — Declaradas · classe C · **opcional**

| # | Campo | Por que fica | Fonte |
|:--:|---|---|---|
| F1 | `executor` (`human` \| `ai` \| `hybrid`, `ai_tool`) | é a **única** informação de valor que nenhum outro artefato do MDPE registra | declarado no fecho |
| F2 | `effort_actual` vs `estimate.total_time` | calibra estimativa; é testemunho, não medição | `{id}-learnings.yml` vs micro-task `estimate.total_time` |
| F3 | `complexity_actual` vs `estimate.complexity` | calibra decomposição | idem |

Todo o bloco F é opcional e **rotulado como declarado** no template. Ausente é resultado correto.

#### Reservado para a Fase 6 — declarado aqui, **não** exigido

`orphans_count`, `critical_path_length`, `parallelism_available` e `cycles_detected` são métricas
legítimas de processo e **dependem do grafo unificado que ainda não existe** (ADR-005, tarefas 6.1-6.4).
Ficam nomeadas nesta seção do ADR e **não entram no template na 5.2**. Quando a Fase 6 entregar o grafo,
entram como bloco G, classe D. Nomear aqui e não declarar lá é a diferença entre roadmap e referência
fantasma.

### D5 — Regras de integridade numérica

Herdadas do ADR-003 D3 e estendidas ao agregado:

1. **Nenhum default numérico.** Métrica sem medição é **linha ausente**, nunca `0`. Um `0` apresentado
   como medição é evidência falsa.
2. **Contagem antes de razão.** Toda razão é publicada com o denominador explícito
   (`first_pass: 4 de 7`), nunca como percentual solto. Com **menos de 5 micro-tasks fechadas**, razões
   não são publicadas — só as contagens: percentual sobre 2 itens é encenação.
3. **Sem número agregado sem os itens que o compõem.** Todo agregado tem de ser reconstituível a
   partir da lista de micro-tasks do próprio arquivo. É a regra que o exemplo atual viola (§1.2).
4. **Sem escore composto.** Nenhum índice de qualidade, saúde ou maturidade. Um número que mistura
   dimensões esconde qual delas se moveu — e é assim que `quality_score` nasce.
5. **`unknown` é valor válido.** Melhor que uma estimativa apresentada como leitura.
6. **Sem cálculo automático prometido.** Quem recomputa é o agente lendo artefatos (D6). Nenhuma
   instrução do template aponta script, workflow ou integração que não exista.

### D6 — Frequência, responsável e reconciliação

Atualização **orientada a evento, nunca periódica**. Cadência periódica sem ferramenta é promessa que
ninguém cumpre — é a origem da Lacuna 4.1.

| Escrita | Quando | Responsável |
|---|---|---|
| Bloco derivado da micro-task (A, B, C, D, E) | no **fecho da micro-task**, dentro de `mdpe-learnings` (etapa *Propagate*) | agente |
| Bloco declarado (F) | no mesmo fecho | quem executou (agente ou pessoa) |
| Agregados de feature | no fecho da **última** micro-task da feature | agente |
| Reconciliação (D4/D6) | a **cada** escrita | agente |
| Recomputação total | on demand, quando alguém pede o número | agente |

**Leitura:** humano a qualquer momento; agente na Fase 6 (grafo) e na Fase 7 (memória). **Nada no
framework bloqueia esperando um humano preencher tracking** — se ninguém abrir o arquivo, o ciclo de
execução continua funcionando.

**Regra de reconciliação (o antídoto ao §1.2):** ao escrever, o agente confere status contra artefato.
Uma micro-task só é `completed` se existir `{id}-validation.yml` com `overall_status` em
`approved`/`approved_with_reservations` **e** `{id}-code-review.yml` com verdict equivalente. Só é
`blocked` com `root_cause_diagnosis` e rota. Divergência entre tracking e artefato: **o artefato vence**
e o tracking é corrigido na mesma escrita. Divergência entre tracking e `microtasks-index.yml`:
registrada como pendência de reconciliação — nunca resolvida por dedução.

### D7 — Sem duplicação do contrato: o tracking guarda ponteiro, não cópia

Por micro-task, o tracking carrega **apenas**:

`id` · `feature_id` · caminho dos artefatos (`validation`, `code-review`, `learnings`) ·
`status` reconciliado · os campos derivados dos blocos A-E · os campos declarados do bloco F.

Saem por serem cópia: `title`, `type`, `priority`, `dependencies`, `artifacts`, `effort_estimated`,
`auto_checks_passed`, `validation_attempts`, `rework_count`, `notes`. Quem quer o título lê o contrato
pelo ponteiro. Uma verdade, um lugar.

### D8 — Nenhuma métrica é gate

Regra explícita, e a mais importante deste ADR.

Nenhum número deste catálogo aprova, reprova, bloqueia ou libera qualquer coisa. Os gates estão no
ADR-003 (evidência por dimensão, dimensões 1 e 3 verdes, limite do loop) e no ADR-002 (`drivers`
bloqueante). O tracking **observa**.

O motivo é mecânico, não filosófico: `iterations_to_green` é escrito pelo mesmo agente que fecha a
micro-task. No instante em que ele vira meta, a pressão passa a ser **sub-reportar iteração** — e o
framework perde de uma vez a métrica e a evidência. Vale para `first_pass`, `not_verifiable`,
`coverage_when_measured` e `open_findings`: são sensores, e um sensor com meta acoplada mede a meta.

Corolário: uma micro-task `blocked` com causa-raiz documentada **não piora** métrica nenhuma. É
resultado correto do processo (ADR-003 D6), e o tracking a conta como tal.

### D9 — Eixos de agregação: micro-task → feature → projeto (+ onda quando houver)

A unidade é a **micro-task**. Agrega-se por **feature** (o recorte que o MDPE realmente produz) e por
**projeto**. Quando `mdpe-transformation` gerou ondas, `wave` é um quarto eixo — porque onda é a unidade
de paralelismo do framework.

`sprint` vira metadado **opcional**: quem usa sprint não é impedido de registrar; nenhuma métrica
depende disso. Saem `team_members`, `autonomy_level`, `events` e `alerts` como definidos hoje (§1.5).

### D10 — Sinais de roteamento no lugar de alertas

`alerts` — mensagem em prosa com severidade atribuída à mão — é substituído por `signals`, **opcional**,
onde cada sinal cita métrica, limiar e destino. Sinal sem destino é ruído; três bastam como canônicos:

| Condição | Sinal | Destino |
|---|---|---|
| `overrun ≥ 1` | há micro-task parada com causa-raiz e rota pendente | a rota do `root_cause_diagnosis` |
| `scopes_without_decision ≥ 2` | código sendo revisado sem baseline arquitetural escrito | rodada de `mdpe-architecture` |
| `environment_aborts ≥ 2` | o ambiente está consumindo o laço | `mdpe-execution-context` |

Nenhum outro sinal é sugerido pelo template. Catálogo de alertas genéricos é o tipo de conteúdo que a
Fase 8 corta.

### D11 — O que é **removido** e por quê

| Removido | Motivo |
|---|---|
| `quality_score`, `avg_quality_score` | número sem fórmula, sem fonte e sem escala (§1.3); proibido por D5.4 |
| `velocity_story_points` | nenhum artefato do MDPE tem story point |
| `avg_lead_time` | exige data de solicitação que nada registra |
| `avg_cycle_time`, `avg_completion_time` | dependem de `started_at`/`completed_at` inexistentes → substituídos por D1/D2 |
| `progress_percentage` | percentual autodeclarado, não medível |
| `code_lines_generated` | sem fonte e com incentivo invertido |
| `test_coverage`, `test_coverage_avg` como campos fixos | viram B4, opcional, só quando medido |
| `blocker_duration`, `avg_blocker_resolution_time`, `longest_blocker` | nada marca fim de bloqueio; o ADR-003 dá rota, não cronômetro |
| `auto_checks_passed` | resume sem evidência o que o `validation-report` registra com evidência |
| `validation_attempts`, `rework_count` | duplicam o bloco `loop` → derivados de A1/A7 |
| `dependency_graph: nodes/edges` | duplica `dependencies/full-graph.yml`; grafo é a Fase 6 (ADR-005) |
| `config.auto_calculations` | nomeia cálculos que nada executa |
| `config.integrations` (github, slack) | integrações inexistentes |
| `config.auto_update: true` | afirma automação inexistente |
| *USAGE INSTRUCTIONS* §3, §4, §5 | `tools/mdpe-status.py` e `.github/workflows/mdpe-tracking-update.yml` não existem (§1.1) |
| §7 *Dashboard (Grafana/Metabase)* | ferramenta externa como instrução; vira nota opcional, se ficar |
| `events`, `alerts`, `team_members[].autonomy_level`, roster | gestão de sprint de time, não derivável (§1.5) → `alerts` substituído por D10 |
| ids `MT-001` / `feature-001` | trocados por `mt-XXX-YYY` / `feat-XXX` (§1.6) |

### D12 — Trabalho futuro registrado (não referenciado em template)

A tarefa 5.2 dá duas opções para as referências fantasma: remover, ou registrar como trabalho futuro.
Decisão: **remover do template e registrar aqui**, o que satisfaz as duas sem deixar ponteiro quebrado.

Se um dia existir tooling de métricas, seu contrato é definido agora, para não nascer como fonte
paralela:

- **Nome/local:** decididos quando existir; **nada** no framework os referencia antes disso.
- **Papel:** *verificador*, não fonte. Lê os artefatos, recomputa o bloco derivado, compara com o
  tracking e **retorna diferente de zero na divergência**. Não inventa métrica nova, não escreve
  número que o agente não poderia derivar à mão.
- **Obrigatoriedade:** nunca. O tracking tem de continuar preenchível e conferível sem ele — como o
  ADR-003 recusou gates por script (alternativa c) pelo mesmo motivo.
- **Pré-requisito:** a Fase 9 decidir onde ferramentas vivem neste repositório. Hoje não existe esse
  lugar, e criar um agora repetiria a Lacuna 4.1.

### D13 — Costuras para as fases seguintes

| Fase | O que este ADR deixa pronto |
|---|---|
| **6** — grafo | bloco G nomeado e **não declarado** (órfãos, caminho crítico, paralelismo, ciclos); a remoção do `dependency_graph` duplicado tira o concorrente do grafo unificado; C3/C5 dão a aresta `ad-NNN → achado` |
| **7** — memória | E2 (`recurring_signatures`) é a matéria-prima de `candidate → confirmed` (A12); A4 (`blocked_by_route`) diz **qual estágio a montante** gera retrabalho; E1 mede se os três loops de feedback estão de fato correndo |
| **8** — anti-alucinação | D3 (classes D/C/M), D5 (integridade numérica), D7 (fim da duplicação) e D11 (remoções) entram na auditoria 8.1 já classificados; o template encolhe em vez de crescer |
| **9** — wiring | ids `mt-XXX-YYY`/`feat-XXX` (§1.6) alimentam o padrão único da 9.1; `docs/tracking/mdpe-tracking.yml` (D2) entra na tabela de caminhos; a cadeia critério → evidência → métrica fecha o rastreio da 9.1 |
| **3** — arquitetura | C4 (`scopes_without_decision`) é o primeiro sensor que **cobra** uma rodada de `mdpe-architecture` em vez de deixar o review adivinhar baseline |

---

## 3. Critério de conclusão do artefato de métricas ("tracking honesto")

Um `mdpe-tracking.yml` está válido quando **todos** valem:

- [ ] Toda métrica presente aponta **artefato + campo** de origem e traz a classe (**D**/**C**).
- [ ] Nenhuma métrica de classe **D** existe sem que o artefato-fonte exista no repositório.
- [ ] Nenhum agregado sem os itens que o compõem no próprio arquivo (D5.3).
- [ ] Nenhuma razão sem denominador explícito; nenhuma razão com menos de 5 micro-tasks fechadas (D5.2).
- [ ] Nenhum campo numérico em default; nenhum `0` que não foi contado (D5.1).
- [ ] Nenhum escore composto (D5.4).
- [ ] Nenhuma instrução aponta script, workflow, integração ou dashboard inexistente (D5.6).
- [ ] Status de cada micro-task **reconciliado** contra os artefatos, com o artefato vencendo (D6).
- [ ] Nenhum campo que duplique o contrato da micro-task (D7).
- [ ] Ids no formato `mt-XXX-YYY` / `feat-XXX`.
- [ ] Bloco declarado (F) rotulado como declarado, e ausente quando não há dado.

**Preenchível com uma única micro-task real** é o teste operacional (cenário positivo da 5.2): uma
micro-task fechada produz A1-A7, B1-B3, C1-C5, D1-D4 — sem razões, porque o denominador é 1 (D5.2).

---

## 4. Alternativas consideradas

### (a) Manter o tracking atual — **rejeitada**

É o baseline (nota 1). Mantém automação inexistente como instrução (Lacuna 4.1), métricas sem fonte
(Lacuna 4.2) e um exemplo que não reconcilia com os próprios dados (§1.2). Não alcança nem o nível 2 do
Eixo 4, que exige que as referências fantasma estejam ao menos **marcadas**.

### (b) Construir `tools/mdpe-status.py` agora e manter as métricas como estão — **rejeitada**

Resolveria a Lacuna 4.1 pela outra ponta. Rejeitada por três motivos, na ordem: (i) não resolve a
Lacuna 4.2 — script nenhum consegue calcular `quality_score` ou `velocity_story_points`, porque o dado
não existe em artefato algum; (ii) repete a recusa já registrada em `competitive-analysis.md` §7 e no
ADR-003 (alternativa c) — o MDPE **sofre** por dependência de tooling e a v1 não tem lugar sustentável
para binários; (iii) inverteria D1, transformando o script em fonte e os artefatos em coadjuvantes. O
contrato de um tooling futuro fica em D12: verificador, nunca fonte.

### (c) Nova skill `mdpe-metrics` — **rejeitada**

Métrica não tem entrada, saída nem gate próprios: é o passo de fecho que `mdpe-learnings` já executa
(*Propagate*) e que já compara esperado vs alcançado. Uma skill separada criaria uma décima primeira
skill para costurar na 9.2, duplicaria a leitura dos mesmos artefatos e pioraria o Eixo 7 sem elevar o
Eixo 4 — cujo nível 4 fala explicitamente de `mdpe-tracking.yml`.

### (d) Métricas só dentro de cada artefato por-feature, sem arquivo de projeto — **rejeitada**

Cada `validation-report` já carrega suas próprias medições, e seria tentador parar aí. Mas a pergunta da
Fase 5 é sobre o **processo**, e processo só aparece no cruzamento: `first_pass` entre features,
`blocked_by_route` acumulado, `scopes_without_decision` somado. Sem um ponto de agregação, cada número
fica preso ao seu arquivo e ninguém compara nada.

### (e) Manter as métricas ambiciosas no template, marcadas como "futuro" — **rejeitada**

Parece conciliador e é exatamente o que a 5.1 proíbe no cenário negativo. Campo marcado como futuro
dentro de um artefato de preenchimento é preenchido: o agente vê a chave, não lê o comentário. Futuro
vive no ADR e no backlog (D12 e o bloco G reservado em D4), não no arquivo que alguém vai preencher.

### (f) Manter `dependency_graph` no tracking até a Fase 6 chegar — **rejeitada**

Manter uma cópia reduzida do grafo "por enquanto" garantiria que, ao chegar o grafo unificado, existam
duas representações divergentes e nenhuma regra de precedência. Removido agora; o tracking **referencia**
`dependencies/full-graph.yml` pelo caminho e não copia nós nem arestas.

### (g) Tracking como projeção derivada + catálogo mínimo com fonte por métrica (D1-D11) — **escolhida**

Contra a rubrica 1.2:

| Eixo | Efeito |
|---|---|
| **4 — Mensurabilidade** (1 → 3 aqui, 4 na 5.2) | O nível 3 pede literalmente "ADR define o conjunto mínimo, a fonte de cada métrica e a separação automática vs manual, sem aplicar" — D3, D4, D6. O nível 4 (template só exige o derivável; nenhuma instrução aponta script inexistente) fica inteiramente contratado para a 5.2, e o nível 5 depende de F6 (bloco G) e da F7 (E1/E2). |
| **3 — Fidelidade / loop** | Dá **uso** ao que o ADR-003 criou: `iterations_to_green`, `overrun`, `not_verifiable_count` e `coverage` deixam de ser campos de relatório e passam a ser sensores de processo. D8 protege a evidência de virar meta. |
| **8 — Alucinação** | Remove três vetores catalogados aqui e ausentes do gap-map: escore sem fórmula (`quality_score`), agregado que não reconcilia com a própria lista (§1.2) e percentual autodeclarado (`progress_percentage`). |
| **2 — Arquitetura** | C4/C5 são o primeiro sensor de conformidade arquitetural do framework: mede quanto do código foi revisado sem `ad-NNN` em escopo e se o campo `verification` é executado. |
| **5 — Grafos** | Remove o `dependency_graph` concorrente e reserva o bloco G sem declará-lo, deixando a F6 como única fonte de grafo. |
| **6 — Memória** | E2 e A4 entregam à F7 a assinatura de falha recorrente e a distribuição de rotas — a matéria-prima de lição de maior valor. |
| **7 — Custo cognitivo** | O tracking **encolhe**: fim da duplicação do contrato (D7), fim do roster/eventos/alertas (D9/D10), fim dos blocos de automação (D11). Menos campo, mais informação recomputável. |
| Custo | Nenhuma skill nova; 1 template reescrito + 1 seção em `mdpe-learnings/SKILL.md` na 5.2. O agente passa a **precisar reconciliar** ao fechar micro-task, o que adiciona um passo de leitura de artefatos no fecho. |

---

## 5. O que **NÃO** é obrigatório

Nada abaixo é pré-requisito para o tracking ser válido, nem para fechar uma micro-task:

**De métrica:**

- Todo o bloco F (declaradas): `executor`, `effort_actual`, `complexity_actual`.
- `coverage_when_measured` (B4) — só existe quando o projeto mede; ausência é o normal.
- Bloco E (propagação) enquanto os artefatos de learnings não tiverem template (Lacuna 6.2).
- Bloco G (órfãos, caminho crítico, paralelismo, ciclos) — chega com a Fase 6.
- Razões e percentuais com menos de 5 micro-tasks fechadas: só contagens.
- `signals` (D10) — e nenhum sinal além dos três canônicos.
- Tempo de resolução de bloqueio, duração de blocker, tempo médio de qualquer coisa que não seja D1/D2.
- Story point, velocity, burndown, custo, tokens, linhas de código.
- Escore de qualidade, saúde, maturidade ou índice composto de qualquer natureza — **proibidos**, não
  apenas dispensáveis (D5.4).

**De processo de medição:**

- Cadência periódica (diária, semanal, por sprint). A atualização é por evento (D6).
- Humano preencher qualquer campo. O framework não bloqueia esperando tracking.
- Ferramenta, script, workflow de CI, integração ou dashboard (D12).
- Reunião, standup, registro de evento de time, roster com nível de autonomia.
- `sprint` como conceito — opcional (D9).

**Do artefato:**

- Bloco de micro-task para tarefas ainda não iniciadas: criação preguiçosa (A5) — a micro-task entra no
  tracking quando **fecha**, não quando é planejada. Quem quer o planejado lê `microtasks-index.yml`.
- Nota, observação ou comentário livre por micro-task.
- Cópia de qualquer campo que o contrato da micro-task já declara (D7).

**Regra geral:** a ausência de item desta lista nunca invalida o tracking. O que invalida é métrica sem
campo de origem, métrica de classe D sem artefato-fonte, default numérico apresentado como medição,
razão sem denominador, agregado que a lista do próprio arquivo não sustenta, status não reconciliado
contra artefato, escore composto, e qualquer instrução apontando ferramenta que não existe.

---

## 6. Consequências

**Positivas**

- Eixo 4 sai de 1 para 3 com este ADR e habilita o 4 na 5.2. Fecha as Lacunas 4.1 e 4.2 pelas duas
  pontas: remove a automação prometida e dá a cada métrica sobrevivente um campo de origem.
- O framework passa a ter métricas que **um humano consegue conferir à mão** abrindo dois arquivos. É o
  primeiro artefato de medição do MDPE que não depende de acreditar em quem preencheu.
- Dá função ao investimento do ADR-003: `iterations_to_green`, `overrun`, `not_verifiable_count` e o
  bloco `coverage` deixam de existir só para o registro e passam a informar decisão de processo.
- Cria o primeiro sensor de conformidade arquitetural (C4/C5), que **cobra** rodada de
  `mdpe-architecture` em vez de deixar o review revisar contra baseline inexistente.
- Remove três vetores de fabricação que o gap-map não havia catalogado: escore sem fórmula, agregado que
  contradiz a própria lista de itens, e percentual de progresso autodeclarado.
- Elimina uma fonte de deriva estrutural (D7): o tracking parava de concordar com o contrato da
  micro-task em duas semanas e nada dizia qual valia.
- Tira o grafo duplicado do caminho da Fase 6 antes de ela começar.
- O artefato **encolhe** — raro num ADR que adiciona contrato. Menos campo, e o que sobra é recomputável.

**Negativas / custos**

- **O fecho de micro-task fica mais caro.** `mdpe-learnings` passa a ler o `validation-report`, o
  `code-review` e o índice para reconciliar status. É leitura de arquivos que já existem, mas é trabalho
  que hoje ninguém faz.
- **Perde-se visibilidade que parecia existir.** Ninguém mais vê "velocity 12" nem "quality score 0.92".
  Isso vai incomodar quem lia esses números como informação. Eram números sem fonte — a perda é de
  conforto, não de dado, mas a percepção de regressão é real e precisa ser dita.
- **Métrica de esforço fica frágil.** `effort_actual` é classe C e opcional; sem ela não há acurácia de
  estimativa. Deliberado: não existe carimbo de esforço em artefato nenhum, e inventar um seria criar o
  próximo `quality_score`.
- **Bloco E nasce condicional**, o que deixa o eixo de propagação medido só parcialmente até a Fase 7
  entregar os templates de learnings. É a escolha honesta, e fica visível como pendência nomeada.
- **A regra dos 5 itens (D5.2) deixa projetos pequenos sem razões.** Um projeto com 3 micro-tasks
  fechadas verá só contagens. Aceito: percentual sobre 3 é pior que contagem sobre 3.
- **D8 é uma disciplina, não um mecanismo.** Nada impede alguém de transformar `first_pass` em meta de
  time; o ADR só registra por que isso destrói a métrica e a evidência junto.
- **`docs/tracking/` é mais um diretório de topo** na árvore que o MDPE cria no repositório consumidor,
  que já ganha `docs/architecture/`, `docs/brownfield/`, `docs/backlog/`, `docs/learning-loops/`,
  `docs/transformation/` e `docs/adr/`. A 9.1 pode consolidar ao padronizar caminhos.

**Neutras**

- Nenhum artefato é criado; um é reescrito (5.2). Nenhuma skill nova; uma ganha um passo de fecho.
- Micro-task continua fechando pelas regras do ADR-003 — as métricas não participam de gate (D8).
- Quem usa sprint continua podendo registrar sprint (D9), sem que nada dependa disso.
- O caminho `docs/tracking/mdpe-tracking.yml` substitui uma sugestão (*"project root or .mdpe/"*) que
  nunca foi decisão, então não há caminho legado a migrar.

---

## 7. Verificação contra os cenários de teste da tarefa 5.1

| Cenário | Onde é atendido |
|---|---|
| + Cada métrica do conjunto mínimo aponta de qual artefato/campo é derivada | D4 — catálogo com colunas *Fórmula* e *Campo de origem* em todos os blocos A-F; D5.6 e o critério de conclusão (Seção 3) tornam isso condição de validade |
| + Métricas não sustentáveis hoje são marcadas como opcionais ou removidas | D11 (tabela de remoções, uma linha por item, com motivo) · D3 (classe C = opcional) · D4 bloco E (condicional, com a lacuna nomeada) · bloco G (reservado, não declarado) · B4 e todo o bloco F opcionais |
| + Define frequência de atualização e responsável (agente vs humano) | D6 — tabela escrita/quando/responsável, atualização orientada a evento no fecho da micro-task, humano só como leitor, mais a regra de reconciliação |
| − Manter métrica que depende de tooling inexistente como "obrigatória" reprova | D5.6 e D11 removem `config.auto_calculations`, `config.integrations`, `auto_update` e as instruções §3/§4/§5 que citam `tools/mdpe-status.py` e `.github/workflows/mdpe-tracking-update.yml`; D12 registra o tooling como trabalho futuro **sem** referência em template; D1 impede que qualquer script volte como fonte |
| − Métrica sem fórmula/definição reprova | D4 (fórmula obrigatória por linha) · D5.1-D5.4 (sem default, sem razão sem denominador, sem agregado sem itens, sem escore composto) · D11 remove `quality_score` e `avg_quality_score`, que são exatamente esse defeito |
| + Separar métricas automáticas de manuais | D3 — três classes (**D** derivada, **C** declarada, **M** externa/fora de escopo), com a regra de não misturar classes na mesma fórmula |

---

## 8. Fontes

**Internas (lidas para este ADR):** `skills/mdpe-learnings/assets/templates/mdpe-tracking.yml`
(`microtasks[]` MT-001 a MT-006 com `quality_score`, `progress_percentage`, `code_lines_generated`,
`auto_checks_passed`, `validation_attempts`, `rework_count`, `blocker_duration`; bloco `metrics` com
`total_tasks: 15` contra 6 itens listados, `throughput.velocity_story_points`, `avg_cycle_time`,
`avg_lead_time`, `quality.rejection_rate: 0.17 # 1/6`, `blockers.*`; `events`; `alerts`;
`dependency_graph: nodes/edges`; `config.integrations` e `config.auto_calculations`;
*USAGE INSTRUCTIONS* §3-§5 e §7) · `skills/mdpe-learnings/SKILL.md` (*Validated metrics — expected vs
achieved*; três alvos de feedback; outputs `docs/execution/{microtask-id}-learnings.yml` e
`docs/learning-loops/aggregated-learnings.yml`) ·
`skills/mdpe-coding/assets/templates/validation-report-template.yml` (bloco `loop` com
`iterations_to_green`/`limit`/`overrun`/`iterations[]`; `acceptance_criteria.coverage`; `fidelity`;
`summary.overall_status` e `not_verifiable_count`; `verification_plan.frozen_at`;
`metadata.validated_at`) · `skills/mdpe-coding/assets/templates/code-review-template.yml`
(`verdict.open.*`; `findings[].severity`/`.violates`/`.resolved`;
`scope.architecture_decisions_in_scope` e `no_decisions_note`;
`dimensions.architecture.decisions_checked[].result`; `metadata.reviewed_at`) ·
`skills/mdpe-transformation/assets/templates/mdpe-microtask-template.yml` (`estimate.total_time`,
`estimate.complexity`, `metadata.status`, formato de id `mt-{feature-number}-{sequence}`) ·
`skills/mdpe-transformation/assets/templates/microtasks-index-template.yml`
(`summary.overall_status`, `execution_order.wave_N`, `dependency_graph.critical_path`) ·
`skills/mdpe-architecture/assets/templates/architecture-decisions-template.yml` (`ad-NNN`,
`verification`, criação preguiçosa) · `docs/adr/adr-003-loop-engineering.md` (D3 contrato de evidência
e fim dos defaults numéricos; D4 vocabulário de status; D5/D6 loop e rotas; D13 métricas reservadas
para a Fase 5) · `docs/adr/adr-002-architecture-skill.md` (D5 `verification`, D9 integração com o
review) · `docs/analysis/baseline-gap-map.md` (Lacunas 4.1, 4.2, 5.1, 6.2, 9.1; Seções B e C) ·
`docs/analysis/evaluation-rubric.md` (Eixo 4 e âncoras dos Eixos 2, 3, 5, 6, 7, 8) ·
`docs/analysis/competitive-analysis.md` (4.4 métricas persistidas em artefato; §7 adoções A5, A9, A11,
A12 e as recusas registradas).

**Externas:** OSpec — [clawplays/ospec](https://github.com/clawplays/ospec)
(`execution-metrics.json` como artefato versionado; métricas que distinguem cobertura completa,
parcial e ausente em vez de um número único) · TLC Spec-Driven —
[SKILL.md v3.3.0](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md)
(evidência conferível como base do veredito, em vez de escore autoatribuído).

> Conteúdo parafraseado a partir das fontes para conformidade de licenciamento; URLs reaproveitadas de
> `competitive-analysis.md`, verificadas em 27/08/2026.
