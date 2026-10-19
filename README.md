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
