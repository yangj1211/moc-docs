# 客户端工具连接

MatrixOne 现在支持通过以下几种数据库客户端工具的方式连接 MatrixOne 服务：

- MySQL Client
- Navicat
- DBeaver

## 前期准备

- 已完成[创建实例](../../Instance-Mgmt/create-instance.md)。
- 已经[获取 MatrixOne Cloud 实例的连接命令](../../Instance-Mgmt/create-instance.md#_10)。

## 通过 MySQL Client 连接 MatrixOne Cloud服务

1. 下载安装 [MySQL Client](https://dev.mysql.com/downloads/installer/)。

2. 下载完成后，你可以使用 MySQL 命令行客户端来连接 MatrixOne Cloud 服务，只需要复制你获取的MatrixOne Cloud 实例的连接命令，并根据提示输入密码。

    ```
    mysql -h host_ip_address -P port -u tenant:user:role -p
    Enter password:
    ```


3. 连接成功提示如下：

    ```
    Welcome to the MySQL monitor. Commands end with ; or \g. Your MySQL connection id is 1031
    Server version: 8.0.30-MatrixOne-v1.0.0-rc1 MatrixOne
    Copyright (c) 2000, 2022, Oracle and/or its affiliates.

    Oracle is a registered trademark of Oracle Corporation and/or its affiliates. Other names may be trademarks of their respective owners.
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    ```

!!! note
    MatrixOne Cloud 与客户端默认是非加密传输，如果需要开启加密传输请参见[数据传输加密](../../Security/TLS-introduction.md)。

## 通过 Navicat 连接 MatrixOne Cloud 服务

1. 下载安装 [Navicat](https://www.navicat.com/en/products)。

2. 安装 Navicat 完成后，打开 Navicat，点击左上角 **Connection > MySQL**，在弹窗中填入如下参数：

    - **Connction Name**: MOCloud
    - **Host**: host_ip_address
    - **Port**: 6001
    - **User Name**: tenant:user:role
    - **Password**: your_password
    - **Save password**：勾选

3. 点击 **Save** 保存设置。

    ![navicat_config](https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/docs/develop/navicat-config.png)

4. 双击左侧数据库目录中的 **MOCloud**，图标点亮，连接成功。

5. 连接到 MatrixOne Cloud 后，在左侧数据库目录栏，你将看到 6 个默认系统数据库：

    <img src="https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/docs/develop/navicat-databases.png"  style="zoom: 60%;" />

    右侧窗口可查看有关此连接的基本信息：

    <img src="https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/docs/develop/navicat-connection.png"  style="zoom: 60%;" />

## 通过 DBeaver 连接 MatrixOne Cloud 服务

1. 下载安装 [DBeaver](https://dbeaver.io/download/)。

2. 安装 DBeaver 完成后，打开 DBeaver，点击左上角**连接**图标，在弹窗中选择 **MySQL**，点击 **Next**。

    ![dbeaver-mysql](https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/docs/develop/dbeaver-mysql.png)

    在 **Connect to a database** 窗口的 **Main** 区中填写如下参数：

    - **Host**: host_ip_address
    - **Port**: 6001
    - **Database**: system
    - **User Name**: tenant:user:role
    - **Password**: your_password
    - **Save password locally**: 勾选
    !!! note
        初次连接可以将Database选项填写系统库`system`方便连接，后续可根据需求自行修改。

    ![dbeaver-connection](https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/docs/develop/dbeaver-connection.png)
    

3. 双击左侧目录中的 **MatrixOne Cloud**，连接 MatrixOne Cloud 服务。你可以在左侧目录树中看到默认的四个系统数据库：

    ![dbeaver-databases](https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/docs/develop/dbeaver-databases.png)

4. 默认情况下，DBeaver 中不展示视图。如需显示完整的系统数据库，你可以右键单击 **MatrixOne**，选择 **Connection view** 并打开 **Show system objects**：

    <img src="https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/docs/develop/show-system-objects.png"  style="zoom: 40%;" />

    设置完成后，你将看到 6 个系统数据库。

    ![dbeaver-databases-with-view](https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/docs/develop/dbeaver-databases-with-view.png)
