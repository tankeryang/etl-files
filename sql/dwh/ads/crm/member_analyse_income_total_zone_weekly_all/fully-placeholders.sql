WITH g AS (
    SELECT cast(dow(localtimestamp) AS VARCHAR) AS gap
), gg AS (
    SELECT date(localtimestamp) - interval g.gap day AS week_head_date FROM g
)
SELECT
    array['country', 'sales_area', 'sales_district', 'province', 'city'] AS zone,
    array[gg.week_head_date] AS gap
FROM gg;