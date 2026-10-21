-- scripts/build.py runs this file first, on an empty warehouse.

DROP TABLE IF EXISTS fact_result;
DROP TABLE IF EXISTS dim_race;
DROP TABLE IF EXISTS dim_driver;
DROP TABLE IF EXISTS dim_team;


-- One row per race; storing circuit and country here avoids an extra join for circuit analysis.
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


-- One row per driver; these attributes support driver-level reporting.
CREATE TABLE dim_driver (
    driver_key   integer PRIMARY KEY,
    code         text,
    driver_name  text NOT NULL,
    nationality  text
);

-- One row per team; these attributes support team-level reporting.
CREATE TABLE dim_team (
    team_key    integer PRIMARY KEY,
    team_name   text NOT NULL,
    nationality text
);

-- Grain: one row per driver per race. The primary key enforces it.
CREATE TABLE fact_result (
    race_key        integer NOT NULL REFERENCES dim_race(race_key),
    driver_key      integer NOT NULL REFERENCES dim_driver(driver_key),
    team_key        integer NOT NULL REFERENCES dim_team(team_key),
    grid            integer CHECK (grid >= 0),            -- 0 = pit-lane start
    finish_position integer CHECK (finish_position >= 1), -- retirements still get a position
    is_classified   boolean,
    points          double  CHECK (points >= 0),
    pit_stops       integer NOT NULL CHECK (pit_stops >= 0),
    PRIMARY KEY (race_key, driver_key)
);