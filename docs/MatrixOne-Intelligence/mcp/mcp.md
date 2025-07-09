# MOI MCP 快速使用指南

## 什么是 MOI MCP？

MOI MCP（MatrixOne Intelligence Model Context Protocol）是 MatrixOne Intelligence 提供的智能服务接口，让 AI 助手可以直接使用 MOI 平台的各种数据处理和分析功能。

**MOI MCP 主要功能：**

- **创建连接器** - 连接各种数据源（数据库、文件、API 等）
- **载入数据** - 从不同数据源导入和处理数据
- **创建工作流** - 构建自动化的数据处理流程
- **获取解析后的数据** - 获取经过 AI 处理和分析的结构化数据

## 1. MCP 配置

1. 进入您的 MCP 客户端（Cursor、Claude 等）设置，找到配置 MCP 服务器的地方（不同客户端位置可能不同）

2. 注册新的 MCP 服务器，在 `mcpServers` 下添加 "moi" 配置块，配置内容如下：

```json
{
  "mcpServers": {
    "mcp-moi-server": {
      "type": "streamable-http",
      "url": "https://mcp.m1intelligence.cn/mcp/",
      "note": "For Streamable HTTP connections, add this URL directly in your MCP Client",
      "headers": {
        "moi-key": "<your-api-key>"
      }
    }
  }
}
```

3. 保存配置文件后，**退出客户端并重新进入**，使配置生效

## 2. 获取 API Key

1. 访问 MatrixOne Intelligence 控制台
2. 进入 API 管理页面
3. 创建新的 API Key
4. 复制密钥并更新配置文件中的 `<your-api-key>`
5. 重启 AI 客户端

> 💡 **详细说明**：关于 API Key 的创建和管理，请参考 [API Key 管理文档](../workflow%20api/token_api.md#api-key-管理)

## 开始使用

完成上述两个步骤后，就可以在对话中使用 MOI MCP 功能了：

![](../../assets/images/mcp.png)
