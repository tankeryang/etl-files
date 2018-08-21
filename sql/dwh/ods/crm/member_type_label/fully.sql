INSERT INTO ods_crm.member_type_label
    SELECT
        '全国',
        t1.sales_area,
        t1.city,
        t1.store_code,
        t2.member_type
    FROM (
        SELECT DISTINCT
            sales_area,
            city,
            store_code,
            'key' AS key
        FROM
            ods_crm.daliy_report_base
        WHERE
            channel_type = '自营'
    ) t1
    FULL JOIN (
        SELECT DISTINCT
            member_type,
            'key' AS key
        FROM
            ods_crm.daliy_report_base
        WHERE
            member_type IS NOT NULL
    ) t2
    ON
        t1.key = t2.key;