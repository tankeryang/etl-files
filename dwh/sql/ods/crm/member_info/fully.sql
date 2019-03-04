DELETE FROM ods_crm.member_info;


INSERT INTO ods_crm.member_info
    SELECT
        mi.member_id,
        mi.member_no,
        mi.brand_code,
        mi.country,
        mi.province,
        mi.city,
        mi.region,
        mi.address,
        mi.zip_code,
        mi.identity_type,
        mi.identity_number,
        mi.wechat_id,
        mi.taobao_nick,
        mi.member_code,
        mi.member_card,
        mi.member_name,
        mi.member_nick_name,
        mi.member_birthday,
        mi.member_gender,
        mi.member_phone,
        mi.member_mobile,
        mi.member_email,
        mi.reg_source,
        mi.member_register_time,
        mi.member_register_store,
        mi.member_manage_store,
        mi.member_grade_id,
        mg.grade_name,
        mi.grade_begin,
        mi.grade_expiration,
        mi.member_score,
        mi.member_will_score,
        mi.member_coupon_denomination,
        mi.status,
        me.ec_status,
        mi.modify_time,
        mi.last_update_time,
        localtimestamp
    FROM prod_mysql_crm.crm.member_info mi
    LEFT JOIN prod_mysql_crm.crm.member_info_ec_status me
        ON mi.member_no = me.member_no AND mi.brand_code = me.brand_code
    LEFT JOIN prod_mysql_crm.crm.member_grade_info mg
        ON mi.member_grade_id = mg.grade_id;
