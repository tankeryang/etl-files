DELETE FROM cdm_crm.member_last_feedback_time;


INSERT INTO cdm_crm.member_last_feedback_time
    SELECT
        member_no,
        brand_code,
        MAX(feedback_time),
        localtimestamp
    FROM ods_crm.feedback_customer_contact_log
    GROUP BY member_no, brand_code;
