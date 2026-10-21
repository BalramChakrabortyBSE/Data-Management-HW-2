"""Your F1 dashboard, on top of the star in warehouse.duckdb.

    uv run python scripts/build.py           # build the warehouse first
    uv run streamlit run solution/dashboard.py

It opens in your browser and reloads each time you save this file.
"""

from pathlib import Path

import duckdb
import pandas as pd
import streamlit as st

ROOT = Path(__file__).resolve().parent.parent
WAREHOUSE = ROOT / "warehouse.duckdb"


def query(sql: str, params: list | None = None) -> pd.DataFrame:
    """Run one query and return the result as a DataFrame. Use ? for parameters.

    The warehouse is opened read-only for each query and closed straight after, so
    scripts/build.py can rebuild it while the dashboard is running: save, or press R
    in the browser, and the charts pick up the new build.
    """
    path = str(WAREHOUSE) if WAREHOUSE.exists() else ":memory:"
    with duckdb.connect(path, read_only=WAREHOUSE.exists()) as con:
        return con.execute(sql, params or []).df()


st.set_page_config(
    page_title="F1 2014–2025",
    layout="wide",
    initial_sidebar_state="expanded",
)
st.title("Formula 1, 2014–2025")

st.subheader("McLaren scored the most points in 2024 with 609, ahead of Ferrari's 595.")

first, last = st.sidebar.slider("Seasons", 2014, 2025, (2014, 2025))


# --- Race wins per team ---------------------------------------------------------
st.header("Race wins per team")
wins = query(
    """
    SELECT r.season, t.team_name AS team, count(*) AS wins
    FROM fact_result f
    JOIN dim_race r USING (race_key)
    JOIN dim_team t USING (team_key)
    WHERE f.finish_position = 1
      AND r.season BETWEEN ? AND ?
    GROUP BY r.season, t.team_name
    ORDER BY r.season
    """,
    [first, last],
)
st.bar_chart(wins, x="season", y="wins", color="team")


# --- Your chart ----------------------------------------------------------------
# Who scored the most across the slider's seasons, and how did each season go?
st.header("Season points for the five leading drivers")
driver_points = query(
    """
    WITH driver_totals AS (
        SELECT f.driver_key, sum(f.points) AS total_points
        FROM fact_result f
        JOIN dim_race r USING (race_key)
        WHERE r.season BETWEEN ? AND ?
        GROUP BY f.driver_key
        ORDER BY total_points DESC
        LIMIT 5
    )
    SELECT r.season, d.driver_name, sum(f.points) AS points
    FROM fact_result f
    JOIN dim_race r USING (race_key)
    JOIN dim_driver d USING (driver_key)
    JOIN driver_totals top USING (driver_key)
    WHERE r.season BETWEEN ? AND ?
    GROUP BY r.season, d.driver_name
    ORDER BY r.season, points DESC
    """,
    [first, last, first, last],
)
st.line_chart(driver_points, x="season", y="points", color="driver_name")
