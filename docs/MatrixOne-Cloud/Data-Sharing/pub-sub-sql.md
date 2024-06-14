# 使用 SQL 进行发布订阅

MatrixOne Cloud 支持以下两种方式进行实例间的发布订阅：

- SQL 语句
- [Web 端](./pub-sub-web.md)

本篇文档主要介绍如何使用 SQL 进行实例间的发布订阅。

## 发布订阅示例

![](https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/data-sharing/subpub.jpg)

需要注意的是，你的实例 ID 可以通过 Mysql 连接串来获得，若你还未获得，[点此获取 MarixOne Cloud 实例的连接命令](../Instance-Mgmt/connect-instance.md)。

你会获得类似这样的 Mysql 连接串：

```bash
mysql -h freetier-01.cn-hangzhou.cluster.matrixonecloud.cn -P 6001 
-u 499575b7_4b78_403b_8356_ebd767dcxxxx:admin:accountadmin  -p
```

参数 -u 后面的字符串 `499575b7_4b78_403b_8356_ebd767dcxxxx:admin:accountadmin` 是完整的用户名，其中以 `:` 为分隔符的第一段 `499575b7_4b78_403b_8356_ebd767dcxxx` 即为你的实例 ID。

### 发布订阅数据库

1. **发布者**: 实例 A 创建数据库 mall 与表 customer 并发布此数据库为 pub_mall:

    ```sql
    -- 实例 A
    create database mall;
    CREATE TABLE mall.customer (
    customer_id INT,
    customer_name VARCHAR(255)
    );
    create publication pub_mall database mall;

    mysql> show publications;
    +-------------+----------+---------------------+-------------+-------------+----------+
    | publication | database | create_time         | update_time | sub_account | comments |
    +-------------+----------+---------------------+-------------+-------------+----------+
    | pub_mall    | mall     | 2024-05-27 09:02:49 | NULL        | *           |          |
    +-------------+----------+---------------------+-------------+-------------+----------+

    1 row in set (0.17 sec)
    ```

2. **订阅者**: 实例 B 和实例 C 都创建订阅库 sub_mall（订阅自实例 A 的 pub_mall），于是得到实例 A 数据库 mall 中的所有数据：

    ```sql
    -- 实例 B && 实例 C 
    create database sub_mall from 018fb8d3_2b05_7be8_b526_bb62576dxxxx publication pub_mall;
    use sub_mall;

    mysql> show subscriptions;
    +----------+--------------------------------------+--------------+---------------------+----------+---------------------+
    | pub_name | pub_account                          | pub_database | pub_time            | sub_name | sub_time            |
    +----------+--------------------------------------+--------------+---------------------+----------+---------------------+
    | pub_mall | 018fb8d3_2b05_7be8_b526_bb62576dxxxx | mall         | 2024-05-27 09:02:49 | sub_mall | 2024-05-27 09:05:44 |
    +----------+--------------------------------------+--------------+---------------------+----------+---------------------+
    1 row in set (0.08 sec)

    mysql> show tables;
    +--------------------+
    | Tables_in_sub_mall |
    +--------------------+
    | customer           |
    +--------------------+
    1 row in set (0.11 sec)
    ```

### 订阅后数据同步更新

1. **发布者**: 实例 A 创建数据表 orders：

    ```sql
    --  实例 A
    CREATE TABLE mall.orders (
    order_id INT,
    order_date DATE
    );
    ```

2. **订阅者**: 已经订阅数据库 mall 的实例 B 和实例 C 得到更新的数据表 orders:

    ```sql
    --  实例 B &&  实例 C
    use sub_mall;
    show tables;
    +--------------------+
    | Tables_in_sub_mall |
    +--------------------+
    | customer           |
    | orders             |
    +--------------------+
    2 rows in set (0.09 sec)        
    ```

### 发布者可指定有限订阅者

1. **发布者**: 实例 A 创建数据库 school 与表 student，并发布 pub_school 给实例 B:

    ```sql
    --  实例 A
    create database school;
    CREATE TABLE school.student (
    student_id INT,
    student_name VARCHAR(255)
    );
    create publication pub_school database school account 018fb931_4ca7_78f5_a9a2_51e7ae88xxxx;
    ```

2. **订阅者**: 实例 B 和实例 C 都创建订阅库 sub_school（订阅自实例 A 的 pub_school），实例 B 订阅成功并得到数据，实例 C 订阅失败：

    ```sql
    -- 实例 B 
    create database sub_school from 018fb8d3_2b05_7be8_b526_bb62576dxxxx publication pub_school;
    use sub_school;

    mysql> show subscriptions;
    +------------+--------------------------------------+--------------+---------------------+------------+---------------------+
    | pub_name   | pub_account                          | pub_database | pub_time            | sub_name   | sub_time            |
    +------------+--------------------------------------+--------------+---------------------+------------+---------------------+
    | pub_school | 018fb8d3_2b05_7be8_b526_bb62576dxxxx | school       | 2024-05-27 09:20:13 | sub_school | 2024-05-27 09:22:01 |
    | pub_mall   | 018fb8d3_2b05_7be8_b526_bb62576dxxxx | mall         | 2024-05-27 09:02:49 | sub_mall   | 2024-05-27 09:05:44 |
    +------------+--------------------------------------+--------------+---------------------+------------+---------------------+
    2 rows in set (0.08 sec)

    mysql> show tables;
    +----------------------+
    | Tables_in_sub_school |
    +----------------------+
    | student              |
    +----------------------+
    1 row in set (0.12 sec)             
    ```

    ```sql
    -- 实例 C
    mysql>  create database sub_school from 018fb8d3_2b05_7be8_b526_bb62576dxxxx publication pub_school;
    ERROR 20101 (HY000): internal error: the account 018fb939_e13e_7941_90bb_2aa52796xxxx is not allowed to subscribe the publication pub_school
    ```

### 发布者可修改发布给全体

1. **发布者**: 实例 A 修改发布 pub_school 给全部实例：

    ```sql
    -- 实例 A
    alter publication pub_school account all;
    ```

2. **订阅者**: 实例 C 创建订阅库 sub_school 成功，得到共享的数据表 student：

    ```sql
    -- 实例 C
    create database sub_school from 65758cd2_b40b_4729_b3e4_1959137fxxxx publication pub_school;
    use sub_school;

    mysql> show subscriptions;
    +------------+--------------------------------------+--------------+---------------------+------------+---------------------+
    | pub_name   | pub_account                          | pub_database | pub_time            | sub_name   | sub_time            |
    +------------+--------------------------------------+--------------+---------------------+------------+---------------------+
    | pub_school | 018fb8d3_2b05_7be8_b526_bb62576dxxxx | school       | 2024-05-27 09:20:13 | sub_school | 2024-05-27 09:28:54 |
    | pub_mall   | 018fb8d3_2b05_7be8_b526_bb62576dxxxx | mall         | 2024-05-27 09:02:49 | sub_mall   | 2024-05-27 09:12:29 |
    +------------+--------------------------------------+--------------+---------------------+------------+---------------------+
    2 rows in set (0.08 sec)

    mysql> show tables;
    +----------------------+
    | Tables_in_sub_school |
    +----------------------+
    | student              |
    +----------------------+
    1 row in set (0.17 sec)
    ```

### 发布者可删除已发布的发布对象，订阅者随即无法连接相关的订阅对象，但是可以删除

1. **发布者**: 实例 A 删除发布 pub_mall:

    ```sql
    -- 实例 A
    drop publication pub_mall;

    mysql> show publications;
    +-------------+----------+---------------------+---------------------+-------------+----------+
    | publication | database | create_time         | update_time         | sub_account | comments |
    +-------------+----------+---------------------+---------------------+-------------+----------+
    | pub_school  | school   | 2024-05-27 09:20:13 | 2024-05-27 09:28:42 | *           |          |
    +-------------+----------+---------------------+---------------------+-------------+----------+
    1 row in set (0.13 sec)
    ```

2. **订阅者**: 实例 B 连接 sub_mall 失败：

    ```sql
    -- 实例 B 
    use sub_mall;
    ERROR 20101 (HY000): internal error: there is no publication pub_mall
    ```

3. **订阅者**: 实例 C 删除 sub_mall:

    ```sql
    -- 实例 C 
    drop database sub_mall;

    mysql> show subscriptions;
    +------------+--------------------------------------+--------------+---------------------+------------+---------------------+
    | pub_name   | pub_account                          | pub_database | pub_time            | sub_name   | sub_time            |
    +------------+--------------------------------------+--------------+---------------------+------------+---------------------+
    | pub_school | 018fb8d3_2b05_7be8_b526_bb62576dxxxx | school       | 2024-05-27 09:20:13 | sub_school | 2024-05-27 09:28:54 |
    +------------+--------------------------------------+--------------+---------------------+------------+---------------------+
    1 row in set (0.08 sec)
    ```

### 发布者重新发布已经删除的发布对象，之前的订阅者可以重新连接订阅对象

1. **发布者**: 实例 A 重新创建 pub_mall:

    ```sql
    -- 实例 A
    create publication pub_mall database mall;

    mysql> show publications;
    +-------------+----------+---------------------+---------------------+-------------+----------+
    | publication | database | create_time         | update_time         | sub_account | comments |
    +-------------+----------+---------------------+---------------------+-------------+----------+
    | pub_school  | school   | 2024-05-27 09:20:13 | 2024-05-27 09:28:42 | *           |          |
    | pub_mall    | mall     | 2024-05-27 09:41:09 | NULL                | *           |          |
    +-------------+----------+---------------------+---------------------+-------------+----------+
    2 rows in set (0.22 sec)
    ```

2. **订阅者**: 实例 B 连接 sub_mall 成功：

    ```sql
    -- 实例 B 
    use sub_mall;

    mysql> show tables;
    +--------------------+
    | Tables_in_sub_mall |
    +--------------------+
    | customer           |
    | orders             |
    +--------------------+
    2 rows in set (0.18 sec)
    ```

### 发布者发布已删除发布对象的同名对象，之前的订阅者可以连接至新的订阅对象

1. **发布者**: 实例 A 删除发布 pub_mall:

    ```sql
    -- 实例 A
    drop publication pub_mall;
    ```

2. **发布者**: 实例 A 创建数据库 mall2 与表 customer2:

    ```sql
    -- 实例 A
    create database mall2;
    create table mall2.customer2 (customer_id INT,customer_name VARCHAR(255));
    ```

3. **发布者**: 实例 A 重新创建 pub_mall:

    ```sql
    -- 实例 A
    create publication pub_mall database mall2;

    mysql> show publications;
    +-------------+----------+---------------------+---------------------+-------------+----------+
    | publication | database | create_time         | update_time         | sub_account | comments |
    +-------------+----------+---------------------+---------------------+-------------+----------+
    | pub_school  | school   | 2024-05-27 09:20:13 | 2024-05-27 09:28:42 | *           |          |
    | pub_mall    | mall2    | 2024-05-27 09:46:59 | NULL                | *           |          |
    +-------------+----------+---------------------+---------------------+-------------+----------+
    2 rows in set (0.10 sec)
    ```

4. **订阅者**: 实例 B 连接 sub_mall 成功：

    ```sql
    -- 实例 B 
    use sub_mall;

    mysql> show tables;
    +--------------------+
    | Tables_in_sub_mall |
    +--------------------+
    | customer2          |
    +--------------------+
    1 row in set (0.41 sec)
    ```

可以看到，订阅者无需额外操作，即可连接至最新订阅对象。

### 发布者修改已发布内容，订阅者可以看到修改后的内容

1. **发布者**: 实例 A 修改发布 pub_mall 内容：

    ```sql
    -- 实例 A
    alter publication pub_mall comment "this is pub_mall";--修改 comments
    create database new_pub;
    create table new_pub.new_tab(n1 int);
    alter publication pub_mall database new_pub;--修改 database

    mysql> show publications;
    +-------------+----------+---------------------+---------------------+-------------+------------------+
    | publication | database | create_time         | update_time         | sub_account | comments         |
    +-------------+----------+---------------------+---------------------+-------------+------------------+
    | pub_mall    | new_pub  | 2024-05-27 09:46:59 | 2024-05-27 10:06:28 | *           | this is pub_mall |
    | pub_school  | school   | 2024-05-27 09:20:13 | 2024-05-27 09:28:42 | *           |                  |
    +-------------+----------+---------------------+---------------------+-------------+------------------+
    2 rows in set (0.11 sec)
    ```

1. **订阅者**: 实例 B 查看订阅，能看到发布数据库修改后的内容：

    ```sql
    -- 实例 B
    mysql> show subscriptions;
    +------------+--------------------------------------+--------------+---------------------+------------+---------------------+
    | pub_name   | pub_account                          | pub_database | pub_time            | sub_name   | sub_time            |
    +------------+--------------------------------------+--------------+---------------------+------------+---------------------+
    | pub_school | 018fb8d3_2b05_7be8_b526_bb62576dxxxx | school       | 2024-05-27 09:20:13 | sub_school | 2024-05-27 09:22:01 |
    | pub_mall   | 018fb8d3_2b05_7be8_b526_bb62576dxxxx | new_pub      | 2024-05-27 09:46:59 | sub_mall   | 2024-05-27 09:05:44 |
    +------------+--------------------------------------+--------------+---------------------+------------+---------------------+
    2 rows in set (0.16 sec)

    use sub_mall;

    mysql> show tables;
    +--------------------+
    | Tables_in_sub_mall |
    +--------------------+
    | new_tab            |
    +--------------------+
    1 row in set (0.21 sec)
    ```

## 快速复制订阅对象中的数据

由于订阅者对订阅对象仅有读取权限，订阅者无法直接操作订阅对象，但在一些情况下，订阅者需要对订阅对象中的数据进行进一步的操作，订阅者可以使用 `INSERT INTO SELECT` 进行订阅对象的快速复制。

``INSERT INTO SELECT`` 语句从一个表复制数据，然后把数据插入到一个已存在的表中。且目标表中任何已存在的行都不会受影响。

其语法结构如下：

```
INSERT INTO table2 (column1, column2, column3, ...)
SELECT column1, column2, column3, ...
FROM table1
WHERE condition;
```

### INSERT INTO SELECT 的示例：快速复制数据表中全部数据

接着上面的示例，下面将给出复制数据表 mall.customer 中的所有数据。

1. 实例 A 可以使用 `show create table` 语句快速查看原先的表结构：

    ```mysql
    -- 实例 A
    mysql> show create table sub_mall.customer;
    +----------+-------------------------------------------------------------------------------------------------------+
    | Table    | Create Table                                                                                          |
    +----------+-------------------------------------------------------------------------------------------------------+
    | customer | CREATE TABLE `customer` (
    `customer_id` INT DEFAULT NULL,
    `customer_name` VARCHAR(255) DEFAULT NULL
    ) |
    +----------+-------------------------------------------------------------------------------------------------------+
    1 row in set (0.15 sec)
    ```

2. 首先创建自己的数据库和表结构：

    ```mysql
    create my_mall;
    use my_mall;
    CREATE TABLE `customer` (
    `customer_id` INT DEFAULT NULL,
    `customer_name` VARCHAR(255) DEFAULT NULL
    );
    ```

3. 使用 `INSERT INTO SELECT` 复制所有数据：

    ```mysql
    INSERT INTO customer SELECT * from sub_mall.customer;
    ```

4. 查看数据已经全部复制成功：

    ```mysql
    select * from my_mall.customer;
    +-------------+---------------+
    | customer_id | customer_name |
    +-------------+---------------+
    |           1 | John          |
    |           2 | Alice         |
    |           3 | Bob           |
    |           4 | Emma          |
    +-------------+---------------+
    4 rows in set (0.30 sec)
    ```

对于更多复杂的操作，你可以根据以上的语法结构自行调整，复制或生成你需要的数据。

## 参考文档

### 发布者参考文档

- [CREATE PUBLICATION](../Reference/SQL-Reference/Data-Definition-Language/create-publication.md)
- [ALTER PUBLICATION](../Reference/SQL-Reference/Data-Definition-Language/alter-publication.md)
- [DROP PUBLICATION](../Reference/SQL-Reference/Data-Definition-Language/drop-publication.md)
- [SHOW PUBLICATIONS](../Reference/SQL-Reference/Other/SHOW-Statements/show-publications.md)
- [SHOW CREATE PUBLICATION](../Reference/SQL-Reference/Other/SHOW-Statements/show-create-publication.md)

### 订阅者参考文档

- [CREATE...FROM...PUBLICATION...](../Reference/SQL-Reference/Data-Definition-Language/create-subscription.md)
- [SHOW SUBSCRIPTIONS](../Reference/SQL-Reference/Other/SHOW-Statements/show-subscriptions.md)
