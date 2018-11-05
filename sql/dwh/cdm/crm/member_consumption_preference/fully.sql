DELETE FROM cdm_crm.member_consumption_preference;


INSERT INTO cdm_crm.member_consumption_preference
    WITH spc AS (
        SELECT DISTINCT
            brand_code,
            member_no,
            store_code,
            count(store_code) OVER (PARTITION BY brand_code, member_no, store_code) AS store_code_count
        FROM cdm_crm.order_info_detail
        WHERE COALESCE(try_cast(member_no AS INTEGER), 0) > 0
    ), sp AS (
        SELECT DISTINCT
            brand_code,
            member_no,
            first_value(store_code) OVER (
                PARTITION BY brand_code, member_no
                ORDER BY store_code_count DESC) AS store_preference
        FROM spc
    ), ppc AS (
        SELECT DISTINCT
            brand_code,
            member_no,
            order_pay_type,
            count(order_pay_type) OVER (PARTITION BY brand_code, member_no, order_pay_type) AS pay_type_count
        FROM cdm_crm.order_info_detail
        WHERE COALESCE(try_cast(member_no AS INTEGER), 0) > 0
    ), pp AS (
        SELECT DISTINCT
            brand_code,
            member_no,
            first_value(order_pay_type) OVER (
                PARTITION BY brand_code, member_no
                ORDER BY pay_type_count DESC) AS pay_type_preference
        FROM ppc
    ), 