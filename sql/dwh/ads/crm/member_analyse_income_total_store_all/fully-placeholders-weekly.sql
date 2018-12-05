WITH g AS (
    SELECT date(date_add('day', -dow(date(localtimestamp) - interval '1' day), localtimestamp)) AS first_date_of_week
)
SELECT
    array['store_code'] AS zone,
    array[g.first_date_of_week] AS first_date_of_week
FROM g;
