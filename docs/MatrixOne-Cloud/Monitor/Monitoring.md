# 监控指标

本节将详细介绍 MatrixOne Cloud 提供的各种监控指标。

## 实例监控指标

实例监控指标是服务于 MatrixOne Cloud 实例管理平台的运维人员的监控信息，包括：

![](https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/monitor/monitoring-1.png)

### 平均连接数

同时连接到实例的 Session 数。

### CU 使用量

在统计周期内，CU 消耗的总量。

### 存储用量

在统计周期内，实例中数据存储的平均使用量。

## 业务监控指标

业务监控指标是服务于数据应用人员的监控信息，可以在 MatrixOne Cloud 数据库管理平台中找到，其中包括：

![](https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/monitor/monitoring-2.png)

### 每秒查询次数 (QPS)

平均每秒完成的 SQL 查询数量，代表实例的吞吐能力，支持按 SQL 类型进行统计。

### 查询延迟

平均每条 SQL 查询的执行时间，代表实例的运行性能，同样支持按 SQL 类型进行统计。

### 事务总数

在统计周期内，执行的事务总数。

### 事务失败数

在统计周期内，执行失败的事务总数。

### SQL 语句总数

在统计周期内，执行的 SQL 语句总数。

### SQL 语句失败数

在统计周期内，执行失败的 SQL 语句总数。

## 统计时长与统计周期

为了帮助用户从宏观和微观角度分析实例的性能和问题，MatrixOne Cloud 提供了多种统计时长，每种时长对应不同的统计周期。用户可以根据需要自由切换。以下是统计时长与统计周期的映射关系：

- Last 30 minutes：1 分钟
- Last 1 hour：5 分钟
- Last 6 hours：30 分钟
- Last 1 day：1 小时
- Last 1 week：6 小时
- Last 1 month：1 天

!!! note
    较短的统计周期更能反映业务的最近变化，而较长的统计周期更适合观察长期趋势和历史问题。
