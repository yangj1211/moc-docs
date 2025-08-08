# 数据中心 API

本文档介绍 MatrixOne Intelligence 数据中心的资源结构与 API。数据中心由“目录 → 数据库 → 卷 → 文件”构成，并通过“卷引用”建立跨资源的关联关系。

- 目录：用于组织业务域与资源边界
- 数据库：承载表与数据对象的逻辑库
- 卷：面向文件与处理结果的资源容器
- 文件：卷内的具体文件条目
- 卷引用：跨卷/跨资源的引用绑定

- 基础地址：`https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn`
- 公共请求头：
  - `moi-key`：string，API Key
- 返回结构：除特殊说明外，统一为：

```json
{
  "code": "OK",
  "msg": "OK",
  "data": { },
  "request_id": "..."
}
```

## 目录

### 创建目录

用途：创建一个新的目录，用于组织数据库与卷。

```
POST /catalog/create
```

**Body 输入参数：**

| 参数         | 是否必填 | 类型   | 含义     |
| ------------ | -------- | ------ | -------- |
| name         | 是       | string | 目录名称 |
| description  | 否       | string | 描述     |

**示例 (Python)：**

```python
import requests, json
url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/catalog/create"
headers = {
    "moi-key": "xxxxx"
}
body = {
    "name": "my-catalog",
    "description": "业务域 A 的目录"
}
print(requests.post(url, headers=headers, json=body).json())
```

**返回：**

```json
{
  "code": "OK",
  "msg": "OK",
  "data": {
    "id": 1
  }
}
```

### 获取目录列表

用途：分页返回当前账号下的目录集合及统计信息。

```
POST /catalog/list
```

**请求：**仅需 `moi-key` 请求头。

**示例 (Python)：**

```python
import requests, json
url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/catalog/list"
headers = {
    "moi-key": "xxxxx"
}
print(requests.post(url, headers=headers).json())
```

**返回：**

```json
{
  "code": "OK",
  "msg": "OK",
  "data": {
    "list": [
      {
        "id": 1,
        "name": "my-catalog",
        "description": "业务域 A 的目录",
        "database_count": 2,
        "file_count": 10,
        "table_count": 5,
        "volume_count": 1,
        "reserved": false,
        "created_at": "2025-02-13T10:00:00Z",
        "updated_at": "2025-02-13T10:10:00Z",
        "created_by": "user_a",
        "updated_by": "user_a"
      },
      {
        "id": 2,
        "name": "marketing",
        "description": "市场线目录",
        "database_count": 1,
        "file_count": 3,
        "table_count": 2,
        "volume_count": 1,
        "reserved": false,
        "created_at": "2025-02-12T09:00:00Z",
        "updated_at": "2025-02-12T09:05:00Z",
        "created_by": "user_b",
        "updated_by": "user_b"
      }
    ]
  }
}
```

### 根据 ID 获取目录详情

用途：根据目录 ID 获取目录的基本信息（名称、描述）。

```
POST /catalog/info
```

**Body 输入参数：**

| 参数 | 是否必填 | 类型    | 含义   |
| ---- | -------- | ------- | ------ |
| id   | 是       | integer | 目录 ID |

**示例 (Python)：**

```python
import requests
url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/catalog/info"
headers = {
    "moi-key": "xxxxx"
}
body = {
    "id": 1
}
print(requests.post(url, headers=headers, json=body).json())
```

**返回：**

```json
{
  "code": "OK",
  "msg": "OK",
  "data": {
    "id": 1,
    "name": "my-catalog",
    "description": "业务域 A 的目录"
  }
}
```

### 更新目录

用途：修改目录名称或描述。

```
POST /catalog/update
```

**Body 输入参数：**

| 参数        | 是否必填 | 类型    | 含义     |
| ----------- | -------- | ------- | -------- |
| id          | 是       | integer | 目录 ID   |
| name        | 是       | string  | 目录名称 |
| description | 否       | string  | 描述     |

**示例 (Python)：**

```python
import requests
url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/catalog/update"
headers = {
    "moi-key": "xxxxx"
}
body = {
    "id": 1,
    "name": "my-catalog-renamed",
    "description": "目录描述更新"
}
print(requests.post(url, headers=headers, json=body).json())
```

**返回：**

```json
{
  "code": "OK",
  "msg": "OK",
  "data": {
    "id": 1
  }
}
```

### 删除目录

用途：删除指定目录（仅当无强依赖资源时允许删除）。

```
POST /catalog/delete
```

**Body 输入参数：**

| 参数 | 是否必填 | 类型    | 含义   |
| ---- | -------- | ------- | ------ |
| id   | 是       | integer | 目录 ID |

**示例 (Python)：**

```python
import requests
url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/catalog/delete"
headers = {
    "moi-key": "xxxxx"
}
body = {
    "id": 1
}
print(requests.post(url, headers=headers, json=body).json())
```

**返回：**

```json
{
  "code": "OK",
  "msg": "OK",
  "data": {
    "id": 1
  }
}
```

### 获取目录树

用途：以树形结构返回目录下的数据库与卷层级。

```
POST /catalog/tree
```

**请求：**仅需 `moi-key` 请求头。

**返回：**

```json
{
  "code": "OK",
  "msg": "OK",
  "data": {
    "tree": [
      {
        "id": "catalog-1",
        "name": "my-catalog",
        "type": "catalog",
        "description": "业务域 A 的目录",
        "has_workflow_target_ref": false,
        "node_list": [
          {
            "id": "db-100",
            "name": "db1",
            "type": "database",
            "description": "业务数据库",
            "node_list": [
              {
                "id": "vol-abc",
                "name": "origin",
                "type": "volume",
                "description": "源数据卷",
                "node_list": []
              }
            ]
          }
        ]
      }
    ]
  }
}
```

## 数据库

### 创建数据库

用途：在指定目录下创建数据库。

```
POST /catalog/database/create
```

**Body 输入参数：**

| 参数       | 是否必填 | 类型    | 含义     |
| ---------- | -------- | ------- | -------- |
| catalog_id | 是       | integer | 目录 ID   |
| name       | 是       | string  | 数据库名 |
| description| 否       | string  | 描述     |

**示例 (Python)：**

```python
import requests
url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/catalog/database/create"
headers = {
    "moi-key": "xxxxx"
}
body = {
    "catalog_id": 1,
    "name": "db1",
    "description": "业务库"
}
print(requests.post(url, headers=headers, json=body).json())
```

**返回：**

```json
{
  "code": "OK",
  "msg": "OK",
  "data": {
    "id": 100
  }
}
```

### 获取数据库列表

用途：返回某个目录下的数据库集合及统计信息。

```
POST /catalog/database/list
```

**Body 输入参数：**

| 参数 | 是否必填 | 类型    | 含义   |
| ---- | -------- | ------- | ------ |
| id   | 是       | integer | 目录 ID |

**示例 (Python)：**

```python
import requests
url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/catalog/database/list"
headers = {
    "moi-key": "xxxxx"
}
body = {
    "id": 1
}
print(requests.post(url, headers=headers, json=body).json())
```

**返回：**

```json
{
  "code": "OK",
  "msg": "OK",
  "data": {
    "list": [
      {
        "id": 100,
        "name": "db1",
        "description": "业务库",
        "file_count": 0,
        "table_count": 0,
        "reserved": false,
        "created_at": "2025-02-13T10:00:00Z",
        "updated_at": "2025-02-13T10:05:00Z",
        "created_by": "user_a",
        "updated_by": "user_a"
      }
    ]
  }
}
```

### 根据 ID 获取数据库详情

用途：根据数据库 ID 获取详细信息（含创建/更新时间）。

```
POST /catalog/database/info
```

**Body 输入参数：**

| 参数 | 是否必填 | 类型    | 含义   |
| ---- | -------- | ------- | ------ |
| id   | 是       | integer | 数据库 ID |

**示例 (Python)：**

```python
import requests
url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/catalog/database/info"
headers = {
    "moi-key": "xxxxx"
}
body = {
    "id": 100
}
print(requests.post(url, headers=headers, json=body).json())
```

**返回：**

```json
{
  "code": "OK",
  "msg": "OK",
  "data": {
    "id": 100,
    "name": "db1",
    "description": "业务库",
    "created_at": "2025-02-13T10:00:00Z",
    "updated_at": "2025-02-13T10:05:00Z"
  }
}
```

### 更新数据库

用途：修改数据库的描述信息。

```
POST /catalog/database/update
```

**Body 输入参数：**

| 参数        | 是否必填 | 类型    | 含义   |
| ----------- | -------- | ------- | ------ |
| id          | 是       | integer | 数据库 ID |
| description | 否       | string  | 描述     |

**示例 (Python)：**

```python
import requests
url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/catalog/database/update"
headers = {
    "moi-key": "xxxxx"
}
body = {
    "id": 100,
    "description": "描述更新"
}
print(requests.post(url, headers=headers, json=body).json())
```

**返回：**

```json
{
  "code": "OK",
  "msg": "OK",
  "data": {
    "id": 100
  }
}
```

### 删除数据库

用途：删除指定数据库（需确保无依赖资源）。

```
POST /catalog/database/delete
```

**Body 输入参数：**

| 参数 | 是否必填 | 类型    | 含义   |
| ---- | -------- | ------- | ------ |
| id   | 是       | integer | 数据库 ID |

**示例 (Python)：**

```python
import requests
url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/catalog/database/delete"
headers = {
    "moi-key": "xxxxx"
}
body = {
    "id": 100
}
print(requests.post(url, headers=headers, json=body).json())
```

**返回：**

```json
{
  "code": "OK",
  "msg": "OK",
  "data": {
    "id": 100
  }
}
```

### 获取数据库子列表

用途：查询数据库下的子资源列表（如卷）。

```
POST /catalog/database/children
```

**Body 输入参数：**

| 参数 | 是否必填 | 类型    | 含义   |
| ---- | -------- | ------- | ------ |
| id   | 是       | integer | 数据库 ID |

**示例 (Python)：**

```python
import requests
url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/catalog/database/children"
headers = {
    "moi-key": "xxxxx"
}
body = {
    "id": 100
}
print(requests.post(url, headers=headers, json=body).json())
```

**返回：**

```json
{
  "code": "OK",
  "msg": "OK",
  "data": {
    "list": [
      {
        "id": "vol-abc",
        "name": "origin",
        "type": "volume",
        "size": 0,
        "children_count": 0,
        "reserved": false,
        "created_at": "2025-02-13T10:10:00Z",
        "updated_at": "2025-02-13T10:10:00Z",
        "created_by": "user_a",
        "updated_by": "user_a"
      }
    ]
  }
}
```

## 卷

### 创建卷

用途：在数据库下创建卷，用于存放文件与处理结果。

```
POST /catalog/volume/create
```

**Body 输入参数：**

| 参数        | 是否必填 | 类型    | 含义     |
| ----------- | -------- | ------- | -------- |
| database_id | 是       | integer | 数据库 ID |
| name        | 是       | string  | 卷名称   |
| description | 否       | string  | 描述     |

**示例 (Python)：**

```python
import requests
url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/catalog/volume/create"
headers = {
    "moi-key": "xxxxx"
}
body = {
    "database_id": 100,
    "name": "origin",
    "description": "源数据卷"
}
print(requests.post(url, headers=headers, json=body).json())
```

**返回：**

```json
{
  "code": "OK",
  "msg": "OK",
  "data": {
    "id": "vol-abc"
  }
}
```

### 获取卷详情

用途：根据卷 ID 获取卷的基础信息。

```
POST /catalog/volume/info
```

**Body 输入参数：**

| 参数 | 是否必填 | 类型   | 含义 |
| ---- | -------- | ------ | ---- |
| id   | 是       | string | 卷 ID |

**示例 (Python)：**

```python
import requests
url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/catalog/volume/info"
headers = {
    "moi-key": "xxxxx"
}
body = {
    "id": "vol-abc"
}
print(requests.post(url, headers=headers, json=body).json())
```

**返回：**

```json
{
  "code": "OK",
  "msg": "OK",
  "data": {
    "id": "vol-abc",
    "name": "origin",
    "description": "源数据卷",
    "created_at": "2025-02-13T10:10:00Z",
    "updated_at": "2025-02-13T10:10:00Z"
  }
}
```

### 更新卷

用途：修改卷的名称与描述。

```
POST /catalog/volume/update
```

**Body 输入参数：**

| 参数        | 是否必填 | 类型   | 含义   |
| ----------- | -------- | ------ | ------ |
| id          | 是       | string | 卷 ID   |
| name        | 是       | string | 卷名称 |
| description | 是       | string | 描述   |

**示例 (Python)：**

```python
import requests
url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/catalog/volume/update"
headers = {
    "moi-key": "xxxxx"
}
body = {
    "id": "vol-abc",
    "name": "origin-updated",
    "description": "源数据卷描述更新"
}
print(requests.post(url, headers=headers, json=body).json())
```

**返回：**

```json
{
  "code": "OK",
  "msg": "OK",
  "data": {
    "id": "vol-abc"
  }
}
```

### 删除卷

用途：删除指定卷（需确保未被引用）。

```
POST /catalog/volume/delete
```

**Body 输入参数：**

| 参数 | 是否必填 | 类型   | 含义 |
| ---- | -------- | ------ | ---- |
| id   | 是       | string | 卷 ID |

**示例 (Python)：**

```python
import requests
url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/catalog/volume/delete"
headers = {
    "moi-key": "xxxxx"
}
body = {
    "id": "vol-abc"
}
print(requests.post(url, headers=headers, json=body).json())
```

**返回：**

```json
{
  "code": "OK",
  "msg": "OK",
  "data": {
    "id": "vol-abc"
  }
}
```

## 文件

### 创建文件

用途：在卷内创建文件元数据或占位记录。

```
POST /catalog/file/create
```

**Body 输入参数：**

| 参数            | 是否必填 | 类型   | 含义           |
| --------------- | -------- | ------ | -------------- |
| name            | 是       | string | 文件名         |
| show_type       | 是       | string | 展示类型       |
| parent_id       | 否       | string | 父文件夹 ID     |
| ref_file_id     | 否       | string | 引用文件 ID     |
| origin_file_ext | 否       | string | 原始扩展名     |
| save_path       | 否       | string | 保存路径       |
| size            | 否       | integer| 大小           |
| volume_id       | 否       | string | 卷 ID           |

**示例 (Python)：**

```python
import requests
url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/catalog/file/create"
headers = {
    "moi-key": "xxxxx"
}
body = {
    "name": "demo.md",
    "show_type": "markdown",
    "volume_id": "vol-abc"
}
print(requests.post(url, headers=headers, json=body).json())
```

**返回：**

```json
{
  "code": "OK",
  "msg": "OK",
  "data": {
    "id": "file-xyz",
    "name": "demo.md"
  }
}
```

### 获取文件信息

用途：根据文件 ID 获取文件详情（类型、大小、归属卷等）。

```
POST /catalog/file/info
```

**Body 输入参数：**

| 参数 | 是否必填 | 类型   | 含义   |
| ---- | -------- | ------ | ------ |
| id   | 是       | string | 文件 ID |

**示例 (Python)：**

```python
import requests
url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/catalog/file/info"
headers = {
    "moi-key": "xxxxx"
}
body = {
    "id": "file-xyz"
}
print(requests.post(url, headers=headers, json=body).json())
```

**返回：**

```json
{
  "code": "OK",
  "msg": "OK",
  "data": {
    "id": "file-xyz",
    "name": "demo.md",
    "file_type": "text",
    "file_ext": ".md",
    "origin_file_ext": ".md",
    "parent_id": "",
    "ref_file_id": "",
    "show_type": "markdown",
    "size": 1234,
    "created_at": "2025-02-13T11:00:00Z",
    "updated_at": "2025-02-13T11:10:00Z",
    "volume_id": "vol-abc"
  }
}
```

### 获取文件列表

用途：分页查询卷内或账号范围内的文件列表，支持排序过滤。

```
POST /catalog/file/list
```

**Body 输入参数（可选）：**

| 参数       | 类型              | 含义                 |
| ---------- | ----------------- | -------------------- |
| filters    | array[Filter]     | 过滤条件             |
| order      | string            | asc/desc             |
| order_by   | string            | 排序字段             |
| page       | integer           | 页码（默认 1）        |
| page_size  | integer           | 每页数量（默认 10）   |

- `Filter`:
  - `name`: string, `values`: string []，`fuzzy`: boolean

**示例 (Python)：**

```python
import requests
url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/catalog/file/list"
headers = {
    "moi-key": "xxxxx"
}
body = {
    "order": "desc",
    "order_by": "created_at",
    "page": 1,
    "page_size": 10
}
print(requests.post(url, headers=headers, json=body).json())
```

**返回：**

```json
{
  "code": "OK",
  "msg": "OK",
  "data": {
    "list": [
      {
        "id": "file-xyz",
        "name": "demo.md",
        "file_type": "text",
        "file_ext": ".md",
        "origin_file_ext": ".md",
        "parent_id": "",
        "ref_file_id": "",
        "ref_workflow_id": "",
        "save_path": "/user_a/origin/file-xyz/demo.md",
        "show_path": "/origin/demo.md",
        "show_type": "markdown",
        "size": 1234,
        "created_at": "2025-02-13T11:00:00Z",
        "updated_at": "2025-02-13T11:10:00Z",
        "created_by": "user_a",
        "volume_id": "vol-abc",
        "volume_name": "origin",
        "volume_reserved": false
      }
    ],
    "total": 1
  }
}
```

### 获取文件预览链接

用途：获取文件的临时可访问链接（用于浏览器预览/下载）。

```
POST /catalog/file/preview_link
```

**Body 输入参数：**

| 参数      | 是否必填 | 类型   | 含义   |
| --------- | -------- | ------ | ------ |
| file_id   | 是       | string | 文件 ID |
| volume_id | 否       | string | 卷 ID   |

**示例 (Python)：**

```python
import requests
url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/catalog/file/preview_link"
headers = {
    "moi-key": "xxxxx"
}
body = {
    "file_id": "file-xyz",
    "volume_id": "vol-abc"
}
print(requests.post(url, headers=headers, json=body).json())
```

**返回：**

```json
{
  "code": "OK",
  "msg": "OK",
  "data": {
    "link": "https://oss.example.com/bucket/user_a/origin/file-xyz/demo.md"
  }
}
```

### 获取文件预览流

用途：以二进制流形式返回文件内容（不经跳转）。

```
POST /catalog/file/preview_stream
```

**Body 输入参数：**`{"id": string}`（文件 ID）

**说明：**返回为二进制流，此处不展示样例。

### 上传文件

用途：提交一个上传任务，返回文件占位 ID（结合其他能力完成实际上传）。

```
POST /catalog/file/upload
```

**Body 输入参数：**

| 参数      | 是否必填 | 类型   | 含义     |
| --------- | -------- | ------ | -------- |
| name      | 是       | string | 文件名   |
| volume_id | 是       | string | 卷 ID     |
| parent_id | 否       | string | 父文件夹 |

**示例 (Python)：**

```python
import requests
url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/catalog/file/upload"
headers = {
    "moi-key": "xxxxx"
}
body = {
    "name": "report.pdf",
    "volume_id": "vol-abc"
}
print(requests.post(url, headers=headers, json=body).json())
```

**返回：**

```json
{
  "code": "OK",
  "msg": "OK",
  "data": {
    "id": "file-uvw"
  }
}
```

### 更新文件

用途：修改文件名称等元数据。

```
POST /catalog/file/update
```

**Body 输入参数：**

| 参数 | 是否必填 | 类型   | 含义   |
| ---- | -------- | ------ | ------ |
| id   | 是       | string | 文件 ID |
| name | 是       | string | 新名称 |

**示例 (Python)：**

```python
import requests
url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/catalog/file/update"
headers = {
    "moi-key": "xxxxx"
}
body = {
    "id": "file-xyz",
    "name": "demo-renamed.md"
}
print(requests.post(url, headers=headers, json=body).json())
```

**返回：**

```json
{
  "code": "OK",
  "msg": "OK",
  "data": {
    "id": "file-xyz"
  }
}
```

### 删除文件

用途：删除指定文件记录（若存在引用关系需先解除）。

```
POST /catalog/file/delete
```

**Body 输入参数：**

| 参数 | 是否必填 | 类型   | 含义   |
| ---- | -------- | ------ | ------ |
| id   | 是       | string | 文件 ID |

**示例 (Python)：**

```python
import requests
url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/catalog/file/delete"
headers = {
    "moi-key": "xxxxx"
}
body = {
    "id": "file-xyz"
}
print(requests.post(url, headers=headers, json=body).json())
```

**返回：**

```json
{
  "code": "OK",
  "msg": "OK",
  "data": {
    "id": "file-xyz"
  }
}
```

### 通过引用文件 ID 删除文件

用途：根据引用文件 ID 删除目标文件（常用于清理派生/引用关系）。

```
POST /catalog/file/delete_ref
```

**Body 输入参数：**

| 参数 | 是否必填 | 类型   | 含义       |
| ---- | -------- | ------ | ---------- |
| id   | 是       | string | 引用文件 ID |

**示例 (Python)：**

```python
import requests
url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/catalog/file/delete_ref"
headers = {
    "moi-key": "xxxxx"
}
body = {
    "id": "file-xyz"
}
print(requests.post(url, headers=headers, json=body).json())
```

**返回：**

```json
{
  "code": "OK",
  "msg": "OK",
  "data": {
    "id": "file-xyz"
  }
}
```

### 下载文件链接

用途：获取文件的直链下载地址（带签名，短时有效）。

```
POST /catalog/file/download
```

**Body 输入参数：**

| 参数      | 是否必填 | 类型   | 含义   |
| --------- | -------- | ------ | ------ |
| file_id   | 是       | string | 文件 ID |
| volume_id | 否       | string | 卷 ID   |

**示例 (Python)：**

```python
import requests
url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/catalog/file/download"
headers = {
    "moi-key": "xxxxx"
}
body = {
    "file_id": "file-xyz",
    "volume_id": "vol-abc"
}
print(requests.post(url, headers=headers, json=body).json())
```

**返回：**

```json
{
  "code": "OK",
  "msg": "OK",
  "data": {
    "link": "https://oss.example.com/bucket/user_a/origin/file-xyz/demo.md?signature=..."
  }
}
```
