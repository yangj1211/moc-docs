# **CREATE PUBLICATION**

## **语法说明**

`CREATE PUBLICATION` 将一个新的发布添加到当前数据库中。

## **语法结构**

```
CREATE PUBLICATION pubname
    DATABASE database_name ACCOUNT
    [ { ALL
    | account_name, [, ... ] }]
    [ COMMENT 'string']
```

## 语法解释

- pubname：发布名称。发布名称必须与当前数据库中任何现有发布的名称不同。
- database_name：当前实例下已存在的某个数据库名称。
- account_name：可获取该发布的用户实例名称。

## **示例**

```sql
-- MatrixOne Cloud 的某个用户实例创建发布给 MatrixOne Cloud 的另外两个用户实例 acc0 和 acc1, MatrixOne Cloud 的用户实例名一般为类似 5e18ef19_7f2a_4762_9626_f3444a529a87 的数字。
mysql> create database t;
mysql> create publication pub1 database t account acc0,acc1;
Query OK, 0 rows affected (0.01 sec)

-- MatrixOne Cloud 的某个用户实例创建发布广播给整个 MatrixOne Cloud 同一 region 上的所有用户。
mysql> create database t;
mysql> create publication pub1 database t;
Query OK, 0 rows affected (0.01 sec)
```

## 限制

MatrxiOne Cloud 当前仅支持一次发布一个 Database。
