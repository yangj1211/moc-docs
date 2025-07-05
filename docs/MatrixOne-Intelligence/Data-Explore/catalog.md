# Catalog

Catalog 是数据存储与管理的关键组件，专为多模态数据场景打造，在数据驱动的业务中用于高效存储数据卷。

## 原始数据卷

原始数据卷用于存放用户上传的未处理非结构化数据，作为数据处理的基础存储单元，支持对原始卷中数据进行下载、预览和删除操作。

<div align="center">
    <img src=https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/catalog/vol_1.png
 width=80% heigth=80%/>
</div>

## 处理数据卷

处理数据卷用于存放经过数据清洗、转换等处理后的非结构化数据，便于后续分析与应用。

<div align="center">
    <img src=https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/catalog/vol_2.png
 width=80% heigth=80%/>
</div>

### 结果展示

点击文件名可查看该文件的处理详情页面，在此页面中，用户可对解析生成的文本块进行查看与删除操作。对于文本类型的识别内容，系统已将其中提取的图片按照对应的块 ID 命名，实现图片与文本块的精准关联，便于内容管理与溯源。

![](../../assets/images/catalog_1.png)

点击文件列表右侧的预览按钮可查看该文件的解析情况。

![](../../assets/images/catalog_2.png)

### 结果下载

点击下载后，将获得一个包含文字解析信息和图片资源的文件夹，文件夹内包括 JSON 文件、Markdown 文件和图片文件夹：

- JSON 文件：记录完整的文字解析内容，包括文件基础信息、分段类型、分段所在页码以及对应图片的原始元数据。
  
  <div align="center">
    <img src=https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/workspace/parse_1.png width=80% heigth=80%/>
  </div>

| 字段             | 描述             |
| -----------------| --------------- |
| filename               | 文件名            |
| filetype         | 文件类型          |
| block_count     | 被解析出的块数            |
| id             | block 现有的 id        |
| index             | block 的 id 从 1 自增|
| type             | block 类型，text/image         |
| content  |block 解析的内容        |
| page_number      | block 包含内容所在的页数，markdown 和 text 或者没有分页的文件就都为 1      |
| level           | block 的属性，目前只有 image 类型的 block 有此属性，1 表示 ocr，2 表示 caption  |
| image_url           | block 类型为 image 时，表示原始图片的存放路径|

- Markdown 文件：记录完整的 markdown 内容。
  
- 图片文件夹：存放文档中解析生成的图片资源，便于后续查看与使用。
