# 工作流

工作流功能是 MatrixOne Intelligence 的核心特性之一，支持用户通过可视化方式定义和执行复杂的数据处理任务。

## 工作流创建

进入到工作区，依次点击**数据处理**>**工作流**>**创建工作流**，根据实际情况填写来进行工作流的创建。

<div align="center">
    <img src=https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/workspace/workflow_1.png width=80% heigth=80%/>
</div>

**基础配置**  

   | 配置项       | 说明                               |
   |--------------|----------------------------------|
   | 源数据卷     | 输入数据存储位置                   |
   | 目标数据卷   | 处理结果输出路径                   |
   | 文件类型     | 支持格式：<br>• 文档：doc/docx/ppt/pptx/txt/md/pdf<br>• 图像：jpg/jpeg/bmp/png |
   | 处理模式     | 支持：<br>• 单次处理：任务触发后仅运行一次<br>• 周期处理：调度周期：1/5/10/30 分钟、1/2/4/8 小时、1 天（默认 5 分钟），短周期（<1 天）：整点触发（如 30 分钟周期在 00/30 分执行），长周期（≥1 天）：需手动设置下次执行时间。<br>•关联处理：当相同原始卷中数据载入任务完成一批文件载入后，会立即执行工作流处理这些文件。 |
   | 优先级      | 选项包括“低”、“中”和“高”，默认值为“中”。设置后，新的工作流作业将根据该优先级即时生效。当多个工作流并发执行时，平台将按照优先级从高到低的顺序依次调度执行。                   |

**处理流程配置**  

   | 模块          | 功能说明                      |
   |---------------|---------------------------|
   | 文本分段      |  •分段方式：按字符<br>• 分段最大长度：100-2000（默认 800）<br>• 分段重叠：不超过设置的字段分段长度<br>• 文本预处理规则：替换掉连续的空格、换行符和制表符，删除所有的 URL 和电子邮箱地址        |
   | 图片描述      | 基于 Qwen/Qwen2-VL-72B-Instruct 模型生成图片内容描述                                         |
   | OCR 识别       | 采用 ucaslcl/GOT-OCR2_0 模型提取图像文字                                     |
   | 自定义脚本    | 支持 Python 脚本扩展处理逻辑，可访问上下游数据                                               |
   | 文本嵌入      | 通过 BAAl/bge-m3 模型生成文本向量                                |

## 分支管理

工作流分支管理功能旨在帮助数据工程师更高效地管理相似数据处理流程的不同版本，允许用户基于同一工作流创建多个分支版本，从而解决以下问题：

- 降低管理成本：避免重复创建相似工作流  
- 优化资源使用：相同处理步骤仅执行一次，结果仅存储一份  
- 简化对比：直观比较不同分支的流程和结果差异  

工作流分支机制类似于 Git 仓库的分支概念，一个工作流可包含多个分支版本，默认拥有一个“主要”分支作为基础版本。各分支共享基础配置信息（如源数据卷、文件类型等），但可独立修改其处理流程，执行结果则按分支名称分别存储在目标数据卷的子目录中。

### 创建分支

进入到工作流列表，点击右侧的创建工作流分支按钮，来进行分支创建。需选择基准分支（默认 "主要" 分支），新分支初始处理流程与基准分支一致，分支名称需唯一且符合命名规范。

!!! note
    主分支不可单独删除，删除所有分支等同于删除工作流。

<div align="center">
    <img src=https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/data-processing/workflow_3.png
 width=60% heigth=60%/>
</div>

新分支创建时根据工作流状态决定是否立即执行，所有分支共享执行基础信息，相同处理步骤只执行一次（优化资源使用），工作流状态由所有分支共同决定，起停操作影响所有分支。

### 修改分支

- 仅**停止状态**的工作流可编辑  
- 仅 "主要" 分支可修改基础配置，各分支可独立调整处理流程

<div align="center">
    <img src=https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/data-processing/workflow-7.png
 width=80% heigth=80%/>
</div>

### 对比分支

默认包含 "主要" 分支，支持多选对比  

<div align="center">
    <img src=https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/data-processing/workflow-5.png
 width=60% heigth=60%/>
</div>

### 删除分支

- "主要" 分支不可单独删除
- 删除所有分支等同于删除工作流
- 可选择是否同时删除数据卷中的分支数据

<div align="center">
    <img src=https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/data-processing/workflow-6.png
 width=80% heigth=80%/>
</div>

## 工作流管理

在工作流列表可以对工作流进行管理，您可以选择重新运行工作流或者修改、删除工作流，删除所有分支等同于删除工作流。

<div align="center">
    <img src=https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/data-processing/workflow-8.png
 width=100% heigth=100%/>
</div>

点击工作流名称可以查看工作流详细信息，点击右上角编辑按钮可以修改并重新运行工作流，点击执行详情按钮查看作业情况。

<div align="center">
    <img src=https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/data-processing/workflow-9.png
 width=100% heigth=100%/>
</div>