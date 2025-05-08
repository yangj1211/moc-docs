# 数据载入

在创建了 OSS 或 S3 连接器后，您可以将存储在 OSS 或 S3 中的文件导入到 MatrixOne Intelligence 中的原始卷中。原始卷是用于存放非结构化数据的单位。您可以在 Catalog 中查看该卷及其中的数据。

## 如何进行数据载入

进入到 MatrixOne Intelligence 工作区，依次点击**数据接入**>**数据载入**>**载入数据**，选择连接器进行载入，支持载入 doc/docx/，ppt/pptx/，txt/md/，pdf，jpg/jpeg/bmp/png 格式文件，单个文件大小不超过 200MB。

<div align="center">
    <img src=https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/data-connect/conn-3.png
 width=80% heigth=80%/>
</div>

- 载入位置：您可以将文件载入到已创建好的原始数据卷，或新建一个原始数据卷。
  
- 载入模式：分为一次性载入和周期载入。一次性载入适合仅需导入一次的场景，周期性载入适合定期更新数据的需求，并可设置具体周期（如每小时或每日）。

创建完载入任务后，可以在数据载入列表中查看载入详情，对于运行中的载入任务您可以随时进行停止操作，只有任务在停止状态才能修改载入信息。当状态变成“完成”表示载入任务已成功。

<div align="center">
    <img src=https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/data-connect/load-1.png
 width=100% heigth=100%/>
</div>
