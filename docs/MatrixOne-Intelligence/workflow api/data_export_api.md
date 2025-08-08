# 数据导出 API 文档

## 概述

数据导出 API 提供了一套完整的接口来管理和执行数据导出任务。支持将工作流处理的数据导出到外部系统，如 Dify 知识库等。

## 导出任务管理

### 创建导出任务

```
POST /export/task/create
```

**输入参数：**

|  参数             | 是否必填 |含义|
|  --------------- | ------- |----  |
| task_name        | 是      | 任务名称|
| creator          | 是      | 创建者|
| connector_id     | 是      | 连接器 ID|
| connector_name   | 是      | 连接器名称|
| type             | 是      | 任务类型|
| config           | 是      | 导出配置对象|
| &nbsp;&nbsp;&nbsp;&nbsp;dify_config | 是    | Dify 配置对象|
| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;dataset_id | 是 | 数据集 ID|
| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;dataset_name | 是 | 数据集名称|
| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;embedding_model | 是 | 嵌入模型|
| &nbsp;&nbsp;&nbsp;&nbsp;mo_config | 否    | MatrixOne 导出配置对象|
| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;database_name | 是 | 数据库名|
| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;table_name | 是 | 表名|
| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;new_table | 否 | 是否新建表，默认 false|
| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;column | 是 | 列配置对象|
| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;export_column | 是 | 字段映射列表|
| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;source_column | 是 | 源字段名|
| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;mapping_column | 是 | 目标字段名|
| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;combine_column | 是 | 需要合并的字段名列表|
| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;duplicated_strategy | 是 | 重复数据处理策略（整数）|
| &nbsp;&nbsp;&nbsp;&nbsp;merge_title_to_text | 否    | 是否将标题合并到文本，默认 false|
| files            | 是      | 文件列表|
| &nbsp;&nbsp;&nbsp;&nbsp;file_id    | 是      | 文件 ID|
| &nbsp;&nbsp;&nbsp;&nbsp;full_path  | 是      | 文件完整路径数组|

提示：如果仅导出到 Dify，可只提供 `dify_config`；导出到 MatrixOne 时，需要提供 `mo_config` 并按要求配置列映射与重复策略。

**示例：**

```python
import requests

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/export/task/create"
headers = {
    "moi-key": "xxxxx"
}

body = {
    "task_name": "测试导出任务",
    "creator": "admin",
    "connector_id": 1,
    "connector_name": "Dify 连接器",
    "type": 1,
         "config": {
         "dify_config": {
             "dataset_id": "dataset_123",
             "dataset_name": "测试数据集",
             "embedding_model": "text-embedding-ada-002"
         },
         "merge_title_to_text": False
     },
    "files": [
        {
            "file_id": "file_456",
            "full_path": ["/data", "documents", "test.pdf"]
        }
    ]
}

response = requests.post(url, json=body, headers=headers)

if response.status_code == 200:
    print(response.json()) 
else:
    print(f"请求失败，状态码：{response.status_code}, 错误信息：{response.text}")
```

**返回：**

```json
{
    "code": "ok",
    "msg": "ok",
    "data": null
}
```

### 查询导出任务列表

```
POST /export/task/list
```

**输入参数：**

|  参数             | 数据类型 | 是否必填 |含义 | 默认值 |
|  --------------- | ---- | ----   | ----  | ---- |
| offset           |int |否 |分页偏移量 |0 |
| limit            |int |否 |分页限制 |10 |
| statuses         |array |否 |任务状态列表 | |
| creator          |string |否 |任务创建用户 | |
| connector_name   |string |否 |连接器名称 | |
| task_id          |string |否 |任务 ID | |
| order_by         |string |否 |排序字段 |created_at |
| order_direction  |string |否 |排序方向 |desc |

**输出参数：**

|  参数             | 含义 |
|  --------------- | ----  |
| tasks            |导出任务列表       |
| &nbsp;&nbsp;&nbsp;&nbsp;id         | 任务 ID     |
| &nbsp;&nbsp;&nbsp;&nbsp;name       | 任务名称    |
| &nbsp;&nbsp;&nbsp;&nbsp;connector_name | 连接器名称    |
| &nbsp;&nbsp;&nbsp;&nbsp;type       | 任务类型    |
| &nbsp;&nbsp;&nbsp;&nbsp;status     | 任务状态    |
| &nbsp;&nbsp;&nbsp;&nbsp;export_source | 导出源    |
| &nbsp;&nbsp;&nbsp;&nbsp;create_time | 创建时间    |
| &nbsp;&nbsp;&nbsp;&nbsp;end_time   | 结束时间    |
| total            | 总数量    |

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/export/task/list"
headers = {
    "moi-key": "xxxxx"
}

body = {
    "offset": 0,
    "limit": 10,
    "statuses": [1, 2],
    "creator": "admin",
    "order_by": "created_at",
    "order_direction": "desc"
}

response = requests.post(url, json=body, headers=headers)

print("Response Body:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

**返回：**

```json
{
    "code": "ok",
    "msg": "ok",
    "data": {
        "tasks": [
            {
                "id": "string",
                "name": "string",
                "connector_name": "string",
                "type": 1,
                "status": 2,
                "export_source": [["string"]],
                "create_time": "2024-01-01T00:00:00Z",
                "end_time": "2024-01-01T01:00:00Z"
            }
        ],
        "total": 1
    }
}
```

### 获取导出任务详情

```
POST /export/task/info
```

**输入参数：**

|  参数             | 是否必填 |含义|
|  --------------- | ------- |----  |
| id               | 是      | 任务 ID |

**输出参数：**

|  参数             | 含义 |
|  --------------- | ----  |
| id               |任务 ID       |
| name             | 任务名称     |
| creator          | 创建者    |
| connector_name   | 连接器名称    |
| type             | 任务类型    |
| status           | 任务状态    |
| config           | 导出配置    |
| &nbsp;&nbsp;&nbsp;&nbsp;dify_config | Dify 配置对象    |
| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;dataset_id | 数据集 ID    |
| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;dataset_name | 数据集名称    |
| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;embedding_model | 嵌入模型    |
| create_time      | 创建时间    |
| end_time         | 结束时间    |

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/export/task/info"
headers = {
    "moi-key": "xxxxx"
}

body = {
    "id": "task_123"
}

response = requests.post(url, json=body, headers=headers)

print("Response Body:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

**返回：**

```json
{
    "code": "ok",
    "msg": "ok",
    "data": {
        "id": "string",
        "name": "string",
        "creator": "string",
        "connector_name": "string",
        "type": 1,
        "status": 2,
                 "config": {
             "dify_config": {
                 "dataset_id": "string",
                 "dataset_name": "string",
                 "embedding_model": "string"
             }
         },
        "create_time": "2024-01-01T00:00:00Z",
        "end_time": "2024-01-01T01:00:00Z"
    }
}
```

### 查询导出任务文件列表

```
POST /export/task/files
```

**输入参数：**

|  参数             | 数据类型 | 是否必填 |含义 | 默认值 |
|  --------------- | ---- | ----   | ----  | ---- |
| offset           |int |否 |分页偏移量 |0 |
| limit            |int |否 |分页限制 |10 |
| task_id          |string |是 |任务 ID | |
| statuses         |array |否 |文件状态列表 | |
| order_by         |string |否 |排序字段 |created_at |
| order_direction  |string |否 |排序方向 |desc |

**输出参数：**

|  参数             | 含义 |
|  --------------- | ----  |
| files            |文件列表       |
| &nbsp;&nbsp;&nbsp;&nbsp;id         | 文件 ID     |
| &nbsp;&nbsp;&nbsp;&nbsp;status     | 文件状态    |
| &nbsp;&nbsp;&nbsp;&nbsp;full_path  | 文件完整路径    |
| &nbsp;&nbsp;&nbsp;&nbsp;details    | 详细信息    |
| &nbsp;&nbsp;&nbsp;&nbsp;create_time | 创建时间    |
| &nbsp;&nbsp;&nbsp;&nbsp;start_time | 开始时间    |
| &nbsp;&nbsp;&nbsp;&nbsp;end_time   | 结束时间    |
| total            | 总数量    |

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/export/task/files"
headers = {
    "moi-key": "xxxxx"
}

body = {
    "offset": 0,
    "limit": 10,
    "task_id": "task_123",
    "statuses": [1, 2],
    "order_by": "created_at",
    "order_direction": "desc"
}

response = requests.post(url, json=body, headers=headers)

print("Response Body:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

**返回：**

```json
{
    "code": "ok",
    "msg": "ok",
    "data": {
        "files": [
            {
                "id": "string",
                "status": 2,
                "full_path": ["string"],
                "details": "string",
                "create_time": "2024-01-01T00:00:00Z",
                "start_time": "2024-01-01T00:00:00Z",
                "end_time": "2024-01-01T01:00:00Z"
            }
        ],
        "total": 1
    }
}
```

### 删除导出任务

```
POST /export/task/delete
```

**输入参数：**

|  参数             | 是否必填 |含义|
|  --------------- | ------- |----  |
| id               | 是      | 任务 ID |

**示例：**

```python
import requests

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/export/task/delete"
headers = {
    "moi-key": "xxxxx"
}

body = {
    "id": "task_123"
}

response = requests.post(url, json=body, headers=headers)

if response.status_code == 200:
    print(response.json()) 
else:
    print(f"请求失败，状态码：{response.status_code}, 错误信息：{response.text}")
```

**返回：**

```json
{
    "code": "ok",
    "msg": "ok",
    "data": null
}
```

## 数据卷文件管理

### 查询数据卷文件列表（导出用）

```
POST /export/volumes/{vid}/files
```

**路径参数：**

|  参数             | 是否必填 |含义|
|  --------------- | ------- |----  |
| vid              | 是      | 数据卷 ID |

**输入参数：**

|  参数             | 数据类型 | 是否必填 |含义 | 默认值 |
|  --------------- | ---- | ----   | ----  | ---- |
| filters          |object |否 |过滤条件对象 | |
| &nbsp;&nbsp;&nbsp;&nbsp;types    |array |否 |文件类型列表 | |
| &nbsp;&nbsp;&nbsp;&nbsp;status   |array |否 |文件状态列表 | |
| &nbsp;&nbsp;&nbsp;&nbsp;exclude_status |array |否 |排除的状态列表 | |
| sorter           |object |否 |排序设置对象 | |
| &nbsp;&nbsp;&nbsp;&nbsp;sort_by   |string |否 |排序字段 |created_at |
| &nbsp;&nbsp;&nbsp;&nbsp;is_desc   |boolean |否 |是否降序 |true |
| offset           |int |否 |分页偏移量 |0 |
| limit            |int |否 |分页限制 |30 |
| task_id          |string |否 |任务 ID | |

**输出参数：**

|  参数             | 含义 |
|  --------------- | ----  |
| total            |总数量       |
| items            | 文件列表     |
| &nbsp;&nbsp;&nbsp;&nbsp;user_id    | 用户 ID    |
| &nbsp;&nbsp;&nbsp;&nbsp;id         | 文件 ID    |
| &nbsp;&nbsp;&nbsp;&nbsp;file_name  | 文件名称    |
| &nbsp;&nbsp;&nbsp;&nbsp;file_status | 文件状态    |
| &nbsp;&nbsp;&nbsp;&nbsp;file_type  | 文件类型    |

**示例：**

```python
import requests
import json

vid = "volume_123"
url = f"https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/export/volumes/{vid}/files"
headers = {
    "moi-key": "xxxxx"
}

body = {
    "filters": {
        "types": [1, 2],
        "status": [1, 2],
        "exclude_status": [3, 4]
    },
    "sorter": {
        "sort_by": "created_at",
        "is_desc": True
    },
    "offset": 0,
    "limit": 30
}

response = requests.post(url, json=body, headers=headers)

print("Response Body:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

**返回：**

```json
{
    "code": "ok",
    "msg": "ok",
    "data": {
        "total": 10,
        "items": [
            {
                "user_id": "string",
                "id": "string",
                "file_name": "string",
                "file_status": 2,
                "file_type": 1
            }
        ]
    }
}
```
