# **SHOW PUBLICATIONS**

## **语法说明**

返回所有 PUBLICATION 名称列表与对应数据库名。

## **语法结构**

```
SHOW PUBLICATIONS;
```

## **示例**

```sql
create database t;
create publication pub3 database t account acc0,acc1;

mysql> show publications;
+------+----------+
| Name | Database |
+------+----------+
| pub3 | t        |
+------+----------+
1 row in set (0.00 sec)
```