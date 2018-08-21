
### SQL : 存放ETL的SQL文件
目录结构：

* `根目录	： dwh（dataware house）`
* `分层结构 ： ods（操作数据），cdm（dwd公共明细，dws公共汇总），ads（应用数据`）
* `特殊目录 ： ods_frt（frim real-time），历史遗留，存放准实时数据（后续可使用流式计算替代）`

命名规范：

* `目录 ： 层级目录名 - 业务系统标识 - 表名 - SQL名称`
* `SQL名称 ： 建表名称统一为create.sql，增量统一为increment.sql`


### JOB ： 存放ETL任务调度配置文件
