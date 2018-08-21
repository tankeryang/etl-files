INSERT INTO member_structure_duration (
  duration
)
  SELECT
    1 AS duration
  UNION ALL
  SELECT
    3 AS duration
  UNION ALL
  SELECT
    6 AS duration
  UNION ALL
  SELECT
    12 AS duration;