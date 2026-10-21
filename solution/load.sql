-- Load dimensions and facts from the attached source database.
-- The source database is attached as `src`: read from src.results, src.races, ...

-- One row per race, including circuit attributes for circuit-level analysis.
INSERT INTO dim_race
SELECT r.race_id, r.season, r.round, r.name, r.date, c.name, c.country
FROM src.races r
JOIN src.circuits c ON c.circuit_id = r.circuit_id;


-- dim_driver. The source driver_id is the dimension key.
INSERT INTO dim_driver (driver_key, code, driver_name, nationality)
SELECT
    driver_id,
    code,
    forename || ' ' || surname,
    nationality
FROM src.drivers;


-- dim_team. The source team_id is the dimension key.
INSERT INTO dim_team (team_key, team_name, nationality)
SELECT team_id, name, nationality
FROM src.teams;


-- fact_result: one row per result. Pit stops are counted per entry first, so the join
-- keeps one row per result (joining the raw stops would multiply rows). Entries with no
-- stops get 0.
INSERT INTO fact_result (
    race_key,
    driver_key,
    team_key,
    grid,
    finish_position,
    is_classified,
    points,
    pit_stops
)
SELECT
    e.race_id,
    e.driver_id,
    e.team_id,
    res.grid,
    res.position,
    res.is_classified,
    res.points,
    COALESCE(stops.pit_stops, 0)
FROM src.results res
JOIN src.entries e ON e.entry_id = res.entry_id
LEFT JOIN (
    SELECT entry_id, count(*) AS pit_stops
    FROM src.pit_stops
    GROUP BY entry_id
) stops ON stops.entry_id = res.entry_id;
