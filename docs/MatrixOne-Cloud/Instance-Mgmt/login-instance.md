
MatrixOne Cloud 除了可以使用管理员用户登录到实例的数据库管理平台，还支持普通用户访问，只要授予相应权限即可。

**步骤：**

- 通过 admin 用户登陆后，创建一个新的用户

```sql
create user u2 identified by '123456';
```

- 在租户中，没有被赋予角色的情况下用户是不能做任何操作的。所以我们需要创建一个新的角色。

```sql
create role if not exists role2;
```

- 将对象权限授予给角色，再将角色赋予给用户，这个时候，用户就可以对对象进行操作了。如果未授权，那么普通用户登录后只能查看查询历史的信息，如需其它操作，则应授予相应权限，详情可查看 [MatrixOne Cloud 中的权限管理](../Reference/access-control-type.md)。执行以下操作可为角色赋最高权限。

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