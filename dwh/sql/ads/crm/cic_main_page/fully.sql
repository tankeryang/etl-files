DELETE FROM ads_crm.cic_main_page;


INSERT INTO ads_crm.cic_main_page
    WITH ydst AS (
        SELECT DISTINCT
            brand_name,
            cardinality(array_distinct(flatten(array_agg(register_member_array)))) AS register_member_amount
        FROM ads_crm.member_register_detail
        WHERE date = date(localtimestamp) - interval '2' day
        GROUP BY brand_name
    ), lwst AS (
        SELECT DISTINCT
            brand_name,
            cardinality(array_distinct(flatten(array_agg(register_member_array)))) AS register_member_amount
        FROM ads_crm.member_register_detail
        WHERE date = date(localtimestamp) - interval '8' day
        GROUP BY brand_name
    ), lmst AS (
        SELECT DISTINCT
            brand_name,
            cardinality(array_distinct(flatten(array_agg(register_member_array)))) AS register_member_amount
        FROM ads_crm.member_register_detail
        WHERE date = date(localtimestamp) - interval '31' day
        GROUP BY brand_name
    )
    SELECT DISTINCT
        f.brand_name AS brand,
        cast(cardinality(array_distinct(flatten(array_agg(f.register_member_array)))) AS INTEGER) AS register_member_amount,
        cast(COALESCE(TRY(cardinality(array_distinct(flatten(array_agg(f.register_member_array)))) * 1.0000 /       ydst.register_member_amount), 0) AS DECIMAL(18, 4)) AS rma_compared_with_ydst,
        cast(COALESCE(TRY(cardinality(array_distinct(flatten(array_agg(f.register_member_array)))) * 1.0000 /       lwst.register_member_amount), 0) AS DECIMAL(18, 4)) AS rma_compared_with_lwst,
        cast(COALESCE(TRY(cardinality(array_distinct(flatten(array_agg(f.register_member_array)))) * 1.0000 /       lmst.register_member_amount), 0) AS DECIMAL(18, 4)) AS rma_compared_with_lmst
    FROM ads_crm.member_register_detail f
    LEFT JOIN ydst ON f.brand_name = ydst.brand_name
    LEFT JOIN lwst ON f.brand_name = lwst.brand_name
    LEFT JOIN lmst ON f.brand_name = lmst.brand_name
    WHERE f.date = date(localtimestamp) - interval '1' day
    GROUP BY f.brand_name, ydst.register_member_amount, lwst.register_member_amount, lmst.register_member_amount;
