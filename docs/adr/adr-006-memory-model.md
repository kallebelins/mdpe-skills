# ADR-006 — Modelo de memória do MDPE

| Campo | Valor |
|---|---|
| **Status** | Aceito |
| **Data** | 28/08/2026 |
| **Tarefa de origem** | `tasks-v1.md` → Fase 7 → 7.1 |
| **Eixo da rubrica** | Eixo 6 — Memória (baseline **1**, meta **4**; nível 5 com a curadoria da 7.2 + wiring da 9.2) |
| **Implementado por** | Tarefa 7.2 (`project-memory-template.yml`, template de `aggregated-learnings.yml`, contratos de leitura nas skills) · reclassificado na 8.1 · costurado na 9.2 · repontuado na 9.3 |
| **Adoções associadas** | A6 (memória de projeto legível com contrato de retomada) · A12 (lições `candidate` → `confirmed`, com curadoria embutida) · A5 (criação preguiçosa) · A4 (cadeia de verificação: evidência vence snapshot) · A13 (pendências cross-artefato) |
| **Depende de** | ADR-001 (inventário datável: `verified_at` + commit, §3 convenções com evidência, §7 dívida; **D7 delega a reconciliação com memória a este ADR**) · ADR-002 (`decisions.yml` como log de decisões; **D5 e alternativa (f) delegam princípios e convenções duráveis a este ADR**) · ADR-003 (`root_cause_diagnosis.symptom`, vocabulário de status, rotas de escalonamento) · ADR-004 (tracking como projeção; E2 `recurring_signatures` nomeado como matéria-prima da lição confirmada; bloco E condicional por falta de template; D8 métrica não é gate) · ADR-005 (grafo como índice de recuperação por adjacência; D1 procedência; D9 regeneração e deriva) |

---

## 1. Contexto

O MDPE **escreve** memória e **não lê** memória. Não é uma metáfora: é literal, e é verificável abrindo
as onze skills e procurando um passo que abra um artefato de aprendizado antes de decidir. Existe em
uma — a que escreve.

### 1.1 Nenhuma skill de entrada tem passo de leitura (Lacuna 6.1)

Inventário do que cada skill declara ler, campo a campo:

| Skill | Lê decisões? | Lê inventário? | Lê aprendizado? | Evidência |
|---|:---:|:---:|:---:|---|
| `mdpe-router` | — | — | **não** | `SKILL.md` inteiro: tabela de roteamento, laços de retorno, diretório de skills. Zero passo de leitura de estado. |
| `mdpe-discovery` | — | — | **não** | `## Inputs`: visão, problema, mercado, objetivos, participantes, restrições, *"optional prior inputs: research, interviews, user data"* — pesquisa externa, não artefato do MDPE |
| `mdpe-backlog` | — | — | **não** | `## Inputs`: só `docs/discovery/01..05-*.yml` + metadados da sessão |
| `mdpe-code-discovery` | — | (é quem escreve) | **não** | documentação prévia entra como *secondary input*, com *"code beats documentation"* |
| `mdpe-architecture` | **sim** | **sim** | **não** | `decisions.yml` é *"Yes, when it exists"*; inventário §2/§3/§7 é restrição vinculante. Aprendizado aparece só como possível **driver** avulso, sem caminho e sem passo |
| `mdpe-transformation` | **sim** | **sim** | **não** | *"Technical context — by reference, not from memory"* aponta `decisions.yml` e o inventário |
| `mdpe-execution-context` | **sim** | **sim** | **quase** | `## Inputs` diz *"Repository state: stack, conventions, existing structure, **aggregated learnings from prior tasks**"* — e **não nomeia arquivo nenhum**. A dimensão 6 repete: *"prior learnings applicable to this task"*. Nenhuma fase abre nada |
| `mdpe-coding` | **sim** | **sim** | **não** | a cadeia de resolução de comandos da Fase 0 tem **seis** fontes numeradas (`quality_criteria[].how_to_verify` → `setup.yml` → manifesto real → `verification` do `ad-NNN` → `inventory.md` §6 → perguntar). `aggregated-learnings.yml` não está nela |
| `mdpe-tasks` | **sim** | **sim** | **não** | *"take it **by reference** instead of from memory"* cita `decisions.yml` e o inventário; lições, não |
| `mdpe-learnings` | **sim** | — | **escreve** | único que produz aprendizado — e roteia para Discovery/Transformation/Next executions |

`mdpe-graph` fica fora da tabela de propósito: é projeção derivada dos artefatos (ADR-005 D1) e não
decide nada, então não tem o que consultar. Seu papel aqui é inverso — **fornecer** o índice de
recuperação (D8).

O padrão é nítido e é assimétrico: `mdpe-learnings` roteia lição para três alvos
(*Discovery* · *Transformation* · *Next executions*) e **nenhum dos três tem contrato de leitura
correspondente**. A ponta de saída do laço existe; a ponta de entrada não. É a Lacuna 6.1 na sua forma
mais crua: o framework é cognitivo na escrita e amnésico na leitura.

Detalhe que merece ser dito porque é o caso mais próximo de acerto: `mdpe-execution-context` **sabe**
que devia ler aprendizado — está escrito duas vezes no `SKILL.md` — e não tem para onde apontar.
Prometer leitura sem caminho é o mesmo defeito que o ADR-004 removeu na medição: referência sem
artefato.

### 1.2 Os dois artefatos de aprendizado não têm template (Lacuna 6.2)

`mdpe-learnings/SKILL.md` → `## Outputs` promete três arquivos:

1. `docs/transformation/{feature-id}/execution/{microtask-id}-learnings.yml`
2. `docs/learning-loops/aggregated-learnings.yml`
3. `docs/tracking/mdpe-tracking.yml`

`skills/mdpe-learnings/assets/templates/` contém **um** arquivo: `mdpe-tracking.yml`. Os dois primeiros
são saída prometida sem artefato-modelo, e o repositório já registra isso em três lugares
independentes:

- `mdpe-tracking.yml`, bloco E: *"CONDITIONAL by decision (ADR-004 D4/E): that artifact has no template
  yet (Phase 7). No file → DELETE this block."*
- `mdpe-graph/SKILL.md`: *"`{microtask-id}-learnings.yml`, `docs/learning-loops/aggregated-learnings.yml`
  | No | learning nodes — **no template exists yet**, so treat as condition, never as a required node"*
- `traceability-graph-template.md`: *"learnings | … | absent — no template exists yet"*

Consequência em cadeia, já paga por duas fases: a métrica de propagação do ADR-004 (bloco E, E1/E2)
nasceu **condicional**, e o nó `learning` do ADR-005 nasceu **condicional**. Duas fases entregaram
contrato parcial porque esta faltava. Fechar a Lacuna 6.2 é o que devolve o bloco E e o nó `learning` a
seus donos.

E há um efeito mais silencioso: dos quatro tipos de aprendizado que `mdpe-learnings` define
(*technical, process, strategic, problems*), **nenhum tem campo em template nenhum**. Antes deste ADR, a palavra
`pitfall` aparecia uma única vez em todas as skills e templates — na própria lista dos quatro tipos, em
`mdpe-learnings/SKILL.md`. Não existe lugar para armazenar uma armadilha.

### 1.3 A memória já existe em três camadas — e três ADRs guardaram o lugar dela de propósito

Este é o achado que muda o desenho: **duas das três camadas já estão prontas, datadas e com
procedência.** O que falta é uma camada e, principalmente, o contrato de leitura.

| Camada pedida pela 7.1 | Artefato que já a implementa | O que ele já traz |
|---|---|---|
| **(1) memória de projeto** — decisões e convenções | `docs/architecture/decisions.yml` (ADR-002) | `ad-NNN` estável, `date`, `status`, `type` (`ratify`/`adopt`/`deviate`/`revise`/`defer`), `implications[].type` incluindo **`conventions`**, `verification` conferível, `supersedes`/`superseded_by`, `spike` nos `defer` |
| | `docs/brownfield/inventory.md` (ADR-001) | §3 convenções observadas (`Convention` · `Observed rule` · `Evidence`, ≥1 é gate) · §7 preocupações/dívida com evidência · header com **`verified_at` + branch@commit** · regra de staleness |
| **(2) aprendizados agregados** | `docs/learning-loops/aggregated-learnings.yml` | **só o caminho existe** — sem template, sem schema, sem estrutura conhecida |
| **(3) execução** | `docs/tracking/mdpe-tracking.yml` (ADR-004) | projeção derivada de micro-task fechada, `signals` com rota, `reconciliation.pending[]` e — decisivo — `aggregates.project.propagation.recurring_signatures` com `signature` + `occurrences[]`, anotado no próprio template como *"raw material for a confirmed lesson (Phase 7)"* |

E três ADRs anteriores **recusaram explicitamente ocupar este espaço**, cada um deixando a costura
nomeada:

- **ADR-002 D5:** *"Um bloco `principles[]` no topo de `decisions.yml` é opcional e admitido apenas para
  princípios que tenham driver real. A memória durável de princípios e convenções do projeto é escopo do
  ADR-006 (Fase 7); este ADR não a implementa, só evita ocupar o lugar dela."* O mesmo texto está
  repetido no `architecture-decisions-template.yml`, imediatamente acima da chave `principles:`.
- **ADR-002, alternativa (f):** *"Princípios estáveis do projeto são úteis, mas são **memória**, não
  decisão pontual: o lugar deles é o ADR-006, onde já está prevista a memória de projeto com convenções
  e armadilhas (A6)."*
- **ADR-001 D7:** *"`verificado_em` torna o inventário datável. Ao retomar, se o repo mudou desde
  `verificado_em`, a **evidência atual vence o inventário** e as seções afetadas são reinventariadas.
  A conexão formal com memória de projeto fica para a Fase 7 (ADR-006)."*
- **ADR-005 D15 / `graph-queries.md`:** *"a adjacência do nó em que se está trabalhando
  (`derives-from`, `implements`, `learned-from`) é a lista curta de decisões e lições relevantes para
  ele, então uma sessão pode ler por vizinhança em vez de carregar todo artefato. O formato da memória é
  decidido em outro lugar; esta skill fornece o índice e não presume nada sobre ele."*

Ou seja: o mecanismo de **recuperação** (adjacência no grafo) já foi entregue na Fase 6, o **log de
decisões** já foi entregue na Fase 3, a **evidência datada de convenções** já foi entregue na Fase 2, e
a **matéria-prima da lição** já foi entregue na Fase 5. Falta a camada de lições e falta o gatilho de
leitura.

### 1.4 Onde a memória está genuinamente ausente

Cinco ausências reais, e nenhuma delas é "falta um banco de dados":

1. **Não há casa de escrita para lição nem para armadilha.** §1.2.
2. **`code_conventions` é redigitado por micro-task, sem procedência.** No
   `execution-context-template.yml`, todos os irmãos do bloco `architecture` carregam
   `*_source: ad-NNN` (`overall_pattern_source`, `target_layer_source`,
   `layer_dependencies_source`, `directory_structure[].source`, `architectural_patterns[].source`,
   `verification[].source`). O bloco `code_conventions` — que o próprio comentário do template mapeia
   como destino da implicação `conventions` — **não tem campo de fonte nenhum**. Pior: é
   linguagem-chumbada (`database_naming`, `csharp_naming`). Convenção é, hoje, o único item de contexto
   técnico que o framework manda preencher **de memória** — exatamente o que ele proíbe em cinco outros
   lugares (*"by reference, not from memory"*).
3. **Não existe contrato de retomada.** A palavra `session` no repositório significa **sessão de
   discovery** (`discovery_session_id`, `persona-NNN`), nunca sessão de trabalho. Não há
   `session-brief`, não há próximo passo seguro, não há snapshot de handoff. Quem entra em uma sessão
   nova descobre o estado abrindo arquivos na ordem que adivinhar.
4. **A regra de staleness do inventário não tem consumidor.** `mdpe-code-discovery` diz que, ao
   retomar, evidência atual vence inventário antigo e só as seções afetadas são reinventariadas — mas
   **não há campo** que registre qual seção foi atualizada, nem mecanismo que avise outra skill de que o
   inventário envelheceu. É regra narrativa sem gancho.
5. **Pendências ficam espalhadas.** `defer` + `spike` moram em `decisions.yml`;
   `reconciliation.pending[]` mora no tracking; a pendência de caminho de execução (ADR-005 D6) mora no
   grafo. Três lugares para responder "o que ainda está em aberto neste projeto?" — pergunta que é
   memória, e das mais úteis.

### 1.5 O que o benchmark diz sobre memória

`docs/analysis/competitive-analysis.md` marca **○ para o MDPE** em quatro recursos de memória
(*log de decisões recuperável entre sessões*, *handoff/retomada reconciliada*, *arquivamento/
consolidação ao concluir*, *princípios do projeto*) e **◐** em *lições com curadoria*. Duas adoções P0/P1
apontam para cá:

- **A6 (P0) — TLC 5.5 · OSpec 4.6.** TLC mantém `STATE.md`: log de decisões com id + snapshot de
  handoff, e ao retomar **o snapshot é reconciliado contra o git — a evidência real vence um snapshot
  desatualizado**. OSpec emite `session-brief` mostrando as mudanças ativas, o estado da fila e **o
  próximo comando seguro**, antes de tocar em qualquer coisa. O detalhe "evidência vence snapshot" é
  anti-alucinação embutido, e é a regra que este ADR adota inteira.
- **A12 (P1) — TLC 5.6.** Camada de lições com curadoria: estado canônico de propriedade da máquina,
  **somente lições confirmadas** são carregadas nas fases de decisão — candidatas nunca — e **um
  resultado limpo não registra nada**. É o antídoto ao risco que a própria 7.2 nomeia no cenário
  negativo: memória que cresce sem limite.
- **OpenSpec 2.4** fecha o ciclo por **arquivamento**: o delta é fundido na spec principal e a pasta da
  mudança vai para um arquivo datado — a spec passa a descrever a nova realidade. Traduzido para cá: a
  lição confirmada que se torna regra **gradua** para o artefato que a governa, em vez de acumular.
- **TLC 5.7** declara orçamento de contexto: carregamento sob demanda, proibição de carregar múltiplas
  specs ao mesmo tempo. Memória que exige carregar tudo antes de agir não é memória, é imposto.

---

## 2. Decisão

### D1 — Memória não é artefato novo: é **contrato de leitura** sobre três camadas, das quais só uma falta

A inversão deste ADR é diferente das anteriores. O ADR-004 e o ADR-005 inverteram *onde a verdade vive*.
Aqui a verdade já vive no lugar certo — o que falta é **alguém abrir o arquivo**.

| Camada | Artefato | Dono (quem escreve) | Situação |
|:--:|---|---|---|
| **C1 — Restrições** (decisões + convenções + dívida observada) | `docs/architecture/decisions.yml` · `docs/brownfield/inventory.md` | `mdpe-architecture` · `mdpe-code-discovery` | **existe**; este ADR não muda nem um campo |
| **C2 — Lições** (aprendizados agregados, os loops) | `docs/learning-loops/aggregated-learnings.yml` | `mdpe-learnings` | **caminho existe, estrutura não**; a 7.2 cria o template (D5) |
| **C3 — Execução** (o que já rodou) | `docs/tracking/mdpe-tracking.yml` | `mdpe-learnings` | **existe** (ADR-004); memória só **lê** |

Três regras duras que decorrem disso:

1. **A memória não copia nada da C1 nem da C3.** Quem quer a decisão lê `decisions.yml`. Quem quer o
   número lê o tracking. Duplicar aqui recriaria a deriva que o ADR-004 D7 acabou de eliminar.
2. **A memória não tem escrita própria.** Cada camada é escrita pelo seu dono, no seu gatilho. Não
   existe "gravar na memória" como ação independente (D4).
3. **A memória não é fonte.** Em divergência entre memória e artefato — ou entre memória e o **código** —
   vence o artefato, e vence o código acima do artefato. É a regra A6/TLC 5.5 (*evidência vence
   snapshot*) e é a mesma postura já escrita em `mdpe-code-discovery` (*"code beats documentation, and
   current evidence beats an old inventory"*).

### D2 — Um índice de leitura derivado: `docs/memory/project-memory.yml`

O contrato de leitura precisa ser **barato**, ou ninguém o cumpre. As três camadas somam centenas de
linhas espalhadas por quatro caminhos; mandar cada skill abrir tudo antes de agir é o oposto de um
orçamento de contexto (TLC 5.7) e seria abandonado no segundo dia.

Decisão: um **índice**, derivado e regenerável, no mesmo contrato do grafo (ADR-005 D1/D9) e do tracking
(ADR-004 D1) — **projeção, nunca fonte**.

**Local:** `docs/memory/project-memory.yml`. Template em
`skills/mdpe-learnings/assets/templates/project-memory-template.yml` (destino grafado na 7.2).

**O que o índice carrega — e nada além:**

| Bloco | Conteúdo | Fonte (artefato → campo) | Obrigatoriedade |
|---|---|---|---|
| `metadata` | `generated_at`, `branch@commit` lido, `generated_by` | a geração | **essencial** |
| `constraints[]` | uma linha por decisão **em vigor**: `ref: ad-NNN` + o `title` como está escrito + `type` | `decisions.yml` → `id`, `title`, `type`, `status: accepted` | essencial quando `decisions.yml` existe |
| `conventions[]` | uma linha por convenção em vigor: `rule` + `source` + `evidence` | `decisions.yml` → `implications[].type: conventions`; `inventory.md` §3 → linha (`Observed rule` + `Evidence`) | essencial quando alguma das fontes existe |
| `pitfalls[]` | uma linha por lição **`confirmed`** de tipo `technical`/`problem`: `ref: ls-NNN` + `statement` | `aggregated-learnings.yml` → lições `status: confirmed` | condicional (C2 com ≥1 confirmada) |
| `calibration[]` | lições `confirmed` de tipo `process`/`strategic`, com o alvo de roteamento | idem + `target` | condicional |
| `open_questions[]` | o que está em aberto: `defer` sem spike resolvido · `reconciliation.pending[]` · pendência de caminho do grafo | `decisions.yml` → `type: defer` + `spike`; `mdpe-tracking.yml` → `reconciliation.pending[]`; view de grafo | condicional |
| `staleness[]` | itens cuja evidência pode ter envelhecido: `inventory.md` com `verified_at` anterior ao commit atual; caminho citado que não existe mais | header do inventário vs estado do repo; auditoria de deriva do grafo (ADR-005 D9) | condicional |
| `next` | **ponteiro** para o despacho, nunca recálculo | view de ondas do `mdpe-graph` (ADR-005 D10) ou `microtasks-index.yml` | opcional |

**Uma cópia é admitida, e apenas uma:** o `title`/`statement` de uma linha, para o índice ser legível
sem abrir cinco arquivos — exatamente como a tabela de arestas do grafo carrega rótulo e o tracking
carrega ponteiro. Em divergência, **o dono vence e o índice é regenerado** (D1 regra 3). Nenhum outro
campo do dono entra: sem `drivers`, sem `alternatives`, sem `consequences`, sem `verification`, sem
`evidence[]` completo de lição.

**Criação preguiçosa (A5).** Sem `decisions.yml`, sem inventário e sem micro-task fechada → **nenhum
arquivo**, e a resposta correta é *"não há memória a consultar"*. Índice vazio sinalizaria que houve
projeto quando não houve.

**Tamanho como sensor.** O índice só admite decisão `accepted`, convenção em vigor, lição `confirmed` e
pendência aberta — então seu tamanho é limitado por construção. Quando ele passa de uma tela, o sinal
não é "paginar": é que há lição pendente de **graduação** (D5). O crescimento do índice é o termômetro
da curadoria, não um problema de formato.

### D3 — Contrato de **leitura**: quem lê, quando, e o que é proibido concluir da leitura

Esta é a seção que fecha a Lacuna 6.1. A regra geral: **lê-se o índice, não as camadas**; a camada é
aberta só quando o índice aponta um item relevante ao que está em pauta.

| Skill | Quando lê | O que lê | O que **não** pode fazer com isso |
|---|---|---|---|
| `mdpe-router` | **antes de rotear** | o índice inteiro (é limitado por D2) | não decide arquitetura nem escopo; anuncia o que está em vigor, o que está em aberto e o que está *stale*, e roteia |
| `mdpe-discovery` | antes de abrir sessão | `calibration[]` com `target: discovery` | não trata lição como requisito; lição é insumo de repriorização, não feature |
| `mdpe-backlog` | antes de estruturar | idem | não reescreve valor percebido com base em lição sem evidência |
| `mdpe-code-discovery` | Fase 0 | `staleness[]` + `conventions[]` com origem no inventário | **o código vence a memória**: convenção do índice serve para conferir, nunca para preencher §3 sem amostrar arquivo |
| `mdpe-architecture` | Fase 0, junto de `decisions.yml` | `pitfalls[]` (confirmadas), `open_questions[]`, `conventions[]` | lição **não é driver** por si: vira driver só com `evidence[]` apontando artefato e campo (ADR-002 D6) |
| `mdpe-transformation` | Fase 1, junto do contexto técnico | `conventions[]`, `pitfalls[]`, `calibration[]` com `target: transformation` | não altera faixa de decomposição por palpite; calibração exige lição `confirmed` |
| `mdpe-execution-context` | ao montar as dimensões | `conventions[]` (com `source`) e `pitfalls[]` aplicáveis | **substitui** o redigitar de convenção: o que entra em `code_conventions` passa a ter origem (D6). Sem fonte, o campo fica vazio |
| `mdpe-coding` | **antes da Fase 1 (Act)**, depois de congelar o plano da Fase 0 | `pitfalls[]` (confirmadas) aplicáveis ao escopo | **não entra na cadeia de comandos.** Comando vem de artefato executável, nunca de lição (ADR-003). Lição informa a implementação; não vira evidência, não vira gate, não vira `verification` |
| `mdpe-tasks` | uma leitura, no cabeçalho | o índice inteiro | fast-path: uma leitura, um arquivo. Não abre camada nenhuma |
| `mdpe-learnings` | ao fechar micro-task | C2 + C3 + `decisions.yml` | é o único que **escreve** e regenera (D4) |
| `mdpe-graph` | — | nada | não consulta memória: **fornece** o índice de recuperação por adjacência (D8) e nunca é fonte de restrição |

Três proibições valem para todos, e são o que impede a memória de virar fonte de alucinação:

1. **Lição não é evidência.** Nada em `validation-report` ou `code-review` pode ser preenchido a partir
   de lição. Evidência é comando executado com resultado (ADR-003 D3). Uma lição pode dizer *onde
   olhar*; nunca *o que aconteceu*.
2. **Memória não decide.** Nenhuma decisão de arquitetura, nenhum status de micro-task, nenhum veredito
   nasce do índice. O índice diz o que já foi decidido, por quem, e onde conferir.
3. **Índice ausente não bloqueia.** Sem memória, cada skill segue com o que já lia hoje. A leitura é
   **enabler, não gate** (OpenSpec 2.5), postura que `mdpe-architecture` já adota por escrito.

### D4 — Contrato de **escrita**: gatilhos por camada, nenhum dono novo

| Camada | Quando é escrita | Por quem |
|---|---|---|
| **C1** — `decisions.yml` | quando um driver exige decisão (`adopt`/`ratify`/`deviate`/`revise`/`defer`) | `mdpe-architecture` — **inalterado** |
| **C1** — `inventory.md` | primeira adoção; re-inventário por escopo ou quando `staleness[]` acusa | `mdpe-code-discovery` — **inalterado** |
| **C2** — `{id}-learnings.yml` | no fecho de cada micro-task | `mdpe-learnings` |
| **C2** — `aggregated-learnings.yml` | no mesmo fecho: lição nova entra como `candidate`; lição existente ganha ocorrência; promoção/graduação conforme D5 | `mdpe-learnings` |
| **C3** — `mdpe-tracking.yml` | no mesmo fecho (ADR-004 D6) | `mdpe-learnings` — **inalterado** |
| **Índice** | **regenerado**, nunca editado: no fecho de micro-task, ao aceitar/revisar decisão, ao (re)inventariar, e sob demanda | quem escreveu a camada, ou `mdpe-learnings` no fecho |

Escrita orientada a evento, nunca periódica — mesma razão do ADR-004 D6: cadência periódica sem
ferramenta é promessa que ninguém cumpre.

**Um resultado limpo não escreve nada** (A12). Micro-task que fecha em `i1`, sem achado e sem
`root_cause_diagnosis`, não gera lição. Registrar o sucesso trivial é como o framework produziria
volume sem informação — o problema da Fase 8 reintroduzido pela porta da memória.

### D5 — Curadoria: `candidate` → `confirmed` → `retired`, e graduação em vez de acúmulo

O cenário negativo da 7.2 é explícito: *"memória que cresce sem limite/curadoria reprova"*. O mecanismo
tem três estados e uma saída.

**Campos de uma lição** (a estrutura que a 7.2 vai templatar em `aggregated-learnings.yml`):

| Campo | Obrigação | Conteúdo |
|---|:---:|---|
| `id` | essencial | `ls-NNN`, sequencial e estável — nunca renumerado |
| `kind` | essencial | `technical` · `process` · `strategic` · `problem` — **os quatro tipos que `mdpe-learnings` já define**; nenhum vocabulário novo |
| `statement` | essencial | uma linha, imperativa, no que fazer ou evitar |
| `status` | essencial | `candidate` · `confirmed` · `retired` |
| `evidence[]` | essencial, ≥1 | micro-task + artefato + **campo** (ex.: `mt-001-003` → `{id}-validation.yml` → `loop.iterations[1].failed[].dimension`) |
| `target` | essencial | `discovery` · `transformation` · `next_executions` — os três alvos que `mdpe-learnings` já roteia |
| `action` · `owner` · `horizon` | essencial | já exigidos hoje pelo quality gate de `mdpe-learnings` |
| `applies_to` | condicional | `system` · `feature` · `module` (+ camada/tecnologia quando houver) — é o filtro de relevância do índice |
| `signature` | condicional | `root_cause_diagnosis.symptom` normalizado, quando a lição nasceu de falha (liga em E2 do ADR-004) |
| `first_seen` / `last_seen` | essencial | data de fecho da primeira e da última micro-task que a evidenciou |
| `promoted_to` | condicional | `ad-NNN`, linha de convenção ou item de skill onde a lição **graduou** |
| `superseded_by` | condicional | `ls-NNN` que a substitui |

**Promoção a `confirmed`** — uma das duas, nunca por julgamento:

1. **≥2 ocorrências** com `evidence[]` nomeando micro-tasks distintas. É literalmente
   `aggregates.project.propagation.recurring_signatures` do tracking (ADR-004 E2), que o próprio
   template já anota como *"raw material for a confirmed lesson (Phase 7)"*; ou
2. **1 ocorrência de peso verificável**: achado `blocker` no `code-review`, ou `loop.overrun: true` com
   `root_cause_diagnosis`. Falha que parou o laço não precisa repetir para valer.

Fora dessas duas, a lição fica `candidate` — **e candidata não entra no índice, logo ninguém a lê antes
de decidir** (A12). Candidata é hipótese arquivada, não conselho.

**Graduação (a saída, adaptada de OpenSpec 2.4).** Lição confirmada que se transformou em regra **sai
da memória e entra no artefato que a governa**:

| A lição virou | Vai para | E então |
|---|---|---|
| regra de arquitetura ou fronteira | `decisions.yml`, como decisão com driver e `verification` | `status: retired`, `promoted_to: ad-NNN` |
| convenção de código | implicação `conventions` de um `ad-NNN`, ou §3 do inventário quando é prática observada | `status: retired`, `promoted_to` preenchido |
| ajuste de processo do próprio framework | mudança na skill (Fase 9) | `status: retired`, `promoted_to` = a skill |

**Aposentadoria sem graduação:** lição confirmada cuja decisão-dona virou `superseded`, ou que não
reaparece em 10 micro-tasks fechadas, vira `retired` **com motivo**. Retirada sai do índice e
**permanece no arquivo** — apagar destruiria a evidência de que já se pensou naquilo. O histórico é
barato; o índice é que precisa ser curto.

É esse par graduação/aposentadoria que responde ao cenário negativo: a memória **não cresce, ela
gradua**. Um projeto maduro tende a ter poucas lições confirmadas e muitas graduadas — sinal de saúde,
não de esquecimento.

### D6 — A única adição de campo: procedência da convenção

`code_conventions` no `execution-context-template.yml` é hoje o único bloco de contexto técnico sem
campo de origem (§1.4 item 2). Correção mínima, uma linha:

- **`code_conventions_source`**, **condicional**: `ad-NNN` (implicação `conventions`) ou
  `inventory.md §3`. Sem fonte → o bloco fica **vazio**, e o vazio é o resultado correto — mesma regra
  já escrita para `overall_pattern` (*"Leave the field EMPTY and record the absence"*).
- E o efeito colateral bem-vindo: sem fonte, não há convenção a redigitar de memória. O campo
  linguagem-chumbado (`csharp_naming`, `database_naming`) deixa de ser preenchido por hábito; a
  reclassificação do bloco para algo agnóstico de linguagem é trabalho da 8.1, não deste ADR.

Nenhum outro campo é adicionado em nenhum template existente. `aggregated-learnings.yml` e
`project-memory.yml` são estrutura **nova para caminho já prometido** — fechar referência fantasma, não
criar obrigação.

### D7 — Retomada: reconciliação contra o repo, evidência vence snapshot

A retomada é o caso de uso que justifica a memória existir (A6 / TLC 5.5 · OSpec 4.6), e o MDPE não tem
nada disso hoje (§1.4 item 3).

**Ao iniciar uma sessão** (`mdpe-router`, ou a skill de entrada quando o router é pulado):

1. Ler o índice. Sem índice → *"não há memória"*, seguir.
2. Comparar `metadata.branch@commit` do índice com o estado atual do repositório. Divergiu →
   **regenerar** antes de usar.
3. Conferir `staleness[]`: `verified_at` do inventário anterior ao commit atual, caminho citado que
   deixou de existir, `ad-NNN` `superseded` ainda referenciado. Cada item vira **aviso com rota**, nunca
   correção por dedução.
4. Anunciar em uma linha: o que está em vigor, o que está em aberto, o que está *stale*, e o próximo
   passo — este último **lido** do despacho do grafo ou do índice de micro-tasks, jamais recalculado
   (ADR-005 D10).

**A regra que governa tudo isso:** em qualquer divergência, a ordem de precedência é
**código > artefato do dono > índice**. Um snapshot que discorda do repositório está errado por
definição. É o mecanismo anti-alucinação embutido que o benchmark destaca em TLC 5.5, e é a mesma
precedência que `mdpe-code-discovery` já aplica a documentação.

**Fecha a costura do ADR-001 D7:** o item `staleness[]` do índice é o consumidor que a regra de
staleness do inventário nunca teve. A regra continua sendo *reinventariar só as seções afetadas* — a
novidade é que agora alguém percebe que é hora.

### D8 — Recuperação por adjacência; o índice é o piso, o grafo é o teto

Duas formas de recuperar, e a ordem importa:

| Situação | Como se recupera |
|---|---|
| Existe view de grafo (`mdpe-graph`) | **por adjacência** do nó em pauta: `implements` → decisões que o governam; `derives-from` → de onde ele veio; `learned-from` → lições ligadas a ele. É o mecanismo que o ADR-005 D15 e `graph-queries.md` Q3 já entregaram |
| Não existe grafo | **pelo índice**, filtrado por `applies_to` (escopo/camada/tecnologia) e pelo escopo do trabalho em pauta |

**Nunca se carrega C2 inteira.** O `aggregated-learnings.yml` cresce com o projeto e contém
`candidate` e `retired`, que por definição não devem influenciar decisão. Carregar tudo seria
importar hipótese descartada como conselho — o vetor de alucinação mais direto que uma camada de memória
pode criar.

Isso também é o orçamento de contexto (TLC 5.7) sem inventar mecanismo novo: o índice é curto por
construção (D2), a adjacência é curta por definição, e a camada só abre no item apontado.

### D9 — Memória **não** é gate

Mesma regra do ADR-004 D8 e do ADR-005 D12, e pelo mesmo motivo mecânico.

Nenhum item de memória aprova, reprova, bloqueia ou libera. Os gates continuam onde estão: ADR-003
(evidência por dimensão, limite de laço), ADR-002 (`drivers` bloqueante), `mdpe-transformation`
(7 critérios), `mdpe-code-discovery` (5 itens).

O motivo: quem escreve a lição é o mesmo agente que fecha a micro-task. No instante em que "número de
lições" ou "aderência a lição" virar meta, a pressão passa a ser **fabricar lição** — e a camada que
existia para reduzir alucinação passa a produzi-la. Lição é conselho com procedência, não regra
executável. Quando ela **precisa** virar regra executável, o caminho é a graduação (D5): vira decisão
com `verification`, e aí sim o review a confere — no lugar certo, com o mecanismo certo.

### D10 — Nenhuma infraestrutura, nenhum tooling, nenhum serviço

Recusa explícita, porque o cenário negativo da 7.1 a exige e porque o histórico do repositório a cobra
(Lacuna 4.1):

- **Nada de banco vetorial, embeddings, servidor MCP de memória, serviço externo ou índice binário.** O
  mínimo viável é YAML e Markdown versionados no repositório do projeto, conferíveis em diff e em
  review.
- **Nada de script.** Se um dia existir ferramenta de memória, o contrato é o mesmo do ADR-004 D12:
  **verificador, nunca fonte** — recomputa o índice a partir das camadas e retorna diferente de zero na
  divergência. Nenhum template referencia ferramenta antes de ela existir.
- **Nada de janela de contexto do harness como camada.** Memória que vive na conversa não sobrevive à
  sessão, que é justamente o problema.

### D11 — Ponte com `steering` do Kiro: **exportação opcional, em um sentido só**

A 7.1 levanta *"potencial ponte para steering `.kiro`"*. Verificado: o repositório não menciona
`steering` em nenhuma skill ou ADR — as únicas ocorrências de `.kiro` estão em `README.md` e
`INSTALL.md`, e são o **local de instalação das skills** (`~/.kiro/skills`), não de artefatos de
projeto.

Decisão: **exportação opcional, derivada e unidirecional**. Um arquivo de steering pode ser gerado a
partir do índice (ou simplesmente **apontar** para ele), e nunca o contrário. Três razões:

1. **Portabilidade.** As skills do MDPE são texto e rodam em qualquer harness. Amarrar o mínimo viável a
   um diretório específico de um IDE tornaria a memória indisponível fora dele.
2. **Uma fonte.** Steering editado à mão viraria segunda fonte de convenções, sem regra de precedência —
   o erro que o ADR-004 D11 removeu do grafo e que o ADR-002 D5 evitou nos princípios.
3. **Ganho marginal.** O valor do steering é injeção automática de contexto; o valor deste ADR é o
   contrato de leitura. Com o contrato escrito na skill, a injeção é conveniência.

Fica registrado como conveniência de host, não como mecanismo — e sem referência em template nenhum
enquanto não existir.

### D12 — O que este ADR **recusa** criar

| Recusado | Motivo |
|---|---|
| Bloco `principles[]` gerado no índice | ADR-002 D5 admitiu `principles[]` **opcional e só com driver real** em `decisions.yml`. Princípio genérico gerado por IA (*"prefira simplicidade"*) é exatamente o enchimento que a Fase 8 corta. Princípio entra na memória **só por graduação** de lição confirmada ou como decisão com driver — nunca autorado pelo índice |
| Camada de "memória de conversa"/histórico de sessão | não é derivável de artefato, cresce sem limite e não é conferível. O que uma sessão precisa saber é estado, e estado está nas três camadas |
| Cópia de decisões ou convenções para um artefato de memória "autoritativo" | seria a terceira representação da mesma coisa, sem precedência — o erro que o ADR-005 alternativa (c) rejeitou |
| `severity`/escore/peso numérico de lição | escore sem fórmula é o `quality_score` do ADR-004 §1.3 voltando por outra porta. Lição tem `status` e `evidence[]`; não tem nota |
| Contagem-alvo de lições por micro-task | número de lições é número de coisas aprendidas. Alvo produziria lição fabricada (D9) |
| Apagar lição `retired` | destruiria a evidência de que a hipótese já foi considerada. Sai do índice, fica no arquivo |

### D13 — Costuras para as fases seguintes

| Fase | O que este ADR entrega ou deixa pronto |
|---|---|
| **7.2** (implementação) | as três camadas nomeadas (D1), o índice com blocos e fontes (D2), a tabela de leitura por skill (D3), os gatilhos de escrita (D4), a estrutura da lição com curadoria (D5), a adição condicional `code_conventions_source` (D6) |
| **5 — métricas** | **devolve o bloco E ao ADR-004**: com `aggregated-learnings.yml` templatado, E1 (`learnings_by_target`) e E2 (`recurring_signatures`) deixam de ser condicionais por falta de artefato. E2 passa a ter contrapartida estrutural: `signature` é campo da lição |
| **6 — grafo** | **devolve o nó `learning` ao ADR-005**: deixa de ser condicional por falta de template. A aresta `learned-from` ganha ponta de destino com estrutura conhecida (`ls-NNN`), e `promoted_to` cria uma aresta nova de graduação (`ls-NNN` → `ad-NNN`) rastreável — a registrar na 9.1, não aqui |
| **3 — arquitetura** | fecha a delegação do ADR-002 D5 e da alternativa (f): convenções e princípios duráveis têm dono, e `decisions.yml` continua sendo só decisão pontual |
| **2 — brownfield** | fecha a delegação do ADR-001 D7: `staleness[]` é o consumidor que a regra de re-inventário nunca teve |
| **4 — fidelidade** | nada muda no gate. Lição informa a implementação e **não** entra na cadeia de comandos nem na evidência (D3, proibição 1) |
| **8 — anti-alucinação** | uma única adição condicional de campo (D6); tudo o mais é derivado ou preenche caminho já prometido. Três mecanismos são diretamente anti-fabricação: *evidência vence snapshot* (D7), *só confirmada é lida* (D5) e *nunca carregar C2 inteira* (D8). A classificação dos campos da lição entra na auditoria 8.1 já marcada |
| **9 — wiring** | `mdpe-router` ganha passo de leitura (9.2); `docs/memory/` entra na tabela de caminhos da 9.1; o par `ls-NNN` ↔ `promoted_to` fecha a cadeia de rastreio *backlog → arquitetura → micro-task → evidência → lição → regra* que a 9.1 pede; a divisão `docs/memory/` vs `docs/learning-loops/` é candidata a consolidação (Seção 6) |

---

## 3. Critério de conclusão da memória ("memória honesta")

A memória de um projeto está válida quando **todos** valem:

- [ ] Toda linha do índice aponta **artefato + campo** de origem (ou é a cópia de uma linha do dono,
      regenerável).
- [ ] Nenhuma decisão, convenção, número ou veredito é **autorado** no índice.
- [ ] `metadata` traz `generated_at` + `branch@commit`; nenhuma edição manual.
- [ ] Só lições **`confirmed`** aparecem no índice; `candidate` e `retired` ficam fora.
- [ ] Toda lição tem `evidence[]` com micro-task **e** campo; nenhuma lição promovida sem satisfazer uma
      das duas regras de promoção (D5).
- [ ] Nenhuma lição usada como evidência de validação, como comando de verificação ou como gate.
- [ ] `staleness[]` presente quando há divergência entre `verified_at`/caminhos e o estado do repo — e
      **relatado, não corrigido por dedução**.
- [ ] Precedência respeitada em toda divergência: **código > artefato do dono > índice**.
- [ ] Nenhum bloco de princípios genéricos; nenhum escore de lição.
- [ ] Nenhuma instrução aponta script, serviço, banco vetorial ou ferramenta inexistente.
- [ ] Nenhum arquivo de memória criado sem memória a indexar (criação preguiçosa).
- [ ] Existe ≥1 skill de entrada cujo passo de leitura é executável e verificável — memória só de
      escrita **reprova** por definição.

**Teste operacional (o cenário positivo da 7.2):** uma decisão registrada em uma sessão e uma lição
confirmada no fecho de uma micro-task estão **legíveis no índice na sessão seguinte**, apontando os
artefatos de origem, sem que nada tenha sido redigitado.

---

## 4. Alternativas consideradas

### (a) Manter como está: escrever `aggregated-learnings.yml` e esperar que alguém leia — **rejeitada**

É o baseline (nota 1). O artefato não tem template, ninguém o abre, e a rubrica é explícita: nível 1 é
*"memória só de escrita: grava aprendizados, mas ninguém os lê antes de decidir; output sem template"*.
Não alcança nem o nível 2, que exige artefato legível.

### (b) Um arquivo único de memória, autorado pelo agente, com decisões + convenções + lições — **rejeitada**

É o desenho intuitivo, e é o que a 7.2 poderia sugerir lendo *"template de memória de projeto
(decisões + convenções + armadilhas)"* ao pé da letra. Rejeitada por três motivos:

1. **Duplica C1 e C3.** Decisões já vivem em `decisions.yml` com driver, alternativa, consequência e
   `verification`; convenções observadas já vivem no inventário com evidência e data. Copiá-las cria a
   deriva que o ADR-004 D7 removeu — em duas semanas os dois arquivos discordam e nada diz qual vale.
2. **Autorado é fabricável.** Um arquivo que o agente escreve livremente é o lugar natural para
   princípios genéricos e convenções que o repositório não tem. É o problema da Fase 8 dentro da
   solução da Fase 7.
3. **Não resolve a leitura.** Continuaria sendo escrita sem gatilho de consulta — o defeito real.

O que sobra dessa ideia, e é adotado: um **índice** com o mesmo propósito de conveniência, mas
**derivado** (D2), com procedência por linha e regeneração como regra.

### (c) Sem índice: cada skill lê direto as três camadas — **rejeitada**

Mais puro (zero artefato novo, zero cópia) e tentador. Rejeitada porque o contrato de leitura ficaria
caro o suficiente para ser ignorado:

- Convenção em vigor está **espalhada** por N `implications[].type: conventions` de N decisões, mais §3
  do inventário. Não há um lugar para ler "as convenções deste projeto".
- Pendência aberta está em três arquivos diferentes (§1.4 item 5).
- Lição relevante exigiria varrer C2 inteira, incluindo `candidate` e `retired` — precisamente o que D8
  proíbe.
- Retomada exigiria abrir quatro caminhos antes de qualquer decisão, contra o orçamento de contexto
  (TLC 5.7).

Um contrato que ninguém cumpre pontua igual a não ter contrato.

### (d) Steering do Kiro (`.kiro/steering`) como mecanismo de memória — **parcialmente adotada**

Injeção automática de contexto é genuinamente atraente e resolveria "quando ler" sem depender de
disciplina. Rejeitada **como mecanismo** pelas três razões de D11 (portabilidade entre harnesses, risco
de segunda fonte editável à mão, ganho marginal sobre o contrato escrito) e adotada como
**exportação opcional e unidirecional**. Vale registrar a assimetria: o MDPE já se instala em
`~/.kiro/skills`, mas seus artefatos vivem no repositório do projeto — a memória segue a regra dos
artefatos, não a da instalação.

### (e) Banco vetorial / embeddings / servidor MCP de memória — **rejeitada**

Recuperação semântica resolveria relevância melhor que `applies_to`. Rejeitada porque contraria
diretamente o cenário negativo da 7.1 (*"proposta que exige infraestrutura externa para o mínimo viável
reprova"*), repete a Lacuna 4.1 por outra escala, e quebra três propriedades que a v1 depende: diff,
review e clone. Memória fora do repositório não é conferível.

### (f) Lição como gate ("não implemente contra uma lição confirmada") — **rejeitada**

Daria dentes à memória e é o que mais parece "fazer a memória valer". Rejeitada por D9: o mesmo agente
escreve e é medido pela lição, então o gate cria incentivo para fabricá-la. E é desnecessário — quando
uma lição precisa ser executável, a graduação (D5) a transforma em decisão com `verification`, e o
review passa a conferi-la pelo mecanismo que já existe e já tem evidência.

### (g) Registrar toda micro-task fechada como aprendizado — **rejeitada**

Garantiria "memória rica" e produziria ruído em volume. A12 é explícita no contrário: resultado limpo
não registra nada. Sem essa recusa, o índice encheria de lições de valor zero e o mecanismo de
relevância morreria no primeiro mês.

### (h) Contrato de leitura sobre três camadas + índice derivado + curadoria com graduação (D1-D13) — **escolhida**

Contra a rubrica 1.2:

| Eixo | Efeito |
|---|---|
| **6 — Memória** (1 → 3 aqui) | O nível 3 pede literalmente *"ADR define camadas, formato, local e contratos de leitura/escrita, sem implementação"* — D1, D2, D3, D4. O nível 4 (*router/discovery/architecture/coding consultam antes de decidir; learnings atualiza ao fechar*) fica integralmente contratado para a 7.2. O nível 5 exige *"regra de consolidação/curadoria e sem duplicar aggregated-learnings/tracking"* — é D5 (graduação) e D1 (nada é copiado) |
| **4 — Mensurabilidade** | Devolve o bloco E ao ADR-004: E1/E2 deixam de ser condicionais por falta de artefato, e `signature` dá lastro estrutural a `recurring_signatures` |
| **5 — Grafos** | Devolve o nó `learning` ao ADR-005 e dá ponta de destino à aresta `learned-from`; `promoted_to` acrescenta uma cadeia rastreável de lição → regra |
| **2 — Arquitetura** | Fecha a delegação do ADR-002 D5/(f) sem duplicar `decisions.yml`, e resolve o único bloco de contexto técnico sem procedência (`code_conventions`, D6) |
| **1 — Brownfield** | Fecha a delegação do ADR-001 D7: a regra de staleness passa a ter consumidor (`staleness[]`) |
| **3 — Fidelidade** | Nenhuma mudança no gate; a proibição explícita de lição-como-evidência protege o contrato do ADR-003 |
| **7 — Custo cognitivo** | O índice é curto por construção, e seu crescimento é sensor de curadoria pendente (D2). Recuperação por adjacência ou por filtro, nunca carga total (D8) |
| **8 — Alucinação** | Três mecanismos duros: *evidência vence snapshot* (D7), *só confirmada é lida* (D5), *nunca carregar C2 inteira* (D8). Mais as recusas de D12 — princípio genérico, escore de lição, cópia autoritativa |
| Custo | Zero skill nova. Dois templates novos (`aggregated-learnings.yml`, `project-memory.yml`), um campo condicional, um passo de leitura em até seis skills, um diretório `docs/memory/`, e disciplina de regeneração |

---

## 5. O que **NÃO** é obrigatório

Nada abaixo é pré-requisito para a memória ser válida, nem para nenhuma skill avançar:

**De conteúdo:**

- O índice inteiro, em projeto que ainda não decidiu nem fechou nada: **criação preguiçosa** (A5). Sem
  memória, a resposta correta é *"não há memória a consultar"*.
- `pitfalls[]` e `calibration[]` antes de existir lição `confirmed`. Zero confirmadas é o estado normal
  de um projeto novo.
- `open_questions[]`, `staleness[]`, `next` — condicionais/opcionais.
- Lição para micro-task que fechou limpa (A12). Ausência é o resultado correto.
- `applies_to`, `signature`, `promoted_to`, `superseded_by` — condicionais.
- Bloco de princípios, constituição do projeto, manifesto, valores — **não existem** (D12).
- Convenção no índice quando nem `decisions.yml` nem o inventário a evidenciam. Convenção sem fonte não
  entra; o `code_conventions` da micro-task fica vazio (D6).
- Número mínimo de lições, de convenções ou de restrições. Uma decisão em vigor → uma linha.

**De formato:**

- Schema JSON para a memória. Os templates bastam, como em `decisions.yml`.
- Arquivo de steering, injeção automática de contexto, integração com o host (D11).
- Banco, índice binário, embeddings, servidor, script, workflow, dashboard (D10).
- Um único arquivo unificando C1, C2 e C3 (alternativa b).
- Histórico de conversa, transcrição, resumo de sessão.

**De processo:**

- Regeneração periódica. Os gatilhos são de evento (D4).
- Humano abrir, aprovar, curar ou preencher a memória. Nada bloqueia esperando isso.
- Rodar `mdpe-learnings` para produzir memória antes de a primeira micro-task fechar.
- Ler a memória quando ela não existe — a leitura degrada para "nada a ler", sem falhar.
- Resolver `staleness[]`, `open_questions[]` ou promover lição candidata para a memória ser válida:
  relatar basta (D9).
- Graduar lição em prazo determinado. Graduação é oportunidade, não SLA.

**Regra geral:** a ausência de item desta lista nunca invalida a memória. O que invalida é linha sem
artefato-fonte, decisão ou convenção **autorada** no índice, lição `candidate` sendo lida como
conselho, lição usada como evidência ou como gate, snapshot vencendo o código, escore de lição, bloco de
princípios genéricos, memória editada à mão, arquivo criado sem memória a indexar, e qualquer instrução
apontando ferramenta ou serviço que não existe.

---

## 6. Consequências

**Positivas**

- Eixo 6 sai de 1 para 3 com este ADR e deixa o 4 inteiramente contratado para a 7.2. Fecha a Lacuna
  6.1 pelo contrato de leitura (D3) e a Lacuna 6.2 pelo template da camada C2 (D5).
- **Duas das três camadas já existem**, então a Fase 7 é majoritariamente **leitura**, não
  instrumentação — o mesmo achado que tornou a Fase 6 barata. O custo real está em um template novo e em
  um passo de leitura por skill.
- **Devolve duas pendências nomeadas** que fases anteriores tiveram de deixar abertas: o bloco E do
  ADR-004 e o nó `learning` do ADR-005 deixam de ser condicionais por falta de artefato.
- **Fecha as três delegações explícitas** que ADR-001 (D7) e ADR-002 (D5, alternativa f) fizeram a este
  ADR. Nenhuma delas fica sem resposta, e nenhuma é respondida duplicando o artefato do delegante.
- Elimina o último lugar do framework que manda preencher contexto técnico **de memória**
  (`code_conventions`, D6) — em um framework cujas cinco skills repetem *"by reference, not from
  memory"*.
- Cria o primeiro contrato de **retomada** do MDPE (D7), com a precedência
  código > artefato > índice escrita como regra e não como recomendação.
- A curadoria por **graduação** (D5) resolve o crescimento sem limite de forma estrutural: a lição que
  mais importa é a que sai da memória e vira regra verificável.
- Nenhum campo obrigatório novo em template existente. Uma adição condicional, e ela **remove**
  preenchimento em vez de acrescentar.

**Negativas / custos**

- **Um artefato derivado a mais para manter fresco.** O índice envelhece em silêncio como o grafo;
  `generated_at` + `branch@commit` tornam o envelhecimento visível, não impossível. Índice desatualizado
  é pior que ausente, porque parece verdade — mitigado por D7 passo 2 (regenerar antes de usar), que é
  disciplina, não mecanismo.
- **O passo de leitura toca até seis skills na 7.2.** É a mudança mais espalhada da v1 até aqui, e cada
  toque é oportunidade de inconsistência entre skills. A 9.2 tem de conferir.
- **`docs/memory/` é mais um diretório de topo**, somando a `docs/architecture/`, `docs/brownfield/`,
  `docs/backlog/`, `docs/tracking/`, `docs/learning-loops/`, `docs/transformation/`, `docs/graph/` e
  `docs/adr/`. E fica a esquisitice de a camada C2 continuar em `docs/learning-loops/` enquanto o índice
  vive em `docs/memory/` — deliberado, porque mover `aggregated-learnings.yml` quebraria o caminho já
  declarado em `mdpe-learnings/SKILL.md`, no `mdpe-tracking.yml` (`sources.aggregated_learnings`) e em
  dois templates do `mdpe-graph`. Candidato explícito de consolidação na 9.1.
- **A promoção de lição é regra, mas a redação da lição não.** `statement` é texto livre escrito pelo
  agente; duas ocorrências do mesmo problema podem gerar duas lições com redações diferentes e nunca
  atingir o limite de duas ocorrências. `signature` mitiga (normaliza pelo sintoma do
  `root_cause_diagnosis`), não elimina.
- **Graduação depende de alguém querer graduar.** Sem SLA (§5) e sem gate (D9), uma lição confirmada
  pode ficar anos no índice. O sensor de tamanho (D2) expõe; não obriga.
- **`retired` acumula no arquivo.** O índice fica curto, o arquivo não. Aceito: histórico em YAML é
  barato, e apagar destruiria a evidência de que a hipótese já foi considerada.
- **Uma adição de campo** (D6), ainda que condicional e redutora, precisa entrar na auditoria 8.1 já
  classificada.
- **Nada garante que o agente leia.** O contrato está na skill, e skill é texto. Este ADR não cria
  enforcement — e o benchmark é honesto sobre isso: TLC e OSpec usam script/hook para o que aqui é
  disciplina. A recusa de tooling (D10) é consciente e tem preço.

**Neutras**

- Nenhuma skill nova. `mdpe-learnings` ganha uma camada para escrever; as demais ganham um passo de
  leitura.
- `decisions.yml`, `inventory.md` e `mdpe-tracking.yml` não têm nem um campo alterado. Seus donos e
  gatilhos permanecem.
- Gates permanecem exatamente onde estavam (D9); a memória informa e roteia.
- Quem não quiser memória simplesmente não tem índice: cada skill segue lendo o que já lia.
- O grafo continua sendo o mecanismo de recuperação preferido quando existe (D8); o índice é o piso, não
  o substituto.

---

## 7. Verificação contra os cenários de teste da tarefa 7.1

| Cenário | Onde é atendido |
|---|---|
| + O ADR define as camadas de memória, formato, local e gatilhos de leitura/escrita | D1 (três camadas, com dono e situação de cada uma) · D2 (formato do índice, bloco a bloco, com fonte por bloco; local `docs/memory/project-memory.yml`) · D3 (gatilhos de leitura por skill) · D4 (gatilhos de escrita por camada) · D5 (formato da lição em C2) |
| + Descreve como discovery/architecture/coding consultam a memória antes de decidir | D3 — tabela com as onze skills: `mdpe-discovery` lê `calibration[]` com `target: discovery` antes de abrir sessão; `mdpe-architecture` lê `pitfalls[]`/`open_questions[]`/`conventions[]` na Fase 0 junto de `decisions.yml`; `mdpe-coding` lê `pitfalls[]` confirmadas **antes da Fase 1**, com a proibição explícita de entrar na cadeia de comandos; `mdpe-router` lê o índice inteiro antes de rotear (D7 passos 1-4) |
| + Evita duplicar o que já existe (aggregated-learnings, tracking) — integra, não recria | D1 (C1 e C3 **existem** e não têm campo alterado; C2 é o caminho já prometido, só sem template) · D1 regra 1 (a memória não copia da C1 nem da C3) · D2 (índice é ponteiro, com uma única cópia admitida, de uma linha, regenerável) · alternativa (b) rejeitada exatamente por duplicar · alternativa (c) rejeitada por não resolver leitura · D12 (recusa de cópia autoritativa) |
| − Memória só de escrita (ninguém lê) reprova | D3 é o contrato de leitura, com "quando" e "o que" por skill; D7 é o contrato de retomada; a Seção 3 torna a existência de ≥1 passo de leitura executável **condição de validade** — memória só de escrita reprova por definição |
| − Proposta que exige infraestrutura externa para o mínimo viável reprova | D10 (nada de banco vetorial, embeddings, MCP de memória, serviço, script; mínimo viável é YAML/Markdown versionado) · D11 (steering do Kiro é exportação opcional, nunca mecanismo) · alternativa (e) rejeitada com o motivo escrito · Seção 3 (nenhuma instrução aponta ferramenta inexistente) |
| Camadas pedidas: (1) memória de projeto (decisões/convenções), (2) aprendizados agregados, (3) execução | D1 mapeia uma a uma: C1 = `decisions.yml` + `inventory.md` §3/§7 · C2 = `aggregated-learnings.yml` · C3 = `mdpe-tracking.yml` |
| Curadoria/consolidação (nível 5 do Eixo 6; cenário negativo da 7.2) | D5 — `candidate` → `confirmed` → `retired`, promoção por ≥2 ocorrências com evidência nomeada ou 1 ocorrência de peso, **graduação** para `decisions.yml`/convenção/skill, aposentadoria com motivo, e resultado limpo que não registra nada |

---

## 8. Fontes

**Internas (lidas para este ADR):** `skills/mdpe-learnings/SKILL.md` (quatro tipos de aprendizado —
*technical, process, strategic, problems*; três alvos de feedback com ação, dono e horizonte; três
outputs prometidos, dos quais dois sem template; *"Do not write from memory of the session"*;
seis regras de escrita do tracking) ·
`skills/mdpe-learnings/assets/templates/mdpe-tracking.yml` (`sources.aggregated_learnings` e
`sources.learnings` marcados `[C] block E`; bloco E anotado como condicional *"that artifact has no
template yet (Phase 7)"*; `aggregates.project.propagation.recurring_signatures` com `signature` +
`occurrences[]` e a nota *"raw material for a confirmed lesson (Phase 7)"*; `signals` com três rotas;
`reconciliation.pending[]`) · `skills/mdpe-router/SKILL.md` (tabela de roteamento, laços de retorno,
diretório de skills — nenhum passo de leitura de estado) · `skills/mdpe-discovery/SKILL.md`
(`## Inputs`: *"optional prior inputs: research, interviews, user data"*) ·
`skills/mdpe-backlog/SKILL.md` (`## Inputs`: só `docs/discovery/01..05-*.yml` + metadados) ·
`skills/mdpe-code-discovery/SKILL.md` (header `verified_at` + `branch @ commit`; §3 convenções
observadas como seção essencial com ≥1 evidência no gate; §7 preocupações/dívida condicional; regra
5 *"code beats documentation, and current evidence beats an old inventory"*; parágrafo *Staleness*
com re-inventário parcial) ·
`skills/mdpe-code-discovery/assets/templates/brownfield-inventory-template.md` (§3 colunas
`Convention` · `Observed rule` · `Evidence`; §7 colunas `Concern` · `Evidence` · `Note`, sem id, sem
severidade, sem data) · `skills/mdpe-architecture/SKILL.md` (Fase 0 lê `decisions.yml` e o inventário;
`implications[].type: conventions`; Fase 5 e o parágrafo que delega *"durable project memory for
principles and conventions … MDPE Phase 7"*; reentrância por `revise`) ·
`skills/mdpe-architecture/assets/templates/architecture-decisions-template.yml` (bloco `principles:`
com a mesma delegação escrita acima da chave) ·
`skills/mdpe-execution-context/SKILL.md` (`## Inputs`: *"aggregated learnings from prior tasks"* sem
caminho; dimensão 6 *"prior learnings applicable to this task"*; saídas em
`docs/execution/{microtask-id}-context.yml` e `-setup.yml`) ·
`skills/mdpe-execution-context/assets/templates/execution-context-template.yml`
(`architecture.*_source: ad-NNN` em seis campos, `decisions_ref`, `applies[]`,
`no_decision_in_scope`; bloco `code_conventions` com `database_naming`/`csharp_naming` e **sem campo
de fonte**; `project_patterns` idem) · `skills/mdpe-coding/SKILL.md` (cadeia de seis fontes de comando
na Fase 0, sem aprendizado; severidade da dimensão 2; registro da ausência de `ad-NNN` como driver de
`mdpe-architecture`) · `skills/mdpe-transformation/SKILL.md` (*"Technical context — by reference, not
from memory"*; `derived_work` como candidato de micro-task) · `skills/mdpe-tasks/SKILL.md`
(*"take it by reference instead of from memory"*; cabeçalho com `ad-NNN` condicional) ·
`skills/mdpe-graph/SKILL.md` e `assets/templates/traceability-graph-template.md` (nó `learning`
condicional, *"no template exists yet"*; pendência de caminho de execução) ·
`skills/mdpe-graph/assets/references/graph-queries.md` (Q3 com semente `ad-NNN`; leitura por
vizinhança como mecanismo, formato da memória deixado para esta fase) ·
`docs/adr/adr-001-brownfield-discovery.md` (D7: `verificado_em`, evidência atual vence inventário,
re-inventário parcial, *"a conexão formal com memória de projeto fica para a Fase 7 (ADR-006)"*) ·
`docs/adr/adr-002-architecture-skill.md` (D5 e alternativa (f): princípios e convenções duráveis são
escopo do ADR-006; linha da tabela de fases: *"`decisions.yml` é a camada log de decisões que o
ADR-006 vai formalizar"*; D6 driver bloqueante; D8 implicações tipadas) ·
`docs/adr/adr-003-loop-engineering.md` (contrato de evidência; `root_cause_diagnosis.symptom` e
rotas; vocabulário de status) · `docs/adr/adr-004-execution-metrics.md` (D1 projeção derivada;
D5 integridade numérica; D6 escrita orientada a evento; D7 ponteiro em vez de cópia; D8 métrica não é
gate; D12 tooling como verificador; bloco E condicional e E2 como matéria-prima da lição) ·
`docs/adr/adr-005-traceability-graph.md` (D1 procedência como condição de existência; D9 regeneração e
auditoria de deriva; D12 grafo não é gate; D15 grafo como índice de recuperação da Fase 7) ·
`docs/analysis/baseline-gap-map.md` (Lacunas 6.1 e 6.2, com critério observável) ·
`docs/analysis/evaluation-rubric.md` (Eixo 6: âncoras 0-5, baseline 1, meta 4) ·
`docs/analysis/competitive-analysis.md` (5.5, 5.6, 5.7, 4.6, 2.4, 2.5; adoções A4, A5, A6, A12, A13;
Seção 6 com ○ do MDPE em log de decisões, handoff, arquivamento e princípios) ·
`docs/analysis/impact-analysis-example.md` (recuperação por adjacência como mecanismo) ·
`README.md` e `INSTALL.md` (as únicas menções a `.kiro`, ambas sobre local de instalação das skills).

**Externas:** TLC Spec-Driven —
[SKILL.md v3.3.0](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md)
(memória de projeto com log de decisões e snapshot de handoff reconciliado contra o estado real, em que
a evidência vence o snapshot desatualizado; camada de lições em que só as confirmadas são carregadas nas
fases de decisão e um resultado limpo não registra nada; orçamento de contexto com carregamento sob
demanda) · OSpec — [clawplays/ospec](https://github.com/clawplays/ospec) (briefing de sessão com
mudanças ativas, estado da fila e próximo passo seguro, lido antes de tocar em qualquer coisa) ·
OpenSpec — [docs/overview.md](https://github.com/Fission-AI/OpenSpec/blob/main/docs/overview.md)
(arquivamento que funde o delta na spec principal e datar a mudança concluída, de modo que a spec passe
a descrever a realidade nova; *enablers, not gates*) · Spec-Kit —
[github/spec-kit](https://github.com/github/spec-kit) (constituição do projeto como princípios
estabelecidos uma vez — adotada apenas parcialmente, ver D12).

> Conteúdo parafraseado a partir das fontes para conformidade de licenciamento; URLs reaproveitadas de
> `competitive-analysis.md`, verificadas em 28/08/2026.
