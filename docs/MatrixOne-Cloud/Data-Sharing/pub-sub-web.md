# 在 Web 端进行发布订阅

MatrixOne Cloud 支持以下两种方式进行实例间的发布订阅：

- [SQL 语句](./pub-sub-sql.md)
- Web 端

本篇文档主要介绍如何在 Web 端进行实例间的发布订阅。

## 发布订阅操作

### 发布订阅数据库

1. **发布者**: 实例_1 创建数据库 mall 与表 customer，登录实例平台，依次点击**数据库** > **发布** > **添加发布**，填写发布信息，发布此数据库为 pub_mall:

    ```sql
    -- 实例_1
    create database mall;
    CREATE TABLE mall.customer (
    customer_id INT,
    customer_name VARCHAR(255)
    );
    ```

    <div align="center">
    <img src=https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/data-sharing/pub-01.png width=70% heigth=70%/>
    </div>

    - **发布名**：发布名，唯一值，长度小于等于 64 字符。
    - **发布数据库**：发布对应的数据库名，不支持发布订阅库和系统数据库。
    - **发布权限**：发布库为只读。
    - **发布目标**：仅支持同一集群内的实例目标添加，至少添加一个发布目标，没有上限，可选择本组织实例和其他组织实例，不能发布给本实例。
    - **备注**：对于该发布的备注，长度小于等于 256 字符

    发布创建成功后，我们可以修改或者删除该发布

    <div align="center">
    <img src=https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/data-sharing/pub-04.png width=90% heigth=90%/>
    </div>

2. **订阅者**: 实例_2 和实例_3 登录实例平台，依次点击**数据库** > **订阅** > **+**，输入订阅名 sub_mall（订阅自实例_1 的 pub_mall），于是得到实例_1 数据库 mall 中的所有数据：

    <div align="center">
    <img src=https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/data-sharing/pub-02.png width=60% heigth=60%/>
    </div>

    <div align="center">
    <img src=https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/data-sharing/pub-03.png width=60% heigth=60%/>
    </div>

### 修改发布内容

发布者修改已发布内容，订阅者可以看到修改后的内容

1. **发布者**: 实例_1 创建数据库 mall2 和表 mall2.customer2，修改发布 pub_mall 内容：

    ```sql
    -- 实例_1
    create database mall2;
    CREATE TABLE mall2.customer2 (
    customer_id INT,
    customer_name VARCHAR(255)
    );
    ```

    <div align="center">
    <img src=https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/data-sharing/pub-05.png width=60% heigth=60%/>
    </div>

2. **订阅者**: 实例_2 查看订阅，能看到发布数据库修改后的内容：

    <div align="center">
    <img src=https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/data-sharing/pub-06.png width=90% heigth=90%/>
    </div>

### 删除发布对象

发布者可删除已发布的发布对象，订阅者随即无法连接相关的订阅对象，但是可以删除

<div align="center">
<img src=https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/data-sharing/pub-07.png width=90% heigth=90%/>
</div>

发布者发布已删除发布对象的同名对象，之前的订阅者可以连接至新的订阅对象

<div align="center">
<img src=https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/data-sharing/pub-08.png width=90% heigth=90%/>
</div>

可以看到，订阅者无需额外操作，即可连接至最新订阅对象。
