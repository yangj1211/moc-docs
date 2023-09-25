# 终止和恢复实例

本篇文档将介绍如何终止和恢复实例，以及相关产品行为。

!!! note
    MO Cloud 不会永久保存已终止实例的状态，请谨慎操作。如果不慎删除，及时恢复实例以防数据丢失。

## 终止实例

1. 点击菜单栏中的 **Instances** 按钮，进入实例列表。
2. 在 **Active Instances** 页签中选择要终止的实例，在实例卡片上点击 **Terminate**。
3. 在弹窗中确认要终止实例的名称，实例将进入终止中状态。数秒后，实例将完全终止，并显示在 **Terminated Instances** 页签中。

!!! note
     1. 实例终止后，将立即终止数据库的所有访问连接。
     2. 我们会为终止状态的实例保留 7 天的数据，7 天后，MO Cloud 将自动永久删除该实例的数据信息。

## 恢复实例

在 **Terminated Instances** 页签内的实例可以恢复到 **Active Instances**，请按照以下步骤操作：

1. 选择要恢复的实例，然后点击 **Recovery** 按钮。
2. 在弹窗中确认，实例将在数秒后完全恢复正常状态。

以下是不同实例状态下可进行的操作和其他相关操作：

- **实例状态：Creating**
  - 描述：创建实例中
  - 实例操作：无
  - 其他操作：无

- **实例状态：Active**
  - 描述：正常运行中，可以提供服务
  - 实例操作：Terminate
  - 其他操作：Connect、Monitoring、实例详情、Edit Spend Limit

- **实例状态：Inactive**
  - 描述：实例状态异常，无法提供完整服务
  - 实例操作：Terminate
  - 其他操作：Monitoring、实例详情、Edit Limit

- **实例状态：Terminating**
  - 描述：实例终止中
  - 实例操作：无
  - 其他操作：Monitoring

- **实例状态：Recovering**
  - 描述：实例恢复中
  - 实例操作：无
  - 其他操作：Monitoring

- **实例状态：Upgrading**
  - 描述：实例正在升级中
  - 实例操作：无
  - 其他操作：Connect、Monitoring、实例详情、Edit Spend Limit

- **实例状态：Terminated**
  - 描述：实例终止
  - 实例操作：Recovery
  - 其他操作：Monitoring

希望这些操作指南能够帮助您更好地管理和恢复 MatrixOne 实例。如有任何疑问或需要进一步的帮助，请继续查看我们的文档或联系支持团队。
