<!--
====================================================================
MDPE Framework - Consolidated Task List - Template
====================================================================
Versão: 1.0.0
Propósito: Esqueleto de preenchimento para a skill mdpe-tasks.
            Uma única saída Markdown consolidando discovery-lite +
            transformation-lite + execution-context-lite por tarefa.

Como usar:
  1. Copie este arquivo para docs/mdpe-tasks/{item-id-ou-slug}.md
  2. Preencha o "Resumo do item" (Fase 1 da skill)
  3. Duplique o bloco "Fase N" para cada wave de dependências
  4. Duplique o bloco de tarefa para cada micro-tarefa da wave
  5. Remova estes comentários de instrução ao finalizar
====================================================================
-->

# Tasks — {título do item}

<!-- Resumo do item: framing discovery-lite (Fase 1 da skill) -->
## Resumo do item

- **Objetivo:** {o que este item entrega e para quem}
- **Problema / valor:** {problema resolvido e valor gerado}
- **Escopo (dentro):** {o que está incluso}
- **Escopo (fora):** {o que explicitamente não está incluso}
- **Critérios de aceite do item:**
  - [ ] {critério objetivo de aceite no nível do item}
  - [ ] {critério objetivo de aceite no nível do item}
- **Stakeholders/personas:** {quem é impactado, se conhecido}
- **Riscos/restrições:** {riscos ou restrições conhecidos no nível do item}
- **Contexto técnico padrão:** {stack, padrões, convenções que valem para todas as tarefas, salvo indicação em contrário}

---

<!--
Duplique este bloco de Fase para cada wave (Fase 1 = Wave 1 = sem
dependências, Fase 2 = Wave 2 = depende só da Fase 1, etc.).
Dentro da fase, ordene as tarefas por camada lógica:
Database → Domain → Infrastructure → Application → API → Frontend → Tests → Docs.
-->
## Fase 1 — {rótulo da fase, ex: "Fundação — Database/Domain"} (Wave 1)

<!-- Duplique este bloco de tarefa para cada micro-tarefa da fase -->
- [ ] **{id-da-tarefa}** — {título da tarefa}
  - **Categoria:** {backend | frontend | database | infra | docs | tests} · **Estimativa:** {N}h · **Prioridade:** {Critical | High | Medium | Low}{ · Quick win | · Spike, se aplicável}
  - **Descrição:** {o que deve ser feito, em um parágrafo}
  - **Input:** {o que precisa existir antes: arquivos, dados, contratos, artefatos upstream}
  - **Output:** {o que deve ser produzido: arquivos, artefatos, efeitos colaterais}
  - **Critérios de aceite:**
    - [ ] {critério verificável 1}
    - [ ] {critério verificável 2}
  - **Dependências:** upstream: {ids ou "—"} · downstream: {ids ou "—"}
  - **Arquivos de referência:** `{caminho/para/arquivo-existente}`, `{caminho/para/novo-arquivo}`
  - **Contexto de execução:**
    - Estratégico: {por que esta tarefa importa para o objetivo do item}
    - Técnico: {notas de stack/padrão/convenção específicas desta tarefa, se diferentes do padrão do item}
    - Validação: `{comando ou nome de teste}` → {resultado esperado}
  - **Setup/branch:** `feature/{item-id}/{id-da-tarefa}`

---

## Fase 2 — {rótulo da fase} (Wave 2)

- [ ] **{id-da-tarefa}** — {título da tarefa}
  - **Categoria:** {categoria} · **Estimativa:** {N}h · **Prioridade:** {prioridade}
  - **Descrição:** {descrição}
  - **Input:** {input}
  - **Output:** {output}
  - **Critérios de aceite:**
    - [ ] {critério 1}
  - **Dependências:** upstream: {ids} · downstream: {ids ou "—"}
  - **Arquivos de referência:** `{caminho}`
  - **Contexto de execução:**
    - Estratégico: {texto}
    - Técnico: {texto}
    - Validação: `{comando/teste}` → {resultado esperado}
  - **Setup/branch:** `feature/{item-id}/{id-da-tarefa}`

<!-- Adicione quantas fases forem necessárias, seguindo o mesmo padrão -->

---

## Resumo

| Fase | Tarefas | Estimativa total |
|------|---------|-------------------|
| Fase 1 | {N} | {N}h |
| Fase 2 | {N} | {N}h |
| **Total** | **{N}** | **{N}h** |
