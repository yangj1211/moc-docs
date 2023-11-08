# 导入 TPC-H 样例数据

本篇文档将指导你如何使用 MatrixOne Cloud 平台页面轻松导入 TPC-H 样例数据。

## 步骤

1. 登录你的 MatrixOne Cloud 账号，并选择目标 MatrixOne Cloud 实例。点击 **通过云平台连接** 进入 MatrixOne Cloud 数据库管理平台。在左侧菜单栏中，找到 **查询** 并选择 **查询编辑器** 模块，然后点击进入 SQL 编辑器页面。

2. 在 SQL 编辑器界面中，你将看到一个**导入**按钮。

    ![导入按钮](https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/import/tpch/tpch-1.png)

3. 单击**导入**按钮后，你将看到一个交互式引导弹窗。按顺序选择**试用样例数据**、**TPC-H 基准测试**和**导入 TPC-H数据**，这样你就成功加载了 TPC-H 样例数据。

    - MatrixOne Cloud 现在提供 TPC-H 1GB 和 10GB 两种样例数据库。
    - TPC-H 样例数据加载速度非常快，而且不会占用你的存储空间，这得益于 MatrixOne 的租户间数据发布订阅功能。

    ![导入TPC-H示例数据](https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/import/tpch/tpch-2.png)

4. 你现在可以测试 TPC-H 样例数据了。刷新左侧的数据库对象，你将看到已成功加载的 TPC-H 样例数据。选择其中一个 TPC-H 数据库，将 TPC-H 的查询语句输入到 SQL 编辑框中，然后单击**运行**开始查询。

    ![运行查询](https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/import/tpch/tpch-3.png)

    在互动悬浮窗中，我们提供了一种快速获取 TPC-H 查询语句的方法。单击**试一试**即可快速查看示例查询语句。

    ![示例查询](https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/import/tpch/tpch-4.png)

    单击**执行**后，SQL 编辑器将执行查询，你可以在窗口中查看结果。

    ![查询结果](https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/import/tpch/tpch-5.png)

现在，你已经成功导入和测试了 TPC-H 样例数据，可以开始利用这些数据进行各种查询和分析。
