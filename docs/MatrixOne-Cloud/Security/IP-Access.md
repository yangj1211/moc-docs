# 设置 IP 白名单

设置 IP 白名单是 MatrixOne Cloud 服务中的一项重要功能，它允许你限制哪些 IP 地址可以访问你的数据库，确保只有受信任的 IP 地址能够连接到数据库服务器，以增加数据库的安全性。

本篇文档将为你介绍如何设置 IP 白名单。

## 如何设置 IP 白名单

以下是在 MatrixOne Cloud 中开启 IP 白名单的步骤：

1. 使用 MatrixOne Cloud 帐户登录到 MatrixOne Cloud 控制台。

2. 在控制台中，选择并点击进入你要设置 IP 白名单的数据库实例。

3. 点击进入 **Network Policy > IP Access**，点击 **Edit**。

4. 在弹窗中选择 **Access restriction method**，选择 **Access from spcified IP Address** 前的复选框，可以添加 IP 白名单。

5. 将新的 IP 地址到白名单中后，点击 **Submit**，添加成功。

通过开启 IP 白名单，确保只有受信任的 IP 地址能够访问数据库服务器。请谨慎配置 IP 白名单，并定期审查和更新允许访问的 IP 地址，以保持数据库的安全性。
