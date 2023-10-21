# **SQL 查询历史**

本篇文章将介绍 Queries History 模块，以帮助你轻松查看历史 SQL 查询记录，识别潜在风险的 SQL 语句和异常情况等审计内容。

## SQL 查询记录

1. 登录到 MatrixOne Cloud 实例管理平台。选择目标实例，然后点击 **Connect to Platform** 以访问 MatrixOne Cloud 数据库管理平台。

2. 在 MatrixOne Cloud 数据库管理平台中，找到左侧菜单栏中的 **Query**，然后选择 **Queries History** 模块。点击以进入 SQL 查询历史页面。

   ![查询历史页面](https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/sqleditor/image-7.png)

3. 在此页面，您可以设置特定筛选条件，如数据库、状态、查询类型，以及更多的筛选条件，如 SQL 文本、执行时间、时间范围和你等，以缩小查询范围，快速定位到特定条件下的 SQL 查询记录。点击 **Apply** 按钮，以筛选出符合特定条件的查询记录列表。

4. Queries 列表支持显示多个字段，包括 SQL 文本、查询 ID、执行时间、状态、查询类型、开始时间和你。

如果您对查询类型的定义感兴趣，可以参考 [MatrixOne SQL 目录](https://docs.matrixorigin.cn/1.0.0-rc1/MatrixOne/Reference/SQL-Reference/Data-Definition-Language/create-database/)章节。

## SQL 查询详情

1. 在列表中，点击 SQL 文本内容，即可进入 SQL 查询详情页。在此页面，您可以详细查看特定 SQL 查询的执行时间、起止时间、事务 ID、会话 ID、CU 消耗等详细信息。

   ![查询详情页面](https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/sqleditor/image-8.png)

2. 在此页面，您还可以查看 SQL 查询语句的详细内容，并根据需要进行复制。同时，您也可以查看特定 SQL 查询的查询结果，点击**下载**按钮以导出完整的查询结果。

现在，您已经了解如何访问 SQL 查询历史，筛选查询记录，并查看详细的查询信息。这将有助于您监测和审计 SQL 查询，以确保数据库的正常运行和安全性。
