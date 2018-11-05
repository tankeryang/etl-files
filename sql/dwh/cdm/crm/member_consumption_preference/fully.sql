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
    )