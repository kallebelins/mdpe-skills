# Evaluation Rubric — Régua de avaliação do framework MDPE

> **Tarefa de origem:** `tasks-v1.md` → Fase 1 → 1.2 (Definir a régua de avaliação do framework).
> **Entrada:** `docs/analysis/baseline-gap-map.md` (auditoria 1.1).
> **Objetivo:** rubrica objetiva (0-5 por critério) em 8 eixos, reutilizável como **definition of done**
> das Fases 2-9, com o **baseline atual pontuado** e a **meta** que cada fase deve atingir.
> **Regra de aceite aplicada:** todo critério tem definição, escala 0-5 com âncoras em **cada nível**
> (não só números), exemplo concreto de nota 0 e nota 5, e nota inicial rastreada a uma lacuna do gap-map.

## Como ler esta rubrica

- **Eixo:** dimensão avaliada. São 8, um por pergunta-tema do usuário (exceto verbosidade e alucinação,
  que compartilham a Fase 8).
- **Escala 0-5:** cada nível tem uma âncora descritiva. Sem âncora → nota inválida.
- **Baseline:** nota atual (agosto/2026), com evidência citando uma lacuna de `baseline-gap-map.md`.
- **Meta / fase:** nota mínima que a fase responsável deve entregar para considerar o eixo "pronto".
- **Uso como DoD:** ao fechar uma fase, repontuar o eixo; se a nota < meta, a fase não está concluída
  (ver Fase 9.3 — repontuação final).

### Semântica comum dos níveis (âncora transversal)

| Nível | Significado geral |
|-------|-------------------|
| **0** | Ausente. A capacidade não existe em nenhuma forma. |
| **1** | Incidental. Só aparece como efeito colateral/exemplo, sem contrato nem gatilho. |
| **2** | Parcial. Dados ou base existem, porém fragmentados e não operáveis de ponta a ponta. |
| **3** | Definido. Há contrato/especificação (ADR/skill/template), mas não é aplicado nem verificável de forma consistente. |
| **4** | Implementado e verificável. Funciona com evidência real; mínimo viável sólido e rastreável. |
| **5** | Otimizado. Verificável, integrado ao fluxo e à memória/métricas, sem referências fantasma nem regressão. |

Cada eixo abaixo especializa esses níveis com âncoras próprias.

---

## Eixo 1 — Cobertura brownfield

**Definição.** Capacidade de adotar o MDPE sobre um repositório que **já contém código**, sem exigir uma
sessão de discovery greenfield completa: inventariar stack/módulos/convenções e reconstruir features a
partir do código real, servindo de ponte para transformation/tasks. Mensurável por: existe gatilho de
entrada para código existente? A saída referencia arquivos reais e verificáveis? O mínimo dispensa
personas/MoSCoW?

| Nível | Âncora |
|-------|--------|
| 0 | Nenhum caminho para código existente; só greenfield. |
| 1 | Existe um fast-path, mas ele enquadra por texto/invenção, não lê o repositório. |
| 2 | Há orientação para olhar o código, porém sem inventário estruturado nem rastreio a arquivos. |
| 3 | ADR define o modo brownfield (entradas/saídas mínimas, o que é dispensável), sem implementação. |
| 4 | Skill/modo brownfield gera inventário + ≥1 feature reconstruída citando arquivos reais; repo vazio não gera features inventadas. |
| 5 | Brownfield roteado pelo router, alimenta arquitetura/transformation e nunca cita caminho inexistente; integrado ao fluxo e à memória. |

- **Exemplo nota 0:** pedir "já tenho código, e agora?" e o framework só oferecer discovery de produto novo.
- **Exemplo nota 5:** apontar a raiz do repo, receber inventário de stack/camadas + features reconstruídas
  com links a arquivos reais, e seguir direto para arquitetura/transformation.
- **Baseline: 1.** Discovery é greenfield-only e exige 20-30 features/personas/MoSCoW; router não tem rota
  de brownfield; o fast-path `mdpe-tasks` deriva de texto, não do código (gap-map Lacunas 2.1, 2.2, 2.3).
- **Meta: 4 — Fase 2** (ADR 2.1 leva a 3; implementação 2.2 leva a 4). Chega a 5 com o wiring da Fase 9.2.

---

## Eixo 2 — Definição de arquitetura

**Definição.** Capacidade de **decidir** padrões de arquitetura a partir do backlog/discovery (estilo,
camadas, padrões, trade-offs, requisitos não-funcionais) e alimentar transformation/execution-context com
essas decisões — em vez de a arquitetura entrar como texto livre ou ser apenas avaliada no review.
Mensurável por: existe artefato de decisão (ADR) rastreado a um item do backlog? Transformation consome
essa saída? Em brownfield, respeita a arquitetura inventariada?

| Nível | Âncora |
|-------|--------|
| 0 | Arquitetura não aparece como conceito próprio. |
| 1 | Arquitetura só existe como dimensão de review e/ou como texto livre/exemplo chumbado. |
| 2 | Há espaço para registrar arquitetura, mas sem rastreio ao backlog nem consumo a jusante. |
| 3 | ADR define como decisões de arquitetura nascem do backlog e onde encaixam no fluxo, sem skill. |
| 4 | `mdpe-architecture` gera decisões + ADR(s) rastreadas ao item; transformation/execution-context referenciam a saída. |
| 5 | Decisões consultam memória/convenções, respeitam arquitetura brownfield existente, e a dimensão "Architecture" de `mdpe-coding` valida contra elas em vez de reavaliar do zero. |

- **Exemplo nota 0:** nenhuma etapa menciona escolha arquitetural em todo o ciclo.
- **Exemplo nota 5:** de `feat-012` sai um ADR (estilo, camadas, trade-offs, NFRs) que a transformation
  cita e que o review usa como baliza, respeitando o padrão já existente no repo.
- **Baseline: 1.** Arquitetura só aparece como dimensão 2 do review em `mdpe-coding` e como "technical
  context" em texto livre; `execution-context-template.yml` chumba `overall_pattern: "Clean Architecture
  with DDD"`; ADRs só existem como exemplos sem produtor (gap-map Lacunas 1.1, 1.2; Seção C).
- **Meta: 4 — Fase 3** (ADR 3.1 → 3; skill 3.2 → 4). Chega a 5 com memória (F7) e o wiring (F9).

---

## Eixo 3 — Fidelidade de implementação e engenharia de loop

**Definição.** Grau em que a execução segue um contrato explícito de loop (plan → act → verify): o agente
**roda** build/lint/testes, itera até verde ou até um limite, nunca declara "pronto" sem evidência de
execução, diagnostica causa-raiz após N falhas, e a saída bate com os critérios de aceite/IOQD da
microtask. Mensurável por: o veredito "aprovado" exige evidência de comando? Há limite de iterações e
comportamento ao estourar? Há rastreio microtask → aceite?

| Nível | Âncora |
|-------|--------|
| 0 | Não há noção de verificar antes de concluir. |
| 1 | Existe um loop return-to-fix, mas depende do agente e permite "aprovado" sem rodar nada. |
| 2 | Recomenda-se verificar, porém sem campo de evidência nem critério de parada. |
| 3 | ADR define o contrato (passos, comandos, limite de iterações, causa-raiz, fidelidade), sem aplicação. |
| 4 | `mdpe-coding` exige evidência por dimensão (comando + resultado) e conta iterações até verde; teste que falha bloqueia "aprovado". |
| 5 | Fidelidade rastreada microtask → IOQD → aceite; evidência alimenta métricas (F5) e o gate barra automaticamente aprovação sem prova. |

- **Exemplo nota 0:** implementar e marcar concluído sem qualquer ideia de teste/verificação.
- **Exemplo nota 5:** cada dimensão do relatório traz o comando executado e sua saída, o nº de iterações
  até verde consta, e uma microtask com teste falho não consegue chegar a "aprovado".
- **Baseline: 1.** `mdpe-coding` tem loop "return to Phase 1" sem obrigar build/testes;
  `validation-report-template.yml` permite `overall_status: approved` sem `commands_executed`/`evidence`
  e não tem campo de iterações (gap-map Lacunas 3.1, 3.2).
- **Meta: 4 — Fase 4** (ADR 4.1 → 3; reforço 4.2 → 4). Chega a 5 ao conectar com métricas (F5).

---

## Eixo 4 — Mensurabilidade (métricas de execução)

**Definição.** Capacidade de medir o processo com um conjunto **sustentável** de métricas derivadas dos
artefatos que o MDPE já gera (validation-report, code-review, learnings), sem depender de tooling
inexistente. Mensurável por: cada métrica aponta o campo/artefato de origem? O que não é sustentável é
opcional/removido? Há frequência e responsável definidos?

| Nível | Âncora |
|-------|--------|
| 0 | Não há métricas. |
| 1 | Tracking existe mas promete automação inexistente (scripts/CI ausentes) e métricas sem fonte derivável. |
| 2 | Algumas métricas têm fonte clara, mas convivem com "referências fantasma" não marcadas. |
| 3 | ADR define o conjunto mínimo, a fonte de cada métrica e a separação automática vs manual, sem aplicar. |
| 4 | `mdpe-tracking.yml` só exige o derivável dos artefatos existentes; nenhuma instrução aponta script/workflow inexistente sem marcação. |
| 5 | Métricas preenchíveis a partir de 1 microtask real; alimentadas pela evidência do loop (F3) e pelo grafo (nº de órfãos, caminho crítico). |

- **Exemplo nota 0:** nenhum lugar registra throughput, retrabalho ou tempo de ciclo.
- **Exemplo nota 5:** o tracking é preenchido só com dados reais de uma microtask, cada métrica aponta o
  campo do artefato de onde vem, e não há promessa de cálculo automático sem ferramenta.
- **Baseline: 1.** `mdpe-tracking.yml` cita `tools/mdpe-status.py`, `.github/workflows/...` e
  `config.auto_calculations` inexistentes, e as métricas não apontam campo de origem (gap-map Lacunas
  4.1, 4.2; Seção C).
- **Meta: 4 — Fase 5** (ADR 5.1 → 3; reconciliação 5.2 → 4). Chega a 5 com loop (F3) e grafo (F6).

---

## Eixo 5 — Visualização e rastreabilidade (engenharia de grafos)

**Definição.** Capacidade de unificar os dados de grafo espalhados por feature em um grafo de
rastreabilidade que ligue toda a cadeia (discovery → feature → microtask → decisão de arquitetura →
artefato/arquivo → aprendizado) e renderizá-lo (Mermaid/DOT), suportando caminho crítico, impacto,
órfãos e ciclos. Mensurável por: existe grafo unificado? Toda aresta é rastreável a um artefato? Renderiza
no Markdown do repo sem tooling pago?

| Nível | Âncora |
|-------|--------|
| 0 | Não há dados de dependência nem diagrama. |
| 1 | Só diagramas chumbados de roteamento; nenhum derivado dos YAMLs. |
| 2 | Dados de grafo são gerados por feature (`dependencies/*.yml`), mas nunca unificados nem renderizados. |
| 3 | ADR define nós/arestas/fontes e casos de uso (visualizar, caminho crítico, impacto, órfãos, ciclos), sem geração. |
| 4 | Gera diagrama Mermaid cujos nós/arestas batem com os YAMLs, distingue waves e caminho crítico, sem aresta inventada. |
| 5 | Rastreabilidade transversal (backlog→arquitetura→microtask→artefato→aprendizado) + análise de impacto/consultas, alimentando métricas (F5) e memória (F7). |

- **Exemplo nota 0:** não há como saber que a microtask B depende da A.
- **Exemplo nota 5:** um diagrama gerado mostra waves e caminho crítico, responde "o que muda se a
  microtask X mudar?" e cada aresta aponta o artefato que a origina.
- **Baseline: 2.** `mdpe-transformation` gera `dependencies/full-graph.yml`, `waves.yml`,
  `critical-path.yml`, `parallelizable.yml` e o tracking tem `dependency_graph`, mas nada os unifica ou
  desenha; rastreio só cobre microtask↔microtask (gap-map Lacunas 5.1, 5.2).
- **Meta: 4 — Fase 6** (ADR 6.1 → 3; geração 6.2 + skill `mdpe-graph` 6.4 → 4; impacto 6.3 → 5).

---

## Eixo 6 — Memória

**Definição.** Capacidade de construir e **recuperar** memória entre sessões: o agente consulta decisões,
convenções e erros recorrentes **antes** de agir, e atualiza a memória ao final. Camadas: projeto
(decisões/convenções), aprendizados agregados (loops) e execução (tracking). Mensurável por: existe
contrato de leitura (quando ler) e de escrita (quando atualizar)? Uma decisão registrada fica legível na
sessão seguinte? Há curadoria/consolidação?

| Nível | Âncora |
|-------|--------|
| 0 | Nada é lembrado entre sessões. |
| 1 | Memória só de escrita: grava aprendizados, mas ninguém os lê antes de decidir; output sem template. |
| 2 | Existe artefato legível, porém sem gatilho de leitura nas skills de entrada. |
| 3 | ADR define camadas, formato, local e contratos de leitura/escrita, sem implementação. |
| 4 | Router/discovery/architecture/coding consultam a memória antes de decidir; learnings a atualiza ao fechar a microtask. |
| 5 | Decisões de uma sessão ficam disponíveis na seguinte, com regra de consolidação/curadoria e sem duplicar aggregated-learnings/tracking. |

- **Exemplo nota 0:** repetir o mesmo erro toda sessão porque nada é consultado.
- **Exemplo nota 5:** ao rotear, o agente lê a memória de projeto, aplica uma convenção decidida antes, e
  ao fechar a microtask registra a nova decisão — que a próxima sessão já enxerga.
- **Baseline: 1.** `mdpe-learnings` grava `aggregated-learnings.yml`, mas o router não tem passo de leitura
  e não há template do agregado (gap-map Lacunas 6.1, 6.2; Seção C).
- **Meta: 4 — Fase 7** (ADR 7.1 → 3; implementação 7.2 → 4). Chega a 5 com curadoria + wiring (F9).

---

## Eixo 7 — Custo cognitivo / verbosidade

**Definição.** Grau em que o framework evita forçar volume: campos essenciais são obrigatórios, os demais
são condicionais/opcionais, e os mínimos rígidos (ex.: "15-25 microtasks") viram faixas orientadas ao
tamanho. Mensurável por: cada campo tem classificação (essencial/condicional/opcional) justificada?
Campos opcionais podem ficar em branco sem reprovar o gate? Itens pequenos são dispensados do mínimo?

| Nível | Âncora |
|-------|--------|
| 0 | Tudo é obrigatório e os mínimos são fixos independentemente do tamanho do item. |
| 1 | Templates sem marcação de opcional; mínimos rígidos (20-30 features, 15-25 microtasks, 6 dimensões sempre). |
| 2 | Alguns campos marcados como opcionais, mas os mínimos rígidos permanecem. |
| 3 | Auditoria classifica cada campo (essencial/condicional/opcional) com justificativa, sem aplicar. |
| 4 | Campos não-essenciais são opcionais e podem ficar vazios sem reprovar; mínimos viram faixas "conforme o tamanho". |
| 5 | Volume proporcional ao item, sem perder rastreabilidade/verificação; conciliado com a exigência de evidência da F4. |

- **Exemplo nota 0:** um item de 4 tarefas obrigado a virar 15-25 microtasks e a preencher 6 dimensões.
- **Exemplo nota 5:** o mesmo item pequeno gera poucas microtasks, deixa opcionais em branco, e ainda
  mantém o rastreio essencial.
- **Baseline: 1.** Mínimos rígidos em discovery/transformation/execution-context; schemas com
  obrigatoriedade profunda; **0 campos** marcados como opcionais nos templates (gap-map Lacunas 8.1, 8.2,
  8.3; Seção B).
- **Meta: 4 — Fase 8** (auditoria 8.1 → 3; enxugamento 8.2 → 4). Chega a 5 conciliado com F4/F9.

---

## Eixo 8 — Risco de alucinação

**Definição.** Grau em que o framework impede conteúdo inventado: diretriz explícita "não invente para
preencher", campos que podem ficar vazios/"desconhecido", e a garantia de que todo caminho de arquivo
citado é real (nunca "TBD" nem referência fantasma). Mensurável por: cada skill tem frase
anti-preenchimento? Existe referência a artefato inexistente? A saída cita apenas arquivos verificáveis?

| Nível | Âncora |
|-------|--------|
| 0 | Nada desencoraja invenção; placeholders e caminhos fictícios são aceitos. |
| 1 | Sem diretriz anti-alucinação; existem referências fantasma (scripts/workflows/outputs sem produtor). |
| 2 | Diretriz mencionada em parte das skills, mas referências fantasma persistem. |
| 3 | Diretriz especificada e referências fantasma inventariadas, sem correção aplicada. |
| 4 | Cada skill afetada tem frase anti-preenchimento; campos opcionais aceitam vazio; nenhum caminho citado é inexistente. |
| 5 | Saída sempre rastreável a artefato real; brownfield/grafo não inventam arquivos/arestas; verificado ponta a ponta (F9.3). |

- **Exemplo nota 0:** feature reconstruída apontando um arquivo que não existe no repo.
- **Exemplo nota 5:** ao faltar dado, a skill deixa o campo vazio/"desconhecido" em vez de inventar, e todo
  caminho citado resolve.
- **Baseline: 1.** Nenhum `SKILL.md` tem frase "não invente"; há referências fantasma
  (`tools/mdpe-status.py`, workflow de CI, outputs sem template) e templates que induzem preenchimento
  (gap-map Lacuna 8.3; Seção C).
- **Meta: 4 — Fase 8** (junto de 8.1/8.2). Chega a 5 com o loop de evidência (F4) e a validação e2e (F9.3).

---

## Eixo 9 — Comunicação de release

**Definição.** Capacidade de encerrar uma feature/versão com um artefato voltado a quem consome o
software (usuário, cliente, suporte) — não ao agente ou ao desenvolvedor — derivado apenas de
micro-tasks efetivamente concluídas e evidenciadas, seguindo um formato padronizado (categorias,
ordem reversa cronológica). Mensurável por: existe artefato de release? Toda entrada rastreia a uma
microtask concluída com evidência? A linguagem é dirigida a quem consome, não a quem implementa?

| Nível | Âncora |
|-------|--------|
| 0 | Nenhum artefato de release existe; nada comunica o que mudou. |
| 1 | Menção informal a "changelog" sem formato nem fonte definida. |
| 2 | Há intenção de registrar mudanças, mas sem categorias nem rastreio a microtask concluída. |
| 3 | ADR define o formato (Keep a Changelog), a fonte de cada entrada e o critério de inclusão, sem skill. |
| 4 | `mdpe-release` gera o changelog só com microtasks `completed`+evidenciadas; nenhuma mudança inventada; categorias corretas. |
| 5 | Changelog + trilha de proveniência interna coexistem; versão anterior nunca é reescrita; alimenta e é alimentado pela memória/tracking. |

- **Exemplo nota 0:** uma feature fecha e não existe em lugar nenhum o que ela entregou, exceto YAML técnico.
- **Exemplo nota 5:** o `CHANGELOG.md` lista a feature em linguagem de usuário, cada linha rastreia a
  1+ `mt-XXX-YYY` `completed` com artefato existente, e a versão anterior permanece intacta.
- **Baseline: 0.** Nenhum artefato de release existe no framework (gap-map Lacuna R.1).
- **Meta: 4 — Fase 10** (ADR 10.1/10.2 → 3-4). Chega a 5 com o wiring e a trilha de proveniência.
- **Repontuado: 4.** `docs/adr/adr-007-release-notes.md` define a fonte/formato/regras;
  `skills/mdpe-release/SKILL.md` + `assets/templates/changelog-template.md` implementam a skill; a
  categorização por evidência (D5) e a imutabilidade de versão publicada (D7) estão no gate. Roteado
  no router, `mdpe-flow.md`, `mapping-commands-to-skills.md` e README (tarefa 10.9). Nível 5 depende
  de uma execução real do framework produzindo `CHANGELOG.md` a partir de microtasks de fato
  concluídas — ainda não verificável sem um projeto em execução (fica para a 10.10/validação e2e).

---

## Eixo 10 — Comunicação com stakeholders (status report)

**Definição.** Capacidade de projetar o estado do projeto em linguagem simples, sem jargão técnico
nem ids obrigatórios no corpo principal, para quem decide sem ler YAML — mantendo, em apêndice,
rastreio a artefato+campo para quem quiser verificar. Mensurável por: existe leitura RAG/1-pager?
Toda afirmação do corpo principal é sustentada por um artefato citável no apêndice? O relatório
decide algo, ou só relata?

| Nível | Âncora |
|-------|--------|
| 0 | Nenhuma projeção de estado em linguagem não-técnica existe. |
| 1 | Estado só é comunicável lendo YAML/Mermaid diretamente (mdpe-graph, tracking). |
| 2 | Há uma leitura de estado (Passo 0 do router), mas em vocabulário técnico (ad-NNN, mt-XXX-YYY). |
| 3 | ADR define o formato (RAG/1-pager), as fontes por seção e a regra de rastreio em apêndice, sem skill. |
| 4 | `mdpe-status-report` gera relatório sem jargão no corpo, com apêndice de proveniência; nada é decidido no relatório. |
| 5 | Relatório distingue accomplished/in-progress/riscos-bloqueios/próximos com fonte em cada bullet; nunca um gate; integrado ao grafo e à memória. |

- **Exemplo nota 0:** um stakeholder só descobre o estado perguntando a um desenvolvedor que abre o YAML.
- **Exemplo nota 5:** o relatório tem farol (verde/amarelo/vermelho) + 4 seções em uma página, e o
  apêndice mostra de onde cada bullet vem.
- **Baseline: 0.** Nenhuma projeção em linguagem simples existe (gap-map Lacuna R.3).
- **Meta: 4 — Fase 10** (ADR 10.5/10.6 → 3-4). Chega a 5 com integração ao grafo/memória.
- **Repontuado: 4.** `docs/adr/adr-009-status-report.md` define o farol derivado de árvore de
  decisão (D4), a regra de zero jargão no corpo (D3) e o apêndice de proveniência (D5);
  `skills/mdpe-status-report/SKILL.md` + `assets/templates/status-report-template.md` implementam a
  skill, já integrada a `mdpe-tracking.yml`, `mdpe-graph` e `project-memory.yml` como fontes (D2, D6).
  Roteado no router/flow/mapping/README (tarefa 10.9). Nível 5 depende de execução real com sinais
  reais (bloqueio, ciclo cross-feature) para confirmar que o farol nunca é opinião — fica para a
  validação e2e (10.10).

---

## Eixo 11 — Retrospectiva de ciclo

**Definição.** Capacidade de agregar múltiplos fechamentos de microtask (via `mdpe-learnings`) em
uma cerimônia de fim de ciclo/feature/sprint: o que funcionou, o que melhorar, itens de ação — cada
um com responsável e horizonte — e uma leitura de tendência de métricas quando há ≥2 ciclos para
comparar. Mensurável por: todo bullet cita evidência (lição/tracking/verdict)? Todo item de ação tem
responsável, mesmo que "a definir"? A tendência só aparece com ≥2 ciclos?

| Nível | Âncora |
|-------|--------|
| 0 | Aprendizados nunca são vistos em conjunto; cada microtask fica isolada. |
| 1 | O registro de lições agrega ocorrências (`candidate`→`confirmed`), mas não produz cerimônia de ciclo. |
| 2 | Há dados suficientes (tracking + lições) para uma retro, mas nenhum artefato os lê como ciclo. |
| 3 | ADR define o formato (o que funcionou / a melhorar / ação), a fonte de cada bullet e a regra de responsável, sem skill. |
| 4 | `mdpe-retro` gera a retro só com evidência (lição/tracking/verdict); todo item de ação tem `owner` (ou "a definir", nunca ausente). |
| 5 | Tendência de métricas entre ciclos citada quando há histórico; itens de ação roteiam aos mesmos 3 alvos de `mdpe-learnings`; nunca um gate. |

- **Exemplo nota 0:** o time nunca vê um retrato consolidado do que fechou bem ou mal no ciclo.
- **Exemplo nota 5:** a retro cita 3 lições confirmadas com evidência, aponta 2 overruns com causa-raiz,
  e cada ação tem responsável e horizonte — comparando com a retro anterior.
- **Baseline: 0.** Nenhuma cerimônia de ciclo existe; agregação para nesse nível de microtask (gap-map
  Lacuna R.4).
- **Meta: 4 — Fase 10** (ADR 10.7/10.8 → 3-4). Chega a 5 com histórico entre ciclos.
- **Repontuado: 4.** `docs/adr/adr-010-cycle-retro.md` define o formato (D4), a regra de `owner`
  sempre presente (D5), o roteamento aos 3 alvos já existentes de `mdpe-learnings` (D6) e a condição
  de existência da seção Trend (D7); `skills/mdpe-retro/SKILL.md` +
  `assets/templates/retro-template.md` implementam a skill, lendo (nunca re-curando)
  `aggregated-learnings.yml` e `mdpe-tracking.yml`. Roteado no router/flow/mapping/README (tarefa
  10.9). Nível 5 depende de ≥2 ciclos reais para exercitar a seção Trend — fica para a validação e2e
  (10.10) e para o segundo ciclo real do projeto.

---

## Placar consolidado (baseline × meta)

| # | Eixo | Pergunta | Baseline | Meta | Fase responsável | Evidência-chave (gap-map) |
|---|------|----------|:-------:|:----:|------------------|---------------------------|
| 1 | Cobertura brownfield | 2 | 1 | 4 | Fase 2 | Lacunas 2.1-2.3 (discovery greenfield-only) |
| 2 | Definição de arquitetura | 1 | 4 | Fase 3 | Lacunas 1.1-1.2 (só review + texto livre) |
| 3 | Fidelidade / loop | 3 | 1 | 4 | Fase 4 | Lacunas 3.1-3.2 (aprova sem evidência) |
| 4 | Mensurabilidade | 4 | 1 | 4 | Fase 5 | Lacunas 4.1-4.2 (tooling inexistente) |
| 5 | Visualização / grafos | 5 | 2 | 4 | Fase 6 | Lacunas 5.1-5.2 (grafo nunca unificado) |
| 6 | Memória | 6 | 1 | 4 | Fase 7 | Lacunas 6.1-6.2 (só escrita; sem template) |
| 7 | Custo cognitivo / verbosidade | 8 | 1 | 4 | Fase 8 | Lacunas 8.1-8.3 (mínimos rígidos; 0 opcionais) |
| 8 | Risco de alucinação | 8 | 1 | 4 | Fase 8 | Lacuna 8.3 + Seção C (referências fantasma) |
| 9 | Comunicação de release | R.1 | 0 | 4 | Fase 10 | Lacuna R.1 (nenhum artefato de release) — **repontuado: 4** |
| 10 | Comunicação com stakeholders | R.3 | 0 | 4 | Fase 10 | Lacuna R.3 (estado só em vocabulário técnico) — **repontuado: 4** |
| 11 | Retrospectiva de ciclo | R.4 | 0 | 4 | Fase 10 | Lacuna R.4 (aprendizado nunca agregado em ciclo) — **repontuado: 4** |

- **Baseline agregado (v1, Eixos 1-8):** 9/40 (média ≈ 1,1/5).
- **Meta agregada da v1 (Eixos 1-8):** 32/40 (média 4,0/5) — mínimo para considerar a v1 pronta.
- **Baseline agregado (Eixos 9-11, Fase 10):** 0/12 (os três nascem em 0 — nenhum artefato existia).
- **Meta agregada da Fase 10 (Eixos 9-11):** 12/12 (4/5 cada) — mínimo para considerar a Fase 10 pronta.
- **Repontuação da Fase 10 (após ADRs 007-010 + as 4 skills + wiring):** 12/12 (4/5 cada) — **meta
  atingida** por especificação e implementação estática (ADR + SKILL.md + templates + roteamento sem
  órfãos). O nível 5 de cada eixo permanece como objetivo pós-implementação: exige uma execução real
  do framework (microtasks de fato concluídas, ≥2 ciclos para a seção Trend de `mdpe-retro`, sinais
  reais de farol para `mdpe-status-report`) — verificação que só a tarefa 10.10/validação e2e pode
  fechar, não a escrita dos artefatos.
- **Nível 5** por eixo é objetivo de maturidade pós-v1/pós-Fase 10, atingido quando o wiring e a
  validação e2e confirmam integração + memória + ausência de regressão.

**Eixo 1 (brownfield) recebe uma extensão na Fase 10**, sem mudar sua meta original (4, já atingida na
v1): a Lacuna R.2 (esquema/banco legado sem código de aplicação legível) é uma variante do mesmo gap
de cobertura brownfield, fechada por `mdpe-data-discovery` como skill irmã de `mdpe-code-discovery` —
mesma postura anti-fabricação, mesmo nível de exigência, escopo diferente (esquema em vez de código de
aplicação). Não abre um eixo 12: é o mesmo eixo, mais uma porta de entrada.

**Extensão repontuada: nível 4 mantido, porta de entrada nova confirmada.**
`docs/adr/adr-008-data-discovery.md` + `skills/mdpe-data-discovery/SKILL.md` +
`assets/templates/data-inventory-template.md` fecham a Lacuna R.2 com a mesma disciplina de
`mdpe-code-discovery` (`dm-NNN`, campo `tabelas` bloqueante, cardinalidade só de constraint real —
D6). Roteado no router/flow/mapping/README (tarefa 10.9), incluindo a composição com
`mdpe-code-discovery` quando ambos existem.

> **Uso como Definition of Done.** Ao encerrar cada fase, repontue o eixo correspondente. Se a nota ficar
> abaixo da meta, a fase não está concluída (Fase 9.3 repontua todos os eixos e compara com este baseline).
> Correção por 2 falhas repetidas: diagnosticar causa-raiz do eixo em vez de subir a nota por opinião.

> Conteúdo redigido a partir de `baseline-gap-map.md` e da leitura direta dos arquivos do repositório.
> Notas de baseline são rastreadas às lacunas evidenciadas; metas seguem o mapa de fases de `tasks-v1.md`.
