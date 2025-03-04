# 流式导入

本文档介绍如何使用 SQL 语句在 MatrixOne Intelligence 中进行流式导入数据。具体来说，MatrixOne Intelligence 支持使用 `LOAD DATA INLINE` 语法对以 *csv* 格式组织的字符串进行导入，导入速度较 `INSERT` 操作更快。

## 语法结构

```mysql
mysql> LOAD DATA INLINE 
FORMAT='csv' ,
DATA=$XXX$
csv_string $XXX$
INTO TABLE tbl_name;
```

<!-- 等支持 json

mysql> LOAD DATA INLINE 
FORMAT=('csv'|'json') ,
DATA=$XXX$
(csv_string| json_string) $XXX$
INTO TABLE tbl_name;

-->

**参数解释**

`FORMAT='csv'` 表示后面 `DATA` 中的字符串数据是以 `csv` 为格式组织的。

`DATA=$XXX$ csv_string $XXX$` 中的 `$XXX$` 是数据开始和结束的标识符。`csv_string` 是以 `csv` 为格式组织字符串数据，以 `\n` 或者 `\r\n` 作为换行符。

!!! note
    `$XXX$` 为数据开始和结束的标识符，注意数据结束处的 `$XXX$` 需要和最后一行数据放在同一行，换行可能导致 `ERROR 20101`

## MySQL Client 中使用 `LOAD DATA INLINE` 命令导入数据

你可以使用 `LOAD DATA INLINE` 将流式数据导入 MatrixOne Intelligence，本章将介绍如何进行流式导入，并且给出导入 *csv* 数据的示例。

1. [创建 MatrixOne Intelligence 实例](../../Instance-Mgmt/create-instance/create-serverless-instance.md)。

2. [通过 MySQL Client 连接 MatrixOne Intelligence 服务](../connect-mo/database-client-tools.md#mysql-client-matrixone-cloud)。

3. 在 MatrixOne Intelligence 数据库中执行 `LOAD DATA INLINE` 之前，需要提前创建数据表 `user`:

    ```mysql

    CREATE TABLE `user` (
    `name` VARCHAR(255) DEFAULT null,
    `age` INT DEFAULT null,
    `city` VARCHAR(255) DEFAULT null
    )
    ```

4. 在 MySQL 客户端执行 `LOAD DATA INLINE` 进行数据导入，以 *csv* 格式导入数据：

    ```mysql
    mysql> LOAD DATA INLINE 
    FORMAT='csv',
    DATA=$XXX$
    Lihua,23,Shanghai
    Bob,25,Beijing $XXX$ 
    INTO TABLE user;
    ```

## Python-pymysql 应用中使用 `LOAD DATA INLINE` 命令导入数据

PyMySQL 是一个纯 Python MySQL 客户端库，下面将指导你如何使用 PyMySQL 进行 `LOAD DATA INLINE` 操作。

1. [创建 MatrixOne Intelligence 实例](../../Instance-Mgmt/create-instance/create-serverless-instance.md)。

2. [通过 MySQL Client 连接 MatrixOne Intelligence 服务](../connect-mo/database-client-tools.md#mysql-client-matrixone-cloud)

3. 使用 MySQL 客户端连接 MatrixOne Intelligence 实例，新建一个名称为 *test* 数据库和 *user* 的数据表：

    ```sql
    mysql> create database test;
    use test;
    CREATE TABLE `user` (
    `name` VARCHAR(255) DEFAULT null,
    `age` INT DEFAULT null,
    `city` VARCHAR(255) DEFAULT null
    );
    ```

4. 下载安装 pymysql：

    ```bash
    pip3 install pymysql 

    #If you are in China mainland and have a low downloading speed, you can speed up the download by following commands.
    pip3 install pymysql -i https://pypi.tuna.tsinghua.edu.cn/simple 
    ```

5. 创建一个纯文本文件 *pymysql_load_data_inline.py* 并将代码写入文件，此处作为示范 *csv_string* 只写了两行，你可以根据自己的流式数据决定 *csv_string* 的大小：

    ```python
    #!/usr/bin/python3
    import pymysql

    # Open database connection
    db = pymysql.connect(
        host='freetier-01.cn-hangzhou.cluster.matrixonecloud.cn',
        port=6001,
        user='585b49fc_852b_4bd1_b6d1_d64bc1d8xxxx:admin:accountadmin',
        password = "your_password",
        db='test',
        )
    # prepare a cursor object using cursor() method
    cursor = db.cursor()
    csv_string="Lihua,23,Shanghai \n Bob,25,Beijing"
    sql="load data inline format='csv',data=$XXX$" + csv_string + " $XXX$ into table user;"
    # execute SQL query using execute() method.
    cursor.execute(sql)
    data=db.commit()
    # Fetch a single row using fetchone() method.
    # disconnect from server
    db.close()

    ```

6. 打开一个终端，在终端内执行下面的命令：

    ```bash
    python3 pymysql_load_data_inline.py
    ```

7. 打开 mysql 客户端，查询数据表中的数据，结果如下：

    ```mysql
    mysql> select * from user;
    +-------+------+-----------+
    | name  | age  | city      |
    +-------+------+-----------+
    | Lihua |   23 | Shanghai  |
    |  Bob  |   25 | Beijing   |
    +-------+------+-----------+
    2 rows in set (0.02 sec)
    ```