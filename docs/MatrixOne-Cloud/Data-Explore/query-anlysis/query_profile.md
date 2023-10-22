# 查询分析

本篇文档将指导用户如何通过 MatrixOne Cloud 内置的查询分析（Query Profile）进行在线的 SQL 查询分析。也可以理解成，查询分析模块是将数据库中的Explain，即解释详细执行计划的能力做成了可视化模块，通过可视化的方式向用户展示这条SQL的执行计划。

## 什么是执行计划

执行计划（execution plan，也叫查询计划或者解释计划）是数据库执行 SQL 语句的具体步骤，例如通过索引还是全表扫描访问表中的数据，连接查询的实现方式和连接的顺序等；执行计划根据你的表、列、索引和 `WHERE` 子句中的条件的详细信息，可以告诉你这个查询将会被如何执行或者已经被如何执行过，可以在不读取所有行的情况下执行对巨大表的查询；可以在不比较行的每个组合的情况下执行涉及多个表的连接。如果 SQL 语句性能不够理想，首先应该查看它的执行计划。和大多数成熟的数据库产品一样，MatrixOne 数据库也提供了这一分析查询语句性能的功能。

MatrixOne 查询优化器对输入的 SQL 查询语句通过**执行计划**而选择出效率最高的一种执行方案。你也可以通过执行计划看到 SQL 代码中那些效率比较低的地方。

## 使用 `EXPLAIN` 查询执行计划

用户可以使用 `EXPLAIN` 可查看 MatrixOne 执行某条 SQL 语句时的执行计划。

`EXPLAIN` 可以和 `SELECT`、`DELETE`、`INSERT`、`REPLACE`、`UPDATE` 语句结合使用。当 `EXPLAIN` 与可解释的语句一起使用时，MatrixOne 会解释它将如何处理该语句，包括有关表如何连接以及连接顺序的信息。MatrixOne Cloud中暂时不支持通过在SQL编辑器中使用`EXPLAIN` 查询执行计划，而是提供了`查询分析`的可视化界面向用户展示执行计划，如果用户希望查看`EXPLAIN`的原始信息的时候，可以通过 MySQL 客户端连接 MatrixOne Cloud 的实例进行执行。

!!! note
    使用 MySQL 客户端连接到 MatrixOne 时，为避免输出结果在终端中换行，可先执行 `pager less -S` 命令。执行命令后，新的 `EXPLAIN` 的输出结果不再换行，可按右箭头 **→** 键水平滚动阅读输出结果。

## 在SQL编辑器中执行一条Query

这里我们以系统自带的TPCH10G数据集为例，在SQL编辑器中执行Q1，并展示`查询分析`界面上的执行计划如何展示。首先执行这条SQL，如下图所示：
![Execute Q1](https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/sqleditor/queryprofile_execute_tpch.png)




## 在查询历史中找到这条Query

接下来我们在查询历史中找到这条Query，如下图所示:

![Alt text](https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/sqleditor/queryprofile_get_query.png)

## 查看该Query的查询分析

点击进入这条Query的查询详情界面，我们可以同时看到它的查询分析（Query Profile）界面，如下图所示：

![Alt text](https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/sqleditor/queryprofile_queryprofile.png)

该界面展示了TPCH Q1的整个执行过程，总共分为了4个算子：表扫描(Table Scan)，聚合(Aggregate)，排序(Sort) 及 投影(Project)。

同时每一个小的执行步骤的方块上我们都表明了它的操作对象，执行细节及所消耗的CPU及内存资源。比如针对Table Scan算子, 可以看到它的操作对象是`mo_sample_data_tpch_sf10.lineitem`这张表，同时这个操作消耗的CPU资源是`1.6 core*s`, 即占用了1个CPU核1.6秒的时间。而内存则消耗了`4.7GB`, 这些资源消耗即是我们计算CU消耗的基础。我们会根据一定的算法加总所有步骤所消耗的CPU和内存资源，即得到这条Query消耗的CU个数。

另外从Table Scan算子到Aggregate算子中间有一个小箭头，这个箭头上会带有一个数字，这个数字代表的即为本算子输出的数据行数，在这张图里为`58,682,142`行, 这些数据也是下一个算子的输入。

![Alt text](https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/sqleditor/queryprofile_details.png)

如果我们再选中点击Table Scan算子方块，我们将看到Table Scan算子执行的更多细节。

在该案例中我们可以看到Table Scan算子执行的过程中选中的是18个列中的7个`（l_quantity, l_extendedprice, l_discount, l_tax, l_returnflag, l_linestatus, l_shipdate）`, 另外还包含了一个过滤的条件`(lineitem.l_shipdate <= 1998-08-11)`。

## 理解MatrixOne的执行计划

对于更详细的MatrixOne的执行计划的细节，请参考[Explain](../../Reference/SQL-Reference/Other/Explain/explain.md)的参考手册。
