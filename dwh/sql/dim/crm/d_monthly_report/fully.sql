DELETE FROM dim_crm.d_monthly_report;


INSERT INTO dim_crm.d_monthly_report
    WITH bc AS (
        SELECT
            '2' AS brand_code,
            'FivePlus' AS brand_name,
            'key' AS key
        UNION SELECT
            '3' AS brand_code,
            'Trendiano' AS brand_name,
            'key' AS key
        UNION SELECT
            '6' AS brand_code,
            'MissSixty' AS brand_name,
            'key' AS key
    ), ct AS (
        SELECT '自营' AS channel_type, 'key' AS key
        UNION SELECT '特许' AS channel_type, 'key' AS key
        UNION SELECT '官网' AS channel_type, 'key' AS key
    ), mgt AS (
        SELECT '普通会员' AS mr_member_grade_type, 'key' AS key
        UNION SELECT 'VIP' AS mr_member_grade_type, 'key' AS key
    ), mnot AS (
        SELECT '新会员' AS mr_member_new_old_type, 'key' AS key
        UNION SELECT '老会员' AS mr_member_new_old_type, 'key' AS key
    ), mst AS (
        SELECT '有消费' AS mr_member_sales_type, 'key' AS key
        UNION SELECT '无消费' AS mr_member_sales_type, 'key' AS key
    )
    SELECT
        bc.brand_code,
        bc.brand_name,
        ct.channel_type,
        mgt.mr_member_grade_type,
        mnot.mr_member_new_old_type,
        mst.mr_member_sales_type
    FROM bc
    FULL JOIN ct ON bc.key = ct.key
    FULL JOIN mgt ON bc.key = mgt.key
    FULL JOIN mnot ON bc.key = mnot.key
    FULL JOIN mst ON bc.key = mst.key;
