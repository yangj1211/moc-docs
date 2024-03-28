# Serverless 生产实例价格明细

## 关于 Compute Unit(CU)

Compute Unit（简称 CU）是 MatrixOne Cloud Serverless 实例的计算资源开销的基本单位，包含 CPU、Memory 和 S3 I/O 的消耗量。其中，CPU 用量 和 Memory 用量 是指在一段时间内的资源消耗。

以下为 CU 的计费原则：

| 计费项    | 计费原则           |
| -------- | ------------------|
| CPU      | CN 节点按使用量计费  |
| Memory   | CN 节点按使用量计费  |
| I/O      | 按 S3 I/O 次数收费        |

## 价格详情

- CU

我们定义 1 个 CU 计算资源消耗量 = MO 读取 40KB 数据所消耗的计算资源。下面是 CU 的价格详情：

| 资源      | 单价                     |
| -------- | ------------------------ |
| CPU      |  ¥5.37E-14/per core*ns   |
| Memory   |  ¥1.05E-23/per byte*ns   |
| Input    |  ¥1.00E-06/次            |
| Output   |  ¥1.00E-06/次            |

目前，MO Cloud 的 CU 定价为 **¥10/100 万-CUs**。

- 存储

数据存储是指用户在 MatrixOne Cloud 实例中存入的数据大小，MO Cloud 的存储定价为 **¥0.15/GiB-月**。