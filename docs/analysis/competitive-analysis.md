# Competitive Analysis — MDPE vs. frameworks spec-driven / agentic

> **Tarefa de origem:** `tasks-v1.md` → Fase 1 → 1.3 (Benchmark competitivo).
> **Entradas:** `docs/analysis/baseline-gap-map.md` (auditoria 1.1) e `docs/analysis/evaluation-rubric.md` (rubrica 1.2).
> **Objetivo:** por framework, ≥3 pontos fortes com **link de fonte** e veredito **V/F** de "MDPE já tem";
> uma tabela recurso-a-recurso; e uma lista priorizada de adoções, cada uma ligada à fase (2-9) que a implementa.
> **Regra de aceite aplicada:** nenhuma afirmação sobre um framework aparece sem link de fonte.
> Onde a fonte não confirma, o item fica marcado como **não confirmado** e não é aprovado como fato.
> **Data da verificação das fontes:** 27/08/2026.

## Método

1. Leitura das fontes primárias (README/docs oficiais de cada projeto), não de resumos de terceiros,
   exceto onde explicitamente indicado como snapshot secundário.
2. Para cada ponto forte: veredito **V** (MDPE já tem) ou **F** (não tem), justificado com a lacuna
   correspondente de `baseline-gap-map.md`. Quando o MDPE tem só parte, o veredito é **F** e a coluna
   *Nuance* registra o que existe.
3. Cada adoção recomendada é amarrada a uma fase de `tasks-v1.md` e ao artefato-destino daquela fase.

> **Conformidade de licenciamento:** todo conteúdo abaixo foi **parafraseado/resumido** a partir das fontes,
> sem reprodução literal extensa. Substância e conclusões das fontes foram preservadas.
> *Content was rephrased for compliance with licensing restrictions.*

---

## Seção 0 — Resolução do item em aberto: "TLC Spec-Driven"

O backlog (nota de execução) pedia confirmar se "TLC Spec-Driven" é um projeto distinto ou uma variação
genérica de TDD/Spec-Driven. **Confirmado como projeto distinto**, com fonte primária:

- É a skill `tlc-spec-driven`, publicada no catálogo [tech-leads-club/agent-skills](https://github.com/tech-leads-club/agent-skills)
  (destacada no README como skill de Development: planejamento em 4 fases, tarefas atômicas com critério
  de verificação e memória persistente entre sessões).
- Fonte primária do conteúdo:
  [`packages/skills-catalog/skills/(development)/tlc-spec-driven/SKILL.md`](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md)
  — frontmatter declara `name: tlc-spec-driven`, `version: 3.3.0`, licença CC-BY-4.0, autor Felipe Rodrigues.
- Snapshot de uma versão anterior (usado apenas para o material de **brownfield**, que não consta da v3.3.0):
  [LobeHub — tlc-spec-driven](https://lobehub.com/skills/tech-leads-club-agent-skills-tlc-spec-driven).

Consequência: o item **não fica em aberto**, e o TLC entra no benchmark como quinto framework analisado.
Separadamente, "Loop Engineering" também é confirmado como termo com projeto próprio
([clawplays/ospec](https://github.com/clawplays/ospec)), tratado aqui como framework distinto.

**Frameworks analisados (5):** Spec-Kit · OpenSpec · Superpowers · OSpec (Loop Engineering) · TLC Spec-Driven.

---

## Seção 1 — Spec-Kit (github/spec-kit)

Fonte primária: [README](https://github.com/github/spec-kit/blob/main/README.md) ·
[metodologia](https://github.com/github/spec-kit/blob/main/spec-driven.md) ·
[docs](https://github.github.com/spec-kit/).

| # | Ponto forte | Fonte | MDPE já tem? | Nuance / evidência no MDPE |
|---|-------------|-------|:------------:|----------------------------|
| 1.1 | **Constituição do projeto** (`/speckit.constitution`): princípios estabelecidos uma vez por projeto, contra os quais as fases seguintes são avaliadas, mantendo os templates dependentes em sincronia. | [README §3](https://github.com/github/spec-kit/blob/main/README.md) · [reference/agentic-sdd](https://github.github.com/spec-kit/reference/agentic-sdd.html) | **F** | Não existe artefato de princípios/convenções do projeto. A memória do MDPE é só de escrita (gap-map Lacuna 6.1). |
| 1.2 | **Pipeline explícito com passo de convergência**: constitution → specify → plan → tasks → implement → **converge**, repetindo implement+converge até o veredito "Converged". | [README §SDD Quickstart](https://github.com/github/spec-kit/blob/main/README.md) | **F** | O MDPE tem cadeia D→B→T→EC→C→L, mas o loop de correção depende do agente e não exige convergência verificada (Lacuna 3.1). |
| 1.3 | **Passo de clarificação** (`/speckit.clarify`, recomendado antes do plan): resolve áreas subespecificadas antes de planejar. | [README §Available Slash Commands](https://github.com/github/spec-kit/blob/main/README.md) | **F** | Nenhuma skill tem etapa de "perguntar em vez de assumir"; o oposto (mínimos rígidos) força preenchimento (Lacunas 8.1, 8.3). |
| 1.4 | **Análise cross-artefato** (`/speckit.analyze`): consistência e cobertura entre spec, plan e tasks, rodada depois de tasks e antes de implement. | [README §Optional Commands](https://github.com/github/spec-kit/blob/main/README.md) | **F** | O MDPE gera artefatos encadeados mas não verifica consistência entre eles; inconsistências reais existem hoje (gap-map Seção E). |
| 1.5 | **Checklists de qualidade gerados** (`/speckit.checklist`): validam completude, clareza e consistência dos requisitos — descritos como "testes unitários para o texto em inglês". | [README §Optional Commands](https://github.com/github/spec-kit/blob/main/README.md) | **F** | Há *quality gates* por skill, mas fixos e não derivados do conteúdo do item. |
| 1.6 | **Extensibilidade em camadas**: overrides do projeto > presets > extensões > core, resolvidos em tempo de execução; e **bundles** que provisionam um papel inteiro em um comando. | [README §Extensions & Presets / Bundles](https://github.com/github/spec-kit/blob/main/README.md) | **F** | O MDPE é monolítico: 8 skills sem camada de customização nem módulos opcionais. |
| 1.7 | **Brownfield como fase de primeira classe** ("Iterative Enhancement": adicionar features iterativamente, modernizar legado), com guia próprio de evolução de specs. | [README §Development Phases](https://github.com/github/spec-kit/blob/main/README.md) | **F** | Discovery é greenfield-only (Lacuna 2.1) e o router não tem rota de brownfield (Lacuna 2.2). |
| 1.8 | **Fluxos dedicados fora do caminho principal**: extensão de bug (assess → fix → test) e de avaliação de ideia (intake → research → define → shape → decide, com decisão go / needs-clarification / kill). | [README §Bug Fixing / Assessing Ideas](https://github.com/github/spec-kit/blob/main/README.md) | **F** | `mdpe-tasks` é um atalho genérico; não há fluxo de bug nem de triagem de ideia com veredito de "matar". |

---

## Seção 2 — OpenSpec (Fission-AI/OpenSpec)

Fonte primária: [docs/overview.md](https://github.com/Fission-AI/OpenSpec/blob/main/docs/overview.md) ·
[docs/getting-started.md](https://github.com/Fission-AI/OpenSpec/blob/main/docs/getting-started.md) ·
[docs/concepts.md](https://github.com/Fission-AI/OpenSpec/blob/main/docs/concepts.md).

| # | Ponto forte | Fonte | MDPE já tem? | Nuance / evidência no MDPE |
|---|-------------|-------|:------------:|----------------------------|
| 2.1 | **Spec como verdade do presente**: `openspec/specs/` descreve como o sistema se comporta *agora*, organizado por domínio, com requisitos e cenários given/when/then. | [overview §1](https://github.com/Fission-AI/OpenSpec/blob/main/docs/overview.md) | **F** | O MDPE produz artefatos de *intenção* (discovery/backlog/microtask) e nunca consolida um "estado atual" do sistema. Sem isso, brownfield não tem âncora. |
| 2.2 | **Delta specs**: dentro de uma mudança escreve-se só o diff (ADDED / MODIFIED / REMOVED), não o documento inteiro — é o que torna viável especificar mudança em sistema grande sem antes documentá-lo todo. | [overview §3](https://github.com/Fission-AI/OpenSpec/blob/main/docs/overview.md) | **F** | Todo artefato do MDPE é integral. Reescrever o `feat-XXX.yml` completo a cada ajuste é exatamente o vetor de volume/alucinação da Fase 8 (Lacunas 8.1-8.3). |
| 2.3 | **Exploração antes de propor** (`/opsx:explore`): parceiro de raciocínio sem compromisso que **lê o código**, pesa opções e transforma ideia vaga em plano concreto, antes de existir qualquer artefato. | [getting-started](https://github.com/Fission-AI/OpenSpec/blob/main/docs/getting-started.md) · [overview §The loop](https://github.com/Fission-AI/OpenSpec/blob/main/docs/overview.md) | **F** | É literalmente o passo que falta no MDPE brownfield (Lacunas 2.1-2.3). |
| 2.4 | **Arquivamento fecha o ciclo**: ao concluir, os deltas são fundidos nas specs principais e a pasta da mudança vai para um arquivo datado — as specs passam a descrever a nova realidade. | [overview §5](https://github.com/Fission-AI/OpenSpec/blob/main/docs/overview.md) | **F** | O MDPE não tem passo de consolidação/arquivamento; é o risco de "memória que cresce sem curadoria" previsto na Fase 7. |
| 2.5 | **"Enablers, not gates"**: a ordem proposal → specs → design → tasks indica o que se torna *possível*, não o que é *obrigatório*; descobrir na implementação que o design estava errado permite editar o design e seguir. | [overview §Enablers, not gates](https://github.com/Fission-AI/OpenSpec/blob/main/docs/overview.md) | **F** | O MDPE usa *quality gates* rígidos por fase; a filosofia oposta. Relevante para a Fase 8 sem perder a evidência exigida pela Fase 4. |
| 2.6 | **Tradeoff assumido**: para um ajuste realmente trivial, a cerimônia pode não se pagar — e isso é declarado, não escondido. | [overview §Why this is worth the small overhead](https://github.com/Fission-AI/OpenSpec/blob/main/docs/overview.md) | **F** | O MDPE tem o atalho `mdpe-tasks`, mas ele não é enquadrado como "quando não usar o processo completo", e ainda parte de texto livre, não do código (Lacuna 2.3). |

---

## Seção 3 — Superpowers (obra/superpowers)

Fonte primária: [README](https://github.com/obra/superpowers/blob/main/README.md) ·
[skills/writing-skills/SKILL.md](https://github.com/obra/superpowers/blob/main/skills/writing-skills/SKILL.md) ·
[skills/test-driven-development/SKILL.md](https://github.com/obra/superpowers/blob/main/skills/test-driven-development/SKILL.md).

| # | Ponto forte | Fonte | MDPE já tem? | Nuance / evidência no MDPE |
|---|-------------|-------|:------------:|----------------------------|
| 3.1 | **TDD RED-GREEN-REFACTOR imposto**: escrever teste que falha, ver falhar, escrever o mínimo, ver passar, commitar — e apagar código escrito antes do teste. | [README §The Basic Workflow, item 5](https://github.com/obra/superpowers/blob/main/README.md) | **F** | Em `mdpe-coding` a validação é revisão *a posteriori*; o relatório pode ser aprovado sem nenhum comando executado (Lacuna 3.1). |
| 3.2 | **Skills testadas com subagentes sob cenários de pressão**: criar skill *é* TDD aplicado a documentação de processo — roda-se o cenário sem a skill para observar a falha (RED), escreve-se a skill (GREEN) e refatora-se para fechar brechas de racionalização. | [writing-skills/SKILL.md](https://github.com/obra/superpowers/blob/main/skills/writing-skills/SKILL.md) · [docs](https://obra-superpowers.mintlify.app/development/creating-skills) | **F** | O MDPE não tem método para verificar se uma skill **muda o comportamento** do agente. É a peça que falta para a rubrica 1.2 deixar de ser autoavaliação. |
| 3.3 | **Granularidade extrema de plano**: tarefas de 2-5 minutos, cada uma com caminhos de arquivo exatos, código completo e passos de verificação, escritas para um júnior sem contexto de projeto. | [README §The Basic Workflow, item 3](https://github.com/obra/superpowers/blob/main/README.md) | **F** | As microtasks do MDPE têm IOQD e estimativa, mas a contagem é imposta por faixa fixa (15-25) em vez de derivada do trabalho (Lacuna 8.1). |
| 3.4 | **Revisão em dois estágios com subagentes**: um subagente novo por tarefa, revisão de conformidade com a spec e depois de qualidade de código; issues críticas bloqueiam o avanço. | [README §The Basic Workflow, itens 4 e 6](https://github.com/obra/superpowers/blob/main/README.md) | **F** | `mdpe-coding` promete `{id}-code-review.yml` mas **não tem template** para ele (gap-map Seção C) nem severidade que bloqueie. |
| 3.5 | **"Evidence over claims"** como princípio declarado, com skill própria de verificação antes de declarar conclusão. | [README §Philosophy / §What's Inside](https://github.com/obra/superpowers/blob/main/README.md) | **F** | O oposto do estado atual: `validation-report-template.yml` permite `overall_status: approved` sem `commands_executed` (Lacuna 3.1). |
| 3.6 | **Baseline limpo antes de começar**: workspace isolado em worktree/branch nova, setup do projeto rodado e baseline de testes verificado limpo. | [README §The Basic Workflow, item 2](https://github.com/obra/superpowers/blob/main/README.md) | **F** | `mdpe-execution-context` gera `{id}-setup.yml`, mas não exige baseline de teste verde antes de codar. |
| 3.7 | **Skills disparam automaticamente**: o agente checa skills relevantes antes de qualquer tarefa — fluxos obrigatórios, não sugestões. | [README §How it works / §The Basic Workflow](https://github.com/obra/superpowers/blob/main/README.md) | **F** | O MDPE depende do `mdpe-router` ser invocado; não há contrato de disparo automático nem de leitura prévia (Lacuna 6.1). |
| 3.8 | **Harness de avaliação separado** para testes de comportamento de skill. | [README §Contributing](https://github.com/obra/superpowers/blob/main/README.md) | **F** | Não há harness nem cenário de teste executável no repo do MDPE. |

---

## Seção 4 — OSpec / Loop Engineering (clawplays/ospec)

Fonte primária: [README](https://github.com/clawplays/ospec) (inclui `docs/loop-engineering.md` como referência interna).

| # | Ponto forte | Fonte | MDPE já tem? | Nuance / evidência no MDPE |
|---|-------------|-------|:------------:|----------------------------|
| 4.1 | **Loop Engineering como laço verificável plan → act → verify**, com proposta, design, plano, tasks, reviews e **evidência de verificação** salvos no repo, para que outra sessão/assistente retome de onde a anterior parou. | [README §Why OSpec](https://github.com/clawplays/ospec) | **F** | O MDPE tem os artefatos, mas o laço não é imposto e a evidência não é campo obrigatório (Lacunas 3.1, 3.2). |
| 4.2 | **Evidência de execução como registro durável**: a verificação é gravada com o comando, o status e o exit code (`ospec execute verify --command … --status PASSED --exit-code 0`); evidência de teste atual é requisito para o goal ser considerado completo. | [README §Agent Execution](https://github.com/clawplays/ospec) | **F** | Exatamente os campos que faltam em `validation-report-template.yml` (Lacuna 3.1). Serve de modelo direto para a tarefa 4.2. |
| 4.3 | **Reparo limitado com parada dura**: uma revisão de planejamento com NEEDS_CHANGES permite **um** reparo agrupado e no máximo **uma** re-revisão; falha semântica repetida vira bloqueio estável em vez de ciclar; o laço fix→re-verify é limitado. | [README §Goal / §Fast planning quality](https://github.com/clawplays/ospec) | **F** | O MDPE não tem limite de iterações nem diagnóstico de causa-raiz após N falhas (Lacuna 3.2). |
| 4.4 | **Métricas de execução persistidas em artefato**: `execution-metrics.json` registra bytes de pacote/relatório e duração de tarefa; as métricas distinguem cobertura completa, parcial e ausente. | [README §Scoped review evidence and cost metrics / §Measured execution](https://github.com/clawplays/ospec) | **F** | O tracking do MDPE promete cálculo automático via `tools/mdpe-status.py` **inexistente** (Lacuna 4.1, Seção C). |
| 4.5 | **Grafo de tarefas usado para despachar trabalho**: o laço lê `task-graph.json` e emite um lote paralelo seguro contra conflitos, explicando o que reduziu o paralelismo (limites, conflitos do grafo, orçamento, capacidade). | [README §Goal / §Task graph controller](https://github.com/clawplays/ospec) | **F** | O MDPE gera `waves.yml`/`parallelizable.yml` e nunca os usa nem os desenha (Lacuna 5.1). |
| 4.6 | **Briefing de sessão para retomada**: `session-brief.json`/`.md` mostram a quem entra no projeto as mudanças ativas, o estado da fila e **o próximo comando seguro**, antes de tocar em qualquer coisa. | [README §Session brief and hooks](https://github.com/clawplays/ospec) | **F** | É o "contrato de leitura" de memória que falta no MDPE (Lacuna 6.1). |
| 4.7 | **Localizador feature ↔ código**: seções de doc declaram um marcador com slug e caminhos de código, um catálogo mantém uma linha por feature, e um comando devolve a seção e o intervalo de linhas — o agente lê uma seção, não um documento inteiro. | [README §Living feature docs with a locator](https://github.com/clawplays/ospec) | **F** | Resolve três coisas de uma vez no MDPE: rastreio feature→arquivo (Fase 2), nó "artefato/arquivo" do grafo (Fase 6) e economia de contexto (Fase 8). |
| 4.8 | **Obrigações de documentação com modo warn/strict**: as obrigações são derivadas do tipo da mudança e das features, e a configuração decide se uma obrigação não cumprida avisa ou **bloqueia** o arquivamento; hashes antes/depois impedem que um arquivo inalterado satisfaça a obrigação. | [README §Documentation obligations / §Verified durable documentation](https://github.com/clawplays/ospec) | **F** | O MDPE não liga saída a obrigação verificável; é o mecanismo que impediria "referência fantasma" (Seção C). |
| 4.9 | **Auditoria de deriva**: lista as seções cujas paths de código mudaram desde a última mudança registrada. | [README §Documentation obligations](https://github.com/clawplays/ospec) | **F** | Análise de impacto/deriva é justamente a tarefa 6.3, hoje inexistente. |
| 4.10 | **Contratos de comportamento do agente**: "Announce-Before-Act" e "Brainstorm-First" (decisões abertas perguntadas uma a uma antes de travar o design), com hooks que **bloqueiam** despacho de subagente enquanto há decisão pendente. | [README §Goal experience contracts](https://github.com/clawplays/ospec) | **F** | O MDPE não tem contrato de "perguntar antes de decidir" nem enforcement fora do texto da skill. |

---

## Seção 5 — TLC Spec-Driven (tech-leads-club/agent-skills)

Fonte primária: [`SKILL.md` v3.3.0](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md) ·
[README do catálogo](https://github.com/tech-leads-club/agent-skills) ·
snapshot de versão anterior: [LobeHub](https://lobehub.com/skills/tech-leads-club-agent-skills-tlc-spec-driven).

| # | Ponto forte | Fonte | MDPE já tem? | Nuance / evidência no MDPE |
|---|-------------|-------|:------------:|----------------------------|
| 5.1 | **Auto-sizing como princípio central**: a complexidade determina a profundidade, não um pipeline fixo. Small (≤3 arquivos) / Medium / Large / Complex definem se Design e Tasks existem; Specify e Execute são sempre obrigatórios. Há **válvula de segurança**: se a listagem inline revelar mais de ~5 passos, para e cria o `tasks.md` formal. | [SKILL.md §Auto-Sizing](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md) | **F** | O MDPE impõe 20-30 features, 15-25 microtasks e 6 dimensões sempre (Lacuna 8.1). Este é o antídoto exato, e vem com a salvaguarda que evita o extremo oposto. |
| 5.2 | **Criação preguiçosa de artefatos**: só escreve o arquivo quando a fase realmente produziu conteúdo; nunca cria `design.md`/`tasks.md` vazios, porque **arquivo vazio sinaliza que uma fase aconteceu quando não aconteceu** — a ausência é o estado correto de uma fase pulada. | [SKILL.md §.specs Structure](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md) | **F** | Os templates do MDPE têm **0 campos marcados como opcionais** (gap-map Seção B) e induzem preenchimento. Argumento pronto para a tarefa 8.2. |
| 5.3 | **Gates determinísticos por script, não por memória**: validadores de spec, de tasks, de mensagem de commit e de estado; saída diferente de zero significa PARAR e corrigir. O **gate de conclusão** exige que o relatório do verificador exista, com veredito PASS **e citando evidência `arquivo:linha`** — relatório ausente, FAIL, com placeholder ou sem evidência reprova. | [SKILL.md §Deterministic gates](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md) | **F** | Duas lacunas do MDPE de uma vez: aprovação sem evidência (3.1) e tooling prometido e inexistente (4.1). Aqui o script **existe e é enviado com a skill**. |
| 5.4 | **Verificador independente, "evidence-or-zero"**: depois da última tarefa um verificador novo roda **sempre e sem ser pedido**, com autor ≠ verificador, re-derivando a cobertura sem herdar o modelo mental do autor; inclui **sensor de discriminação** que injeta falhas de comportamento em cópia isolada e confirma que os testes as matam — mutantes sobreviventes viram tarefas de correção, e o laço corrigir→re-verificar é limitado a 3 iterações antes de escalar. | [SKILL.md §Sub-Agent Delegation](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md) | **F** | O MDPE valida com o mesmo agente que implementou e sem limite de iterações (Lacunas 3.1, 3.2). |
| 5.5 | **Memória de projeto explícita (`STATE.md`)**: log de decisões com id (AD-NNN) + snapshot de handoff; ao retomar, o snapshot é **reconciliado contra o git** e a evidência real vence um snapshot desatualizado. | [SKILL.md §Workflow / §Commands: Memory](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md) | **F** | O MDPE não tem memória de decisões nem contrato de retomada (Lacuna 6.1). O detalhe "evidência vence snapshot" é anti-alucinação embutido. |
| 5.6 | **Camada de lições auto-evolutiva com curadoria**: estado canônico em JSON de propriedade da máquina, playbook renderizado por script (não editado à mão), e **somente lições confirmadas** são carregadas nas fases de Specify/Design — candidatas nunca; um PASS limpo não registra nada. | [SKILL.md §Context Loading / §Sub-Agent Delegation (5)](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md) | **F** | O `aggregated-learnings.yml` do MDPE não tem template (Lacuna 6.2), não tem status candidate/confirmed e ninguém o lê antes de agir (Lacuna 6.1). |
| 5.7 | **Orçamento de contexto declarado**: carregamento sob demanda, proibição de carregar múltiplas specs ao mesmo tempo, alvo abaixo de ~40k tokens e reserva de 160k+ para o trabalho, com aviso ao exceder. | [SKILL.md §Context Loading Strategy](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md) | **F** | O MDPE não tem política de contexto; templates pesados são carregados integralmente. |
| 5.8 | **Cadeia de verificação de conhecimento com passo de incerteza**: código → docs do projeto → MCP de documentação → busca web → **sinalizar como incerto**; regra explícita de nunca assumir nem fabricar, com "não sei" preferível a inventar, porque API/padrão inventado causa falha em cascata por design → tasks → implementação. | [SKILL.md §Knowledge Verification Chain](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md) | **F** | Nenhum `SKILL.md` do MDPE contém frase anti-invenção (Lacuna 8.3). Este é o modelo textual para a diretriz da tarefa 8.2. |
| 5.9 | **Requisitos em notação EARS + rastreabilidade de requisito + matriz de cobertura de teste**; testes derivam dos critérios de aceite da spec e nunca espelham a implementação; o runner decide, não a autoavaliação. | [SKILL.md §frontmatter / §Execution contract](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md) | **F** | `acceptance_criteria` no MDPE é texto livre sem notação testável nem matriz requisito↔teste. |
| 5.10 | **Delegação a subagentes por orçamento de lote**: conta as tarefas, oferece subagentes acima de ~8, **oferece e confirma — nunca dispara sozinho**, nunca divide uma fase entre workers, lotes rodam em sequência, e há rubrica de nível de modelo por papel (trabalho mecânico em tier barato, design e verificação em tier alto). | [SKILL.md §Sub-Agent Delegation](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md) | **F** | O MDPE calcula waves mas não as usa para despachar nem para dimensionar custo. |
| 5.11 | **Comportamento de saída disciplinado**: fazer o trabalho em vez de narrar a máquina (não anunciar a fase), e escrever artefatos em voz direta, começando pelo veredito e cortando enchimento. | [SKILL.md §Output Behavior](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md) | **F** | Diretamente aplicável ao eixo 7 da rubrica (custo cognitivo/verbosidade). |
| 5.12 | **Regra de raio de impacto**: aprovar spec/tasks autoriza implementação e commits **locais**; push, deploy e mudança em banco de produção exigem autorização explícita para aquela ação. | [SKILL.md §Execution contract (5)](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md) | **F** | `mdpe-coding` fala de branch mas não delimita ações destrutivas. |
| 5.13 | **Composição com skills vizinhas**: verifica se `mermaid-studio` está instalada antes de gerar diagrama e delega; idem `codenavi` para exploração de código existente, com fallback embutido e recomendação exibida no máximo uma vez por sessão. | [SKILL.md §Skill Integrations](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md) | **F** | Modelo de composição/fallback útil para a Fase 6.2 (Mermaid sem tooling obrigatório) e para o wiring da Fase 9. |
| 5.14 | **Arquitetura como família de skills próprias**, não como dimensão de review: o mesmo catálogo traz `coupling-analysis`, `modular-decomposition`, `tactical-ddd`, `legacy-migration-planner`, entre outras, na categoria de arquitetura. | [catálogo de skills](https://github.com/tech-leads-club/agent-skills/tree/main/packages/skills-catalog/skills/%28architecture%29) | **F** | Confirma a direção da Fase 3: no MDPE arquitetura só existe como dimensão 2 do review (Lacuna 1.1). |
| 5.15 | **Mapeamento de brownfield em 7 documentos** (stack, arquitetura, convenções, estrutura, testes, integrações e **preocupações/dívida**), acionado por "mapear codebase", com os docs de código carregados só sob demanda. *Observação de fidelidade:* isso consta do snapshot de versão anterior; na v3.3.0 a exploração de código é delegada à skill `codenavi`. | [LobeHub (snapshot anterior)](https://lobehub.com/skills/tech-leads-club-agent-skills-tlc-spec-driven) · [SKILL.md v3.3.0 §Skill Integrations](https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md) | **F** | Lista pronta de seções para o `brownfield-inventory-template.md` da tarefa 2.2. O doc de "preocupações" (dívida/áreas frágeis) é o que nenhum outro framework analisado tem. |

---

## Seção 6 — Tabela recurso-a-recurso

**Legenda:** ● tem · ◐ parcial · ○ não tem · — não se aplica ao escopo do projeto.
A coluna *MDPE hoje* usa a evidência de `baseline-gap-map.md`; a coluna *Fase* indica quem fecha a lacuna.

| Recurso | Spec-Kit | OpenSpec | Superpowers | OSpec | TLC | **MDPE hoje** | Fase |
|---|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Princípios/constituição do projeto | ● | ◐ | ○ | ◐ | ◐ | ○ | 7 |
| Passo de clarificação/discussão antes de planejar | ● | ● | ● | ● | ● | ○ | 8 / 2 |
| Exploração do **código existente** antes de propor | ◐ | ● | ○ | ◐ | ● | ○ | 2 |
| Inventário de brownfield estruturado (stack/convenções/dívida) | ○ | ◐ | ○ | ◐ | ● | ○ | 2 |
| Spec durável do "estado atual" do sistema | ◐ | ● | ○ | ● | ◐ | ○ | 7 / 2 |
| Mudança incremental por **delta** (ADDED/MODIFIED/REMOVED) | ○ | ● | ○ | ◐ | ○ | ○ | 2 / 8 |
| Auto-sizing da profundidade por escopo | ◐ | ◐ | ○ | ◐ | ● | ○ | 8 |
| Criação preguiçosa de artefatos (nada de arquivo vazio) | ○ | ◐ | ○ | ◐ | ● | ○ | 8 |
| Diretriz explícita anti-fabricação | ○ | ○ | ◐ | ◐ | ● | ○ | 8 |
| Orçamento/política de contexto | ○ | ○ | ○ | ● | ● | ○ | 8 |
| Decisões de arquitetura como artefato próprio | ● | ● | ◐ | ● | ● (catálogo) | ○ | 3 |
| Tarefas atômicas com critério de verificação | ● | ● | ● | ● | ● | ◐ | 4 |
| TDD red-green obrigatório | ○ | ○ | ● | ◐ | ● | ○ | 4 |
| **Evidência de execução persistida** (comando + resultado) | ◐ | ○ | ● | ● | ● | ○ | 4 |
| Verificador independente (autor ≠ verificador) | ○ | ○ | ● | ● | ● | ○ | 4 |
| Limite de iterações / reparo limitado | ● | ○ | ◐ | ● | ● | ○ | 4 |
| Gates determinísticos executados por script | ◐ | ● | ◐ | ● | ● | ○ | 4 / 5 |
| Análise de consistência cross-artefato | ● | ◐ | ○ | ● | ◐ | ○ | 6 / 9 |
| Métricas de execução persistidas em artefato | ○ | ○ | ○ | ● | ◐ | ◐ (fantasma) | 5 |
| Grafo de tarefas usado para **despachar** trabalho | ○ | ○ | ● | ● | ● | ○ | 6 |
| Visualização de grafo/diagrama gerada dos dados | ○ | ○ | ○ | ◐ | ◐ (delega) | ○ | 6 |
| Análise de impacto / deriva | ○ | ◐ | ○ | ● | ◐ | ○ | 6.3 |
| Log de decisões recuperável entre sessões | ● | ● | ○ | ● | ● | ○ | 7 |
| Handoff / retomada de sessão reconciliada | ○ | ◐ | ○ | ● | ● | ○ | 7 |
| Lições com curadoria (candidata vs confirmada) | ○ | ○ | ○ | ◐ | ● | ◐ | 7 |
| Arquivamento/consolidação ao concluir | ○ | ● | ◐ | ● | ◐ | ○ | 7 |
| Rastreabilidade requisito ↔ teste ↔ arquivo | ◐ | ● | ◐ | ● | ● | ◐ | 9 / 6 |
| Delegação a subagentes com orçamento | ○ | ○ | ● | ● | ● | ○ | 6 |
| Extensibilidade/presets/módulos opcionais | ● | ◐ | ◐ | ◐ | ● (catálogo) | ○ | 8 / 9 |
| Teste de comportamento da própria skill | ○ | ○ | ● | ○ | ● (eval própria) | ○ | 1 / 9.3 |
| Regra de raio de impacto (ações destrutivas) | ○ | ○ | ◐ | ◐ | ● | ○ | 4 |
| Fluxo dedicado de bug / triagem de ideia | ● | ◐ | ○ | ● | ● (quick mode) | ◐ | 9 |
| Backlog cognitivo com personas/RICE/MoSCoW | ○ | ○ | ○ | ○ | ○ | ● | — |
| Dimensões de contexto de execução formalizadas | ○ | ○ | ○ | ◐ | ◐ | ● | — |
| Ondas/caminho crítico computados por feature | ○ | ○ | ○ | ● | ◐ | ● (só dados) | 6 |

### Onde o MDPE está à frente

Três recursos em que nenhum dos cinco frameworks analisados chega ao nível do MDPE — e que a v1 deve
**preservar** ao enxugar (risco explícito da Fase 8):

1. **Backlog cognitivo estruturado** com personas, critérios de valor, hipóteses e priorização
   (`cognitive-backlog.schema.json`). Os cinco frameworks entram no ciclo já com a feature decidida;
   nenhum modela descoberta de produto. Spec-Kit é o que mais se aproxima, com a extensão de
   avaliação de ideia ([README §Assessing Ideas](https://github.com/github/spec-kit/blob/main/README.md)).
2. **Contexto de execução como artefato dimensionado** (`execution-context-template.yml`): os outros
   carregam contexto sob demanda, mas não o formalizam como entrega auditável.
3. **Dados de onda/caminho crítico/paralelizável por feature** já computados (`dependencies/*.yml`).
   OSpec e TLC têm o despacho, o MDPE tem o cálculo — falta ligar os dois (Fase 6).

---

## Seção 7 — Adoções priorizadas

14 recomendações, cada uma com origem, fase de `tasks-v1.md` que a implementa e artefato-destino.
Prioridade: **P0** = destrava a meta da rubrica de um eixo · **P1** = ganho alto no mesmo eixo ·
**P2** = melhoria desejável, pode ficar pós-v1.

| # | Prio | Adoção | Origem | **Fase** | Artefato-destino |
|---|:----:|--------|--------|:--------:|------------------|
| A1 | **P0** | **Evidência de execução obrigatória**: cada dimensão de validação registra comando, resultado e exit code; sem evidência não existe veredito "aprovado". | OSpec 4.2 · TLC 5.3 · Superpowers 3.5 | **4.1 / 4.2** | `docs/adr/adr-003-loop-engineering.md`; `skills/mdpe-coding/assets/templates/validation-report-template.yml` |
| A2 | **P0** | **Loop limitado**: contador de iterações até verde, limite explícito, e após N falhas diagnóstico de causa-raiz + parada em vez de patch incremental. | OSpec 4.3 · TLC 5.4 | **4.1 / 4.2** | `adr-003-loop-engineering.md`; `skills/mdpe-coding/SKILL.md` |
| A3 | **P0** | **Auto-sizing**: substituir "20-30 features" e "15-25 microtasks" por faixas derivadas do escopo (P/M/G/Complexo), **com válvula de segurança** que exige o artefato formal quando a listagem inline passa do limite. | TLC 5.1 | **8.1 / 8.2** | `docs/analysis/field-obligation-audit.md`; `skills/mdpe-discovery/SKILL.md`; `skills/mdpe-transformation/SKILL.md` |
| A4 | **P0** | **Diretriz anti-fabricação + cadeia de verificação de conhecimento** em cada skill: código → docs → fonte externa → sinalizar incerteza; "não sei" é resposta válida, inventar não. | TLC 5.8 | **8.2** | `skills/*/SKILL.md` |
| A5 | **P0** | **Criação preguiçosa de artefatos**: nunca gerar arquivo/campo vazio; ausência é o estado correto de uma fase pulada, e arquivo vazio é considerado sinal falso. | TLC 5.2 | **8.1 / 8.2** | `docs/analysis/field-obligation-audit.md`; `skills/*/assets/templates/*` |
| A6 | **P0** | **Memória de projeto legível com contrato de retomada**: log de decisões com id + snapshot de handoff, reconciliado contra o estado real do repo (evidência vence snapshot desatualizado). | TLC 5.5 · OSpec 4.6 | **7.1 / 7.2** | `docs/adr/adr-006-memory-model.md`; `skills/mdpe-learnings/assets/templates/project-memory-template.yml`; `skills/mdpe-router/SKILL.md` |
| A7 | **P0** | **Exploração do código antes de propor + inventário brownfield** com seções fixas: stack, arquitetura, convenções, estrutura, testes, integrações e **preocupações/dívida**. | OpenSpec 2.3 · TLC 5.15 | **2.1 / 2.2** | `docs/adr/adr-001-brownfield-discovery.md`; `brownfield-inventory-template.md` |
| A8 | **P1** | **Verificador independente (autor ≠ verificador)** rodando ao fechar a microtask, re-derivando cobertura em vez de herdar o raciocínio de quem implementou. | TLC 5.4 · Superpowers 3.4 | **4.2** | `skills/mdpe-coding/SKILL.md`; template de `{id}-code-review.yml` (hoje inexistente — gap-map Seção C) |
| A9 | **P1** | **Métrica derivada de artefato, nunca de tooling inexistente**: cada métrica aponta campo de origem; o que exige script é marcado como opcional ou removido. | OSpec 4.4 · TLC 5.3 | **5.1 / 5.2** | `docs/adr/adr-004-execution-metrics.md`; `skills/mdpe-learnings/assets/templates/mdpe-tracking.yml` |
| A10 | **P1** | **Localizador feature ↔ arquivo** com paths declarados e catálogo de uma linha por feature, servindo de nó "artefato/arquivo" do grafo e de âncora de rastreio. | OSpec 4.7 | **6.1 / 6.2** (consome 2.2) | `docs/adr/adr-005-traceability-graph.md`; `traceability-graph-template.md` |
| A11 | **P1** | **Grafo que despacha, não só desenha**: usar `waves.yml`/`parallelizable.yml` para dizer o que roda agora e por que o paralelismo foi reduzido. | OSpec 4.5 · TLC 5.10 | **6.3 / 6.4** | `skills/mdpe-graph/SKILL.md`; `docs/analysis/impact-analysis-example.md` |
| A12 | **P1** | **Lições com estado candidata → confirmada**, carregando só confirmadas nas fases de decisão, e sem registrar nada quando o resultado é limpo (curadoria embutida). | TLC 5.6 | **7.2** | `skills/mdpe-learnings/SKILL.md`; template de `aggregated-learnings.yml` (hoje inexistente) |
| A13 | **P2** | **Análise cross-artefato de consistência** antes de codar (backlog ↔ arquitetura ↔ microtask ↔ tasks.md), incluindo detecção de órfãos e caminho quebrado. | Spec-Kit 1.4 · OSpec 4.9 | **6.3 / 9.1** | `skills/mdpe-graph/SKILL.md`; `skills/*/SKILL.md` |
| A14 | **P2** | **Teste de comportamento da própria skill** com cenários de pressão em subagente (baseline sem a skill → com a skill → fechar brechas), para que a repontuação da rubrica deixe de ser autoavaliação. | Superpowers 3.2 | **9.3** | `docs/analysis/v1-validation-report.md` |

### Adoções deliberadamente recusadas (com motivo)

Registrar o "não" evita adotar por moda — e é a mesma disciplina exigida da Fase 3 (não gerar padrão da moda
sem justificativa):

- **Deltas ADDED/MODIFIED/REMOVED como formato de mudança do backlog** (OpenSpec 2.2): conceitualmente
  o melhor remédio contra volume, mas exige uma spec durável de "estado atual" que o MDPE não tem antes
  da Fase 7. Fica registrado como candidato pós-v1, dependente de A6 + A7.
- **CLI/tooling próprio** (Spec-Kit, OpenSpec, OSpec, e os scripts Python do TLC): o MDPE já sofre por
  referenciar tooling inexistente (Lacuna 4.1). Adotar CLI agora repetiria o erro. A v1 mantém o princípio
  ("gate verificável") sem a dependência de binário — decisão a formalizar na tarefa 5.1.
- **Worktrees obrigatórias** (Superpowers 3.6): valor real, mas amarra o framework a git + layout de
  workspace. Entra como recomendação opcional na Fase 4, não como gate.
- **Rubrica de tier de modelo por papel** (TLC 5.10): depende do harness permitir escolher modelo por
  subagente; portável apenas como sugestão. Fora do escopo da v1.

---

## Seção 8 — Impacto esperado na rubrica

Cada eixo de `evaluation-rubric.md` e quais adoções sustentam o salto até a meta:

| Eixo (rubrica 1.2) | Baseline | Meta | Adoções que sustentam | Fase |
|---|:---:|:---:|---|:---:|
| 1 Cobertura brownfield | 1 | 4 | A7 (+ A10 para rastreio a arquivo real) | 2 |
| 2 Definição de arquitetura | 1 | 4 | TLC 5.14 / Spec-Kit 1.1 como referência de "arquitetura é artefato, não dimensão de review" | 3 |
| 3 Fidelidade / loop | 1 | 4 | A1, A2, A8 | 4 |
| 4 Mensurabilidade | 1 | 4 | A9 (e a recusa de CLI própria, que evita nova referência fantasma) | 5 |
| 5 Visualização / grafos | 2 | 4 | A10, A11, A13 | 6 |
| 6 Memória | 1 | 4 | A6, A12 | 7 |
| 7 Custo cognitivo / verbosidade | 1 | 4 | A3, A5 (+ TLC 5.7 orçamento de contexto, TLC 5.11 voz do artefato) | 8 |
| 8 Risco de alucinação | 1 | 4 | A4, A5, A1 (evidência bloqueia veredito inventado) | 8 |

Nenhum eixo fica sem adoção associada, e nenhuma adoção P0/P1 fica sem fase — condição para a Fase 9.3
poder repontuar comparando com o baseline de 9/40.

---

## Resumo

- **5 frameworks** analisados, todos com fonte primária: Spec-Kit (8 pontos fortes), OpenSpec (6),
  Superpowers (8), OSpec/Loop Engineering (10), TLC Spec-Driven (15) — **47 pontos fortes**, cada um com
  link e veredito V/F de "MDPE já tem".
- **Veredito agregado:** dos 47 pontos, **0 recebem V**. O MDPE tem sobreposição parcial em vários
  (registrada na coluna *Nuance*), mas nenhum no nível verificável descrito pela fonte — coerente com o
  baseline agregado de 9/40 da rubrica.
- **Item em aberto resolvido:** "TLC Spec-Driven" **é** projeto distinto (skill `tlc-spec-driven` v3.3.0
  no catálogo tech-leads-club/agent-skills) e passa a ser a fonte mais densa do benchmark — sozinho
  alimenta 6 das 14 adoções, e as 4 de maior prioridade em anti-alucinação e memória.
- **14 adoções priorizadas** (7 P0, 5 P1, 2 P2), todas mapeadas a uma fase entre 2 e 9 e a um
  artefato-destino nominal; **4 adoções recusadas** com motivo registrado.
- **Achado mais acionável:** três frameworks independentes (OSpec, TLC, Superpowers) convergem para a
  mesma regra — *conclusão exige evidência de execução, com autor ≠ verificador e laço limitado*. É
  exatamente a Lacuna 3.1/3.2 do MDPE, e por isso A1 e A2 são as adoções de maior prioridade da v1.

### Fontes

- github/spec-kit — https://github.com/github/spec-kit · README: https://github.com/github/spec-kit/blob/main/README.md · metodologia: https://github.com/github/spec-kit/blob/main/spec-driven.md · docs: https://github.github.com/spec-kit/
- Fission-AI/OpenSpec — https://github.com/Fission-AI/OpenSpec · overview: https://github.com/Fission-AI/OpenSpec/blob/main/docs/overview.md · getting-started: https://github.com/Fission-AI/OpenSpec/blob/main/docs/getting-started.md · concepts: https://github.com/Fission-AI/OpenSpec/blob/main/docs/concepts.md
- obra/superpowers — https://github.com/obra/superpowers · writing-skills: https://github.com/obra/superpowers/blob/main/skills/writing-skills/SKILL.md · test-driven-development: https://github.com/obra/superpowers/blob/main/skills/test-driven-development/SKILL.md · docs: https://obra-superpowers.mintlify.app/development/creating-skills
- clawplays/ospec — https://github.com/clawplays/ospec
- tech-leads-club/agent-skills — https://github.com/tech-leads-club/agent-skills · `tlc-spec-driven` v3.3.0: https://github.com/tech-leads-club/agent-skills/blob/main/packages/skills-catalog/skills/%28development%29/tlc-spec-driven/SKILL.md · catálogo de arquitetura: https://github.com/tech-leads-club/agent-skills/tree/main/packages/skills-catalog/skills/%28architecture%29 · snapshot de versão anterior: https://lobehub.com/skills/tech-leads-club-agent-skills-tlc-spec-driven
- Mermaid (referenciado pela Fase 6) — https://mermaid.js.org/ · Graphviz — https://graphviz.org/

> Fontes verificadas em 27/08/2026. Conteúdo parafraseado/resumido a partir das fontes, sem reprodução
> literal extensa, para conformidade de licenciamento. *Content was rephrased for compliance with
> licensing restrictions.*
