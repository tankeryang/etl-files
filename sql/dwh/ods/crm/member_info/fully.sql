DELETE FROM ods_crm.member_info;


INSERT INTO ods_crm.member_info
    SELECT
        member_id,
        member_no,
        wechat_id,
        member_code,
        member_card,
        member_name,
        member_birthday,
        member_gender,
        member_phone,
        member_mobile,
        member_email,
        reg_source,
        member_grade_id,
        member_score,
        member_coupon_denomination,
        modify_time,
        country,
        province,
        city,
        region,
        address,
        zip_code,
        identity_type,
        identity_number,
        member_nick_name,
        member_will_score,
        grade_expiration,
        grade_begin,
        last_update_time,
        member_register_time,
        member_register_store,
        localtimestamp
    FROM prod_mysql_crm.crm.member_info;