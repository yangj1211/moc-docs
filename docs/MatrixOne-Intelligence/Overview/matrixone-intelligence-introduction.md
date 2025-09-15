# MatrixOne Intelligence：AI-Native 多模态数据智能平台

MatrixOne Intelligence（MO Intelligence）是一个 AI 原生多模态数据智能平台。它不仅延续了 MatrixOne 超融合数据库的高性能与弹性能力，还面向生成式 AI 与智能体（Agent）的落地需求，提供从数据接入、解析、治理到智能检索与应用构建的一站式能力，帮助企业将分散的原始数据快速转化为高质量的 AI-Ready 数据，赋能下一代 AI 应用。

## MatrixOne Intelligence 架构

MatrixOne Intelligence 通过强大的数据与 AI 基座、统一的数据集成与治理及简便的数据服务智能体，形成了一套端到端的数据智能架构。

![](https://community-shared-data-1308875761.cos.ap-beijing.myqcloud.com/artwork/mocdocs/overview/moi_archit.png)

### 超融合存算底座

延续 MatrixOne 的存算分离与事务保障设计，同时支持行列混合存储与高并发 OLTP/OLAP 查询。￼

### AI 数据治理层

内置多模态解析（OCR/ASR/图像与视频解析）、向量化与嵌入管理，支持对文档、图片、音视频等非结构化数据的批量接入与特征抽取。￼

### 检索与推理能力

融合全文检索与语义（向量）检索，支持 RAG、语义搜索、Chat2BI 等上层 AI 应用场景。￼

### Serverless 与弹性计算

提供 Serverless 实例与弹性计算策略，按任务/用量进行资源调度与计费，自动伸缩以匹配负载。￼

### 多源接入与多云部署

支持从阿里云 OSS 和标准 S3 等数据源快速导入，并提供面向公有云与混合云的部署选项，不再局限于单一云厂商。￼

## MatrixOne Intelligence 核心特性

MO Intelligence 注重用户体验，提供了一系列核心特性，让用户轻松驾驭数据平台：

- 超融合统一存储：单一数据库同时支持事务处理、分析、向量检索与全文搜索，避免传统方案的多引擎拼接与数据孤岛问题。
- 云原生弹性：存算分离 + 多级缓存机制，实现按需伸缩与成本最优，支撑从实验原型到企业级生产的平滑过渡。
- 交互式闭环优化：用户反馈直接驱动数据管道与模型策略优化，智能体在真实业务场景中持续进化。
- 生态开放：原生支持 LangChain、Dify 等 RAG 开发框架，以及 MCP（Model-as-a-Controller Protocol）协议，方便开发者无缝集成到现有 AI 工具链。
- 全场景支持：覆盖文档智能处理、多模态搜索、智能问答、报告生成、R&D 助理、BI 分析等应用场景。

MatrixOne Intelligence 是一个面向 GenAI 与 AI 智能体时代的端到端平台。它将企业内部散乱的数据转化为可驱动业务的智能资产，提供可靠的数据与 AI 基座、智能的工作流治理，以及开放的生态集成能力，帮助企业真正释放数据价值，加速智能化转型。
