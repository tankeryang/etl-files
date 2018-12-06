WITH g AS (
    SELECT date(date_add('day', -day(date(localtimestamp)), localtimestamp)) AS last_date_of_last_month
)
SELECT
    array['store_code'] AS zone,
    array[g.last_date_of_last_month] AS last_date_of_last_month
FROM g;