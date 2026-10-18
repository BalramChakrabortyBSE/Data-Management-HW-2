-- Your star schema: one fact table and three dimensions, each one join away.
-- scripts/build.py runs this file first, on an empty warehouse.
--
-- fact_result
-- Grain: one row per driver per race.

DROP TABLE IF EXISTS fact_result;
DROP TABLE IF EXISTS dim_race;
DROP TABLE IF EXISTS dim_driver;
DROP TABLE IF EXISTS dim_team;


-- Given, as an example. One row per Grand Prix, with the circuit folded in: grouping
-- by circuit or country costs no extra join. The country repeats on every race held
-- there, on purpose: the load is the only writer, so the copies cannot disagree.
CREATE TABLE dim_race (
    race_key     integer PRIMARY KEY,   -- the source race_id
    season       integer NOT NULL,
    round        integer NOT NULL,
    race_name    text    NOT NULL,
    race_date    date    NOT NULL,
    circuit_name text    NOT NULL,
    country      text    NOT NULL,
    UNIQUE (season, round)
);


-- Your three tables. load.sql fills these columns, so they must exist with these
-- names. Choose the types, the primary keys, and what each key refers to.

-- Columns: driver_key, code, driver_name (forename and surname in one), nationality.
CREATE TABLE dim_driver (
    driver_key   integer PRIMARY KEY,
    code         text,
    driver_name  text NOT NULL,
    nationality  text
);

-- Columns: team_key, team_name, nationality.
CREATE TABLE dim_team (
    team_key    integer PRIMARY KEY,
    team_name   text NOT NULL,
    nationality text
);

-- Columns: race_key, driver_key, team_key, grid, finish_position, is_classified,
-- points, pit_stops (the number of stops that driver made in that race).
-- Make the primary key match the grain above.
CREATE TABLE fact_result (
    race_key integer NOT NULL REFERENCES dim_race(race_key),
    driver_key integer NOT NULL REFERENCES dim_driver(driver_key),
    team_key integer NOT NULL REFERENCES dim_team(team_key),
    grid integer,
    finish_position integer,
    is_classified boolean,
    points double,
    pit_stops integer NOT NULL,
    PRIMARY KEY (race_key, driver_key)
);