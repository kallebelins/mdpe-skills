# Brownfield inventory — acme-orders-api

- **repo:** `examples/acme-orders-api` (workspace `mdpe-skills`)
- **scope:** root
- **verified_at:** 2026-08-28 · `main @ 4ce53e6`
- **depth:** S (3 code files in scope: `src/orders/__init__.py`, `src/orders/order.py`, `tests/test_order.py`)

## 1. Stack & runtime

| Item | Value | Evidence |
|---|---|---|
| Language | Python | file extension `.py` and syntax of `src/orders/order.py`, `tests/test_order.py` (no manifest exists to confirm a version) |
| Framework(s) | none | no import outside the standard library (`dataclasses`, `enum`, `pathlib`, `sys`) in `src/orders/order.py` or `tests/test_order.py` |
| Package manager | unknown | no `pyproject.toml`, `requirements.txt`, `setup.py`, or lockfile present in `examples/acme-orders-api/` |
| Runtime / target Python version | unknown | no manifest pins a version; the interpreter used to verify this inventory was CPython 3.14.6, which is a run-time fact, not a repo declaration |
| Data store | none | no persistence code or client in scope |
| Build command | not applicable | no build step; pure Python source, nothing compiled |
| Test command | `python -m pytest tests/ -v` | stated verbatim in `README.md` ("Run the tests") and confirmed by executing it: 4 passed |

## 2. Structure & modules

```
examples/acme-orders-api/
├── README.md
├── src/
│   └── orders/
│       ├── __init__.py       (empty)
│       └── order.py           (domain model)
└── tests/
    └── test_order.py
```

**Observed layers / modules**

| Module or layer | Path | Responsibility as observed | Evidence |
|---|---|---|---|
| `orders` domain module | `src/orders/order.py` | Defines the `Order` aggregate and `OrderStatus` enum; holds all business logic (add item, ship) | only file under `src/`; no `application`, `infrastructure`, or `api` subfolder exists |
| Tests | `tests/test_order.py` | Exercises `Order` behavior directly against the domain module | `sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))` then `from orders.order import Order, OrderStatus` |

There is no layering to observe beyond a single domain module: no persistence, no API, no application/service layer exist in scope. Any layered structure introduced later is new territory, not a departure from an existing pattern.

## 3. Observed conventions

| Convention | Observed rule | Evidence |
|---|---|---|
| Domain modeling | `@dataclass` for the aggregate, `Enum` for status, no framework base class | `src/orders/order.py` — `class OrderStatus(Enum)`, `@dataclass class Order` |
| Invariant validation | Guard clauses raising `ValueError` with a lowercase message, no custom exception hierarchy | `order.py` — `add_item` raises `ValueError("quantity must be positive")`; `ship` raises `ValueError("cannot ship an order with no items")` |
| Test layout | One flat `tests/test_order.py`, one `test_*` function per behavior, no test class, no fixtures/framework decorators | `tests/test_order.py` |
| Exception assertions | `try/except ValueError: pass` after an explicit `assert False, "expected ValueError"`, instead of `pytest.raises` | `tests/test_order.py` — `test_add_item_rejects_non_positive_quantity`, `test_ship_requires_items` |
| Import path resolution | Tests reach `src/` via a manual `sys.path.insert`, not an installed/editable package | `tests/test_order.py`, lines 1-4 |
| Docstring header | Module docstring states pre-existing/brownfield status and its lack of framework dependency | `order.py` module docstring |

## 4. Reconstructed features

| id | name | description (today) | files | confidence | gaps |
|---|---|---|---|:---:|---|
| cf-001 | Add item to order | An order accumulates `{sku, quantity}` line items; quantity must be positive or the call is rejected | `src/orders/order.py`, `tests/test_order.py` | high | — |
| cf-002 | Ship order | An order with ≥1 item can transition from `created` to `shipped`; an order with no items cannot ship | `src/orders/order.py`, `tests/test_order.py` | high | — |

No cancellation, persistence, or API surface exists yet — not inferred, not present in the code.

## 6. Test strategy

- **Frameworks:** pytest — evidence: `.pytest_cache/CACHEDIR.TAG` present, README's run command, and the actual run (`python -m pytest tests/ -v` → 4 passed, 0.02s, pytest 9.1.1 / Python 3.14.6, executed 2026-08-28 for this inventory).
- **Levels present:** unit (direct calls against the `Order` dataclass, no I/O) — evidence: `tests/test_order.py`.
- **How to run:** `python -m pytest tests/ -v` — evidence: `README.md`.
- Coverage: not measured — no coverage config, no `--cov` flag in the README's run command, no coverage report file in the repo.

## 7. Concerns / debt

| Concern | Evidence | Note |
|---|---|---|
| No packaging manifest | no `pyproject.toml`, `setup.py`, or `requirements.txt` in `examples/acme-orders-api/` | the package is not pip-installable; tests reach `src/` only via a manual `sys.path.insert` in `tests/test_order.py` |
| Exception-assertion idiom predates `pytest.raises` | `tests/test_order.py` — `test_add_item_rejects_non_positive_quantity`, `test_ship_requires_items` use `try/except` + `assert False` instead of `pytest.raises(ValueError)` | not a defect, but a convention any new test in this module should either follow or deliberately supersede (see `ad-001`, driver D2) |

## Next step

- **Route:** `mdpe-architecture` (existing architecture — a plain, framework-free domain object — is a candidate constraint before adding new domain behavior), then `mdpe-tasks` for the small item ahead (~3 tasks: add `Order.cancel()`, its tests, and the README update).
- **How this inventory is consumed:** `cf-001`/`cf-002` and this file's §2-§3 become the *existing architecture* driver for `ad-001` (`mdpe-architecture`); the `files` above become the concrete **Reference files** of the micro-tasks in `docs/transformation/feat-001/` once the cancellation feature is decomposed (`mdpe-transformation`).
