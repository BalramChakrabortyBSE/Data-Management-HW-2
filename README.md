# Data Management — Homework 2

**Addressed for the F1 work:** this README gives setup/run commands and identifies `data/f1.duckdb` and its source.

## Dataset

The source database is `data/f1.duckdb`, containing Formula 1 Grand Prix data for
2014–2025. It is reshaped from [Jolpica-F1](https://github.com/jolpica/jolpica-f1),
the successor to Ergast, and is distributed under
[CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/).

## Setup and run

From the project root, install dependencies, build the warehouse, run the SQL
answers, and launch the dashboard:

```bash
uv sync
uv run python scripts/build.py
uv run python scripts/query.py solution/queries.sql
uv run streamlit run solution/dashboard.py
```

The build reads `data/f1.duckdb` and the SQL files in `solution/` to create
`warehouse.duckdb`. These commands require the course project support files
(`pyproject.toml`, `scripts/`, and `data/`) in addition to the `solution/` files.

## Assignment test results

The test scenarios and their recorded results are in
[`solution/test_scenarios.xlsx`](solution/test_scenarios.xlsx). The checks were
run in the full course project workspace: all 12 scenarios passed, including
the required row count, point totals, SQL answers, dashboard requirements, and
Part 5 explanations.

The test runner is [`solution/test_assignment.py`](solution/test_assignment.py).
To rerun it, use the full course project workspace with its `data/f1.duckdb`,
`scripts/build.py`, and Python dependencies; those support files are not included
in this solution-only repository.
