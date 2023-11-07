# 插入 csv 文件

本篇文档将指导你在 MySQL 客户端连接 MatrixOne Cloud 时如何完成 *csv* 格式数据导入。

## 语法结构

- 场景一：数据文件与 MatrixOne 服务器在不同的机器上：

```
LOAD DATA LOCAL
INFILE 'file_name'
INTO TABLE tbl_name
[{FIELDS | COLUMNS}
[TERMINATED BY 'string']
[[OPTIONALLY] ENCLOSED BY 'char']
]
[LINES
[STARTING BY 'string']
[TERMINATED BY 'string']
]
[IGNORE number {LINES | ROWS}]
[PARALLEL {'TRUE' | 'FALSE'}]
```

## MySQL Client 中使用 `Load data` 命令导入数据

你可以使用 `Load Data` 从大数据文件中导入数据，本章将介绍如何导入 *csv* 格式文件。

__Note__: *csv*（逗号分隔值）文件是一种特殊的文件类型，可在 Excel 中创建或编辑，*csv* 文件不是采用多列的形式存储信息，而是使用逗号分隔的形式存储信息。

### 步骤

#### 数据文件与 MatrixOne 服务器在不同的机器上

1. 在 MatrixOne 中执行 `LOAD DATA LOCAL` 之前，需要提前在 MatrixOne 中创建完成数据表。

2. 启动 MySQL 客户端，连接 MatrixOne：

    ```
    mysql -h <mo-host-ip> -P 6001 -uroot -p111 --local-infile
    ```

3. 在 MySQL 客户端对对应的文件路径执行 `LOAD DATA LOCAL`：

    ```
    mysql> LOAD DATA LOCAL INFILE '/tmp/xxx.csv'
    INTO TABLE table_name
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY "\r\n";
    ```
    
## __限制__

加载 `csv` 格式支持 JSON 类型，但是需要确保 JSON 内不含有字段终止符号，如果 JSON 内含有字段终止符号，那么 JSON 需要用双引号包裹起来。例如：

- 正确示例：`"{"a":1, "b":2}", 2`
- 错误示例：`{"a":1, "b":2}, 2`
