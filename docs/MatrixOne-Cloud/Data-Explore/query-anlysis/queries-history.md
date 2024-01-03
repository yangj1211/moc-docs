# **SQL 查询历史**

本篇文章将介绍查询历史模块，以帮助你轻松查看历史 SQL 查询记录，识别潜在风险的 SQL 语句和异常情况等审计内容。

## SQL 查询记录

1. 登录到 MatrixOne Cloud 实例管理平台。选择目标实例，然后点击**通过云平台连接**以访问 MatrixOne Cloud 数据库管理平台。

2. 在 MatrixOne Cloud 数据库管理平台中，找到左侧菜单栏中的**查询**，然后选择**查询历史**模块。点击以进入 SQL 查询历史页面。

在此页面，您可以设置特定筛选条件，如数据库、状态、查询类型，以及更多的筛选条件，如 SQL 文本、执行时间、时间范围等，以缩小查询范围，快速定位到特定条件下的 SQL 查询记录。点击**搜索**按钮，以筛选出符合特定条件的查询记录列表。

   ![查询历史页面](https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/sqleditor/src_history.png)

Queries 列表支持显示多个字段，包括 SQL 文本、查询 ID、执行时间、状态、查询类型、开始时间。

在**SQL 文本**列您可以看到部分SQL前面会有"/ * x queries */"的标志，这是因为记录查询历史的表信息量较大。为了提高查询速度，我们将超轻量级的 tp sqls 按以下规则聚合记录：

- 聚合周期为5s  
- 聚合 SQL 的条件  
    - 时间小于 200 ms 的 Insert、Update、Delete、Execute、Select语句  
    - response_at（响应时间）在聚合周期内的 sql  
    - sql_source_type：internal_sql(系统内部 SQL 请求)、cloud_nonuser_sql(云平台非用户语句)、external_sql(外部语句)  

其中，符合条件的SQL语句聚合后会显示总的响应时间，"/ * x queries */"中的"x"指的是聚合的条数

## SQL 查询详情

1. 在列表中，点击 SQL 文本内容，即可进入 SQL 查询详情页。在此页面，您可以详细查看特定 SQL 查询的执行时间、起止时间、事务 ID、会话 ID、CU 消耗等详细信息。

   ![查询详情页面](https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/sqleditor/image-8.png)

2. 在此页面，您还可以查看 SQL 查询语句的详细内容，并根据需要进行复制。同时，您也可以查看特定 SQL 查询的查询结果，点击**下载**按钮以导出完整的查询结果。

现在，您已经了解如何访问 SQL 查询历史，筛选查询记录，并查看详细的查询信息。这将有助于您监测和审计 SQL 查询，以确保数据库的正常运行和安全性。
