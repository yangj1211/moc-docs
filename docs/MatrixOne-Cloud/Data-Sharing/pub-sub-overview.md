# 数据共享

MarixOne Cloud 为用户提供了实例间数据快速共享的功能，用户可以在实例中通过发布订阅操作进行数据共享。下面我们将介绍什么是发布订阅以及如何在 MatrixOne Cloud 中如何使用它。

## 发布订阅

数据库的发布订阅（Publish-Subscribe，简称 Pub/Sub）是一种消息传递模式，其中**发布者**将消息发送给一个或多个**订阅者**，而**订阅者**则接收并处理该消息。在这种模式下，发布者和订阅者之间是松耦合的，它们之间不需要直接通信，因此可以提高应用程序的可扩展性和灵活性。在 MarixOne Cloud 中发布者和订阅者都是 MarixOne Cloud 上的实例。

在数据库中，发布订阅功能通常被用于实时数据更新、缓存同步、业务事件通知等场景。例如，当数据库中某个表的数据发生变化时，可以通过发布订阅功能实时通知订阅者，从而实现实时数据同步和处理。另外，也可以通过发布订阅功能来实现业务事件的通知，例如某个订单被取消、某个库存数量不足等等。

通常，数据库的发布订阅功能由两部分组成：**发布者**和**订阅者**。**发布者**负责发布消息，而**订阅者**则订阅相应消息以达到数据同步的目的。发布者和订阅者之间可以存在多对多的关系，即一个发布者可以向多个订阅者发布消息，而一个订阅者也可以订阅多个消息/数据。

## 应用场景

发布订阅功能具有多种典型的应用场景：

- **数据同步**：当一个数据库需要与另一个数据库保持同步时，发布订阅功能可以用来将数据更改发送到订阅者数据库。例如，当一个网站需要将数据从一个地理位置传输到另一个地理位置时，发布订阅功能可以用来确保两个数据库之间的数据同步。

- **业务数据分发**：发布订阅功能可以用来将业务数据分发到不同的系统或业务流程中。例如，当一个银行需要将客户账户信息分发到多个业务系统中时，发布订阅功能可以用来将数据分发到相应的系统中，确保各个业务流程之间的数据一致性。

- **数据备份**：发布订阅功能可以用来备份数据。例如，当一个数据库需要备份到另一个数据库时，发布订阅功能可以用来将数据备份到订阅者数据库中，以便在主数据库出现故障时恢复数据。

- **实时数据处理**：发布订阅功能可以用来实现实时数据处理。例如，当一个网站需要对来自不同用户的数据进行处理时，发布订阅功能可以用来将数据传输到处理程序中进行处理，以便实现实时数据分析和决策。

<!--- 通知和提醒：发布订阅功能可以用来向不同的用户或系统发送通知和提醒。例如，当一个电子商务网站需要通知顾客有新产品上线时，发布订阅功能可以用来将新产品信息发布到顾客的订阅列表中，以便顾客及时了解到新产品信息。-->

## 名词解释

- **发布**：在数据库中，发布通常指的是将一个数据库对象设置为可供其他实例访问的状态。这是数据共享和复制的一个重要步骤，发布的对象可以被其他实例订阅并获取数据。

- **订阅**：订阅是指一个数据库选择接收和复制发布的数据库对象的数据。

- **发布端（Pub）**：发布端是执行发布操作的数据库。发布端负责创建和管理发布的对象，以及管理订阅该发布对象的数据库的访问权限。

- **订阅端（Sub）**：订阅端是订阅发布对象的实例。

- **发布对象**：发布对象是在发布端创建并设置为可发布的数据库对象，即数据库。这些对象的数据可以被订阅端访问和复制。

- **订阅对象**：订阅对象是在订阅端复制和存储的发布对象。订阅对象的数据会根据发布端的数据进行更新。

## 发布订阅范围说明

### 发布/订阅应用范围

**发布端（Pub）**和**订阅端（Sub）**均为 MatrixOne 的实例。

### 可发布/可订阅权限范围

- **发布端（Pub）**只有 ACCOUNTADMIN 或 MOADMIN 角色可以创建发布与订阅。
- **订阅端（Sub）**由 ACCOUNTADMIN 或 MOADMIN 角色操作访问订阅数据权限。

### 发布/订阅数据范围

- 一个**发布**只能与单一数据库关联。
- 发布和订阅只在数据库级别实现，目前还不支持直接进行表级别的发布和订阅。
- **订阅端**对**订阅库**只具备读取权限。

- 若**发布端（Pub）**调整了发布的分享范围，那些不在新范围内的**订阅端（Sub）**如果已经创建了订阅库，那么对这个**订阅库**的访问将无效。
- 若**发布端（Pub）**尝试删除已经发布的数据库，那么此次删除将不会成功。
- 若**发布端（Pub）**删除了**发布**，但订阅库中的对应对象仍存在，此时**订阅端（Sub）**访问这个对象会触发错误，需要由**订阅端（Sub）**删除对应的**订阅**。
- 若**发布端（Pub）**删除了**发布对象**，但在订阅库中的对应对象仍然存在，此时**订阅端（Sub）**访问这个对象会触发错误，需要由**订阅端（Sub）**删除对应的**订阅对象**。

### 发布订阅示例

![](https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/data-sharing/subpub.jpg)

需要注意的是，你的实例 ID 可以通过 Mysql 连接串来获得，若你还未获得，[点此获取 MarixOne Cloud 实例的连接命令](../Instance-Mgmt/connect-instance.md)。

你会获得类似这样的 Mysql 连接串：

```bash
mysql -h freetier-01.cn-hangzhou.cluster.matrixonecloud.cn -P 6001 
-u 499575b7_4b78_403b_8356_ebd767dcxxxx:admin:accountadmin  -p
```

参数 -u 后面的字符串 `499575b7_4b78_403b_8356_ebd767dcxxxx:admin:accountadmin` 是完整的用户名，其中以 `:` 为分隔符的第一段 `499575b7_4b78_403b_8356_ebd767dcxxx` 即为你的实例 ID。

下面将给出一些示例，介绍当前在 MatrixOne 集群中，发布订阅的操作和权限：

#### 发布订阅数据库

1. **发布者**: 实例 A 创建数据库 mall 与表 customer 并发布此数据库为 pub_mall:

    ```mysql
    -- 实例 A
    create database mall;
    CREATE TABLE mall.customer (
    customer_id INT,
    customer_name VARCHAR(255)
    );
    create publication pub_mall database mall;
    ```

2. **订阅者**: 实例 B 和实例 C 都创建订阅库 sub_mall（订阅自实例 A 的 pub_mall），于是得到实例 A 数据库 mall 中的所有数据：

    ```mysql
    -- 实例 B && 实例 C 
    create database sub_mall from 65758cd2_b40b_4729_b3e4_1959137fxxxx publication pub_mall;
    use sub_mall;
    show tables;
    mysql> show tables;
    +--------------------+
    | Tables_in_sub_mall |
    +--------------------+
    | customer           |
    +--------------------+
    1 row in set (0.11 sec)
    ```

#### 订阅后数据同步更新

1. **发布者**: 实例 A 创建数据表 orders：

    ```mysql
    --  实例 A
    CREATE TABLE mall.orders (
    order_id INT,
    order_date DATE
    );
    ```

2. **订阅者**: 已经订阅数据库 mall 的实例 B 和实例 C 得到更新的数据表 orders:

    ```mysql
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

#### 发布者可指定有限订阅者

1. **发布者**: 实例 A 创建数据库 school 与表 student，并发布 pub_school 给实例 B 和实例 D:

    ```mysql
    --  实例 A
    create database school;
    CREATE TABLE school.student (
    student_id INT,
    student_name VARCHAR(255)
    );
    create publication pub_school database school account 499575b7_4b78_403b_8356_ebd767dcxxxx,abf2eb89_faf1_40fd_b24c_19bed148xxxx;
    ```

2. **订阅者**: 实例 B 和实例 C 都创建订阅库 sub_school（订阅自实例 A 的 pub_school），实例 B 订阅成功并得到数据，实例 C 订阅失败：

    ```mysql
    -- 实例 B 
    create database sub_school from 65758cd2_b40b_4729_b3e4_1959137fxxxx publication pub_school;
    use sub_school;
    show tables;
    +----------------------+
    | Tables_in_sub_school |
    +----------------------+
    | student              |
    +----------------------+
    1 row in set (0.11 sec)                 
    ```

    ```mysql
    -- 实例 C
    create database sub_school from 65758cd2_b40b_4729_b3e4_1959137fxxxx publication pub_school;
    > ERROR 20101 (HY000): internal error: the account 实例 C is not allowed to subscribe the publication pub_school
    ```

#### 发布者可发布给全体

1. **发布者**: 实例 A 修改发布 pub_school 给全部实例：

    ```mysql
    -- 实例 A
    alter publication pub_school account all;
    ```

2. **订阅者**: 实例 C 创建订阅库 sub_school 成功，得到共享的数据表 student：

    ```mysql
    -- 实例 C
    create database sub_school from 65758cd2_b40b_4729_b3e4_1959137fxxxx publication pub_school;
    use sub_school;
    show tables;
    +----------------------+
    | Tables_in_sub_school |
    +----------------------+
    | student              |
    +----------------------+
    1 row in set (0.11 sec)
    ```

#### 发布者可删除已发布的发布对象，订阅者随即无法连接相关的订阅对象，但是可以删除

1. **发布者**: 实例 A 删除发布 pub_mall:

    ```mysql
    -- 实例 A
    drop publication pub_mall;
    ```

2. **订阅者**: 实例 B 连接 sub_mall 失败：

    ```mysql
    -- 实例 B 
    use sub_mall;
    ERROR 20101 (HY000): internal error: there is no publication pub_mall
    ```

3. **订阅者**: 实例 C 删除 sub_mall:

    ```mysql
    -- 实例 C 
    drop database sub_mall;
    ```

#### 发布者重新发布已经删除的发布对象，之前的订阅者可以重新连接订阅对象

1. **发布者**: 实例 A 重新创建 pub_mall:

    ```mysql
    -- 实例 A
    create publication pub_mall database mall;
    ```

2. **订阅者**: 实例 B 连接 sub_mall 成功：

    ```mysql
    -- 实例 B 
    use sub_mall;
    show tables;
    +--------------------+
    | Tables_in_sub_mall |
    +--------------------+
    | customer           |
    | orders             |
    +--------------------+
    2 rows in set (0.21 sec)
    ```

#### 发布者发布已删除发布对象的同名对象，之前的订阅者可以连接至新的订阅对象

1. **发布者**: 实例 A 删除发布 pub_mall:

    ```mysql
    -- 实例 A
    drop publication pub_mall;
    ```

2. **发布者**: 实例 A 创建数据库 mall2 与表 customer2:

    ```mysql
    -- 实例 A
    create database mall2;
    create table mall2.customer2 (customer_id INT,customer_name VARCHAR(255));
    ```

3. **发布者**: 实例 A 重新创建 pub_mall:

    ```mysql
    -- 实例 A
    create publication pub_mall database mall2;
    ```

4. **订阅者**: 实例 B 连接 sub_mall 成功：

    ```mysql
    -- 实例 B 
    use sub_mall;
    show tables;
    +--------------------+
    | Tables_in_sub_mall |
    +--------------------+
    | customer2          |
    +--------------------+
    2 rows in set (0.21 sec)
    ```

可以看到，订阅者无需额外操作，即可连接至最新订阅对象。

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
