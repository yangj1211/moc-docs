# 数据探索相关 API

## 原始数据卷

### 创建原始数据卷

```
POST /byoa/api/v1/explore/volumes
```

**Header 参数：**

| 参数           | 类型   | 是否必填 | 描述             |
| -------------- | ------ | -------- | ---------------- |
| `user-id`      | string | 是       | 用户 ID (工作区 ID) |
| `Access-Token` | string | 是       | 鉴权 Token        |
| `uid`          | string | 是       | 用户登录 UID     |

**Body 输入参数 (`CreateVolumeReq`)：**

| 参数             | 是否必填 | 类型   | 含义        | 默认值 |
| ---------------- | -------- | ------ | ----------- | ------ |
| name             | 是       | string | 数据卷名称  |        |
| parent_volume_id | 否       | string | 父数据卷 ID | ""     |

**Body 示例 (`CreateVolumeReq`)：**

```json
{
    "name": "my-new-volume",
    "parent_volume_id": "optional_parent_id_here" 
}
```

**示例 (Python)：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.cn-dev.matrixone.tech/byoa/api/v1/explore/volumes"

headers = {
    "user-id":"your_user_id",
    "Access-Token": "your_access_token",
    "uid": "your_uid"
}

body = {
    "name": "b_vol3"

}
response = requests.post(url, json=body, headers=headers)
print("Response Body:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

**返回 (`MOIResponse_CreateVolumeResp_`)：**

```json
{
    "code": "ok",
    "msg": "ok",
    "data": {
        "id": "fb93a6c1-6d1e-4d68-bb7c-4d84facda670", 
        "name": "b_vol3", 
        "created_at": "2025-02-13T11:44:36", 
        "updated_at": "2025-02-13T11:44:36"
    }
}
```

**输出参数 (`CreateVolumeResp`)：**

| 参数       | 类型   | 含义       |
| ---------- | ------ | ---------- |
| id         | string | 数据卷 ID  |
| name       | string | 数据卷名称 |
| created_at | string | 创建时间   |
| updated_at | string | 更新时间   |

### 查看原始数据卷列表

```
GET /byoa/api/v1/explore/volumes
```

**Header 参数：**

| 参数           | 类型   | 是否必填 | 描述             |
| -------------- | ------ | -------- | ---------------- |
| `user-id`      | string | 是       | 用户 ID (工作区 ID) |
| `Access-Token` | string | 是       | 鉴权 Token        |
| `uid`          | string | 是       | 用户登录 UID     |

**Query 参数：**

| 参数           | 是否必填 | 类型    | 含义                             |
| -------------- | -------- | ------- | -------------------------------- |
| workflow_using | 否       | boolean | 是否仅列出工作流正在使用的数据卷 |

**示例 (Python)：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.cn-dev.matrixone.tech/byoa/api/v1/explore/volumes"
headers = {
    "user-id": "your_user_id",
    "Access-Token": "your_access_token",
    "uid": "your_uid"
}
params = {
    "workflow_using": False # 可选参数，True 或 False
}
response = requests.get(url, headers=headers, params=params)
print("Response Body:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

**返回 (`MOIResponse_ListVolumeResp_`)：**

```json
{
    "code": "ok",
    "msg": "ok",
    "data": {
        "total": 2,
        "volumes": [
            {
                "name": "example-volume-1",
                "created_at": "2025-02-11T16:06:55Z",
                "updated_at": "2025-02-11T16:06:55Z",
                "user_id": "your_user_id_workspace_id",
                "id": "eb42f0a1-ab18-4010-b95c-cd1716dd5e95",
                "parent_volume_id": ""
            },
            {
                "name": "example-volume-2",
                "created_at": "2025-02-13T11:44:36Z",
                "updated_at": "2025-02-13T11:44:36Z",
                "user_id": "your_user_id_workspace_id",
                "id": "fb93a6c1-6d1e-4d68-bb7c-4d84facda670",
                "parent_volume_id": "eb42f0a1-ab18-4010-b95c-cd1716dd5e95"
            }
        ]
    }
}
```

**输出参数 (`ListVolumeResp` 的 `data` 部分)：**

| 参数    | 类型                | 含义       |
| ------- | ------------------- | ---------- |
| total   | integer             | 数据卷总数 |
| volumes | array[TargetVolume] | 数据卷列表 |

* **`TargetVolume` 对象结构:**

  | 参数             | 类型   | 含义                   |
  | ---------------- | ------ | ---------------------- |
  | id               | string | 数据卷 ID              |
  | name             | string | 数据卷名称             |
  | created_at       | string | 创建时间 (ISO 8601)    |
  | updated_at       | string | 更新时间 (ISO 8601)    |
  | user_id          | string | 用户 ID                |
  | parent_volume_id | string | 父数据卷 ID (可能为空) |

### 查看子数据卷列表

```
GET /byoa/api/v1/explore/volumes/{vid}
```

**路径参数：**

*   `vid` (string, 必填): 父数据卷 ID

**Header 参数：**

| 参数           | 类型   | 是否必填 | 描述             |
| -------------- | ------ | -------- | ---------------- |
| `user-id`      | string | 是       | 用户 ID (工作区 ID) |
| `Access-Token` | string | 是       | 鉴权 Token        |
| `uid`          | string | 是       | 用户登录 UID     |

**示例 (Python)：**

```python
import requests
import json

# 将 {vid} 替换为实际的父数据卷 ID
url = "https://freetier-01.cn-hangzhou.cluster.cn-dev.matrixone.tech/byoa/api/v1/explore/volumes/{vid}" 
headers = {
    "user-id": "your_user_id",
    "Access-Token": "your_access_token",
    "uid": "your_uid"
}
response = requests.get(url.replace("{vid}", "actual_parent_volume_id"), headers=headers)
print("Response Body:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

**返回 (`MOIResponse_ListVolumeResp_`)：**
返回结构与"查看数据卷列表"相同，但 `volumes` 列表将只包含指定 `{vid}` 的子卷。

**输出参数 (`ListVolumeResp` 的 `data` 部分)：**
与"查看数据卷列表"的输出参数一致。


### 删除数据卷

```
DELETE /byoa/api/v1/explore/volumes/{vid}
```

**路径参数：**

*   `vid` (string, 必填): 要删除的数据卷 ID

**Header 参数：**

| 参数           | 类型   | 是否必填 | 描述             |
| -------------- | ------ | -------- | ---------------- |
| `user-id`      | string | 是       | 用户 ID (工作区 ID) |
| `Access-Token` | string | 是       | 鉴权 Token        |
| `uid`          | string | 是       | 用户登录 UID     |

**示例 (Python)：**

```python
import requests

# 将 {vid} 替换为实际的数据卷 ID
url = "https://freetier-01.cn-hangzhou.cluster.cn-dev.matrixone.tech/byoa/api/v1/explore/volumes/{vid}"
headers = {
    "user-id": "your_user_id",
    "Access-Token": "your_access_token",
    "uid": "your_uid"
}
response = requests.delete(url.replace("{vid}", "volume_id_to_delete"), headers=headers)

if response.status_code == 200: # OpenAPI 定义成功响应为 200，内容为 {}
    try:
        print("Response Body:", response.json())
    except requests.exceptions.JSONDecodeError:
        print("Success with empty response body.") # 实际可能返回空体
else:
    print(f"请求失败，状态码：{response.status_code}, 错误信息：{response.text}")
```

**返回：**
成功时 HTTP 状态码为 200，响应体为 `{}` (空 JSON 对象) 或无内容。

### 查看卷内文件列表

```
POST /byoa/api/v1/explore/volumes/{vid}/files
```

**路径参数：**

*   `vid` (string, 必填): 数据卷 ID

**Header 参数：**

| 参数           | 类型   | 是否必填 | 描述             |
| -------------- | ------ | -------- | ---------------- |
| `user-id`      | string | 是       | 用户 ID (工作区 ID) |
| `Access-Token` | string | 是       | 鉴权 Token        |
| `uid`          | string | 是       | 用户登录 UID     |

**Body 输入参数 (`GetVolumeFilesReq`, 可选)：**

| 参数    | 类型              | 含义     | 默认值 |
| ------- | ----------------- | -------- | ------ |
| filters | object (`Filter`) | 过滤器   |        |
| sorter  | object (`Sorter`) | 排序器   |        |
| offset  | integer           | 偏移量   | 0      |
| limit   | integer           | 每页数量 | 30     |

* **`Filter` 对象结构:**

  | 参数           | 类型           | 含义           |
  | -------------- | -------------- | -------------- |
  | types          | array[integer] | 文件类型过滤   |
  | status         | array[integer] | 文件状态过滤   |
  | exclude_status | array[integer] | 排除的文件状态 |

* **`Sorter` 对象结构：**

  | 参数    | 类型    | 含义     | 默认值 |
  | ------- | ------- | -------- | ------ |
  | sort_by | string  | 排序字段 |        |
  | is_desc | boolean | 是否降序 | true   |

**Body 示例 (`GetVolumeFilesReq`)：**

```json
{
    "filters": {
        "types": [2, 3],
        "status": [2]
    },
    "sorter": {
        "sort_by": "updated_at",
        "is_desc": true
    },
    "offset": 0,
    "limit": 10
}
```

**示例 (Python)：**

```python
import requests
import json

# 将 {vid} 替换为实际的数据卷 ID
url = "https://freetier-01.cn-hangzhou.cluster.cn-dev.matrixone.tech/byoa/api/v1/explore/volumes/{vid}/files"
headers = {
    "user-id":"your_user_id",
    "Access-Token": "your_access_token",
    "uid": "your_uid"
}
body = { # 可选
    "limit": 5 
}

response = requests.post(url.replace("{vid}", "actual_volume_id"), json=body, headers=headers) # 使用 json=body
print("Response Body:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

**返回 (`MOIResponse_GetVolumeFilesResp_`)：**

```json
{
    "code": "ok",
    "msg": "ok",
    "data": {
        "total": 1,
        "items": [
            {
                "id": "0194fb44-c44b-7713-b064-bff178ba30c3",
                "created_at": "2025-02-12T17:46:16.000000+0000",
                "updated_at": "2025-02-12T17:51:21.000000+0000",
                "user_id": "your_user_id_workspace_id",
                "priority": 300,
                "source_volume_id": "1889223879880048640",
                "source_file_id": "1889223944229060608",
                "target_volume_id": "actual_volume_id",
                "file_name": "红楼梦 (通行本) 简体横排.pdf",
                "file_type": 2,
                "file_size": 6787457,
                "file_path": "0194dfaa-3eda-7ea5-b47c-b4f4f5940e97/b-vol1/1889223922712281088/红楼梦 (通行本) 简体横排.pdf",
                "file_status": 2,
                "workflow_meta_id": "5775ecd6-5918-42a1-a92f-7245fe96b2bf",
                "workflow_branch_id": null,
                "job_id": "0194fb44-c44b-7708-aab6-c67e094d0352",
                "error_message": "",
                "duration": 300,
                "start_time": "2025-02-12T17:46:20.000000+0000",
                "end_time": "2025-02-12T17:51:21.000000+0000",
                "delete_status": 0
            }
        ]
    }
}
```

**输出参数 (`GetVolumeFilesResp` 的 `data` 部分)：**

| 参数  | 类型          | 含义     |
| ----- | ------------- | -------- |
| total | integer       | 文件总数 |
| items | array[`File`] | 文件列表 |

* **`File` 对象结构:**

  | 参数               | 类型    | 含义                   | 默认值       |
  | ------------------ | ------- | ---------------------- | ------------ |
  | id                 | string  | 文件 ID                |              |
  | created_at         | string  | 创建时间 (ISO 格式)     |              |
  | updated_at         | string  | 更新时间 (ISO 格式)     |              |
  | user_id            | string  | 用户 ID (DC 用户)       | "dc_user_id" |
  | priority           | integer | 优先级                 | 300          |
  | source_volume_id   | string  | 源数据卷 ID            |              |
  | source_file_id     | string  | 源文件 ID              |              |
  | target_volume_id   | string  | 目标数据卷 ID          |              |
  | file_name          | string  | 文件名                 |              |
  | file_type          | integer | 文件类型               |              |
  | file_size          | integer | 文件大小 (bytes)       |              |
  | file_path          | string  | 文件路径               |              |
  | file_status        | integer | 文件状态               |              |
  | workflow_meta_id   | string  | 工作流元数据 ID (可选) | null         |
  | workflow_branch_id | string  | 工作流分支 ID (可选)   | null         |
  | job_id             | string  | 作业 ID (可选)         | null         |
  | error_message      | string  | 错误信息 (可选)        | null         |
  | duration           | integer | 处理时长 (秒，可选)    | 0            |
  | start_time         | string  | 开始处理时间 (可选)    | null         |
  | end_time           | string  | 结束处理时间 (可选)    | null         |
  | delete_status      | integer | 删除状态 (0-未删除)    | 0            |

### 删除卷内文件

```
DELETE /byoa/api/v1/explore/volumes/{vid}/files/{fid}
```

**路径参数：**

*   `vid` (string, 必填): 数据卷 ID
*   `fid` (string, 必填): 文件 ID

**Header 参数：**

| 参数           | 类型   | 是否必填 | 描述             |
| -------------- | ------ | -------- | ---------------- |
| `user-id`      | string | 是       | 用户 ID (工作区 ID) |
| `Access-Token` | string | 是       | 鉴权 Token        |
| `uid`          | string | 是       | 用户登录 UID     |

**示例 (Python)：**

```python
import requests

# 将 {vid} 和 {fid} 替换为实际的 ID
url = "https://freetier-01.cn-hangzhou.cluster.cn-dev.matrixone.tech/byoa/api/v1/explore/volumes/{vid}/files/{fid}"
headers = {
    "user-id": "your_user_id",
    "Access-Token": "your_access_token",
    "uid": "your_uid"
}
response = requests.delete(url.replace("{vid}", "actual_volume_id").replace("{fid}", "file_id_to_delete"), headers=headers)

if response.status_code == 200:
    try:
        print("Response Body:", response.json()) 
    except requests.exceptions.JSONDecodeError:
        print("Success with empty response body.")
else:
    print(f"请求失败，状态码：{response.status_code}, 错误信息：{response.text}")
```

**返回：**
成功时 HTTP 状态码为 200，响应体为 `{}` (空 JSON 对象) 或无内容。

### 获取文件原始内容

```
GET /byoa/api/v1/explore/volumes/{vid}/files/{fid}/raws
```

**路径参数：**

*   `vid` (string, 必填): 数据卷 ID
*   `fid` (string, 必填): 文件 ID

**Header 参数：**

| 参数           | 类型   | 是否必填 | 描述             |
| -------------- | ------ | -------- | ---------------- |
| `user-id`      | string | 是       | 用户 ID (工作区 ID) |
| `Access-Token` | string | 是       | 鉴权 Token        |
| `uid`          | string | 是       | 用户登录 UID     |

**Query 参数：**

| 参数            | 是否必填 | 类型    | 含义               | 默认值 |
| --------------- | -------- | ------- | ------------------ | ------ |
| need_embeddings | 否       | boolean | 是否需要 embedding | false  |

**示例 (Python)：**

```python
import requests

url = "https://freetier-01.cn-hangzhou.cluster.cn-dev.matrixone.tech/byoa/api/v1/explore/volumes/{vid}/files/{fid}/raws"
headers = {
    "user-id":"your_user_id",
    "Access-Token": "your_access_token",
    "uid": "your_uid"
}
params = {
    "need_embeddings": False # 或者 True
}

response = requests.get(url.replace("{vid}", "actual_volume_id").replace("{fid}", "actual_file_id"), headers=headers, params=params)

if response.status_code == 200:
    try:
        print("Response Body (if JSON):", response.json())
    except requests.exceptions.JSONDecodeError:
        print("Response is likely raw file content or an empty body for success.")
else:
    print(f"请求失败，状态码：{response.status_code}, 错误信息：{response.text}")
```

**返回：**
OpenAPI 定义成功响应为 200，响应体为 `{}` (空 JSON 对象)。然而，这类接口通常直接返回文件流 (raw bytes)。如果 `need_embeddings` 为 true 且有 embedding，返回内容可能包含 embedding 信息，具体格式需进一步确认。

### 获取文件关联的作业信息

```
GET /byoa/api/v1/explore/volumes/{vid}/files/{fid}/jobs
```

**路径参数：**

*   `vid` (string, 必填): 数据卷 ID
*   `fid` (string, 必填): 文件 ID

**Header 参数：**

| 参数           | 类型   | 是否必填 | 描述             |
| -------------- | ------ | -------- | ---------------- |
| `user-id`      | string | 是       | 用户 ID (工作区 ID) |
| `Access-Token` | string | 是       | 鉴权 Token        |
| `uid`          | string | 是       | 用户登录 UID     |

**示例 (Python)：**

```python
import requests
import json

# 将 {vid} 和 {fid} 替换为实际的 ID
url = "https://freetier-01.cn-hangzhou.cluster.cn-dev.matrixone.tech/byoa/api/v1/explore/volumes/{vid}/files/{fid}/jobs"
headers = {
    "user-id": "your_user_id",
    "Access-Token": "your_access_token",
    "uid": "your_uid"
}
response = requests.get(url.replace("{vid}", "actual_volume_id").replace("{fid}", "actual_file_id"), headers=headers)
print("Response Body:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

**返回 (`MOIResponse_GetFileJobResp_`)：**

```json
{
    "code": "ok",
    "msg": "ok",
    "data": {
        "job": {
            "id": "job_id_associated_with_file",
            "workflow_name": "Associated Workflow",
            "status": 2,
            "start_time": "2025-02-13T12:00:00Z",
            "end_time": "2025-02-13T12:05:00Z"
        }
    }
}
```

**输出参数 (`GetFileJobResp` 的 `data` 部分)：**

| 参数 | 类型   | 含义                                                         |
| ---- | ------ | ------------------------------------------------------------ |
| job  | object | 文件关联的作业信息对象。具体结构需要参照实际 API 返回或更详细的定义。 |


### 获取文件解析的数据块

```
POST /byoa/api/v1/explore/volumes/{vid}/files/{fid}/blocks
```

**路径参数：**

*   `vid` (string, 必填): 数据卷 ID
*   `fid` (string, 必填): 文件 ID

**Header 参数：**

| 参数           | 类型   | 是否必填 | 描述             |
| -------------- | ------ | -------- | ---------------- |
| `user-id`      | string | 是       | 用户 ID (工作区 ID) |
| `Access-Token` | string | 是       | 鉴权 Token        |
| `uid`          | string | 是       | 用户登录 UID     |

**Body 输入参数 (`GetFileBlocksReq`, 可选)：**

| 参数    | 类型                    | 含义     | 默认值 |
| ------- | ----------------------- | -------- | ------ |
| filters | object (`BlocksFilter`) | 过滤器   |        |
| offset  | integer                 | 偏移量   | 0      |
| limit   | integer                 | 每页数量 | 30     |

* **`BlocksFilter` 对象结构:**

  | 参数           | 类型          | 含义                                     |
  | -------------- | ------------- | ---------------------------------------- |
  | types          | array[string] | 类型过滤 (例如，"text", "image_caption") |
  | search_content | string        | 内容搜索关键字                           |
  | block_ids      | array[string] | 指定数据块 ID 列表                         |


**Body 示例 (`GetFileBlocksReq`)：**

```json
{
    "filters": {
        "types": ["text"],
        "search_content": "MatrixOne"
    },
    "limit": 5
}
```

**示例 (Python)：**

```python
import requests
import json

# 将 {vid} 和 {fid} 替换为实际的 ID
url = "https://freetier-01.cn-hangzhou.cluster.cn-dev.matrixone.tech/byoa/api/v1/explore/volumes/{vid}/files/{fid}/blocks"
headers = {
    "user-id":"your_user_id_workspace_id",
    "Access-Token": "your_access_token",
    "uid": "your_uid"
}
body = {
    "limit": 2
}
response = requests.post(url.replace("{vid}", "actual_volume_id").replace("{fid}", "actual_file_id"), json=body, headers=headers)
print("Response Body:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

**返回 (`MOIResponse_GetFileBlocksResp_`)：**

```json
{
    "code": "ok",
    "msg": "ok",
    "data": {
        "total": 10,
        "items": [
            {
                "id": "000a9605-733f-4335-bc72-ac9aa8351e66",
                "content": "Matrix Search 利用 Efficient Net 模型对上传的图片进行特征提取...",
                "type": "text", 
                "content_type": "text", 
                "file_id": "actual_file_id",
                "description": null,
                "created_at": "2025-02-13T03:45:02",
                "updated_at": "2025-02-13T03:45:02",
                "text_and_image_id": null
            },
            {
                "id": "08aaf135-f8ad-446c-9951-03e94777f608",
                "content": "![](/image.jpg) 接下来我们会逐个分析...",
                "type": "markdown",
                "content_type": "text",
                "file_id": "actual_file_id",
                "description": "An image with text",
                "created_at": "2025-02-13T03:45:03",
                "updated_at": "2025-02-13T03:45:03",
                "text_and_image_id": 123
            }
        ]
    }
}
```

**输出参数 (`GetFileBlocksResp` 的 `data` 部分)：**

| 参数  | 类型                           | 含义       |
| ----- | ------------------------------ | ---------- |
| total | integer                        | 数据块总数 |
| items | array[`SampleEmbeddingResult`] | 数据块列表 |

* **`SampleEmbeddingResult` 对象结构:**

  | 参数              | 类型    | 含义                                             |
  | ----------------- | ------- | ------------------------------------------------ |
  | id                | string  | 数据块 ID                                        |
  | content           | string  | 内容                                             |
  | type              | string  | 数据块类型 (如 "text", "table", "image_caption") |
  | content_type      | string  | 内容 MIME 类型 (实际可能与 block type 更相关)      |
  | file_id           | string  | 文件 ID                                          |
  | description       | string  | 描述 (可选)                                      |
  | created_at        | string  | 创建时间 (ISO 格式)                               |
  | updated_at        | string  | 更新时间 (ISO 格式)                               |
  | text_and_image_id | integer | 图文关联 ID (可选)                                |

### 删除文件解析的数据块

```
DELETE /byoa/api/v1/explore/volumes/{vid}/files/{fid}/blocks
```

**路径参数：**

*   `vid` (string, 必填): 数据卷 ID
*   `fid` (string, 必填): 文件 ID

**Header 参数：**

| 参数           | 类型   | 是否必填 | 描述             |
| -------------- | ------ | -------- | ---------------- |
| `user-id`      | string | 是       | 用户 ID (工作区 ID) |
| `Access-Token` | string | 是       | 鉴权 Token        |
| `uid`          | string | 是       | 用户登录 UID     |

**Body 输入参数 (`DeleteFileBlocksReq`)：**

| 参数 | 是否必填 | 类型          | 含义                 |
| ---- | -------- | ------------- | -------------------- |
| ids  | 是       | array[string] | 要删除的数据块 ID 列表 |

**Body 示例 (`DeleteFileBlocksReq`)：**

```json
{
    "ids": ["block_id_1_to_delete", "block_id_2_to_delete"]
}
```

**示例 (Python)：**

```python
import requests
import json

# 将 {vid} 和 {fid} 替换为实际的 ID
url = "https://freetier-01.cn-hangzhou.cluster.cn-dev.matrixone.tech/byoa/api/v1/explore/volumes/{vid}/files/{fid}/blocks"
headers = {
    "user-id": "your_user_id",
    "Access-Token": "your_access_token",
    "uid": "your_uid"
}
body = {
    "ids": ["03e927d3-edbe-426c-835a-0f1e4fcc39b6"]
}
response = requests.delete(url.replace("{vid}", "actual_volume_id").replace("{fid}", "actual_file_id"), json=body, headers=headers)

if response.status_code == 200:
    try:
        print("Response Body:", response.json())
    except requests.exceptions.JSONDecodeError:
        print("Success, typically with an empty response body.")
else:
    print(f"请求失败，状态码：{response.status_code}, 错误信息：{response.text}")
```

**返回：**
成功时 HTTP 状态码为 200，响应体为 `{}` (空 JSON 对象) 或无内容。原文档中提到 204，但 OpenAPI spec 中是 200。