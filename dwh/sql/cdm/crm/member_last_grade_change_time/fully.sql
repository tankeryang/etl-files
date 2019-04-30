DELETE FROM cdm_crm.member_last_grade_change_time;


INSERT INTO cdm_crm.member_last_grade_change_time
    SELECT
        brand_code,
        member_no,
        MAX(create_time)
    FROM ods_crm.member_grade_log
    GROUP BY brand_code, member_no;
