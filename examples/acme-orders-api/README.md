# Acme Orders API (MDPE brownfield validation fixture)

Minimal, real Python repository used as the end-to-end validation fixture for
`tasks-v1.md` task 9.3. It exists to prove the MDPE pipeline against **real,
executable code** — every command in the artifacts under `docs/` was actually
run against this repository, and every file path cited actually exists.

Pre-existing code (before MDPE was adopted): `src/orders/order.py` and
`tests/test_order.py`. Everything under `docs/` was produced by walking the
MDPE skills against this repository, in order: `mdpe-code-discovery` →
`mdpe-architecture` → `mdpe-transformation` → `mdpe-execution-context` →
`mdpe-coding` → `mdpe-learnings` → `mdpe-graph`.

Run the tests:

```
python -m pytest tests/ -v
```
