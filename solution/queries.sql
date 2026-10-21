-- Part 3, question 1
SELECT
    d.driver_name,
    count(*) FILTER (WHERE f.finish_position = 1) AS wins,
    count(*) FILTER (WHERE f.finish_position <= 3) AS podiums,
    count(*) AS races
FROM fact_result f
JOIN dim_driver d USING (driver_key)
GROUP BY d.driver_key, d.driver_name
ORDER BY wins DESC, podiums DESC, d.driver_name
LIMIT 10;


-- Part 3, question 2
-- Exclude grid = 0 entries because they do not represent a valid starting grid position.
SELECT
    r.circuit_name,
    r.country,
    count(DISTINCT r.race_key) AS races,
    avg(f.grid - f.finish_position) AS avg_places_gained
FROM fact_result f
JOIN dim_race r USING (race_key)
where f.is_classified and f.grid > 0
GROUP BY r.circuit_name, r.country
HAVING count(DISTINCT r.race_key) >= 5
ORDER BY avg_places_gained DESC, r.circuit_name;


-- Part 3, question 3
SELECT
    t.team_name AS team,
    sum(f.points) AS points,
    sum(f.pit_stops) AS pit_stops
FROM fact_result f
JOIN dim_team t USING (team_key)
JOIN dim_race r USING (race_key)
WHERE r.season = 2024
GROUP BY t.team_key, t.team_name
ORDER BY points DESC;
