# **SQL 编辑器**

查询编辑器是 MatrixOne cloud 平台非常重要的一个工具，你可以通过在线 SQL 编辑器，进行 SQL 语句的快速编写、执行、结果查看，还可以将常用的 SQL 语句保存在 WorkBook 中，方便后续使用、参考和对比。

本篇文档将指导你如何通过 MatrixOne Cloud 内置的查询编辑器（SQL Editor）进行在线 SQL 查询与数据探索。

## 打开 SQL 编辑器

登录 MatrixOne Cloud 实例管理平台，选择目标实例 > 通过云平台连接，进入 MatrixOne Cloud 数据库管理平台，在左侧菜单栏中找到查询 > 查询编辑器模块，点击即可进入查询编辑器页面。

![Alt text](https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/sqleditor/image.png)

查询编辑器模块的页面由 3 部分构成。

- **左侧区域**：显示当前实例已有的数据库表和 Workbook，你可以快速查看和复制所关注的数据库名、表名、列名和已保存在 Workbook 中的 SQL 语句。

- **右上区域**：SQL 语句编辑区域。你可以在这个区域快速输入、编辑和执行 SQL 语句。

- **右下区域**：执行结果查看区域。你可以在这个区域查看 SQL 语句的执行结果。

## SQL 语句编辑与执行

在右侧 SQL 语句编辑区域，你可以任意输入和编辑 SQL 语句，并在当前实例上执行目标 SQL 语句。

在线 SQL 编辑器支持导入数据、库表查看和选择、SQL 语句编辑、在线执行、结果查看几项功能。

### 1. 在线导入数据

SQL 编辑器支持快速导入数据，启动数据分析。点击**导入数据**，即可启动导向式数据导入流程。

MatrixOne Cloud 在线数据导入支持两种导入方式：导入样例数据和导入自有数据。
![Alt text](https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/sqleditor/image-1.png)

- 导入样例数据：平台将提供典型开源数据集和互动式数据导入指引，无需准备数据即可体验 MatrixOne Cloud 的核心产品功能。现阶段已支持 TPC-H Benchmark 样例数据。

- 导入自有数据：现阶段 MatrixOne Cloud 支持你从本地客户端直接导入数据集，也可以从你自己的阿里云 OSS 中导入数据。

更多数据导入方式介绍可以参照导入数据章节。

### 2. 从 Database 中查看和选择库表

在查询编辑器中进行 SQL 语句编写过程中，开发者经常需要查看目标库表中的数据结构和数据类型，提升 SQL 语句编写的效率和准确性。

![Alt text](https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/sqleditor/image-4.png)

在左侧 Database 区域，当前实例的数据库和数据表将以树形结构呈现，你可以详细查看各个数据库的表结构及各个数据表中的数据类型，同时也可以复制需要的数据库名、表名和列名，快速在编辑器中粘贴使用。

### 3. 编辑和执行 SQL 查询

在右侧 SQL 编辑区域的上方，你可以在下拉列表中查看和选择目前 SQL 查询使用的数据库。选择数据库后，SQL 语句中可以不包括 dbname 执行，相当于已执行 `use database` 语句。

!!! note
    当你在查询编辑器中重新编辑并执行了一条新的 `use database` 语句且成功后，刷新左侧的 Database 树列表，右侧上方的下拉框中数据库选项将同步切换。

进一步输入想要查询的 SQL 语句，点击执行按钮，MatrixOne Cloud 将直接在线执行对应 SQL 请求。

![Alt text](https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/sqleditor/image-5.png)

- 支持使用光标选中部分 SQL 执行，平台将会按顺序执行这些 SQL。
- 若光标位于 SQL 语句内，则执行该 SQL。
- 若光标位于 SQL 语句外，且后面没有 SQL，则执行前一条 SQL。
- 若光标位于 SQL 语句外，且前面没有 SQL，则执行后一条 SQL。
- 你可以在 SQL 执行过程中，手动停止或关闭 Query Tab, Query 都将终止。

### 4. 执行结果查看

右下侧查询结果区域可以查看当前查询的执行结果。若平台顺序执行了多条 SQL 语句，将分多个 Tab 展示和查看。

受页面长度限制，目前平台可视化查询结果暂只显示前 1000 行，你可以点击下载按钮，进行全量查询结果的导出。

若对查询结果耗时有进一步分析和优化需求，可点击查询结果 Tab 右侧的跳转按钮，进一步在查询历史模块查看查询详情和 Profile 可视化分析。

## Workbook 管理

你在线编辑和执行的 SQL 语句都将保存在不同的 Workbook 中，方便后续进一步参考和使用。

更多信息参见 [Workbook 管理](sql-workbook.md)

首次使用时，将默认在 default 的 Workbook 中进行 SQL 编辑和查询，你可以进一步修改 Workbook 的名称。

你也可以在 Workbook 列表上方点击“+”号新增自定义 Workbook，若 Workbook 数量较多同时支持搜索功能。

每个 Workbook 都支持多个版本，你每次编辑将生成草稿版本，点击执行后将保存为正式版本。

![Alt text](https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/sqleditor/image-6.png)

!!! note
    每个 SQL User 最多可建 100 个 Workbook，每个 Workbook 将保存最近 25 个版本。
