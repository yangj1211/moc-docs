# 结构化抽取 API

## 概述

结构化抽取 API 能够从 PDF 文件中提取关键信息并转换为结构化数据，支持自定义 JSON Schema 模板。

**主要使用场景：**

- PDF 简历信息抽取
- 合同文档关键信息提取  
- 发票 PDF 数据结构化
- 报告文档信息整理
- 证书文档数据化

## API 端点

```
POST https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/explore/extract
```

## 请求头

| 参数名 | 类型 | 是否必填 | 描述 |
|--------|------|----------|------|
| moi-key | String | 是 | API 密钥 |
| Content-Type | String | 是 | 固定值：application/json |

## 请求参数

| 参数名 | 类型 | 是否必填 | 描述 |
|--------|------|----------|------|
| file_path | String | 是 | PDF 文件的 URL 地址 |
| json_schema | Object | 是 | JSON Schema 抽取模式定义 |

## 请求示例

### Python 示例

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/explore/extract"
headers = {
    "moi-key": "your-api-key",
    "Content-Type": "application/json"
}

data = {
    "file_path": "http://120.26.117.79:8080/files/xiyou.pdf",
    "json_schema": {
        "title": "ExtractInfo",
        "type": "object",
        "properties": {
            "email": {
                "type": "string",
                "description": "联系邮箱"
            },
            "book_name": {
                "type": "string",
                "description": "书名"
            }
        },
        "required": [
            "email",
            "book_name"
        ]
    }
}

response = requests.post(url, headers=headers, json=data)
print(response.json())
```

### cURL 示例

```bash
curl --location --request POST 'https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/explore/extract' \
--header 'moi-key: your-api-key' \
--header 'Content-Type: application/json' \
--data-raw '{
    "file_path": "http://120.26.117.79:8080/files/xiyou.pdf",
    "json_schema": {
        "title": "ExtractInfo",
        "type": "object",
        "properties": {
            "email": {
                "type": "string",
                "description": "联系邮箱"
            },
            "book_name": {
                "type": "string",
                "description": "书名"
            }
        },
        "required": [
            "email",
            "book_name"
        ]
    }
}'
```

## 响应格式

```json
{
    "code": "ok",
    "msg": "ok",
    "data": {
        "req_id": "607654fa-f12b-4415-a4c4-38dd07c7926e",
        "msg": "success",
        "file_path": "http://120.26.117.79:8080/files/xiyou.pdf",
        "file_size_bytes": 1562886,
        "results": {
            "email": "466698432@qq.com",
            "book_name": "西游记"
        }
    }
}
```

**主要字段说明：**

- `data.results`：根据 json_schema 抽取的结构化数据
- `data.req_id`：请求唯一标识符
- `data.file_size_bytes`：文件大小（字节）
