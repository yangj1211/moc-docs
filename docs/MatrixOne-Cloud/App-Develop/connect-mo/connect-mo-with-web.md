# 使用 Web 页面连接 MatrixOne 实例

MatrixOne Cloud 支持使用 Web 页面访问数据库，我们将此访问平台称为数据库管理平台。这个平台特别适合数据库管理员和数据分析师使用，提供了丰富的可视化数据库操作功能，包括数据业务监控、数据对象查看与操作、查询历史记录、查询编辑器等。

## 访问入口

在 MatrixOne Cloud 实例管理平台的实例列表中，找到您需要访问的数据库实例卡片，然后按照以下步骤进入数据库管理平台：

1. 登录您的 MO Cloud 账号，进入实例管理平台。

    如果您还没有 MO Cloud 账号，您可以点击[注册登录](https://www.matrixorigin.cn/moc-trial)开始注册，或者参照[快速体验 MatrixOne Cloud](../../Get-Started/quickstart.md) 的注册指南。

2. 在菜单栏中点击**实例**进入实例列表页面，然后选择实例。
3. 点击**连接**。
4. 选择**通过云平台连接**。

## 登录

进入到实例的数据库管理平台登录页面，您需要输入数据库的用户名和密码才能成功登录。为了确保数据安全，您也可以使用普通用户登录到云平台，只要授予相应权限即可。

**步骤：**

- 通过 admin 用户登陆后，创建一个新的用户

```sql
create user u2 identified by '123456';
```

- 在租户中，没有被赋予角色的情况下用户是不能做任何操作的。所以我们需要创建一个新的角色。

```sql
create role if not exists role2;
```

- 将对象权限授予给角色，再将角色赋予给用户，这个时候，用户就可以对对象进行操作了。如果未授权，那么普通用户登录后只能查看查询历史的信息，如需其它操作，则应授予相应权限，详情可查看 [MatrixOne Cloud 中的权限管理](../../Reference/access-control-type.md)。执行以下操作可为角色赋最高权限。

```sql
grant all on account * to role2;
grant all on database * to role2;
grant all on table *.* to role2;
grant role2 to u2;
```

- 用普通用户登录云平台

若想以普通用户登录到云平台，用户名处格式应为“用户名：角色名”，例如 "u2:role2", 如果不填写角色名则默认角色为 public。

<div align="center">
<img src=https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/develop/login.png width=60% heigth=60%/>
</div>

## 访问数据库

数据库管理平台提供了多种数据库访问功能：

- **仪表盘：**在菜单栏中点击**仪表盘**，可以查看数据库的业务监控信息。详细使用方法请参考[数据监控文档](../../../Monitor/Monitoring/)。

- **数据库：**在菜单栏中点击**数据库**，您可以查看和操作数据对象。详细使用方法请参考[相关文档](../../../Monitor/Data-Monitoring/)。

- **查询 -> 查询编辑器：**在菜单栏中依次点击**查询 -> 查询编辑器**，可以进行 SQL 的编辑和执行。详细使用方法请参考[查询编辑器文档](../../../Data-Explore/sql-editor/)。

- **查询 -> 查询历史：**在菜单栏中依次点击**查询 -> 查询历史**，您可以查看历史 SQL 查询的执行状态。详细使用方法请参考[查询分析文档](../../../Data-Explore/query-anlysis/query_profile/)。

希望这些操作指南能够帮助您顺利使用 MatrixOne 数据库管理平台。如果您有任何疑问或需要进一步的帮助，请查看我们的文档或联系支持团队。
