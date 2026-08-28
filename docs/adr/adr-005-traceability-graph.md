# ADR-005 — Modelo de grafo de rastreabilidade do MDPE

| Campo | Valor |
|---|---|
| **Status** | Aceito |
| **Data** | 28/08/2026 |
| **Tarefa de origem** | `tasks-v1.md` → Fase 6 → 6.1 |
| **Eixo da rubrica** | Eixo 5 — Visualização e rastreabilidade (baseline **2**, meta **4**; nível 5 com a 6.3) |
| **Implementado por** | Tarefa 6.2 (skill + template de grafo de rastreabilidade) · 6.3 (consultas e impacto) · 6.4 (view ondas × features) · costurado na 9.2 · repontuado na 9.3 |
| **Adoções associadas** | A10 (localizador feature ↔ arquivo) · A11 (grafo que despacha, não só desenha) · A13 (consistência cross-artefato, órfãos e caminho quebrado) · A5 (criação preguiçosa) |
| **Depende de** | ADR-001 (`cf-NNN` e `files` verificados: o nó de arquivo em brownfield) · ADR-002 (`ad-NNN`, `drivers[].source/evidence`, `implications[].type/consumed_by`, `supersedes`) · ADR-003 (evidência por dimensão, `fidelity.declared_outputs[].exists`, vocabulário de status, rotas) · ADR-004 (D1 projeção derivada; D11 removeu o `dependency_graph` concorrente; bloco G reservado) |

---

## 1. Contexto

O MDPE **calcula** grafo e **não tem** grafo. Os dados existem, são corretos, e morrem no diretório
onde nasceram.

### 1.1 Dados de grafo gerados por feature e nunca unificados nem desenhados

`skills/mdpe-transformation/SKILL.md` Fase 2 produz sete arquivos em
`docs/transformation/{feature-id}/dependencies/`: `full-graph.yml` (upstream/downstream, `level`,
`wave`, pontos de convergência e divergência, `graph_validation.cycles_detected`),
`hard-dependencies.yml`, `soft-dependencies.yml`, `external-dependencies.yml`, `waves.yml`,
`critical-path.yml` e `parallelizable.yml`. É cálculo real, com justificativa por aresta
(`reason`) e com detecção de ciclo.

Nenhum passo do framework os lê depois. É a **Lacuna 5.1**. O `microtasks-index-template.yml` chega a
admitir isso por escrito, no bloco `dependency_graph`: *"Use a visualization tool for the full graph"* —
uma instrução que aponta para nenhum lugar, ao lado de um desenho ASCII de exemplo
(`mt-XXX-001 → mt-XXX-002`) que ninguém gera.

Os únicos Mermaid do repositório (`docs/mdpe-flow.md`, `skills/mdpe-router/SKILL.md`) são diagramas de
**roteamento entre skills**, escritos à mão. Não derivam de YAML nenhum e não mudam quando o projeto
muda. Nível 1 da rubrica, dentro de um framework que tem dado para o nível 4.

O ADR-004 (D11) já retirou do caminho o concorrente: o `dependency_graph: nodes/edges` do
`mdpe-tracking.yml`, que duplicava `full-graph.yml` de forma reduzida e sem regra de precedência. Hoje
existe **uma** fonte de dependência por feature, e nenhuma visão.

### 1.2 O rastreio para nos dois extremos: só micro-task ↔ micro-task

`dependencies-template.yml` liga exclusivamente `mt-XXX-YYY` a `mt-XXX-ZZZ`. É a **Lacuna 5.2**. Nada
no framework percorre a cadeia que a pergunta 5 pede: discovery → feature → micro-task → decisão de
arquitetura → artefato/arquivo → aprendizado.

O efeito prático não é estético. Sem a cadeia transversal não se responde a nenhuma das perguntas que
justificam ter grafo:

- *este arquivo existe por causa de qual decisão?*
- *se `ad-004` for revista, quais micro-tasks e quais arquivos entram em escopo?*
- *esta feature foi de fato implementada, ou só decomposta?*
- *este aprendizado veio de onde, e para onde ele deve voltar?*

### 1.3 A cadeia já existe campo por campo — e ninguém a percorre

Este é o achado que sustenta o ADR: **as arestas transversais não precisam ser inventadas.** Quatro
ADRs de fase depositaram, cada um por seu motivo, exatamente os campos que ligam os elos. Inventário
do que já está declarado em template:

| Elo da cadeia | Campo que já o declara | Onde |
|---|---|---|
| sessão de discovery → backlog | `metadata.discovery_session_id`; `traceability.related_discovery_sessions[].id`; `personas_identified[].id` | `cognitive-backlog-template.yml`; `discovery-session-template.yml` |
| feature → origem | `traceability.feature_origin[].source` | `cognitive-backlog-template.yml` |
| feature reconstruída → arquivos reais | §4 `id` (`cf-NNN`) + `files` (caminho verificado, campo **bloqueante**) | `brownfield-inventory-template.md` |
| `cf-NNN` → `feat-NNN` | promoção registra `origin: cf-NNN` | ADR-001 / inventário §4 |
| decisão → driver | `drivers[].source` + `drivers[].evidence` (artefato **e** campo reais) | `architecture-decisions-template.yml` |
| decisão → escopo | `scope` + `scope_ref` (`system` \| `feature` \| `module`) | idem |
| decisão → trabalho derivado | `implications[].type: derived_work` + `consumed_by` | idem |
| decisão → decisão | `supersedes` / `superseded_by` | idem |
| micro-task → feature | `traceability.feature_id` | `mdpe-microtask-template.yml` |
| micro-task → artefato prometido | `output.generated_artifacts[].location` | idem |
| micro-task → decisões em escopo | `technical_context.architecture.applies[].id` | `execution-context-template.yml` |
| micro-task → onda | `execution_order.wave_N`; `waves.{wave}.microtasks[]` | `microtasks-index-template.yml`; `waves.yml` |
| artefato prometido → artefato real | `fidelity.declared_outputs[].declared` + `.exists` | `validation-report-template.yml` |
| evidência → micro-task | existência do relatório + `summary.overall_status`, `loop.*` | idem |
| review → arquivos lidos | `scope.files[].path` | `code-review-template.yml` |
| review → decisão verificada | `scope.architecture_decisions_in_scope`; `dimensions.architecture.decisions_checked[].result`; `findings[].violates` | idem |
| risco → features/micro-tasks | `affected_features[].id`; `feature_risks[].affected_microtasks` | `validation-risks-template.yml`; `microtasks-index-template.yml` |
| dependência externa → micro-task | `dependencies[].microtask` + `resource` + `status` | `dependencies-template.yml` |
| aprendizado → micro-task | caminho `{microtask-id}-learnings.yml` (por construção) | `mdpe-learnings/SKILL.md` |

Vinte elos declarados, zero percorridos. O trabalho da Fase 6 não é criar rastreabilidade: é **ler o
que já está escrito** e recusar tudo o que não estiver.

### 1.4 Onde a cadeia se rompe de fato (e o grafo é quem vai mostrar)

Quatro rupturas reais, que o modelo tem de tratar em vez de disfarçar:

1. **Features de discovery não têm id.** `discovery-session-template.yml` registra
   `personas_identified[].id` (`persona-001`), e `validation-risks-template.yml` registra
   `hyp-value-001` / `risk-tech-001` — mas o brainstorm de features produz contagens
   (`features_identified: 15`, `features_must_have: 5`), **não ids**. Feature só ganha id ao entrar no
   backlog (`feat-XXX`). Logo a aresta discovery→feature existe na granularidade da **sessão**, não da
   ideia. Inventar `df-001` para fechar o desenho seria fabricar nó.
2. **Micro-task não declara `ad-NNN` antes de começar.** `mdpe-transformation/SKILL.md` manda rastrear
   trabalho nascido de `derived_work` de volta à decisão (*"Trace it back to the `ad-NNN` in the task's
   origin"*), mas `mdpe-microtask-template.yml` → `traceability` só tem `feature_id`, `feature_name`,
   `strategic_context` e `architectural_components`. **Não há campo para o id.** A aresta mt→ad só
   aparece quando o contexto de execução é gerado (`architecture.applies[].id`) — isto é, tarde.
3. **Caminho do artefato de execução divergente (Lacuna 9.1).** `mdpe-execution-context/SKILL.md`
   grava `docs/execution/{microtask-id}-context.yml`; `mdpe-learnings/SKILL.md` e o
   `validation-report-template.yml` leem `docs/transformation/{feature-id}/execution/`. Um grafo que
   resolve caminho ingenuamente reporta órfão onde há só desencontro de convenção.
4. **`{id}-learnings.yml` e `aggregated-learnings.yml` não têm template** (Lacuna 6.2, também nomeada no
   ADR-004 bloco E). O nó de aprendizado existe como caminho prometido, não como estrutura conhecida.

### 1.5 O que o benchmark diz sobre grafo

`docs/analysis/competitive-analysis.md` registra três adoções P1 e uma constatação incômoda:

- **A10 / OSpec 4.7** — *localizador feature ↔ código*: seções declaram slug e caminhos de código, um
  catálogo mantém uma linha por feature, e um comando devolve a seção. É o nó "artefato/arquivo" com
  âncora real, e o MDPE já tem a matéria-prima em `files` (inventário) e `generated_artifacts.location`.
- **A11 / OSpec 4.5 · TLC 5.10** — *grafo que despacha*: o laço lê o grafo de tarefas e emite um lote
  paralelo seguro, **explicando o que reduziu o paralelismo**. A observação do benchmark sobre o MDPE é
  direta: *"OSpec e TLC têm o despacho, o MDPE tem o cálculo — falta ligar os dois"*.
- **A13 / Spec-Kit 1.4 · OSpec 4.9** — *consistência cross-artefato e auditoria de deriva*: listar as
  seções cujos caminhos de código mudaram desde a última mudança registrada.
- **TLC 5.13** — composição com skill vizinha para diagrama (`mermaid-studio`), com **fallback
  embutido**. Modelo para "sem tooling obrigatório".

---

## 2. Decisão

### D1 — O grafo é **projeção derivada**, e toda aresta carrega procedência

Mesma inversão que o ADR-004 (D1) fez com as métricas, aplicada a nós e arestas:

| | Antes | A partir daqui |
|---|---|---|
| Onde a verdade vive | nos `dependencies/*.yml` por feature, sem visão | continua nos artefatos; o grafo é **visão** |
| O que o grafo é | inexistente | artefato **regenerável**, nunca editado à mão |
| Em caso de divergência | — | **o artefato vence**; o grafo é regenerado |

Regra dura, e é a única que interessa: **nó ou aresta sem artefato + campo de origem não entra no
grafo.** Não existe aresta "por inferência razoável", nem nó de conveniência para fechar o desenho. A
única exceção é a aresta computada `impacts` (D5), que cita a cadeia de arestas declaradas que a
produziu — e é rotulada como computada.

Corolário: se o grafo for apagado, tem de poder ser reconstruído lendo os artefatos. Nada nasce ali.

### D2 — Skill dedicada `mdpe-graph`, não um oitavo passo em `mdpe-transformation`

A tarefa 6.2 deixa a escolha aberta e a 6.4 pede a skill. Decisão: **skill dedicada**, e as duas
tarefas convergem para ela.

Motivos, em ordem de peso:

1. **Escopo.** `mdpe-transformation` é por-feature; a rastreabilidade que a pergunta 5 pede é
   **cross-feature** (uma feature não conhece as decisões que outra levantou, nem os aprendizados de
   outra). Passo dentro de transformation nasceria míope.
2. **Cadência.** Transformation roda uma vez por feature; o grafo é regenerado a cada fecho de
   micro-task, a cada decisão nova e a cada pergunta de impacto. Frequências diferentes, artefatos
   diferentes.
3. **Custo cognitivo.** `mdpe-transformation` já executa quatro fases mais o passo de geração do
   `tasks.md`. Um quinto assunto pioraria o Eixo 7 — que a Fase 8 vem consertar.
4. **Insumos.** O grafo lê discovery, inventário, backlog, decisões, transformation, execução,
   learnings e tracking. Nenhuma dessas leituras pertence à decomposição de uma feature.

O que **não** muda: `mdpe-transformation` continua sendo quem calcula `dependencies/*.yml`, ondas e
caminho crítico. `mdpe-graph` **não recalcula dependência** — se recalculasse, viraria segunda fonte, o
erro que o ADR-004 D11 acabou de remover.

**Consequência de caminho:** os dois templates ficam sob `skills/mdpe-graph/assets/templates/` —
`traceability-graph-template.md` (6.2) e `waves-features-mermaid-template.md` (6.4). Isso desvia do
destino primário grafado na 6.2 (`skills/mdpe-transformation/assets/templates/`) e usa a alternativa que
a própria tarefa admite ("ou `skills/mdpe-graph/SKILL.md` + assets"). `mdpe-transformation/SKILL.md`
ganha apenas um **ponteiro** de "próxima skill", não um passo de geração.

### D3 — Duas views, um formato canônico, criação preguiçosa

| View | Arquivo | Pergunta que responde | Fase |
|---|---|---|---|
| **Rastreabilidade** (cadeia transversal) | `docs/graph/traceability-graph.md` | de onde isto veio, e até onde chegou | 6.2 |
| **Ondas × features** (execução) | `docs/graph/{feature-id}-waves.md` | o que roda agora, em que ordem, com quem em paralelo | 6.4 |
| **Consultas** (impacto, órfãos, ciclos) | seções da view de rastreabilidade, ou `docs/graph/impact-{node-id}.md` para uma consulta registrada | o que muda se X mudar | 6.3 |

Formato canônico de cada view: **bloco Mermaid + tabela de arestas com procedência**. O diagrama é a
leitura humana; a tabela é a prova. Uma aresta que está no desenho e não está na tabela é aresta
inventada — e a tabela é o que o critério de conclusão (Seção 3) confere.

Colunas obrigatórias da tabela: `de` · `para` · `tipo` · `artefato de origem` · `campo`. Nada mais é
obrigatório.

**Criação preguiçosa (A5):** o arquivo nasce quando há grafo para desenhar. Zero micro-task
transformada → **nenhum arquivo**, e a resposta correta é "não há grafo a gerar; rode
`mdpe-transformation` antes" (cenário positivo explícito da 6.4). Arquivo de grafo vazio sinaliza que
uma fase aconteceu quando não aconteceu.

**Local:** `docs/graph/` no repositório consumidor, no mesmo padrão um-diretório-por-assunto de
`docs/architecture/`, `docs/brownfield/`, `docs/backlog/`, `docs/tracking/`, `docs/learning-loops/` e
`docs/transformation/`. É mais um diretório de topo — custo registrado na Seção 6, consolidação
eventual na 9.1.

### D4 — Catálogo de nós

Onze tipos. Cada linha traz **fonte (artefato → campo)** e obrigatoriedade. Sem as duas colunas, o nó
não existe (D1).

| Tipo | Id | Fonte: artefato → campo | Obrigatoriedade |
|---|---|---|---|
| `session` | `discovery-session-YYYYMMDD-NNN` | `docs/discovery/00-discovery-session-complete.yml` → `metadata.id` | condicional (greenfield com discovery) |
| `persona` | `persona-NNN` | `docs/discovery/00-discovery-session-complete.yml` → `personas_identified[].id` (detalhe em `02-persona-identification.yml`) | opcional |
| `hypothesis` | `hyp-{tipo}-NNN` | `docs/discovery/05-validation-risks.yml` → `hypotheses[].id` | opcional |
| `risk` | `risk-{cat}-NNN` · `risk-feat-XXX-NNN` | `05-validation-risks.yml` → `risks[].id`; `microtasks-index.yml` → `feature_risks[].id` | opcional |
| `code_feature` | `cf-NNN` | `docs/brownfield/inventory.md` §4 → `id` | condicional (brownfield) |
| `feature` | `feat-XXX` | `docs/backlog/backlog-index.yml`, `features/feat-XXX.yml` → `id` | **essencial** quando há backlog |
| `decision` | `ad-NNN` | `docs/architecture/decisions.yml` → `decisions[].id` | **essencial** quando o arquivo existe |
| `microtask` | `mt-XXX-YYY` | `microtasks-index.yml` → `microtasks[].id`; `microtasks/mt-XXX-YYY.yml` | **essencial** |
| `artifact` | o **caminho** repo-relativo (D6) | contrato: `output.generated_artifacts[].location` · realidade: `{id}-validation.yml` → `fidelity.declared_outputs[].declared/.exists` · review: `{id}-code-review.yml` → `scope.files[].path` · brownfield: inventário §4 `files` | **essencial** para o rastreio até arquivo |
| `evidence` | `{mt-id}:validation` · `{mt-id}:review` | existência de `{id}-validation.yml` / `{id}-code-review.yml` + `summary.overall_status` / `verdict` | condicional (só após execução) |
| `learning` | `{mt-id}:learnings` | `{id}-learnings.yml`; `docs/learning-loops/aggregated-learnings.yml` | condicional — **sem template hoje** (Lacuna 6.2) |
| `external` | `ext:{resource-slug}` | `dependencies/external-dependencies.yml` → `dependencies[].resource`, `.type`, `.status` | condicional |

**`wave` não é nó, é agrupador.** `waves.yml` → `waves.{key}` e `microtasks-index.yml` →
`execution_order.wave_N` viram `subgraph` no Mermaid e atributo `wave` no nó de micro-task. Onda como nó
criaria arestas artificiais mt→wave→mt que nenhum artefato declara.

**Atributos de nó** (só o que já está declarado, nada calculado à parte): micro-task carrega `category`,
`architectural_layer`, `estimate.total_time`, `wave`, `level` (de `full-graph.yml`) e `status`
reconciliado (ADR-004 D6); decisão carrega `type` e `status`; feature carrega MoSCoW; artefato carrega
`exists`; `cf-NNN` carrega `confidence`.

**Duas ausências deliberadas.** Não há nó de critério de aceite (`quality_criteria[]` e
`acceptance_criteria` são listas **sem id** — ver alternativa (f)) e não há nó de "ideia de feature"
pré-backlog (§1.4 item 1). Cobertura de critério é medida pelo `validation-report`
(`acceptance_criteria.coverage`) e pelas métricas do ADR-004 (B1-B3), onde já é conferível.

### D5 — Catálogo de arestas

Nove tipos: os seis pedidos pela tarefa 6.1 mais três adições nomeadas e justificadas. Uma única
computada.

| Tipo | Semântica | De → Para | Fonte: campo |
|---|---|---|---|
| `derives-from` | proveniência: existe por causa de | `feat` → `session` · `feat` → `cf` · `mt` → `feat` · `ad` → driver (`feat` \| `cf` \| `risk` \| inventário) · `learning` → `mt` | `metadata.discovery_session_id`; `traceability.feature_origin[].source`; `origin: cf-NNN`; `traceability.feature_id`; `drivers[].source` + `.evidence`; nome do arquivo de learnings |
| `depends-on` | ordem de execução · atributo **`strength: hard \| soft \| external`** | `mt` → `mt` · `mt` → `external` | `hard-dependencies.yml` / `soft-dependencies.yml` (`source`, `target`, `reason`); `external-dependencies.yml` (`microtask`, `resource`); conferido contra `full-graph.yml` (`upstream_*`/`downstream_*`) |
| `implements` | cumpre / é governada por uma decisão | `mt` → `ad` | `{id}-context.yml` → `technical_context.architecture.applies[].id`; `{id}-code-review.yml` → `scope.architecture_decisions_in_scope`; `traceability.origin_decisions` (D13) |
| `produces` | **adição** — sem ela o nó de artefato não tem entrada | `mt` → `artifact` | `output.generated_artifacts[].location`; `fidelity.declared_outputs[].declared` |
| `validates` | verifica, com resultado · atributo `result` | `evidence` → `mt` · `evidence` → `artifact` · `evidence` → `ad` | `summary.overall_status`; `fidelity.declared_outputs[].exists`; `dimensions.architecture.decisions_checked[].result`; `findings[].violates` (`result: violated`) |
| `learned-from` | lição extraída de | `learning` → `evidence` · `learning` → `ad` (quando a lição colide com decisão) | `{id}-learnings.yml`; `aggregated-learnings.yml` |
| `supersedes` | **adição** — revisão de decisão (ADR-002 D9) | `ad` → `ad` | `supersedes` / `superseded_by` |
| `affects` | **adição** — risco/hipótese sobre escopo | `risk` → `feat` \| `mt` · `hypothesis` → `feat` | `affected_features[].id`; `feature_risks[].affected_microtasks`; `related_features[].id` |
| `impacts` | **a única COMPUTADA**: alcance de uma mudança | qualquer → qualquer | não tem campo próprio: é o fechamento transitivo de `depends-on(hard)` ∪ `implements`⁻¹ ∪ `produces` ∪ `derives-from`⁻¹, e **cita a cadeia** que a produziu |

Três regras de aresta:

1. **`impacts` nunca é declarada, e nunca aparece sem a cadeia.** Uma resposta de impacto sem os nós e
   arestas declaradas que a sustentam é reprovada (cenário negativo da 6.3).
2. **`depends-on` com `strength: soft` e `external` entra no grafo.** Ignorá-las é o outro cenário
   negativo da 6.3: dependência soft não bloqueia, mas muda ordem; externa com
   `status: in_development` é risco de despacho.
3. **Aresta duplicada em duas fontes não vira duas arestas.** Precedência: o artefato mais próximo da
   execução vence (review > validation > context > contrato). A fonte descartada é registrada quando
   **discorda** — divergência é sinal de deriva (D9), não detalhe de merge.

### D6 — Identidade: ids são dos artefatos; caminho é o id do arquivo

- O grafo **não cria id**. Usa `feat-XXX`, `mt-XXX-YYY`, `ad-NNN`, `cf-NNN`, `persona-NNN`,
  `hyp-*`, `risk-*`, e o id da sessão. Id sintético seria nó sem fonte (D1).
- **Nó de artefato tem o caminho repo-relativo normalizado como id** (A10 / OSpec 4.7): o caminho é a
  chave natural e é o que se confere. Sem `ar-001`, sem slug paralelo.
- **Nunca renumerar.** `ad-NNN` já é declarado estável e referenciado pelo grafo
  (`architecture-decisions-template.yml`, instrução 2). O mesmo vale para `mt` e `feat`.
- **Resolução de caminho de artefato de execução** (§1.4 item 3): procurar nas **duas** localizações
  declaradas — `docs/transformation/{feature-id}/execution/` e `docs/execution/` — registrar **onde
  foi encontrado**, e emitir uma pendência de reconciliação de caminho quando não for a canônica. O
  grafo **não repointa nada em silêncio** e não conta desencontro de convenção como órfão. Essa
  pendência é a evidência operacional da Lacuna 9.1 para a tarefa 9.1.
- **Caminho declarado e inexistente não é omitido**: entra como nó `artifact` com `exists: false`,
  marcado como deriva (D9). Omitir seria esconder a falha de fidelidade que o ADR-003 (D7.2) faz
  questão de reprovar.

### D7 — Os cinco casos de uso, com definição operacional

Cada um com entrada, saída e o que reprova. São o contrato que a 6.2 e a 6.3 implementam.

**(1) Visualizar.** Entrada: `microtasks-index.yml`, `waves.yml`, `critical-path.yml`,
`dependencies/*.yml`, `backlog-index.yml`, `decisions.yml`. Saída: Mermaid + tabela de arestas. Reprova:
nó/aresta sem procedência; Mermaid que não renderiza.

**(2) Caminho crítico.** **Lido**, não recalculado: `critical-path.yml` → `sequence[]` e
`total_time`. O grafo marca os nós da sequência e desenha as arestas entre eles com traço distinto
(D8). Reprova: caminho crítico "deduzido" pelo grafo divergindo do artefato sem apontar a divergência.

**(3) Análise de impacto (downstream).** Dada uma mudança em um nó, listar o alcance por `impacts`
(D5), separando: **hard** (bloqueia), **soft** (muda ordem), **implements** (decisão em jogo → rota
`needs_architecture`, ADR-003 D6), **produces** (arquivos que entram em escopo), **validates**
(evidência que precisa ser refeita). Saída: lista de nós afetados **com a cadeia de arestas** de cada
um. Reprova: resposta sem cadeia; análise que ignora soft/external.

**(4) Órfãos.** Definição **por tipo**, porque "órfão" genérico não é acionável:

| Órfão | Condição | Rota |
|---|---|---|
| feature não decomposta | `feat` Must-Have sem `mt` que a referencie | `mdpe-transformation` |
| micro-task sem decisão em escopo | `mt` sem `implements`, com contexto/review já gerados | `mdpe-architecture` (é o C4 do ADR-004) |
| decisão sem trabalho | `ad` `accepted` sem nenhum `mt` que a implemente | revisar escopo ou decompor |
| artefato prometido inexistente | `artifact` com `exists: false` | falha de fidelidade (ADR-003 D7.2) |
| micro-task sem evidência | `mt` `completed` sem nó `evidence` | reconciliação (ADR-004 D6) |
| `cf-NNN` não promovido | feature reconstruída sem `feat` nem `mt` | decisão consciente, não defeito |
| aprendizado sem alvo | `learning` sem ação roteada | `mdpe-learnings` |

**(5) Ciclos.** `depends-on(hard)` e `derives-from` **devem** ser acíclicos. Onde há ciclo, o grafo
reporta o caminho fechado nó a nó e roteia para `mdpe-transformation` (re-decomposição). `soft` em
ciclo é reportado como aviso — não bloqueia, mas indica ordem indefinida. `impacts`, sendo fechamento
transitivo, não é avaliada para ciclo.

### D8 — Legibilidade e auto-sizing das views (o que Mermaid permite de fato)

Decisões técnicas, porque "gera Mermaid" sem elas produz diagrama que não renderiza ou que ninguém lê:

- **Onda é `subgraph`; feature é estilo.** Um nó Mermaid pertence a **um** subgraph. Como onda e
  feature são agrupamentos cruzados, a onda fica sendo o `subgraph` (é o eixo de execução, e é o que a
  6.4 pede) e a feature é expressa por `classDef` + prefixo do id no rótulo. Tentar aninhar os dois
  produz diagrama inválido.
- **Traço com semântica fixa:** `-->` hard · `-.->` soft e external · `==>` aresta do caminho crítico ·
  `classDef critical` nos nós da sequência crítica. Evitar `linkStyle` por índice: quebra a cada aresta
  inserida.
- **Rótulo entre aspas, sem HTML**, e id sempre o id do artefato. Parênteses, dois-pontos e barra em
  rótulo não escapado é a causa mais comum de Mermaid que não renderiza — e o `artifact` tem caminho no
  rótulo.
- **Auto-sizing por tamanho, não por meta fixa** (TLC 5.1): até ~40 nós, view única com artefatos; até
  ~80, artefatos e evidências **colapsados** em atributo do nó de micro-task; acima disso, uma view por
  feature mais um rollup em nível de feature. Sem alvo mínimo de nós: 4 micro-tasks → 4 nós.
- **A tabela de arestas nunca é colapsada.** Quando o diagrama simplifica, a prova continua completa.

### D9 — Regeneração, carimbo e auditoria de deriva

- **Regenerado, nunca editado.** Editar o grafo à mão o transforma em fonte — o oposto de D1. O
  cabeçalho traz `generated_at` e o commit/branch lido, como o inventário brownfield faz com
  `verified_at`.
- **Gatilhos de regeneração:** fim de `mdpe-transformation` (nova feature ou nova onda), decisão nova ou
  revista em `decisions.yml`, fecho de micro-task (`mdpe-learnings`), e sob demanda para uma consulta de
  impacto.
- **Auditoria de deriva (A13 / OSpec 4.9):** ao regenerar, comparar contra a geração anterior e listar
  (i) `artifact` que passou a ter `exists: false`, (ii) aresta que desapareceu da fonte, (iii) `ad`
  `superseded` com `mt` ainda apontando para ele, (iv) caminho declarado em outro lugar diferente de
  onde foi encontrado (D6). Deriva é **relatada**, nunca corrigida por dedução.

### D10 — O grafo despacha, não só desenha (A11)

O cálculo de onda existe desde sempre e nunca foi usado para decidir nada. Passa a responder
**"o que roda agora"**: as micro-tasks da menor onda cujas `depends-on(hard)` estão fechadas (status
reconciliado do tracking, ADR-004 D6), com as `external` em `available`.

E, quando o paralelismo disponível é menor que o de `parallelizable.yml`, **dizer por quê** — em uma
linha, citando o nó: dependência hard aberta, externa indisponível, ou micro-task `blocked` com rota. É
a metade que falta ao MDPE segundo o benchmark (OSpec 4.5): *"OSpec e TLC têm o despacho, o MDPE tem o
cálculo"*.

Duas recusas explícitas: o grafo **não** dispara subagente sozinho (TLC 5.10 — oferecer e confirmar), e
**não** reordena onda. Ordem é de `mdpe-transformation`.

### D11 — Nenhum tooling obrigatório

Aprendizado direto da Lacuna 4.1 e da postura do ADR-004 (D5.6, D12):

- **Mermaid inline é o mínimo viável** e é suficiente: renderiza no Markdown do repositório sem
  instalar nada.
- **Graphviz DOT é opcional**, para quem quer layout de grafo grande; a ausência não invalida nada.
- Nenhum script, workflow, CLI ou ferramenta de layout é referenciado em template. Se um dia existir
  ferramenta de grafo, seu papel é **verificador** (recomputa e retorna diferente de zero na
  divergência), nunca fonte — mesmo contrato do ADR-004 D12.
- Se houver skill vizinha de diagrama disponível, delegar é legítimo, com **fallback embutido** para
  Mermaid inline (TLC 5.13). A composição nunca é pré-requisito.

### D12 — O grafo não é gate (mas não afrouxa o gate que já existe)

- **Nada no grafo aprova, reprova ou libera.** Órfão, ciclo cruzado e deriva são **sinal com rota**
  (D7, D9), como os `signals` do ADR-004 D10. Os gates continuam onde estão: ADR-003 (evidência por
  dimensão, limite de laço), ADR-002 (`drivers` bloqueante), `mdpe-transformation` (7 critérios).
- **Uma exceção que não é nova:** a aciclicidade de `depends-on` **já é** quality gate de
  `mdpe-transformation` (Fase 2, `graph_validation`). Isso permanece. O que o grafo unificado
  acrescenta é ciclo **cross-feature**, que ninguém verificava — e esse é relatado e roteado, não
  transformado em gate novo.
- Motivo, o mesmo do ADR-004 D8: contagem de órfãos escrita pelo agente que gera o grafo, se virar
  meta, passa a ser suprimida. Sensor com meta acoplada mede a meta.

### D13 — A única adição de campo, e a precedência da aresta `mt → ad`

Precedência para `implements` (§1.4 item 2):

1. `{id}-code-review.yml` → `scope.architecture_decisions_in_scope` (mais próximo da execução);
2. `{id}-context.yml` → `technical_context.architecture.applies[].id`;
3. `decisions.yml` → `scope`/`scope_ref` cobrindo a feature — aresta em granularidade de **feature**
   (`ad → feat`), nunca promovida a micro-task por dedução;
4. `traceability.origin_decisions: [ad-NNN]` no contrato da micro-task — **campo novo, CONDICIONAL**.

O item 4 é a única adição de campo que este ADR autoriza, e ela é obrigatória **somente** para
micro-tasks nascidas de uma implicação `derived_work` (ADR-002 / `mdpe-transformation` Fase 1). Três
razões: a instrução de rastrear já existe em `mdpe-transformation/SKILL.md` e não tem onde ser escrita;
sem ela, trabalho criado por decisão fica sem aresta até o contexto ser gerado — isto é, o nó da
decisão parece órfão exatamente onde ela mais produziu; e é **condicional**, então não adiciona
obrigação a nenhuma micro-task comum (compatível com a Fase 8, que reclassifica campos na 8.1).

`architectural_components` do contrato **não** vira aresta: é lista de nomes lógicos
(`Domain/Aggregates/AggregateName`), não caminho verificado. Nó de artefato exige caminho real (D4).

### D14 — Bloco G devolvido à Fase 5

O ADR-004 (D4) reservou e **não declarou** quatro métricas dependentes do grafo. Este ADR entrega a
fonte de cada uma, classe **D** (derivada):

| Métrica | Fórmula | Fonte |
|---|---|---|
| `orphans_count` | contagem por tipo de órfão | D7 caso (4) |
| `critical_path_length` | `total_time` e nº de nós da sequência | `critical-path.yml` → `metadata.total_time`, `sequence[]` |
| `parallelism_available` | micro-tasks despacháveis agora, e a razão da redução | D10 |
| `cycles_detected` | ciclos `hard`/`derives-from`, incluindo cross-feature | D7 caso (5) |
| `drift_count` | itens da auditoria de deriva | D9 |

`scopes_without_decision` (ADR-004 C4) ganha aqui a contrapartida estrutural: `mt` sem `implements`
(D7, órfão tipo 2).

### D15 — Costuras para as fases seguintes

| Fase | O que este ADR deixa pronto |
|---|---|
| **6.2** | catálogo de nós/arestas (D4/D5), formato canônico e regras de renderização (D3/D8), skill decidida (D2) |
| **6.3** | os cinco casos de uso com definição operacional, `impacts` como fechamento transitivo com cadeia citada, tipos de órfão com rota (D7) |
| **6.4** | onda = `subgraph`, feature = `classDef`, traço por tipo de aresta, comportamento sem `waves.yml` (D3 criação preguiçosa, D8) |
| **7 — memória** | o grafo é o **índice de recuperação**: `derives-from` e `learned-from` dizem quais decisões e lições são relevantes para o nó em que se está trabalhando, respondendo o "quando ler" da Lacuna 6.1; `learning` fica condicional até os templates existirem (Lacuna 6.2) |
| **8 — anti-alucinação** | o grafo não adiciona campo (uma exceção condicional, D13) e é 100% derivado; D1 é a formulação mais forte da diretriz anti-fabricação: **aresta sem campo de origem não existe** |
| **9 — wiring** | a pendência de caminho de execução (D6) é a evidência da Lacuna 9.1; `docs/graph/` entra na tabela de caminhos da 9.1; `mdpe-graph` entra no router e no `mdpe-flow.md` na 9.2; a cadeia `feat → ad → mt → artifact → evidence` é a rastreabilidade verificável que a 9.1 exige |
| **5 — métricas** | bloco G com fonte por linha (D14) |

---

## 3. Critério de conclusão do artefato de grafo ("grafo honesto")

Um artefato de grafo está válido quando **todos** valem:

- [ ] Toda aresta do diagrama está na tabela de arestas, com **artefato + campo** de origem.
- [ ] Todo nó tem id vindo de um artefato (ou é caminho repo-relativo real, para `artifact`).
- [ ] Nenhum id sintético criado pelo grafo (D6).
- [ ] `impacts` aparece **somente** como computada, citando a cadeia de arestas declaradas.
- [ ] Há pelo menos uma aresta de cada tipo cujos artefatos-fonte existem — em particular
      `derives-from`, `implements` e `produces`: grafo só com `depends-on` entre micro-tasks é o cenário
      negativo da 6.1 e reprova.
- [ ] Arestas `soft` e `external` presentes quando os artefatos as declaram.
- [ ] Caminho crítico **lido** de `critical-path.yml`, não recalculado; divergência apontada.
- [ ] Ondas refletem `waves.yml` / `execution_order`; nenhuma onda inventada.
- [ ] Mermaid renderiza no Markdown do repositório (rótulos entre aspas, sem HTML, um nó por subgraph).
- [ ] `generated_at` + commit/branch no cabeçalho; nenhuma edição manual.
- [ ] Caminho de artefato declarado e inexistente aparece com `exists: false`, não omitido.
- [ ] Nenhuma instrução aponta script, workflow, CLI ou ferramenta inexistente.
- [ ] Nenhum arquivo de grafo criado sem grafo a desenhar (criação preguiçosa).

**Teste operacional:** uma feature transformada, sem nenhuma micro-task executada, já produz view de
ondas + nós `feat`/`mt`/`ad`/`artifact`(contrato) e arestas `derives-from`/`depends-on`/`implements`/
`produces` — sem nós `evidence` nem `learning`, cuja ausência é resultado correto.

---

## 4. Alternativas consideradas

### (a) Manter os `dependencies/*.yml` por feature, sem unificação — **rejeitada**

É o baseline (nota 2). Os dados continuam corretos e continuam sem responder nenhuma das perguntas de
§1.2. Não atinge o nível 3 do Eixo 5, que exige justamente o ADR de nós/arestas/fontes.

### (b) Passo de geração dentro de `mdpe-transformation` — **rejeitada**

Custo zero de wiring e é o caminho primário grafado na 6.2. Rejeitada pelos quatro motivos de D2, com
peso no primeiro: transformation é por-feature e a rastreabilidade pedida é cross-feature. Um passo
míope entregaria de novo o desenho de micro-tasks de uma feature — o cenário negativo explícito da 6.1.
Além disso, a 6.4 pede a skill; ter as duas coisas criaria dois geradores de grafo.

### (c) Novo YAML de grafo unificado (`graph.yml`) como artefato canônico — **rejeitada**

Parece o formato "certo" para dado estruturado, e é a armadilha que o ADR-004 D11 acabou de remover:
seria uma terceira representação de dependência, sem regra de precedência contra `full-graph.yml`, com
deriva garantida. O Markdown com Mermaid + tabela **não é fonte**: é leitura. A tabela dá o rigor que
se buscaria no YAML, e o diagrama dá o que o YAML nunca deu — alguém olhar.

### (d) CLI/tooling de grafo (extrator + renderizador) — **rejeitada**

Resolveria a geração de uma vez. Rejeitada por (i) repetir a Lacuna 4.1 — este repositório não tem
lugar sustentável para binário, e a 9.x nem decidiu onde ferramenta viveria; (ii) tornar a visualização
dependente de execução, quando o mínimo viável é texto; (iii) inverter D1, com o extrator virando fonte.
Contrato de um tooling futuro: verificador, nunca fonte (D11).

### (e) Grafo em ferramenta externa (banco de grafo, Neo4j, ferramenta de layout paga) — **rejeitada**

Cenário negativo literal da 6.2. Some com o versionamento junto: grafo fora do repositório não entra em
diff, não sobrevive a clone e não é conferível em review.

### (f) Nó por critério de aceite (rastreio requisito ↔ teste no grafo) — **rejeitada**

Tentador, porque é o recurso em que o benchmark aponta ◐ para o MDPE (rastreabilidade requisito ↔ teste
↔ arquivo, TLC 5.9). Rejeitada por falta de chave: `quality_criteria.functional[]` e
`acceptance_criteria` são **listas de strings sem id** — nó exigiria criar id sintético, proibido por D1
e D6. Cobertura de critério já é conferível onde tem lastro: `acceptance_criteria.coverage` do
`validation-report` e as métricas B1-B3 do ADR-004. Dar id a critério é candidato natural para a 9.1;
não é pré-requisito da Fase 6.

### (g) Grafo derivado, com skill dedicada, Mermaid inline e procedência por aresta (D1-D15) — **escolhida**

Contra a rubrica 1.2:

| Eixo | Efeito |
|---|---|
| **5 — Grafos** (2 → 3 aqui) | O nível 3 pede exatamente "ADR define nós/arestas/fontes e casos de uso (visualizar, caminho crítico, impacto, órfãos, ciclos), sem geração" — D4, D5, D7. O nível 4 fica integralmente contratado para 6.2/6.4 (D3, D8) e o 5 para a 6.3 (D7 casos 3-5) mais as costuras com F5 e F7 (D14, D15). |
| **1 — Brownfield** | `cf-NNN` e os `files` verificados do inventário entram como nós de primeira classe (D4), fechando A10: feature reconstruída → arquivo real → micro-task nova. |
| **2 — Arquitetura** | `ad-NNN` deixa de ser referência textual e passa a ter alcance visível: `implements`, `supersedes` e `validates(result: violated)` mostram quais micro-tasks e arquivos uma decisão governa — e o órfão tipo 2 mostra onde não governa nada. |
| **3 — Fidelidade / loop** | `produces` + `validates` com `exists: false` tornam **visível** a falha de fidelidade que o ADR-003 D7.2 reprova, e a rota `needs_architecture` ganha o mapa de quem entra em escopo. |
| **4 — Métricas** | Entrega o bloco G que o ADR-004 reservou e não declarou (D14). |
| **6 — Memória** | O grafo é o índice de recuperação da Fase 7: responde "o que é relevante ler agora" por adjacência, em vez de carregar a memória inteira. |
| **7 — Custo cognitivo** | O grafo **não pede campo novo** (exceto um condicional, D13) e substitui leitura de sete YAMLs por um diagrama; auto-sizing (D8) impede o diagrama de virar parede. |
| **8 — Alucinação** | D1 é a formulação mais dura da diretriz da Fase 8 aplicada a estrutura: aresta sem campo de origem **não existe**. `impacts` computada e rotulada evita o vetor clássico — o desenho plausível. |
| Custo | Uma skill nova (a costurar na 9.2), dois templates, um campo condicional em `mdpe-microtask-template.yml`, um diretório `docs/graph/`, e disciplina de regeneração. |

---

## 5. O que **NÃO** é obrigatório

Nada abaixo é pré-requisito para o grafo ser válido, nem para nenhuma outra fase avançar:

**De conteúdo:**

- Nós `persona`, `hypothesis`, `risk` e `external` — opcionais/condicionais.
- Nós `evidence` e `learning` antes de a micro-task executar e fechar.
- Nó `learning` enquanto `{id}-learnings.yml` e `aggregated-learnings.yml` não tiverem template
  (Lacuna 6.2) — mesma condicionalidade do bloco E do ADR-004.
- Nó de critério de aceite e nó de ideia de feature pré-backlog — **não existem** (D4, alternativa f).
- Nó `wave` — onda é agrupador, não nó.
- Aresta `implements` para micro-task que não tem decisão em escopo: a **ausência** é o dado (órfão tipo
  2, sensor de `mdpe-architecture`), não uma lacuna a preencher.
- `traceability.origin_decisions` em micro-task que não nasceu de `derived_work`.
- Grafo de projeto quando só existe uma feature transformada: a view de ondas basta.

**De formato:**

- Graphviz DOT, ferramenta de layout, skill vizinha de diagrama, script, workflow, dashboard.
- View de projeto com nós de artefato e evidência quando o grafo passa de ~40 nós (colapso é correto).
- Diagrama único: acima de ~80 nós, uma view por feature mais rollup é a forma certa.
- Número mínimo de nós, arestas ou ondas. 4 micro-tasks → 4 nós.

**De processo:**

- Regeneração periódica. Os gatilhos são de evento (D9).
- Humano abrir, aprovar ou preencher o grafo. Nada bloqueia esperando isso.
- Consulta de impacto registrada em arquivo: responder na conversa é suficiente; `impact-{node}.md` só
  quando alguém quer o registro.
- Resolver deriva, órfão ou ciclo cross-feature para o grafo ser válido — relatar e rotear basta (D12).

**Regra geral:** a ausência de item desta lista nunca invalida o grafo. O que invalida é aresta sem
campo de origem, nó com id sintético, `impacts` apresentada como declarada, caminho crítico ou onda
recalculados por conta própria, artefato inexistente omitido, Mermaid que não renderiza, grafo editado
à mão, arquivo de grafo criado sem grafo, e qualquer instrução apontando ferramenta que não existe.

---

## 6. Consequências

**Positivas**

- Eixo 5 sai de 2 para 3 com este ADR e deixa o 4 inteiramente contratado para 6.2/6.4. Fecha as
  Lacunas 5.1 e 5.2 pelo mesmo mecanismo: unifica o que existe e acrescenta os elos transversais que já
  estavam declarados em campo.
- **Nenhuma rastreabilidade nova precisa ser inventada.** Os vinte elos de §1.3 estavam escritos; o
  custo da Fase 6 é leitura, não instrumentação. Esse é o resultado que torna a fase barata.
- O framework passa a responder, com cadeia citável, as quatro perguntas de §1.2 — incluindo "se `ad-004`
  for revista, o que entra em escopo?", que hoje não tem resposta possível.
- Dá **uso** ao cálculo de onda que existia desde a v0 e nunca decidiu nada (D10), fechando a metade que
  faltava segundo o benchmark.
- Cria o primeiro mecanismo do MDPE que **detecta inconsistência entre artefatos** (A13): órfão por tipo,
  ciclo cross-feature e deriva de caminho. Ele já nasce apontando uma inconsistência real e conhecida
  (Lacuna 9.1) em vez de escondê-la.
- Não adiciona campo obrigatório a nenhum template. Em uma fase que entrega estrutura nova, isso é
  incomum — e é o que mantém a Fase 8 possível.
- Entrega o bloco G ao ADR-004 sem que a Fase 5 precise ser reaberta.

**Negativas / custos**

- **Mais uma skill para costurar.** `mdpe-graph` é a décima primeira, e a 9.2 tem de colocá-la no router,
  no `mdpe-flow.md`, no `mapping-commands-to-skills.md` e no README, ou ela nasce órfã — o cenário
  negativo da própria 9.2.
- **Disciplina de regeneração é humana.** Nada impede o grafo de envelhecer em silêncio; `generated_at`
  torna o envelhecimento visível, não impossível. Um grafo desatualizado é pior que nenhum, porque
  parece verdade.
- **O nó de artefato é frágil por natureza.** Caminho muda com refatoração; até a auditoria de deriva
  rodar, o grafo aponta arquivo que não existe mais. É o preço de usar caminho como chave (A10), e a
  alternativa — nome lógico — não é conferível.
- **A view de projeto vai ficar grande.** Auto-sizing (D8) administra, não resolve: em projeto com muitas
  features, ninguém lê o diagrama inteiro, e o valor migra para a tabela e para as consultas da 6.3.
- **`docs/graph/` é mais um diretório de topo**, somando a `docs/architecture/`, `docs/brownfield/`,
  `docs/backlog/`, `docs/tracking/`, `docs/learning-loops/`, `docs/transformation/` e `docs/adr/`. A 9.1
  pode consolidar.
- **Um campo novo, ainda que condicional** (D13), vai na direção contrária da Fase 8 e precisa entrar na
  auditoria 8.1 já classificado como condicional.
- **Duas localizações de artefato de execução aceitas** (D6) é tolerância deliberada a uma inconsistência
  conhecida. Se a 9.1 não padronizar, a tolerância se fossiliza.
- **`learning` nasce condicional**, então a ponta final da cadeia fica parcialmente desenhada até a Fase
  7 entregar os templates. Pendência nomeada, não disfarçada.

**Neutras**

- Nenhum artefato existente é reescrito por este ADR. `mdpe-transformation` ganha um ponteiro de próxima
  skill, não um passo.
- `dependencies/*.yml` continuam sendo a fonte de dependência, calculada onde sempre foi.
- Gates permanecem exatamente onde estavam (D12); o grafo observa e roteia.
- Quem não quiser grafo simplesmente não roda a skill: nada no ciclo de execução depende dele.

---

## 7. Verificação contra os cenários de teste da tarefa 6.1

| Cenário | Onde é atendido |
|---|---|
| + O modelo define tipos de nó e de aresta, cada um com a fonte (artefato/campo) de onde vem | D4 (11 tipos de nó, coluna *Fonte: artefato → campo*) e D5 (9 tipos de aresta, coluna *Fonte: campo*); D1 torna a procedência condição de existência; Seção 3 a torna condição de validade |
| + Cobre a cadeia backlog → feature → microtask → arquitetura → artefato → aprendizado | §1.3 inventaria os 20 elos já declarados; D4 dá nó a cada estágio (`session`/`cf` → `feature` → `microtask` → `decision` → `artifact` → `evidence` → `learning`); D5 dá as arestas (`derives-from`, `implements`, `produces`, `validates`, `learned-from`); Seção 3 exige ≥1 aresta de `derives-from`, `implements` e `produces` |
| + Define os casos de uso (visualização, caminho crítico, impacto, órfãos, ciclos) | D7 — os cinco, cada um com entrada, saída e o que reprova; órfão definido **por tipo** com rota; ciclo separando `hard`/`derives-from` (bloqueante) de `soft` (aviso) |
| − Grafo que só replica as dependências entre microtasks (sem rastreabilidade cruzada) reprova | D2 rejeita o passo por-feature justamente por isso (alternativa b); Seção 3 reprova grafo que só tem `depends-on`; D4/D5 tornam `feature`, `decision`, `artifact`, `evidence` e suas arestas parte do mínimo quando os artefatos existem |
| − Nó ou aresta sem fonte derivável de um artefato existente reprova | D1 (regra dura), D6 (proibição de id sintético; caminho real como id), D5 regra 1 (`impacts` só computada, com cadeia citada), D4 (recusa de nó de critério de aceite e de ideia pré-backlog por falta de id), Seção 3 (checklist) |

---

## 8. Fontes

**Internas (lidas para este ADR):** `skills/mdpe-transformation/SKILL.md` (Fase 2: hard/soft/external,
ondas, caminho crítico, detecção de ciclo, `parallelizable`; Fase 1: `derived_work` como candidato a
micro-task e a instrução de rastrear ao `ad-NNN`; passo de geração do `tasks.md`) ·
`skills/mdpe-transformation/assets/templates/dependencies-template.yml` (7 arquivos;
`full-graph.yml` com `upstream_hard/soft`, `downstream_hard/soft`, `level`, `wave`,
`convergence_points`, `graph_validation.cycles_detected`; `hard/soft` com `source`/`target`/`reason`;
`external-dependencies.yml` com `microtask`/`resource`/`status`/`criticality`; `waves.yml`;
`critical-path.yml` com `sequence[]` e `total_time`; `parallelizable.yml`) ·
`skills/mdpe-transformation/assets/templates/microtasks-index-template.yml`
(`microtasks[].dependencies_upstream/downstream`, `execution_order.wave_N`,
`dependency_graph.critical_path` e a instrução *"use a visualization tool for the full graph"*,
`feature_risks[].affected_microtasks`) ·
`skills/mdpe-transformation/assets/templates/mdpe-microtask-template.yml` (`traceability.feature_id`,
`architectural_components`, `output.generated_artifacts[].location`, `quality_criteria` sem id) ·
`skills/mdpe-architecture/assets/templates/architecture-decisions-template.yml` (`ad-NNN` estável e
referenciado pelo grafo de rastreabilidade; `drivers[].source/evidence`; `scope`/`scope_ref`;
`implications[].type/consumed_by` incluindo `derived_work`; `verification`; `supersedes`/`superseded_by`;
criação preguiçosa) · `skills/mdpe-code-discovery/assets/templates/brownfield-inventory-template.md`
(§2 módulos com `path`, §4 `cf-NNN` com `files` verificados como campo bloqueante e `confidence`) ·
`skills/mdpe-execution-context/assets/templates/execution-context-template.yml`
(`architecture.applies[].id`, `*_source: ad-NNN`, `directory_structure[].source`,
`verification[].source`, `no_decision_in_scope`) ·
`skills/mdpe-execution-context/SKILL.md` (saída em `docs/execution/{microtask-id}-context.yml`) ·
`skills/mdpe-coding/assets/templates/validation-report-template.yml`
(`fidelity.declared_outputs[].declared/.exists`, `out_of_scope_changes[].path`,
`acceptance_criteria.coverage`, `summary.overall_status`, `evidence.artifact`) ·
`skills/mdpe-coding/assets/templates/code-review-template.yml` (`scope.files[].path/change`,
`scope.architecture_decisions_in_scope`, `dimensions.architecture.decisions_checked[].result`,
`findings[].violates`, `verdict.open`) · `skills/mdpe-learnings/SKILL.md` (entradas de execução em
`docs/transformation/{feature-id}/execution/`; saídas `{microtask-id}-learnings.yml` e
`docs/learning-loops/aggregated-learnings.yml`; três alvos de feedback) ·
`skills/mdpe-backlog/SKILL.md` e `assets/templates/cognitive-backlog-template.yml`
(`metadata.discovery_session_id`, `traceability.related_discovery_sessions[].id`,
`traceability.feature_origin[].source`, `feat-XXX`, MoSCoW, `acceptance_criteria` sem id) ·
`skills/mdpe-discovery/SKILL.md` e `assets/templates/discovery-session-template.yml`
(`metadata.id`, `personas_identified[].id`; features do brainstorm **sem id**, só contagens) ·
`skills/mdpe-discovery/assets/templates/validation-risks-template.yml` (`hyp-value-001`,
`risk-tech-001`, `related_features[].id`, `affected_features[].id`) ·
`docs/adr/adr-004-execution-metrics.md` (D1 projeção derivada; D5 integridade; D8 métrica não é gate;
D11 remoção do `dependency_graph`; D12 tooling como verificador; bloco G reservado) ·
`docs/adr/adr-003-loop-engineering.md` (D6 rotas de escalonamento; D7 fidelidade e existência da saída) ·
`docs/adr/adr-002-architecture-skill.md` (`ad-NNN`, implicações tipadas, reentrância como `revise`) ·
`docs/adr/adr-001-brownfield-discovery.md` (`cf-NNN`, promoção com `origin: cf-NNN`) ·
`docs/analysis/baseline-gap-map.md` (Lacunas 5.1, 5.2, 6.2, 9.1) ·
`docs/analysis/evaluation-rubric.md` (Eixo 5: âncoras 0-5, baseline 2, meta 4) ·
`docs/analysis/competitive-analysis.md` (4.5, 4.7, 4.9, 5.9, 5.10, 5.13; adoções A5, A10, A11, A13;
Seção 6 "onde o MDPE está à frente", item 3).

**Externas:** OSpec — [clawplays/ospec](https://github.com/clawplays/ospec) (grafo de tarefas que emite
lote paralelo e explica o que reduziu o paralelismo; localizador feature ↔ código com caminhos
declarados; auditoria de deriva por caminho de código alterado) · TLC Spec-Driven —
[SKILL.md v3.3.0](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md)
(auto-sizing por escopo; composição com skill de diagrama e fallback; oferecer e confirmar antes de
despachar) · Spec-Kit — [github/spec-kit](https://github.com/github/spec-kit) (análise de consistência
cross-artefato) · Mermaid — [sintaxe de flowchart e `subgraph`](https://mermaid.js.org/syntax/flowchart.html)
(um nó pertence a um único subgraph; `-->` / `-.->` / `==>`; `classDef`) ·
Graphviz — [graphviz.org](https://graphviz.org/) (DOT, adotado como opcional).

> Conteúdo parafraseado a partir das fontes para conformidade de licenciamento; URLs reaproveitadas de
> `competitive-analysis.md` e de `tasks-v1.md`, verificadas em 28/08/2026.
