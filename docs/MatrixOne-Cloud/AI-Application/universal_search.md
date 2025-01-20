# 通用搜索

在当今数字化时代，企业面临着数据量的爆炸式增长，尤其是非结构化数据，它们占据了企业数据总量的 80%，并以每年 60% 的速度增长。这些数据中蕴含着丰富的业务洞察和市场趋势，但传统的搜索技术却难以有效挖掘其价值。

为了应对这一挑战，MatrixOne Intelligence 推出了通用搜索应用，它快速定位海量文件和数据库中的关键信息，通过先进的自然语言处理和语义分析技术，用户只需输入简单的查询，就可以获得相关答案，适用于知识管理、问题解答和数据分析等场景，帮助企业快速、准确地获取所需信息，释放数据潜力，驱动业务创新和决策优化。

## 如何使用通用搜索

登录至 MO Intelligence 运维平台，进入到 **AI 应用市场**界面，点击**通用搜索**图标中的**使用**按钮挑转到通用搜索界面。

<div align="center">
    <img src=https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/search/search_1.png
 width=60% heigth=60%/>
</div>

### 连接器

若您的资料存储于百度网盘或 MO Intelligence 实例，请先配置相应的连接器以确保数据的正常访问；若资料存储于本地，则无需进行上述配置，可直接在数据源页面上传本地文件。

#### 百度网盘

在添加连接器的界面，点击**百度网盘**图标，输入连接名称然后获取百度授权，授权完毕后返回连接界面测试连接是否成功。若在授权过程中遇到无法打开授权页面的问题，请检查是否开启代理，如果代理服务处于开启状态，请将其关闭再重新操作。

<div align="center">
    <img src=https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/search/connector-2.png width=60% heigth=60%/>
</div>

#### MatrixOne Intelligence

在添加连接器的界面，点击 **MatrixOne Intelligence** 图标，输入相关连接信息并测试连接是否成功。

<div align="center">
    <img src=https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/search/connector_1.png width=70% heigth=70%/>
</div>

### 数据源

目前支持以下数据源：

- 本地文件
- MatrixOne Intelligence
- 百度网盘
  
<div align="center">
    <img src=https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/search/datasource-1.png width=60% heigth=60%/>
</div>

#### 本地文件

点击右侧的**上传文件**按钮，选择并上传文件。目前支持的文件格式包括 'md', 'txt', 'pdf', 'jpg', 'png', 'jpeg', 'docx', 'pptx'，且每个文件的大小限制为 20 MB。

<div align="center">
    <img src=https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/search/datasource-2.png width=60% heigth=60%/>
</div>

文件上传完成后，将需要一定时间进行解析，请您耐心等待。解析完成后，文件才可用于搜索功能。您可以前往**已上传文件**页面查看文件解析进度。对于解析失败的文件，您可以重新进行解析；对于不需要的文件，亦可进行删除操作。

#### MatrixOne Intelligence

点击右侧的**添加数据表**选择连接器，进入到连接界面，选择您需要连接的表进行连接。可点击**已同步的数据**查看连接情况。

<div align="center">
    <img src=https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/search/datasource-3.png width=60% heigth=60%/>
</div>

#### 百度网盘

点击右侧的**上传文件**选择连接器，进入到连接界面，选择您需要连接的表进行连接。支持上传的文件类型和大小与本地上传一致。

<div align="center">
    <img src=https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/search/datasource-4.png width=60% heigth=60%/>
</div>

### 搜索

在搜索界面，用户可以根据输入的描述或照片进行结果搜索。目前支持以下类型的搜索：

- 文档搜索
- 照片
- 图表

#### 文档搜索

在文档搜索功能中，用户可以输入详细的文本描述，系统将利用智能化算法，从海量数据中精准提取并返回最匹配的答案，帮助用户快速找到所需信息。

<div align="center">
    <img src=https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/search/search_4.png
 width=60% heigth=60%/>
</div>

#### 照片

在进行图像搜索时，MatrixOne Intelligence 提供了两种检索方式：基于文本描述的搜索和基于图像相似度的搜索。

<div align="center">
    <img src=https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/search/search_2.png width=60% heigth=60%/>
</div>

<div align="center">
    <img src=https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/search/search_5.png width=60% heigth=60%/>
</div>

#### 图表

若您希望深入挖掘和分析数据库中的关键信息，可以利用图表搜索功能。这一功能不仅能帮助您通过直观的商务智能（BI）图表呈现数据，还能够结合数据的各类维度进行深入分析，自动生成有价值的见解。这使得决策者能够高效地识别潜在的业务机会、异常模式或优化领域，从而为数据驱动的决策提供有力支持。

<div align="center">
    <img src=https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/search/search_3.png width=70% heigth=70%/>
</div>