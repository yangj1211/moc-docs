# 数据探索相关 API

## 源数据卷

### 创建源数据卷

```
POST /CreateOriginVolume
```

**输入参数：**
  
|  参数             | 是否必填 |含义|
|  --------------- | ----   | ----  |
| name             |是       | 源数据卷名 |

**示例：**

```python
url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/CreateOriginVolume"

headers = {
    "moi-key": "xxxxx"
}

body = {
    "name": "b_vol3"

}
response = requests.post(url, json=body, headers=headers)
print(response.json())
```

返回：

```json
{
    "code": "OK",
    "msg": "OK"
}
```

### 查看源数据卷列表

```
POST /DescribeOriginVolumes
```

**输出参数：**
  
|  参数             | 含义 |
|  --------------- | ----  |
| id               | 卷 id      |
| name             | 卷名    |
| size             | 卷大小  |
| file_num         | 文件数量    |

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/DescribeOriginVolumes"
headers = {
    "moi-key": "xxxxx"
}

response = requests.post(url, headers=headers)
print("Response Body:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

返回：

```bash
Response Body: {
    "code": "OK",
    "msg": "OK",
    "data": {
        "total": 2,
        "volumes": [
            {
                "id": "YOUR_VOLUME_ID_1",
                "name": "b-vol1",
                "size": 6787457,
                "file_num": 1,
                "owner": "YOUR_USERNAME",
                "created_at": 1739261047,
                "updated_at": 1739261047
            },
            {
                "id": "YOUR_VOLUME_ID_2",
                "name": "b-vol2",
                "size": 40724742,
                "file_num": 6,
                "owner": "YOUR_USERNAME",
                "created_at": 1739345595,
                "updated_at": 1739345595
            }
        ]
    }
}
```

### 查看某个源数据卷（文件列表）

```
POST /DescribeOriginVolume
```

**输出参数：**
  
|  参数             | 含义 |
|  --------------- | ----  |
| id               | 文件 id      |
| name             | 文件名    |
| type             |文件类型  |
| status           | 文件解析状态  |
| path             | 文件路径  |

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/DescribeOriginVolume"
headers = {
    "moi-key": "xxxxx"
}

body={
        "id": "YOUR_VOLUME_ID"
}

response = requests.post(url, headers=headers,json=body)
print("Response Body:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

返回：

```bash
Response Body: {
    "code": "OK",
    "msg": "OK",
    "data": {
        "total": 1,
        "items": [
            {
                "id": "YOUR_FILE_ID",
                "name": "红楼梦(通行本)简体横排.pdf",
                "type": 2,
                "status": 5,
                "size": 6787457,
                "update_time": 1739261640,
                "other_metadata": "",
                "reason": "",
                "user": "YOUR_USERNAME",
                "start_time": 1739261063,
                "end_time": 1739261640,
                "path": "/YOUR_VOLUME_NAME/红楼梦(通行本)简体横排.pdf"
            }
        ]
    }
}
```

### 下载某个源数据卷中的文件

```
POST /GetOriginVolumeFileLink
```

**输入参数：**
  
|  参数             | 是否必填 |含义|
|  --------------- | ----   | ----  |
| volume_id        |是       | 源数据卷 id|
| file_id          |是       | 文件 id|

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/GetOriginVolumeFileLink"
headers = {
    "moi-key": "xxxxx"
}

body = {
    "volume_id": "YOUR_VOLUME_ID",
    "file_id": "YOUR_FILE_ID"

}

response = requests.post(url, headers=headers,json=body)
print("Response Body:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

返回：

```bash
Response Body: {
    "code": "OK",
    "msg": "OK",
    "data": {
        "link": "YOUR_OSS_BUCKET_FILE_LINK"
    }
}
```

### 删除某个源数据卷中的某个文件

```
POST /DeleteOriginVolumeFiles
```

**输入参数：**
  
|  参数             | 是否必填 |含义|
|  --------------- | ----   | ----  |
| volume_id        |是       | 源数据卷 id|
| file_ids          |是       | 文件 id|

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/DeleteOriginVolumeFiles"

headers = {
    "moi-key": "xxxxx"
}


body={
    "volume_id": "YOUR_VOLUME_ID",
    "file_ids": ["YOUR_FILE_ID_1", "YOUR_FILE_ID_2"]
}


response = requests.post(url, headers=headers,json=body)

if response.status_code == 200:
    print(response.json())  
else:
    print(f"请求失败，状态码：{response.status_code}, 错误信息：{response.text}")
```

返回：

```json
{
    "code": "OK",
    "msg": "OK",
    "data": {}
}
```

## 处理数据卷

### 创建处理数据卷

```
POST /byoa/api/v1/explore/volumes
```

**Body 输入参数：**

| 参数             | 是否必填 | 类型   | 含义        | 默认值 |
| ---------------- | -------- | ------ | ----------- | ------ |
| name             | 是       | string | 数据卷名称  |        |
| parent_volume_id | 否       | string | 处理数据卷 ID | ""     |

**Body 示例：**

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

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/explore/volumes"

headers = {
    "moi-key": "xxxxx"
}

body = {
    "name": "b_vol3"

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
        "id": "YOUR_PROCESSED_VOLUME_ID", 
        "name": "b_vol3", 
        "created_at": "2025-02-13T11:44:36", 
        "updated_at": "2025-02-13T11:44:36"
    }
}
```

**输出参数：**

| 参数       | 类型   | 含义       |
| ---------- | ------ | ---------- |
| id         | string | 数据卷 ID  |
| name       | string | 数据卷名称 |
| created_at | string | 创建时间   |
| updated_at | string | 更新时间   |

### 查看处理数据卷列表

```
GET /byoa/api/v1/explore/volumes
```

**Query 参数：**

| 参数           | 是否必填 | 类型    | 含义                             |
| -------------- | -------- | ------- | -------------------------------- |
| workflow_using | 否       | boolean | 是否仅列出工作流正在使用的数据卷 |

**示例 (Python)：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/explore/volumes"
headers = {
    "moi-key": "xxxxx"
}
params = {
    "workflow_using": False 
}
response = requests.get(url, headers=headers, params=params)
print("Response Body:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

**返回：**

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
                "user_id": "your_user_id",
                "id": "YOUR_PROCESSED_VOLUME_ID_1",
                "parent_volume_id": ""
            },
            {
                "name": "example-volume-2",
                "created_at": "2025-02-13T11:44:36Z",
                "updated_at": "2025-02-13T11:44:36Z",
                "user_id": "your_user_id",
                "id": "YOUR_PROCESSED_VOLUME_ID_2",
                "parent_volume_id": "YOUR_PARENT_VOLUME_ID"
            }
        ]
    }
}
```

**输出参数：**

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
  | parent_volume_id | string | 处理数据卷 ID (可能为空) |

### 查看分支处理数据卷列表

```
GET /byoa/api/v1/explore/volumes/{vid}
```

**路径参数：**

* `vid` (string, 必填): 处理数据卷 ID

**示例 (Python)：**

```python
import requests
import json

# 将 {vid} 替换为实际的处理数据卷 ID
url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/explore/volumes/{vid}" 
headers = {
    "moi-key": "xxxxx"
}
response = requests.get(url.replace("{vid}", "actual_parent_volume_id"), headers=headers)
print("Response Body:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

**返回：**
返回结构与 "查看数据卷列表" 相同，但 `volumes` 列表将只包含指定 `{vid}` 的分支卷。

**输出参数：**
与 "查看数据卷列表" 的输出参数一致。

### 查看分支处理数据卷内文件列表

```
POST /byoa/api/v1/explore/volumes/{vid}/files
```

**路径参数：**

* `vid` (string, 必填): 数据卷 ID

**Body 输入参数 (可选)：**

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

**Body 示例：**

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
url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/explore/volumes/{vid}/files"
headers = {
    "moi-key": "xxxxx"
}
body = { # 可选
    "limit": 5 
}

response = requests.post(url.replace("{vid}", "YOUR_PROCESSED_VOLUME_ID"), json=body, headers=headers)
print("Response Body:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

**返回：**

```json
{
    "code": "ok",
    "msg": "ok",
    "data": {
        "total": 1,
        "items": [
            {
                "id": "YOUR_FILE_ITEM_ID",
                "created_at": "2025-02-12T17:46:16.000000+0000",
                "updated_at": "2025-02-12T17:51:21.000000+0000",
                "user_id": "YOUR_USER_ID",
                "priority": 300,
                "source_volume_id": "YOUR_SOURCE_VOLUME_ID",
                "source_file_id": "YOUR_SOURCE_FILE_ID",
                "target_volume_id": "YOUR_TARGET_VOLUME_ID",
                "file_name": "红楼梦 (通行本) 简体横排.pdf",
                "file_type": 2,
                "file_size": 6787457,
                "file_path": "YOUR_USER_ID/YOUR_SOURCE_VOLUME_NAME/YOUR_SOURCE_FILE_ID/红楼梦 (通行本) 简体横排.pdf",
                "file_status": 2,
                "workflow_meta_id": "YOUR_WORKFLOW_META_ID",
                "workflow_branch_id": null,
                "job_id": "YOUR_JOB_ID",
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

**输出参数：**

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

### 删除分支处理数据卷内文件

```
DELETE /byoa/api/v1/explore/volumes/{vid}/files/{fid}
```

**路径参数：**

* `vid` (string, 必填): 数据卷 ID
* `fid` (string, 必填): 文件 ID

**示例 (Python)：**

```python
import requests

# 将 {vid} 和 {fid} 替换为实际的 ID
url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/explore/volumes/{vid}/files/{fid}"
headers = {
    "moi-key": "xxxxx"
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
成功时 HTTP 状态码为 200。

### 获取分支处理数据卷文件解析内容

```
GET /byoa/api/v1/explore/volumes/{vid}/files/{fid}/raws
```

**路径参数：**

* `vid` (string, 必填): 数据卷 ID
* `fid` (string, 必填): 文件 ID

**Query 参数：**

| 参数            | 是否必填 | 类型    | 含义               | 默认值 |
| --------------- | -------- | ------- | ------------------ | ------ |
| need_embeddings | 否       | boolean | 是否需要 embedding | false  |

**示例 (Python)：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/explore/volumes/{vid}/files/{fid}/raws"
headers = {
    "moi-key": "xxxxx"
}
params = {
    "need_embeddings": False # 或者 True
}

response = requests.get(url.replace("{vid}", "actual_volume_id").replace("{fid}", "actual_file_id"), headers=headers, params=params)

if response.status_code == 200:
    # 从 Content-Disposition 获取文件名，如果没有则使用 file_id
    filename = file_id + ".zip"
    content_disposition = response.headers.get('Content-Disposition')
    if content_disposition:
        import re
        matches = re.findall("filename=(.+)", content_disposition)
        if matches:
            filename = matches[0].strip('"')
            if not filename.endswith('.zip'):
                filename += '.zip'

    # 保存文件
    output_file = os.path.join(data_dir, filename)
    with open(output_file, 'wb') as f:
        f.write(response.content)
    print(f"\n内容已保存到文件：{output_file}")
    print(f"文件大小：{len(response.content)} 字节")
else:
    print("获取失败！")
    print("错误信息：", response.text) 
```

**返回：**
成功响应为 200。

### 获取文件关联的作业信息

```
GET /byoa/api/v1/explore/volumes/{vid}/files/{fid}/jobs
```

**路径参数：**

* `vid` (string, 必填): 数据卷 ID
* `fid` (string, 必填): 文件 ID

**示例 (Python)：**

```python
import requests
import json

# 将 {vid} 和 {fid} 替换为实际的 ID
url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/explore/volumes/{vid}/files/{fid}/jobs"
headers = {
    "moi-key": "xxxxx"
}
response = requests.get(url.replace("{vid}", "actual_volume_id").replace("{fid}", "actual_file_id"), headers=headers)
print("Response Body:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

**返回：**

```json
{
    "code": "ok",
    "msg": "ok",
    "data": {
        "job": {
            "id": "YOUR_JOB_ID",
            "workflow_name": "Associated Workflow",
            "status": 2,
            "start_time": "2025-02-13T12:00:00Z",
            "end_time": "2025-02-13T12:05:00Z"
        }
    }
}
```

**输出参数：**

| 参数 | 类型   | 含义                                                         |
| ---- | ------ | ------------------------------------------------------------ |
| job  | object | 文件关联的作业信息对象。具体结构需要参照实际 API 返回或更详细的定义。 |

### 获取文件解析的数据块

```
POST /byoa/api/v1/explore/volumes/{vid}/files/{fid}/blocks
```

**路径参数：**

* `vid` (string, 必填): 数据卷 ID
* `fid` (string, 必填): 文件 ID

**Body 输入参数 (`可选)：**

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

**Body 示例：**

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
url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/explore/volumes/{vid}/files/{fid}/blocks"
headers = {
    "moi-key": "xxxxx"
}
body = {
    "limit": 2
}
response = requests.post(url.replace("{vid}", "actual_volume_id").replace("{fid}", "actual_file_id"), json=body, headers=headers)
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
                "id": "YOUR_BLOCK_ID_1",
                "content": "Matrix Search 利用 Efficient Net 模型对上传的图片进行特征提取...",
                "type": "text", 
                "content_type": "text", 
                "file_id": "YOUR_FILE_ID",
                "description": null,
                "created_at": "2025-02-13T03:45:02",
                "updated_at": "2025-02-13T03:45:02",
                "text_and_image_id": null
            },
            {
                "id": "YOUR_BLOCK_ID_2",
                "content": "![](/image.jpg) 接下来我们会逐个分析...",
                "type": "markdown",
                "content_type": "text",
                "file_id": "YOUR_FILE_ID",
                "description": "An image with text",
                "created_at": "2025-02-13T03:45:03",
                "updated_at": "2025-02-13T03:45:03",
                "text_and_image_id": 123
            }
        ]
    }
}
```**输出参数：**

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

* `vid` (string, 必填): 数据卷 ID
* `fid` (string, 必填): 文件 ID

**Body 输入参数：**

| 参数 | 是否必填 | 类型          | 含义                 |
| ---- | -------- | ------------- | -------------------- |
| ids  | 是       | array[string] | 要删除的数据块 ID 列表 |

**Body 示例：**

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
url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/explore/volumes/{vid}/files/{fid}/blocks"
headers = {
    "moi-key": "xxxxx"
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
成功时 HTTP 状态码为 204。

## 查看工作流中间结果

系统会自动将各组件的执行结果保存到数据库的 `debug_results` 表中，您可以通过以下方式查看 Pipeline 组件的中间结果数据，用于开发调试和问题排查。

### API 查询

```
GET /byoa/api/v1/debug_results
```

**Query 参数：**

| 参数名             | 类型              | 是否必填 | 描述                     | 默认值 |
| ----------------- | ----------------- | -------- | ----------------------- | ------ |
| `workflow_job_id` | string           | 否       | 工作流作业 ID            |        |
| `workflow_branch_id` | string        | 否       | 工作流分支 ID            |        |
| `workflow_meta_id` | string          | 否       | 工作流元数据 ID          |        |
| `component_name`  | string           | 否       | 组件名称（支持部分匹配）  |        |
| `file_id`        | string           | 否       | 文件 ID                  |        |
| `limit`          | integer          | 否       | 限制返回结果数量          | 50     |

**示例 (Python)：**

```python
import httpx
import json
from datetime import datetime
from typing import Optional

async def query_debug_results(
    workflow_job_id: Optional[str] = None,
    workflow_branch_id: Optional[str] = None,
    workflow_meta_id: Optional[str] = None,
    component_name: Optional[str] = None,
    file_id: Optional[str] = None,
    limit: int = 50,
):
    url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/debug_results"
    params = {
        "workflow_job_id": workflow_job_id,
        "workflow_branch_id": workflow_branch_id,
        "workflow_meta_id": workflow_meta_id,
        "component_name": component_name,
        "file_id": file_id,
        "limit": limit
    }
    
    # 移除 None 值的参数
    params = {k: v for k, v in params.items() if v is not None}
    
    headers = {
        "moi-key": "xxxxx"
    }
    
    async with httpx.AsyncClient() as client:
        response = await client.get(url, params=params, headers=headers)
        response.raise_for_status()
        return response.json()

# 使用示例
async def main():
    # 查询特定作业的调试结果
    results = await query_debug_results(
        workflow_job_id="your_job_id_here",
        limit=20
    )
    print(json.dumps(results, indent=4))
```

**返回示例：**

```json
{
    "code": "ok",
    "msg": "ok",
    "data": [
        {
            "id": "72f66505-8f26-458b-9621-ef9ce9acf268",
            "workflow_branch_id": "82f1064d-49a7-4c18-851d-8a7419090af3",
            "workflow_meta_id": "69985cd1-cc08-4be5-adac-4de14a5fc4e0",
            "component_name": "EnhancedDOCXToDocument",
            "component_results": "{\"documents\": [{\"_type\": \"Document\", \"id\": \"d0f523a6af915a9ad4c6ca017b3ea79e958305902cd366d600298e00bb318b62\", \"content\": \"云原生应用的高可用架构设计...\", \"content_length\": 1540, \"meta\": {...}}]}",
            "workflow_job_id": "019742c0-ee10-79b3-902b-41df812d0de1",
            "file_id": "019742c0-ee10-79ce-9020-7b266182e431",
            "created_at": "2025-06-06T01:00:41",
            "updated_at": "2025-06-06T01:00:41"
        }
    ]
}
```

**返回参数说明：**

1. **基础信息字段**
   - `id`: 调试结果记录的唯一标识符
   - `workflow_job_id`: 工作流作业的 ID
   - `workflow_branch_id`: 工作流分支的 ID
   - `workflow_meta_id`: 工作流元数据的 ID
   - `component_name`: 组件名称，例如 "EnhancedDOCXToDocument"
   - `file_id`: 处理的文件 ID
   - `created_at`: 记录创建时间
   - `updated_at`: 记录更新时间

2. **component_results 字段**（JSON 字符串，包含以下结构）：
   - `documents`: 文档数组，每个文档包含：
     - `_type`: 文档类型，通常为 "Document"
     - `id`: 文档的唯一标识符
     - `content`: 文档的实际内容
     - `content_length`: 内容长度
     - `meta`: 元数据对象，包含：
       - `content_type`: 内容类型（如 "text"）
       - `file_name`: 文件名
       - `file_id`: 文件 ID
       - `target_volume_id`: 目标数据卷 ID
       - `source_volume_id`: 源数据卷 ID
       - `source_file_id`: 源文件 ID
       - `job_id`: 作业 ID
       - `job_version`: 作业版本
       - `workflow_meta_id`: 工作流元数据 ID
       - `workflow_branch_id`: 工作流分支 ID
       - `user_id`: 用户 ID
       - `docx`: DOCX 特有的元数据（如果是 DOCX 文件）
         - `author`: 作者
         - `created`: 创建时间
         - `modified`: 修改时间
         - 其他 DOCX 相关属性
       - `md_file_url`: 生成的 Markdown 文件 URL（如果有）

通过这个 API，您可以查询工作流中各个组件的处理结果，用于调试和验证工作流的执行情况。每个组件的处理结果都会被记录下来，包括输入文档的处理结果以及相关的元数据信息。

### 数据库直接查询

如果您有数据库访问权限，也可以直接通过 SQL 查询中间结果：

```sql
-- 查看最近的中间结果
SELECT component_name, workflow_job_id, created_at 
FROM debug_results 
ORDER BY created_at DESC LIMIT 20;

-- 按作业 ID 查询特定作业的所有组件结果
SELECT component_name, component_results, created_at
FROM debug_results 
WHERE workflow_job_id = 'your_job_id_here'
ORDER BY created_at ASC;

-- 按组件名称查询
SELECT workflow_job_id, created_at
FROM debug_results 
WHERE component_name = 'PDFConverter'
ORDER BY created_at DESC LIMIT 10;
```

注意事项

1. 建议使用 `limit` 参数限制查询结果数量，避免返回过多数据
2. 组件结果以 JSON 格式存储在 `component_results` 字段中
3. 可以通过组合不同的查询参数来精确定位需要查看的结果
4. 时间戳使用 UTC 时间
