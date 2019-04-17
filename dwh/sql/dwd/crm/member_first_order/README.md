# member_first_order

因为考虑到数据口径，因此统一用 dataware 的数据作为首单记录

```sql
CREATE TABLE cdm_crm.member_first_order (
    member_no              VARCHAR,
    brand_code             VARCHAR,
    mr_member_new_old_type VARCHAR COMMENT '吊毛月报的新老会员类型, 在这里统一为 NEW, 方便后续用 order_info left join 它',
    order_deal_time        TIMESTAMP,
    order_deal_date        DATE,
    order_deal_year_month  VARCHAR
) WITH (format = 'ORC');

INSERT INTO cdm_crm.member_first_order
    SELECT
        CAST(user_id AS VARCHAR)                   AS member_no,
        CASE store_id
            WHEN 2 THEN '2'
            WHEN 6 THEN '3'
            WHEN 23 THEN '6'
        ELSE CAST(store_id AS VARCHAR) END         AS brand_code,
        '新会员'                                    AS mr_member_new_old_type,
        first_order_date_crm                       AS order_deal_time,
        DATE(first_order_date_crm)                 AS order_deal_date,
        DATE_FORMAT(first_order_date_crm, '%Y-%m') AS order_deal_year_month
    FROM ods_dataware_dim.d_crm_user_extend_info;
```