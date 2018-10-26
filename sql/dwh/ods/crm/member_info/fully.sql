DELETE FROM ods_crm.member_info;


INSERT INTO ods_crm.member_info
    SELECT
        member_id,
        member_no,
        brand_code,
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
        member_manage_store,
        localtimestamp
    FROM dev_mysql_fpsit.crm.member_info
    WHERE member_id != 61 OR member_id != 41825;
