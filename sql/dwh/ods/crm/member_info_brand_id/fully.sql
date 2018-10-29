DELETE FROM ods_crm.member_info_brand_id;


INSERT INTO ods_crm.member_info_brand_id
    SELECT
        cast(a.user_id AS VARCHAR) AS member_no,
        '2'                        AS brand_code,
        d.brand_id                 AS brand_id
        FROM prod_remote_mysql_crm.ec_user.user_reg a
        INNER JOIN prod_remote_mysql_crm.ec_user.user_info b ON a.user_id = b.user_id
        INNER JOIN prod_remote_mysql_crm.ec_loyalty.user_profile c ON a.user_id = c.user_id AND c.store_id = 2
        LEFT JOIN prod_remote_mysql_crm.ec_loyalty.user_clerk d ON a.user_id = d.user_id AND d.store_id = 2
        WHERE a.status >= 0
    UNION SELECT
        cast(a.user_id AS VARCHAR) AS member_no,
        '6'                        AS brand_code,
        d.brand_id                 AS brand_id
        FROM prod_remote_mysql_crm.ec_user.user_reg a
        INNER JOIN prod_remote_mysql_crm.ec_user.user_info b ON a.user_id = b.user_id
        INNER JOIN prod_remote_mysql_crm.ec_loyalty.user_profile c ON a.user_id = c.user_id AND c.store_id = 23
        LEFT JOIN prod_remote_mysql_crm.ec_loyalty.user_clerk d ON a.user_id = d.user_id AND d.store_id = 23
        WHERE a.status >= 0;
