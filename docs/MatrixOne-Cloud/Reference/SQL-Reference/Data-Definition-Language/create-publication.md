# **CREATE...FROM...PUBLICATION...**

## **语法说明**

`CREATE...FROM...PUBLICATION...` 是订阅方订阅一个由发布方创建的发布，用来获取发布方的共享数据。

## **语法结构**

```
CREATE DATABASE database_name
FROM account_name
PUBLICATION pubname;
```

## 语法解释

- database_name：订阅方创建的数据库名称。
- pubname：发布方已发布的发布名称。
- account_name：可获取该发布的实例名称。

## **示例**

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
    ```

!!! note
    如果需要取消订阅，可以直接删除已订阅的数据库名称，使用 [`DROP DATABASE`](drop-database.md)。
