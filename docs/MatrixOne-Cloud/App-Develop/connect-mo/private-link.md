# 私网连接（PrivateLink）

## 介绍

阿里云私网连接（PrivateLink）是一种高可用、可扩展的技术，您可以使用它将您的应用程序连接到阿里云同一个地域或者不同地域的 MatrixOne Cloud 实例。"私有网络连接" 允许您阿里云中的应用程序通过您的私有 IP 地址连接到 MatrixOne Cloud 实例的私有网关地址，而不是公共互联网网关地址。既节省公共互联网的网络流量开销，又提高了连接 MatrixOne Cloud 实例的带宽。

MatrixOne Cloud 的架构如下：

![TDengine Cloud 私网连接架构](https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/connect/priveteLink-connectInstance-arch.jpg)

有关阿里云私网连接（PrivateLink）概念的更多详细信息，请参阅以下文档：

- [什么是私网连接](https://help.aliyun.com/document_detail/161974.html)
- [阿里云私网连接概述](https://help.aliyun.com/document_detail/2539840.html)

## 如何使用私网链接

### 步骤一：在 MO Cloud 实例管理平台获取私网连接相关信息

在 MO Cloud 实例管理平台的实例列表中，找到需要访问的 MatrixOne 实例，依次点击**连接 > 通过第三方工具连接>私网连接**，这时可以获取服务名称，可用区 ID，区域 ID。

![](https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/connect/priveteLink-connectInstance.png)

### 步骤二：在阿里云控制台配置终端节点

使用阿里云管理控制台创建终端节点，请按照以下步骤操作：

1. 登录阿里云控制台[阿里云控制台](https://home.console.aliyun.com/home)，打开阿里云 VPC 控制台[专有网络](https://vpc.console.aliyun.com/)。

2. 从区域下拉列表中选择您的 VPC 所在的地域。在左侧导航栏中单击**终端节点**，在右侧页面单击左上角的**创建终端节点**，进入**创建终端节点**页面。

    ![创建终端节点](https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/connect/priveteLink-createNode.png)

3. 选择**接口终端节点**。

4. 搜索框中搜索步骤一中的服务名称，这里就可以看到可用服务，选中可用服务。

5. 选择业务服务所在的 vpc，添加完专有网络，会出现下面两个选择项。

    ![设置安全组&amp;网络交换机](https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/connect/priveteLink-setSafeGroup.png)

6. 选择已有安全组或者创建一个。

7. 可用区交换机如果存在要选择在端点服务所在可用区，不存在请创建一个；这里默认要填两个，删掉第二个。

8. 单击创建端点。等待创建成功，在终端节点详情页面您即可得到 **VPC 终端节点 ID**。

### 步骤三：在您的 ECS 主机配置服务名称 DNS

1. 从阿里云控制台，进入私网连接控制台，找到您在步骤 2 中创建的终端节点，单击查看。

2. 在右侧终端节点详情页面中选择**可用区与网卡**选项卡，可以看到如下图页面。

    ![查看终端节点 IP](https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/connect/priveteLink-availableRegion.png)

3. 在和终端节点同 vpc 下添加一个 ECS

4. 登录您的 ECS 主机，修改 /etc/hosts 文件。格式：**{终端节点 IP} {服务名称} {服务名称}**。

    ![](https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/connect/priveteLink-modHosts.png)

### 步骤四：在您的 ECS 主机连接 MatrixOne Cloud 服务

1. 确保您的 ECS 主机已经 Mysql Client 客户端。
2. 使用 Mysql 客户端连接 MatrixOne Cloud 服务，得到如下结果，说明已经通过私网连接成功连接 MatrixOne Cloud

```mysql
mysql -h com.aliyuncs.privatelink.cn-hangzhou.epsrv-xxx -P 6001 -u xxx:admin:accountadmin  -p
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 6042249
Server version: 8.0.30-MatrixOne-v1.0.0-rc2 MatrixOne

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

```
