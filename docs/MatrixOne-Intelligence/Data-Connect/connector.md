# 连接器

MatrixOne Intellogence 平台提供了一个强大的数据连接器，用于支持数据的载入和导出，允许用户轻松地将存储在阿里云 OSS 或标准 S3 上的数据导入到 MatrixOne Intellogence 平台中。只需提供必要的连接信息，即可实现数据的无缝导入，为后续的数据分析和处理提供便利。同时支持将数据导出到知识库，目前支持导出到 dify。

## 如何使用连接器

进入到 MatrixOne Intelligence 工作区，依次点击**数据接入**>**连接器**>**创建连接器**，选择需要连接的数据源类型。

### 连接阿里云 OSS

要将阿里云 OSS 上的文件导入到 MatrixOne Intellogence 平台，您需要提供以下连接信息：

- 地区：OSS 服务的访问地址。
- AccessKeyId: 您的阿里云账号的 AccessKey ID。
- AccessKeySecret: 您的阿里云账号的 AccessKey Secret。
- 文件路径：OSS 上文件的路径。例如：`bucket-name/path/to/your/file.csv`。

<div align="center">
    <img src=https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/data-connect/conn_1.png
 width=60% heigth=60%/>
</div>

### 连接标准 S3

要将兼容 S3 协议的存储服务（如 AWS S3、MinIO 等）上的文件导入到 MatrixOne Intelligence 平台，您需要提供以下连接信息：

- Endpoint: 标准 S3 服务的访问地址。例如：`https://s3.amazonaws.com`。
- AccessKeyId: 您的标准 S3 账号的 AccessKey ID。
- AccessKeySecret: 您的标准 S3 账号的 AccessKey Secret。
- 文件路径：S3 上文件的路径。例如：`bucket-name/path/to/your/file.csv`。
- S3 地址风格：S3 地址风格决定了访问存储桶（Bucket）的 URL 结构，虚拟主机风格（Virtual Host）（推荐）：https: //my-bucket.s3.amazonaws.com/my-object，路径风格（Path Style）（部分旧系统）：https: //s3.amazonaws.com/my-bucket/my-object，AWS 目前推荐使用虚拟主机风格，部分私有 S3 兼容存储（如 MinIO）仍可能需要路径风格。
- 地区：S3 存储桶所在的地区。例如：us-east-1。

<div align="center">
    <img src=https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/data-connect/conn_2.png
 width=60% heigth=60%/>
</div>

### 连接 Dify 知识库

要将处理好的文件导出到 Dify 知识库，需要提供 API URL 和 API Key，具体配置方法请参考[数据导出](./export.md)

<div align="center">
  <img src="/assets/images/dify_conn.png" width="50%" height="50%">
</div>
