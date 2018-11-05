DELETE FROM cdm_crm.member_product_preference;


INSERT INTO cdm_crm.member_product_preference
    WITH cp AS (
        SELECT brand_code, member_no, 
    )
    SELECT
        brand_code,
        member_no,
