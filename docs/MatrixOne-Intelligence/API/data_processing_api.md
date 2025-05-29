# 数据处理相关 API

## 工作流

### 创建工作流

```
POST /byoa/api/v1/workflow_meta
```

**路径参数：**
(无)

**Query 参数：**
(无)

**Header 参数：**

| 参数名         | 类型   | 是否必填 | 描述         | 默认值      |
| -------------- | ------ | -------- | ------------ | ----------- |
| `user-name`    | string | 否       | 用户名       | "user_name" |
| `user-id`      | string | 是       | 用户 ID       |             |
| `Access-Token` | string | 是       | 鉴权 Token    |             |
| `uid`          | string | 是       | 用户登录 UID |             |

**Body 输入参数 (`WorkflowRequest`)：**

| 参数名                      | 是否必填 | 类型                         | 含义                           | 默认值 |
| --------------------------- | -------- | ---------------------------- | ------------------------------ | ------ |
| `name`                      | 是       | string                       | 工作流名称                     |        |
| `source_volume_names`       | 是       | array[string]                | 源数据卷名称列表               |        |
| `source_volume_ids`         | 是       | array[integer]               | 源数据卷 ID 列表                 |        |
| `file_types`                | 是       | array[integer]               | 文件类型列表                   |        |
| `process_mode`              | 是       | object (`ProcessModeConfig`) | 处理模式配置                   |        |
| `priority`                  | 否       | integer                      | 优先级                         | 300    |
| `target_volume_id`          | 是       | string                       | 目标数据卷 ID                   |        |
| `target_volume_name`        | 否       | string                       | 目标数据卷名称                 | ""     |
| `create_target_volume_name` | 是       | string                       | 创建目标数据卷时使用的名称     |        |
| `workflow`                  | 是       | object (`WorkflowConfig`)    | 工作流配置 (Haystack pipeline) |        |
| `branch_name`               | 否       | string                       | 分支名 (如果同时创建分支)      | ""     |

* **`ProcessModeConfig` 结构:**

  | 参数       | 是否必填 | 类型    | 含义                   |
  | ---------- | -------- | ------- | ---------------------- |
  | `interval` | 是       | integer | 处理间隔（分钟）       |
  | `offset`   | 是       | integer | 处理时间偏移量（分钟） |

* **`WorkflowConfig` 结构:** (参考 `workflow.openapi.json` -> `components.schemas.WorkflowConfig`)

  * `components`: array[object] - 组件配置列表。每个组件对象包含 `name`, `type`, `component_id`, `intro`, `position`, `input_keys`, `output_keys`, `init_parameters`。
  * `connections`: array[object] - 连接配置列表。每个连接对象包含 `sender` 和 `receiver`。
  * `edges`: array[object] - 边配置列表 (通常为空数组 `[]`)。
  * `extra_components`: array[object] - 额外组件配置列表 (通常为空数组 `[]`)。

**示例 (Python)：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/workflow_meta"

headers = {
    "moi-key": "xxxxx"
}

body = {
    "name": "wf-from-meta-api",
    "source_volume_names": ["b-vol1"],
    "source_volume_ids": [1889223879880048640],
    "target_volume_id": "eb42f0a1-ab18-4010-b95c-cd1716dd5e95",
    "create_target_volume_name": "new-target-for-wf-from-meta",
    "process_mode": {
        "interval": 0,
        "offset": 0
    },
    "file_types": [2],
    "priority": 300,
    "workflow": {
        "components": [
            {
                "name": "DocumentCleaner",
                "type": "haystack.components.preprocessors.document_cleaner.DocumentCleaner",
                "component_id": "DocumentCleaner_1739377283742",
                "intro": "DocumentCleaner",
                "position": {"x": 0, "y": 0},
                "input_keys": {},
                "output_keys": {},
                "init_parameters": {
                    "ascii_only": False, # boolean
                    "keep_id": False,    # boolean
                    "remove_empty_lines": True,
                    "remove_extra_whitespaces": True,
                    "remove_regex": "([a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+)|https?://[^\\s]+",
                    "remove_repeated_substrings": False
                }
            },
            // ... (其他组件和连接，参考 workflow.openapi.json 的 WorkflowRequest 示例)
            {
                "name":"DocumentWriter",
                "type":"haystack.components.writers.document_writer.DocumentWriter",
                "component_id":"DocumentWriter_1739377283742",
                "intro":"DocumentWriter",
                "position":{"x":0,"y":0},
                "input_keys":{},
                "output_keys":{},
                "init_parameters":{
                    "document_store":{
                        "init_parameters":{
                            "connection_string":{
                                "env_vars":["DATABASE_SYNC_URI"],
                                "strict":True,
                                "type":"env_var"
                            },
                            "embedding_dimension":1024,
                            "keyword_index_name":"haystack_keyword_index",
                            "recreate_table":True,
                            "table_name":"embedding_results",
                            "vector_function":"cosine_similarity"
                        },
                        "type":"byoa.integrations.document_stores.mo_document_store.MOIDocumentStore"
                    },
                    "policy":"NONE"
                }
            }
        ],
        "connections": [
            // ... (连接定义)
        ],
        "edges": [],
        "extra_components": []
    }
}

response = requests.post(url, json=body, headers=headers)

print(response.status_code)
print(json.dumps(response.json(), indent=4, ensure_ascii=False))
```

**返回 (`NoneDataResp`)：**

```json
{
    "code": "ok",
    "msg": "ok",
    "data": null
}
```

### 查看工作流列表

```
GET /byoa/api/v1/workflow_meta
```

**路径参数：**
(无)

**Query 参数：**

| 参数名          | 类型                                  | 是否必填 | 描述                          | 默认值       |
| --------------- | ------------------------------------- | -------- | ----------------------------- | ------------ |
| `name_search`   | string, nullable                      | 否       | 名称搜索 (工作流名)           |              |
| `start_time`    | integer, nullable                     | 否       | 开始时间戳 (毫秒)             |              |
| `end_time`      | integer, nullable                     | 否       | 结束时间戳 (毫秒)             |              |
| `process_modes` | array[integer], nullable              | 否       | 处理模式 (通常指 interval 值) |              |
| `status`        | array[integer], nullable              | 否       | 状态 (例如：1-运行中，2-完成) |              |
| `file_types`    | array[integer], nullable              | 否       | 文件类型                      |              |
| `priority`      | array[integer], nullable              | 否       | 优先级                        |              |
| `creator`       | string, nullable                      | 否       | 创建者                        |              |
| `offset`        | integer, >=0                          | 否       | 当页偏移量                    | 0            |
| `limit`         | integer, >=1                          | 否       | 每页大小                      | 20           |
| `sort_field`    | string, nullable                      | 否       | 排序字段                      | "created_at" |
| `sort_order`    | string, nullable ("ascend"/"descend") | 否       | 排序方式                      | "descend"    |

**Header 参数：**

| 参数名         | 类型   | 是否必填 | 描述         |
| -------------- | ------ | -------- | ------------ |
| `user-id`      | string | 是       | 用户 ID       |
| `Access-Token` | string | 是       | 鉴权 Token    |
| `uid`          | string | 是       | 用户登录 UID |

**示例 (Python)：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/workflow_meta" # 更新的 URL
headers = {
    "moi-key": "xxxxx"
}
params = {
    "limit": 5,
    "sort_field": "name",
    "sort_order": "ascend"
}

response = requests.get(url, headers=headers, params=params)

print(response.status_code)
print(json.dumps(response.json(), indent=4, ensure_ascii=False))
```

**返回 (`MOIResponse_WorkflowListResponse_`)：**

```json
{
    "code": "ok",
    "msg": "ok",
    "data": { // WorkflowListResponse 结构
        "total": 20, // 符合条件的工作流总数
        "workflows": [ // WorkflowListItem 数组
            {
                "id": "YOUR_WORKFLOW_ID_1",
                "name": "Alpha Workflow",
                "created_at": 1739377287000, // timestamp in ms
                "creator": "YOUR_USERNAME",
                "updated_at": 1739377755000,
                "modifier": "YOUR_USERNAME",
                "source_volume_ids": ["YOUR_SOURCE_VOLUME_ID_1"],
                "source_volume_names": ["b-vol1"],
                "file_types": [2],
                "target_volume_id": "YOUR_TARGET_VOLUME_ID_1",
                "target_volume_name": "a-vol1",
                "process_mode": {"interval": 0, "offset": 0},
                "priority": 300,
                "status": 2, // 示例：2-完成
                "version": "1.0",
                "branch_total": 1, // 该工作流下的分支数量
                "branch_id": "YOUR_BRANCH_ID_1", 
                "branch_name": "main",
                "branch_status": 0, // 最新或主分支状态
                "branch_volume_id": "YOUR_BRANCH_TARGET_VOLUME_ID_1"
            }
            // ... 其他工作流项
        ]
    }
}
```

**输出参数 (`MOIResponse_WorkflowListResponse_` 的 `data` 部分 - `WorkflowListResponse`)：**

| 参数        | 类型                                    | 描述                                           |
| ----------- | --------------------------------------- | ---------------------------------------------- |
| `total`     | integer                                 | 符合条件的工作流总数                           |
| `workflows` | array[object] (`WorkflowListItem` 结构) | 工作流列表，每个对象包含工作流及其主要分支信息 |

* **`WorkflowListItem` 对象结构:** (参考 `workflow.openapi.json` components.schemas.WorkflowListItem)
    * `id` (string): 工作流 ID
    * `name` (string): 工作流名称
    * `created_at` (integer): 创建时间戳 (毫秒)
    * `creator` (string): 创建者
    * `updated_at` (integer): 更新时间戳 (毫秒)
    * `modifier` (string, nullable): 更新者
    * `source_volume_ids` (array[string]): 源数据卷 ID 列表
    * `source_volume_names` (array[string]): 源数据卷名称列表
    * `file_types` (array[integer]): 文件类型列表
    * `target_volume_id` (string): 目标数据卷 ID
    * `target_volume_name` (string): 目标数据卷名称
    * `process_mode` (object `ProcessModeConfig`): 处理模式配置
    * `priority` (integer): 优先级
    * `status` (integer): 状态
    * `version` (string, nullable): 版本号
    * `branch_total` (integer, nullable): 该工作流下的分支总数
    * `branch_id` (string, nullable): (通常是) 主分支或最新活动分支的 ID
    * `branch_name` (string, nullable): (通常是) 主分支或最新活动分支的名称
    * `branch_status` (integer, nullable): (通常是) 主分支或最新活动分支的状态
    * `branch_volume_id` (string, nullable): (通常是) 主分支或最新活动分支的目标数据卷 ID

### 查看工作流详情

```
GET /byoa/api/v1/workflow_meta/{workflow_id}
```

**路径参数：**

| 参数名        | 类型   | 是否必填 | 描述     |
| ------------- | ------ | -------- | -------- |
| `workflow_id` | string | 是       | 工作流 ID |

**Header 参数：**

| 参数名         | 类型   | 是否必填 | 描述         |
| -------------- | ------ | -------- | ------------ |
| `user-id`      | string | 是       | 用户 ID       |
| `Access-Token` | string | 是       | 鉴权 Token    |
| `uid`          | string | 是       | 用户登录 UID |

**示例 (Python)：**

```python
import requests
import json

workflow_to_get = "YOUR_WORKFLOW_ID" # 替换为实际的 workflow_id
url = f"https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/workflow_meta/{workflow_to_get}" # 更新的 URL
headers = {
    "moi-key": "xxxxx"
}
response = requests.get(url, headers=headers)

print(response.status_code)
print(json.dumps(response.json(), indent=4, ensure_ascii=False))
```

**返回 (`MOIResponse_WorkflowDetailResponse_`)：**

```json
{
    "code": "ok",
    "msg": "ok",
    "data": { // WorkflowDetailResponse 结构
        "id": "YOUR_WORKFLOW_ID",
        "name": "Detailed Workflow Test",
        "source_volume_ids": ["YOUR_SOURCE_VOLUME_ID_1"],
        "source_volume_names": ["b-vol1"],
        "target_volume_id": "YOUR_TARGET_VOLUME_ID_W", 
        "target_volume_name": "a-vol2",
        "file_types": [2],
        "process_mode": {"interval": 5, "offset": 0},
        "priority": 300,
        "created_at": 1739435482000,
        "creator": "YOUR_USERNAME",
        "updated_at": 1739436347000,
        "modifier": "YOUR_USERNAME",
        "status": 1, // 主工作流状态
        "workflow": { // 主工作流的 Haystack 配置
            "components": [ /* ... */ ],
            "connections": [ /* ... */ ],
            "edges": [],
            "extra_components": []
        },
        "branch_id": "YOUR_MAIN_BRANCH_ID", 
        "branch_name": "main",                    
        "branch_status": 0,                       
        "branch_volume_id": "YOUR_MAIN_BRANCH_TARGET_VOLUME_ID", 
        "version": "1.2",
        "branches": [ // 此工作流下的所有分支列表
            {
                "branch_id": "YOUR_MAIN_BRANCH_ID",
                "created_at": 1739435482000,
                "creator": "YOUR_USERNAME",
                "updated_at": 1739436347000,
                "modifier": "YOUR_USERNAME",
                "status": 1, // 此分支对应的工作流部分的状态 (通常与父工作流状态一致)
                "workflow": { /* YOUR_MAIN_BRANCH_ID 分支的特定 Haystack 配置 */ },
                "branch_name": "main",
                "branch_status": 0, // 该分支自身的状态
                "branch_volume_id": "YOUR_MAIN_BRANCH_TARGET_VOLUME_ID"
            },
            {
                "branch_id": "YOUR_DEV_BRANCH_ID",
                "created_at": 1739500000000,
                "creator": "YOUR_DEVELOPER_USERNAME",
                "updated_at": 1739501000000,
                "modifier": "YOUR_DEVELOPER_USERNAME",
                "status": 1,
                "workflow": { /* YOUR_DEV_BRANCH_ID 分支的特定 Haystack 配置 */ },
                "branch_name": "dev-feature-x",
                "branch_status": 0,
                "branch_volume_id": "YOUR_DEV_BRANCH_TARGET_VOLUME_ID"
            }
        ]
    }
}
```

**输出参数 (`MOIResponse_WorkflowDetailResponse_` 的 `data` 部分 - `WorkflowDetailResponse`)：**
(参考 `workflow.openapi.json` components.schemas.WorkflowDetailResponse)
主要包含工作流的基础信息、主工作流的 Haystack 配置 (`workflow`)、主/默认分支的相关信息 (`branch_id`, `branch_name`, `branch_status`, `branch_volume_id`)，以及一个 `branches` 数组，其中每一项是 `WorkflowBranchItem`。

* **`WorkflowBranchItem` 结构:** (参考 `workflow.openapi.json` components.schemas.WorkflowBranchItem)
    * `branch_id` (string): 分支 ID
    * `created_at` (integer): 创建时间戳
    * `creator` (string): 创建者
    * `updated_at` (integer): 更新时间戳
    * `modifier` (string): 更新者
    * `status` (integer): 此分支应用的工作流部分的状态
    * `workflow` (object `WorkflowConfig`): 此分支特定的 Haystack 配置
    * `branch_name` (string): 分支名
    * `branch_status` (integer): 分支自身的状态
    * `branch_volume_id` (string): 分支的目标数据卷 ID

### 修改工作流

```
PUT /byoa/api/v1/workflow_meta/{workflow_id}
```

**描述：**更新指定工作流的配置。这通常会更新工作流的 "main" 或默认分支。

**路径参数：**

| 参数名        | 类型   | 是否必填 | 描述     |
| ------------- | ------ | -------- | -------- |
| `workflow_id` | string | 是       | 工作流 ID |

**Header 参数：**

| 参数名         | 类型   | 是否必填 | 描述         |
| -------------- | ------ | -------- | ------------ |
| `user-name`    | string | 否       | 用户名       |
| `user-id`      | string | 是       | 用户 ID       |
| `Access-Token` | string | 是       | 鉴权 Token    |
| `uid`          | string | 是       | 用户登录 UID |

**Body 输入参数 (`WorkflowRequest`)：**
与 "创建工作流" 的 Body (`WorkflowRequest`) 结构相同。所有字段都可以更新。

**示例 (Python)：**

```python
import requests
import json

workflow_to_update = "YOUR_WORKFLOW_ID" # 替换为实际的 workflow_id
url = f"https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/workflow_meta/{workflow_to_update}" # 更新的 URL
headers = {
    "moi-key": "xxxxx"
}

body = { # WorkflowRequest 结构
    "name": "wf-3-updated-name",
    "source_volume_names": ["b-vol1-updated"],
    "source_volume_ids": ["YOUR_SOURCE_VOLUME_ID_1"], 
    "target_volume_id": "YOUR_TARGET_VOLUME_ID_W", 
    "create_target_volume_name": "", 
        "process_mode": {
        "interval": 10, // 更新处理间隔为10分钟
            "offset": 0
        },
    "file_types": [2, 6], // 增加 markdown 支持
    "priority": 350,      // 更新优先级
        "workflow": {
        // 更新后的 Haystack 配置
            "components": [
                {
                    "name": "DocumentCleaner",
                    "type": "haystack.components.preprocessors.document_cleaner.DocumentCleaner",
                "component_id": "YOUR_COMPONENT_ID_UPDATED",
                "intro": "Updated DocumentCleaner",
                "position": {"x": 0, "y": 0},
                "input_keys": {}, "output_keys": {},
                    "init_parameters": {
                    "remove_empty_lines": False, // 修改参数
                    "remove_extra_whitespaces": True
                }
            }
            // ... 其他组件和连接
        ],
        "connections": [ /* ... */ ],
        "edges": [],
        "extra_components": []
    }
    // "branch_name": "main" // 通常更新主工作流时，此字段不需特别指定，或与 workflow_id 的主分支名一致
}

response = requests.put(url, json=body, headers=headers)
print(response.status_code)
print(response.json())
```

**返回 (`NoneDataResp`)：**

```json
{
    "code": "ok",
    "msg": "ok",
    "data": null
}
```

### 删除工作流

```
DELETE /byoa/api/v1/workflow_meta/{workflow_id}
```

**描述：**删除指定的工作流及其所有分支和关联的作业元数据。

**路径参数：**

| 参数名        | 类型   | 是否必填 | 描述     |
| ------------- | ------ | -------- | -------- |
| `workflow_id` | string | 是       | 工作流 ID |

**Query 参数：**

| 参数名        | 类型    | 是否必填 | 描述                           | 默认值 |
| ------------- | ------- | -------- | ------------------------------ | ------ |
| `delete_data` | boolean | 否       | 是否删除该工作流产生的所有数据 | false  |

**Header 参数：**

| 参数名         | 类型   | 是否必填 | 描述         |
| -------------- | ------ | -------- | ------------ |
| `user-id`      | string | 是       | 用户 ID       |
| `Access-Token` | string | 是       | 鉴权 Token    |
| `uid`          | string | 是       | 用户登录 UID |

**示例 (Python)：**

```python
import requests
import json

workflow_to_delete = "YOUR_WORKFLOW_ID_TO_DELETE" # 替换为实际的 workflow_id
url = f"https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/workflow_meta/{workflow_to_delete}" # 更新的 URL

headers = {
    "moi-key": "xxxxx"
}
params = {
    "delete_data": True # 或 False
}

response = requests.delete(url, headers=headers, params=params)

print(response.status_code)
if response.content: # 检查是否有内容，因为成功可能返回空响应体
    try:
        print(json.dumps(response.json(), indent=4, ensure_ascii=False))
    except json.JSONDecodeError:
        print("Response text:", response.text) # 如果不是 JSON，打印文本
else:
    print("Request successful, no content returned.")

```

**返回 (`NoneDataResp`)：**
成功时通常返回此结构，或 HTTP 204 No Content。

```json
{
    "code": "ok",
    "msg": "ok",
    "data": null
}
```

### 停止工作流

```
PUT /byoa/api/v1/workflow_meta/{workflow_id}/stop
```

**描述：**停止指定工作流的运行。这通常会将工作流的状态更改为 "已停止" 或类似状态，并可能停止所有关联的正在进行的作业。

**路径参数：**

| 参数名        | 类型   | 是否必填 | 描述     |
| ------------- | ------ | -------- | -------- |
| `workflow_id` | string | 是       | 工作流 ID |

**Header 参数：**

| 参数名         | 类型   | 是否必填 | 描述         |
| -------------- | ------ | -------- | ------------ |
| `user-id`      | string | 是       | 用户 ID       |
| `Access-Token` | string | 是       | 鉴权 Token    |
| `uid`          | string | 是       | 用户登录 UID |

**(无 Body 输入参数)**

**示例 (Python)：**

```python
import requests
import json

workflow_to_stop = "your_workflow_id_to_stop"
url = f"https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/workflow_meta/{workflow_to_stop}/stop"

headers = {
    "moi-key": "xxxxx"
}

response = requests.put(url, headers=headers)

print(response.status_code)
if response.content:
    try:
        print(json.dumps(response.json(), indent=4, ensure_ascii=False))
    except json.JSONDecodeError:
        print("Response text:", response.text)
else:
    print("Request to stop workflow successful, no content returned.")
```

**返回 (`NoneDataResp`)：**
成功时通常返回此结构，表示操作已接受。

```json
{
    "code": "ok",
    "msg": "ok",
    "data": null
}
```

### 工作流分支

#### 创建工作流分支

```
POST /byoa/api/v1/workflow_meta/{workflow_id}/branch
```

**描述：**为指定的工作流创建一个新的分支。

**路径参数：**

| 参数名        | 类型   | 是否必填 | 描述     |
| ------------- | ------ | -------- | -------- |
| `workflow_id` | string | 是       | 工作流 ID |

**Header 参数：**

| 参数名         | 类型   | 是否必填 | 描述                | 默认值      |
| -------------- | ------ | -------- | ------------------- | ----------- |
| `user-name`    | string | 否       | 用户名              | "user_name" |
| `user-id`      | string | 是       | 用户 ID              |             |
| `Access-Token` | string | 是       | 鉴权 Token (隐式)    |             |
| `uid`          | string | 是       | 用户登录 UID (隐式) |             |

**Body 输入参数 (`WorkflowBranchRequest`)：**

| 参数名        | 是否必填 | 类型                      | 含义       | 默认值 |
| ------------- | -------- | ------------------------- | ---------- | ------ |
| `branch_name` | 否       | string, nullable          | 分支名     | ""     |
| `workflow`    | 是       | object (`WorkflowConfig`) | 工作流配置 |        |

* **`WorkflowConfig` 结构:** (同主工作流创建/更新时的 `WorkflowConfig` 定义)

**示例 (Python)：**

```python
import requests
import json

workflow_id_for_branch = "your_workflow_id"
url = f"https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/workflow_meta/{workflow_id_for_branch}/branch"

headers = {
    "moi-key": "xxxxx"
}

body = {
    "branch_name": "feature-branch-alpha",
    "workflow": {
        // ... (与主工作流类似的 Haystack Pipeline 配置, 但可能针对分支有所调整)
        "components": [],
        "connections": [],
        "edges": [],
        "extra_components": []
    }
}

response = requests.post(url, json=body, headers=headers)
print(response.status_code)
if response.content:
    try:
        print(json.dumps(response.json(), indent=4, ensure_ascii=False))
    except json.JSONDecodeError:
        print(response.text)
```

**返回 (`NoneDataResp`)：**

```json
{
    "code": "ok",
    "msg": "ok",
    "data": null
}
```

#### 查看工作流分支列表

```
GET /byoa/api/v1/workflow_meta/{workflow_id}/branch
```

**描述：**获取指定工作流下的所有分支列表。

**路径参数：**

| 参数名        | 类型   | 是否必填 | 描述     |
| ------------- | ------ | -------- | -------- |
| `workflow_id` | string | 是       | 工作流 ID |

**Query 参数：**

| 参数名          | 类型                     | 是否必填 | 描述                                    |
| --------------- | ------------------------ | -------- | --------------------------------------- |
| `status_in`     | array[integer], nullable | 否       | 工作流状态 (分支应用的工作流部分的状态) |
| `branch_status` | array[integer], nullable | 否       | 分支自身的状态                          |

**Header 参数：**

| 参数名         | 类型   | 是否必填 | 描述                |
| -------------- | ------ | -------- | ------------------- |
| `user-id`      | string | 是       | 用户 ID              |
| `Access-Token` | string | 是       | 鉴权 Token (隐式)    |
| `uid`          | string | 是       | 用户登录 UID (隐式) |

**示例 (Python)：**

```python
import requests
import json

workflow_id_for_branches = "your_workflow_id"
url = f"https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/workflow_meta/{workflow_id_for_branches}/branch"

headers = {
    "moi-key": "xxxxx"
}
params = {
    # "branch_status": [0, 1] // 示例：查询状态为 0 或 1 的分支
}

response = requests.get(url, headers=headers, params=params)
print(response.status_code)
if response.content:
    try:
        print(json.dumps(response.json(), indent=4, ensure_ascii=False))
    except json.JSONDecodeError:
        print(response.text)
```

**返回 (`MOIResponse_WorkflowListResponse_`)：**
返回结构与 "查看工作流列表" (`GET /byoa/api/v1/workflow_meta`) 类似，其中 `data.workflows` 数组的每一项是 `WorkflowListItem`，但此处代表的是该工作流下的各个分支的信息。请参考 `WorkflowListItem` 结构。

```json
{
    "code": "ok",
    "msg": "ok",
    "data": { // WorkflowListResponse 结构
        "total": 2, // 该工作流下的分支总数
        "workflows": [ // WorkflowListItem 数组，代表分支
            {
                "id": "workflow_id_for_branch_1", // 父工作流 ID
                "name": "Parent Workflow Name - Branch Alpha", // 分支可能会有特定命名展示
                // ... 其他 WorkflowListItem 字段 ...
                "branch_id": "branch_uuid_alpha",
                "branch_name": "alpha-feature",
                "branch_status": 0, // 分支状态
                "branch_volume_id": "target_vol_for_alpha_branch"
                // status 字段此时代表此分支应用的工作流部分的状态
            },
            {
                "id": "workflow_id_for_branch_1", // 父工作流 ID
                "name": "Parent Workflow Name - Branch Beta",
                // ... 其他 WorkflowListItem 字段 ...
                "branch_id": "branch_uuid_beta",
                "branch_name": "beta-experiment",
                "branch_status": 1,
                "branch_volume_id": "target_vol_for_beta_branch"
            }
        ]
    }
}
```

**输出参数 (`MOIResponse_WorkflowListResponse_` 的 `data.workflows` 中的 `WorkflowListItem`):**
(具体字段参考 `GET /byoa/api/v1/workflow_meta` 的 `WorkflowListItem` 定义，此处 `id` 是父工作流 ID, `branch_id`, `branch_name`, `branch_status` 等描述分支特有属性)

#### 获取工作流分支详情

```
GET /byoa/api/v1/workflow_meta/branch/{branch_id}
```

**描述：**获取特定工作流分支的详细信息。

**路径参数：**

| 参数名      | 类型   | 是否必填 | 描述         |
| ----------- | ------ | -------- | ------------ |
| `branch_id` | string | 是       | 工作流分支 ID |

**Header 参数：**

| 参数名         | 类型   | 是否必填 | 描述                |
| -------------- | ------ | -------- | ------------------- |
| `user-id`      | string | 是       | 用户 ID              |
| `Access-Token` | string | 是       | 鉴权 Token (隐式)    |
| `uid`          | string | 是       | 用户登录 UID (隐式) |

**示例 (Python)：**

```python
import requests
import json

branch_to_get = "your_branch_id"
url = f"https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/workflow_meta/branch/{branch_to_get}"
headers = {
    "moi-key": "xxxxx"
}
response = requests.get(url, headers=headers)
print(response.status_code)
if response.content:
    try:
        print(json.dumps(response.json(), indent=4, ensure_ascii=False))
    except json.JSONDecodeError:
        print(response.text)
```

**返回 (`MOIResponse_WorkflowDetailResponse_`)：**
返回结构与 "查看工作流详情" (`GET /byoa/api/v1/workflow_meta/{workflow_id}`) 类似，但 `data` 部分描述的是该分支的详情。

```json
{
    "code": "ok",
    "msg": "ok",
    "data": { // WorkflowDetailResponse 结构，但聚焦于分支
        "id": "parent_workflow_uuid", // 父工作流 ID
        "name": "Parent Workflow Name (Branch: feature-x)", // 可能包含分支信息
        // ... (父工作流的详细信息) ...
        "workflow": { /* 该分支应用的 Haystack 配置 */ },
        "branch_id": "your_branch_id",       // 当前分支 ID
        "branch_name": "feature-x",          // 当前分支名称
        "branch_status": 0,                  // 当前分支状态
        "branch_volume_id": "target_vol_for_feature_x_branch", // 当前分支目标卷
        "branches": null // 通常获取单个分支详情时，此字段可能为 null 或不包含其他分支
    }
}
```

**输出参数 (`MOIResponse_WorkflowDetailResponse_` 的 `data` 部分 - `WorkflowDetailResponse`)：**
(参考 `GET /byoa/api/v1/workflow_meta/{workflow_id}` 的 `WorkflowDetailResponse` 定义，其中 `id` 为父工作流 ID，`workflow` 为此分支的配置，`branch_id`, `branch_name` 等为当前分支信息)

#### 更新工作流分支

```
PUT /byoa/api/v1/workflow_meta/branch/{branch_id}
```

**描述：**更新指定工作流分支的配置。

**路径参数：**

| 参数名      | 类型   | 是否必填 | 描述         |
| ----------- | ------ | -------- | ------------ |
| `branch_id` | string | 是       | 工作流分支 ID |

**Header 参数：**

| 参数名         | 类型   | 是否必填 | 描述                | 默认值      |
| -------------- | ------ | -------- | ------------------- | ----------- |
| `user-name`    | string | 否       | 用户名              | "user_name" |
| `user-id`      | string | 是       | 用户 ID              |             |
| `Access-Token` | string | 是       | 鉴权 Token (隐式)    |             |
| `uid`          | string | 是       | 用户登录 UID (隐式) |             |

**Body 输入参数 (`UpdateWorkflowBranchRequest`)：**

| 参数名        | 是否必填 | 类型                      | 含义           | 默认值 |
| ------------- | -------- | ------------------------- | -------------- | ------ |
| `branch_name` | 否       | string, nullable          | 新的分支名     | ""     |
| `workflow`    | 是       | object (`WorkflowConfig`) | 新的工作流配置 |        |

* **`WorkflowConfig` 结构:** (同主工作流创建/更新时的 `WorkflowConfig` 定义)

**示例 (Python)：**

```python
import requests
import json

branch_to_update = "your_branch_id_to_update"
url = f"https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/workflow_meta/branch/{branch_to_update}"
headers = {
    "moi-key": "xxxxx"
}
body = {
    "branch_name": "feature-branch-alpha-v2",
    "workflow": {
        // ... (更新后的 Haystack Pipeline 配置)
        "components": [],
        "connections": []
    }
}
response = requests.put(url, json=body, headers=headers)
print(response.status_code)
if response.content:
    try:
        print(json.dumps(response.json(), indent=4, ensure_ascii=False))
    except json.JSONDecodeError:
        print(response.text)
```

**返回 (`NoneDataResp`)：**

```json
{
    "code": "ok",
    "msg": "ok",
    "data": null
}
```

#### 删除工作流分支

```
DELETE /byoa/api/v1/workflow_meta/branch/{branch_id}
```

**描述：**删除指定的工作流分支。

**路径参数：**

| 参数名      | 类型   | 是否必填 | 描述         |
| ----------- | ------ | -------- | ------------ |
| `branch_id` | string | 是       | 工作流分支 ID |

**Query 参数：**

| 参数名        | 类型    | 是否必填 | 描述                         | 默认值 |
| ------------- | ------- | -------- | ---------------------------- | ------ |
| `delete_data` | boolean | 否       | 是否删除该分支产生的所有数据 | false  |

**Header 参数：**

| 参数名         | 类型   | 是否必填 | 描述                |
| -------------- | ------ | -------- | ------------------- |
| `user-id`      | string | 是       | 用户 ID              |
| `Access-Token` | string | 是       | 鉴权 Token (隐式)    |
| `uid`          | string | 是       | 用户登录 UID (隐式) |

**示例 (Python)：**

```python
import requests
import json

branch_to_delete = "your_branch_id_to_delete"
url = f"https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/workflow_meta/branch/{branch_to_delete}"
headers = {
    "moi-key": "xxxxx"
}
params = {
    "delete_data": False # 或 True
}
response = requests.delete(url, headers=headers, params=params)
print(response.status_code)
if response.content and response.text.strip():
    try:
        print(json.dumps(response.json(), indent=4, ensure_ascii=False))
    except json.JSONDecodeError:
        print(f"Response Text: {response.text}")
else:
    print("Request successful, no content returned or empty response.")
```

**返回 (`NoneDataResp`)：**

```json
{
    "code": "ok",
    "msg": "ok",
    "data": null
}
```

#### 启用工作流分支

```
PUT /byoa/api/v1/workflow_meta/branch/{branch_id}/enable
```

**描述：**启用指定的工作流分支。这通常意味着该分支成为工作流新的活动分支，后续的作业将基于此分支的配置运行。

**路径参数：**

| 参数名      | 类型   | 是否必填 | 描述         |
| ----------- | ------ | -------- | ------------ |
| `branch_id` | string | 是       | 工作流分支 ID |

**Header 参数：**

| 参数名         | 类型   | 是否必填 | 描述                |
| -------------- | ------ | -------- | ------------------- |
| `user-id`      | string | 是       | 用户 ID              |
| `Access-Token` | string | 是       | 鉴权 Token (隐式)    |
| `uid`          | string | 是       | 用户登录 UID (隐式) |

**(无 Body 输入参数)**

**示例 (Python)：**

```python
import requests
import json

branch_to_enable = "your_branch_id_to_enable"
url = f"https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/workflow_meta/branch/{branch_to_enable}/enable"
headers = {
    "moi-key": "xxxxx"
}
response = requests.put(url, headers=headers)
print(response.status_code)
if response.content:
    try:
        # Enable 通常返回更新后的分支详情或父工作流详情
        print(json.dumps(response.json(), indent=4, ensure_ascii=False))
    except json.JSONDecodeError:
        print(response.text)
```

**返回 (`MOIResponse_WorkflowDetailResponse_`)：**
成功启用后，通常返回该分支所属的父工作流的详细信息 (`WorkflowDetailResponse`)，其中该分支的状态会更新，并可能成为主分支。

```json
{
    "code": "ok",
    "msg": "ok",
    "data": { // WorkflowDetailResponse 结构
        "id": "parent_workflow_uuid",
        // ... (父工作流的详细信息) ...
        "branch_id": "your_branch_id_to_enable", // 现在启用的分支成为主分支
        "branch_name": "enabled-branch-name",
        "branch_status": 0, // 状态变为启用/活跃
        "branches": [
            {
                "branch_id": "your_branch_id_to_enable",
                "branch_name": "enabled-branch-name",
                "branch_status": 0, // 更新后的状态
                // ...other 分支详情...
            }
            // ...other 分支列表...
        ]
    }
}
```

#### 禁用工作流分支

```
PUT /byoa/api/v1/workflow_meta/branch/{branch_id}/disable
```

**描述：**禁用指定的工作流分支。被禁用的分支通常不能再用于新的作业。如果该分支是当前活动分支，可能需要先启用另一个分支。

**路径参数：**

| 参数名      | 类型   | 是否必填 | 描述         |
| ----------- | ------ | -------- | ------------ |
| `branch_id` | string | 是       | 工作流分支 ID |

**Header 参数：**

| 参数名         | 类型   | 是否必填 | 描述                |
| -------------- | ------ | -------- | ------------------- |
| `user-id`      | string | 是       | 用户 ID              |
| `Access-Token` | string | 是       | 鉴权 Token (隐式)    |
| `uid`          | string | 是       | 用户登录 UID (隐式) |

**(无 Body 输入参数)**

**示例 (Python)：**

```python
import requests
import json

branch_to_disable = "your_branch_id_to_disable"
url = f"https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/workflow_meta/branch/{branch_to_disable}/disable"
headers = {
    "moi-key": "xxxxx"
}
response = requests.put(url, headers=headers)
print(response.status_code)
if response.content:
    try:
        # Disable 通常返回更新后的分支详情或父工作流详情
        print(json.dumps(response.json(), indent=4, ensure_ascii=False))
    except json.JSONDecodeError:
        print(response.text)
```

**返回 (`MOIResponse_WorkflowDetailResponse_`)：**
成功禁用后，通常返回该分支所属的父工作流的详细信息 (`WorkflowDetailResponse`)，其中该分支的状态会更新。

```json
{
    "code": "ok",
    "msg": "ok",
    "data": { // WorkflowDetailResponse 结构
        "id": "parent_workflow_uuid",
        // ... (父工作流的详细信息) ...
        "branches": [
            {
                "branch_id": "your_branch_id_to_disable",
                "branch_name": "disabled-branch-name",
                "branch_status": 1, // 示例：状态变为禁用/非活跃
                // ...other 分支详情...
            }
            // ...other 分支列表...
        ]
    }
}
```

## 作业

### 创建作业

```
POST /byoa/api/v1/workflow_job
```

**路径参数：**
(无)

**Query 参数：**
(无)

**Header 参数：**

| 参数名         | 类型   | 是否必填 | 描述                    | 默认值 |
| -------------- | ------ | -------- | ----------------------- | ------ |
| `user-id`      | string | 是       | 用户 ID                  |        |
| `Access-Token` | string | 是       | 鉴权 Token (隐式要求)    |        |
| `uid`          | string | 是       | 用户登录 UID (隐式要求) |        |
| `Content-Type` | string | 是       | `application/json`      |        |

**Body 输入参数 (`JobCreateRequest`)：**

| 参数               | 是否必填 | 类型                       | 含义                                                         | 默认值 |
| ------------------ | -------- | -------------------------- | ------------------------------------------------------------ | ------ |
| name               | 是       | string                     | 作业名称                                                     |        |
| workflow_meta_id   | 是       | string                     | 工作流元数据 ID (父工作流的 ID)                                |        |
| workflow_branch_id | 是       | string                     | 工作流分支 ID (如果基于主工作流，可能与 meta_id 相同或特定分支 ID) |        |
| target_volume_id   | 是       | string                     | 目标数据卷 ID (作业产生的数据将写入此卷)                      |        |
| files              | 否       | array[object (`FileItem`)] | 要处理的文件列表。如果为空，则按工作流配置处理               | []     |

* **`FileItem` 对象结构:** (参考 `workflow.openapi.json` -> components.schemas.FileItem)

  | 参数             | 是否必填 | 类型                      | 含义            |
  | ---------------- | -------- | ------------------------- | --------------- |
  | file_name        | 是       | string                    | 文件名          |
  | file_type        | 是       | integer (`FileType` enum) | 文件类型        |
  | file_size        | 是       | integer                   | 文件大小 (bytes) |
  | file_path        | 是       | string                    | 文件路径        |
  | source_volume_id | 是       | integer                   | 源数据卷 ID      |
  | source_file_id   | 是       | integer                   | 源文件 ID        |

**Body 示例 (`JobCreateRequest`)：**

```json
{
    "name": "Sample Job",
    "workflow_meta_id": "ff5d119a-4e94-4968-ac0c-6ef64fcabb6c",
    "workflow_branch_id": "main",
    "target_volume_id": "eb42f0a1-ab18-4010-b95c-cd1716dd5e95",
    "files": [
        {
            "file_name": "sample_file1.pdf",
            "file_type": 2,
            "file_size": 123456,
            "file_path": "/path/to/sample_file1.pdf",
            "source_volume_id": 1889223879880048640,
            "source_file_id": 1
        },
        {
            "file_name": "sample_file2.pdf",
            "file_type": 2,
            "file_size": 123456,
            "file_path": "/path/to/sample_file2.pdf",
            "source_volume_id": 1889223879880048640,
            "source_file_id": 2
        }
    ]
}
```

**返回 (`NoneDataResp`)：**

```json
{
    "code": "ok",
    "msg": "ok",
    "data": null
}
```

### 查看作业列表

```
GET /byoa/api/v1/workflow_job
```

**描述：**获取符合条件的工作流作业列表。

**路径参数：**
(无)

**Query 参数：**

| 参数名        | 类型                                  | 是否必填 | 描述                          | 默认值       |
| ------------- | ------------------------------------- | -------- | ----------------------------- | ------------ |
| `name_search` | string, nullable                      | 否       | 名称搜索 (作业名)             |              |
| `start_time`  | integer, nullable                     | 否       | 开始时间戳 (毫秒)             |              |
| `end_time`    | integer, nullable                     | 否       | 结束时间戳 (毫秒)             |              |
| `status`      | array[integer], nullable              | 否       | 状态 (例如：1-运行中，2-完成) |              |
| `file_types`  | array[integer], nullable              | 否       | 文件类型                      |              |
| `priority`    | array[integer], nullable              | 否       | 优先级                        |              |
| `creator`     | string, nullable                      | 否       | 创建者                        |              |
| `offset`      | integer, >=0                          | 否       | 当页偏移量                    | 0            |
| `limit`       | integer, >=1                          | 否       | 每页大小                      | 20           |
| `sort_field`  | string, nullable                      | 否       | 排序字段                      | "created_at" |
| `sort_order`  | string, nullable ("ascend"/"descend") | 否       | 排序方式                      | "descend"    |

**Header 参数：**

| 参数名         | 类型   | 是否必填 | 描述         |
| -------------- | ------ | -------- | ------------ |
| `user-id`      | string | 是       | 用户 ID       |
| `Access-Token` | string | 是       | 鉴权 Token    |
| `uid`          | string | 是       | 用户登录 UID |

**示例 (Python)：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/workflow_job"
headers = {
    "moi-key": "xxxxx"
}
params = {
    "limit": 5,
    "sort_field": "name",
    "sort_order": "ascend"
}

response = requests.get(url, headers=headers, params=params)

print(response.status_code)
print(json.dumps(response.json(), indent=4, ensure_ascii=False))
```

**返回 (`MOIResponse_JobListResponse_`)：**

```json
{
    "code": "ok",
    "msg": "ok",
    "data": {
        "total": 20,
        "jobs": [
            {
                "id": "job_uuid_1",
                "name": "Alpha Job",
                "created_at": 1739377287000,
                "creator": "admin_user",
                "updated_at": 1739377755000,
                "modifier": "admin_user",
                "status": 2,
                "version": "1.0",
                "workflow_meta_id": "ff5d119a-4e94-4968-ac0c-6ef64fcabb6c",
                "workflow_branch_id": "main"
            }
        ]
    }
}
```

**输出参数 (`MOIResponse_JobListResponse_` 的 `data` 部分 - `JobListResponse`)：**

| 参数    | 类型                               | 描述                                       |
| ------- | ---------------------------------- | ------------------------------------------ |
| `total` | integer                            | 符合条件的工作流作业总数                   |
| `jobs`  | array[object] (`JobListItem` 结构) | 作业列表，每个对象包含作业及其主要分支信息 |

* **`JobListItem` 对象结构:** (参考 `workflow.openapi.json` components.schemas.JobListItem)
    * `id` (string): 作业 ID
    * `name` (string): 作业名称
    * `created_at` (integer): 创建时间戳 (毫秒)
    * `creator` (string): 创建者
    * `updated_at` (integer): 更新时间戳 (毫秒)
    * `modifier` (string, nullable): 更新者
    * `status` (integer): 状态
    * `version` (string, nullable): 版本号
    * `workflow_meta_id` (string): 工作流元数据 ID
    * `workflow_branch_id` (string): 工作流分支 ID

### 查看作业详情

```
GET /byoa/api/v1/workflow_job/{job_id}
```

**描述：**获取指定作业的详细信息。

**路径参数：**

| 参数名   | 类型   | 是否必填 | 描述   |
| -------- | ------ | -------- | ------ |
| `job_id` | string | 是       | 作业 ID |

**Header 参数：**

| 参数名         | 类型   | 是否必填 | 描述         |
| -------------- | ------ | -------- | ------------ |
| `user-id`      | string | 是       | 用户 ID       |
| `Access-Token` | string | 是       | 鉴权 Token    |
| `uid`          | string | 是       | 用户登录 UID |

**示例 (Python)：**

```python
import requests
import json

job_to_get = "YOUR_JOB_ID"
url = f"https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/workflow_job/{job_to_get}"
headers = {
    "moi-key": "xxxxx"
}
response = requests.get(url, headers=headers)

print(response.status_code)
print(json.dumps(response.json(), indent=4, ensure_ascii=False))
```

**返回 (`MOIResponse_JobDetailResponse_`)：**

```json
{
    "code": "ok",
    "msg": "ok",
    "data": {
        "id": "YOUR_JOB_ID",
        "name": "Detailed Job Test",
        "created_at": 1739435482000,
        "creator": "admin",
        "updated_at": 1739436347000,
        "modifier": "admin",
        "status": 1,
        "version": "1.2",
        "workflow_meta_id": "ff5d119a-4e94-4968-ac0c-6ef64fcabb6c",
        "workflow_branch_id": "main",
        "files": [
            {
                "file_name": "sample_file1.pdf",
                "file_type": 2,
                "file_size": 123456,
                "file_path": "/path/to/sample_file1.pdf",
                "source_volume_id": 1889223879880048640,
                "source_file_id": 1
            }
        ]
    }
}
```

**输出参数 (`MOIResponse_JobDetailResponse_` 的 `data` 部分 - `JobDetailResponse`)：**

* **`JobDetailResponse` 对象结构:** (参考 `workflow.openapi.json` components.schemas.JobDetailResponse)
    * `id` (string): 作业 ID
    * `name` (string): 作业名称
    * `created_at` (integer): 创建时间戳 (毫秒)
    * `creator` (string): 创建者
    * `updated_at` (integer): 更新时间戳 (毫秒)
    * `modifier` (string): 更新者
    * `status` (integer): 状态
    * `version` (string): 版本号
    * `workflow_meta_id` (string): 工作流元数据 ID
    * `workflow_branch_id` (string): 工作流分支 ID
    * `files` (array[object] (`FileItem` 结构)): 作业相关的文件列表

* **`FileItem` 对象结构:** (参考 `workflow.openapi.json` -> components.schemas.FileItem)
    * `file_name` (string): 文件名
    * `file_type` (integer): 文件类型
    * `file_size` (integer): 文件大小 (bytes)
    * `file_path` (string): 文件路径
    * `source_volume_id` (integer): 源数据卷 ID
    * `source_file_id` (integer): 源文件 ID

### 查看作业文件列表

```
GET /byoa/api/v1/workflow_job/{job_id}/files
```

**路径参数：**

| 参数名   | 类型   | 是否必填 | 描述   |
| -------- | ------ | -------- | ------ |
| `job_id` | string | 是       | 作业 ID |

**Query 参数：**

| 参数名             | 类型                                  | 是否必填 | 描述                          | 默认值       |
| ------------------ | ------------------------------------- | -------- | ----------------------------- | ------------ |
| `file_name_search` | string, nullable                      | 否       | 文件名搜索                    |              |
| `file_types`       | array[integer], nullable              | 否       | 文件类型 (见 `FileType` 枚举) |              |
| `status`           | array[integer], nullable              | 否       | 文件处理状态                  |              |
| `sort_field`       | string, nullable                      | 否       | 排序字段                      | "created_at" |
| `sort_order`       | string, nullable ("ascend"/"descend") | 否       | 排序方式                      | "descend"    |
| `offset`           | integer, >=0                          | 否       | 当页偏移量                    | 0            |
| `limit`            | integer, >=1                          | 否       | 每页大小                      | 20           |

**Header 参数：**

| 参数名         | 类型   | 是否必填 | 描述         |
| -------------- | ------ | -------- | ------------ |
| `user-id`      | string | 是       | 用户 ID       |
| `Access-Token` | string | 是       | 鉴权 Token    |
| `uid`          | string | 是       | 用户登录 UID |

**示例 (Python)：**

```python
import requests
import json

job_id_for_files = "your_job_id"
url = f"https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/workflow_job/{job_id_for_files}/files"

headers = {
    "moi-key": "xxxxx"
}
params = {
    "limit": 10,
    "file_name_search": ".pdf"
}

response = requests.get(url, headers=headers, params=params)

print(response.status_code)
if response.content:
    try:
        print(json.dumps(response.json(), indent=4, ensure_ascii=False))
    except json.JSONDecodeError:
        print(response.text)
```

**返回 (`MOIResponse_JobListFileResponse_`)：**

```json
{
    "code": "ok",
    "msg": "ok",
    "data": {
        "total": 5,
        "files": [
            {
                "id": "file_item_uuid_1",
                "name": "document_part_1.pdf",
                "type": 2,
                "size": 102400,
                "status": 3,
                "created_at": 1739380000000,
                "updated_at": 1739380050000,
                "path": "/target_volume/processed_files/document_part_1.pdf",
                "volume_id": "target_volume_uuid",
                "job_id": "your_job_id",
                "meta_id": "parent_workflow_meta_id",
                "branch_id": "workflow_branch_id"
            }
        ]
    }
}
```

**输出参数 (`MOIResponse_JobListFileResponse_` 的 `data` 部分 - `JobListFileResponse`)：**

| 参数    | 类型                               | 描述               |
| ------- | ---------------------------------- | ------------------ |
| `total` | integer                            | 符合条件的文件总数 |
| `files` | array[object] (`JobFileItem` 结构) | 作业相关的文件列表 |

* **`JobFileItem` 对象结构:** (参考 `workflow.openapi.json` components.schemas.JobFileItem)
    * `id` (string): 文件项 ID
    * `name` (string): 文件名
    * `type` (integer): 文件类型 (`FileType` 枚举)
    * `size` (integer): 文件大小 (bytes)
    * `status` (integer): 文件处理状态
    * `created_at` (integer): 创建时间戳 (毫秒)
    * `updated_at` (integer): 更新时间戳 (毫秒)
    * `path` (string, nullable): 文件在目标数据卷中的路径
    * `volume_id` (string, nullable): 文件所在的目标数据卷 ID
    * `job_id` (string): 关联的作业 ID
    * `meta_id` (string, nullable): 关联的工作流元数据 ID
    * `branch_id` (string, nullable): 关联的工作流分支 ID

### 重试处理作业文件

```
POST /byoa/api/v1/workflow_job/{job_id}/files
```

**描述：**删除指定作业关联的特定文件记录。

**路径参数：**

| 参数名   | 类型   | 是否必填 | 描述   |
| -------- | ------ | -------- | ------ |
| `job_id` | string | 是       | 作业 ID |

**Query 参数：**

| 参数名     | 类型          | 是否必填 | 描述                                     | 默认值 |
| ---------- | ------------- | -------- | ---------------------------------------- | ------ |
| `file_ids` | array[string] | 是       | 要重试的文件 ID 列表 (指 `JobFileItem.id`) |        |

**Header 参数：**

| 参数名         | 类型   | 是否必填 | 描述         |
| -------------- | ------ | -------- | ------------ |
| `user-id`      | string | 是       | 用户 ID       |
| `Access-Token` | string | 是       | 鉴权 Token    |
| `uid`          | string | 是       | 用户登录 UID |

**(无 Body 输入参数)**

**示例 (Python)：**

```python
import requests
import json

job_id_for_file_retry = "your_job_id"
file_ids_to_retry = ["file_item_uuid_1", "file_item_uuid_2"]

url = f"https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/workflow_job/{job_id_for_file_retry}/files"

headers = {
    "moi-key": "xxxxx"
}

params = {
    "file_ids": file_ids_to_retry, 
    "delete_data": True
}

response = requests.post(url, headers=headers, params=params)

print(response.status_code)
if response.content and response.text.strip():
    try:
        print(json.dumps(response.json(), indent=4, ensure_ascii=False))
    except json.JSONDecodeError:
        print(f"Response Text: {response.text}")
else:
    print("Request successful, no content returned or empty response.")
```

**返回 (`NoneDataResp`)：**

```json
{
    "code": "ok",
    "msg": "ok",
    "data": "string"
}
```

### 获取作业状态

```
GET /byoa/api/v1/workflow_job/{job_id}/status
```

**描述：**获取指定作业的当前状态。

**路径参数：**

| 参数名   | 类型   | 是否必填 | 描述   |
| -------- | ------ | -------- | ------ |
| `job_id` | string | 是       | 作业 ID |

**(无 Query 参数)**

**Header 参数：**

| 参数名         | 类型   | 是否必填 | 描述         |
| -------------- | ------ | -------- | ------------ |
| `user-id`      | string | 是       | 用户 ID       |
| `Access-Token` | string | 是       | 鉴权 Token    |
| `uid`          | string | 是       | 用户登录 UID |

**(无 Body 输入参数)**

**示例 (Python)：**

```python
import requests
import json

job_id_for_status = "your_job_id"
url = f"https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/workflow_job/{job_id_for_status}/status"

headers = {
    "moi-key": "xxxxx"
}

response = requests.get(url, headers=headers)

print(response.status_code)
if response.content:
    try:
        print(json.dumps(response.json(), indent=4, ensure_ascii=False))
    except json.JSONDecodeError:
        print(response.text)
```

**返回 (`MOIResponse_JobStatusResponse_`)：**

```json
{
    "code": "ok",
    "msg": "ok",
    "data": {
        "job_id": "your_job_id",
        "status": 2,
        "message": "Job completed successfully.",
        "progress": 100,
        "start_time": 1739377287000,
        "end_time": 1739377755000
    }
}
```

**输出参数 (`MOIResponse_JobStatusResponse_` 的 `data` 部分 - `JobStatusResponse`)：**

| 参数         | 类型              | 描述                                                         |
| ------------ | ----------------- | ------------------------------------------------------------ |
| `job_id`     | string            | 作业 ID                                                       |
| `status`     | integer           | 作业的当前状态 (参考 `workflow.openapi.json` JobStatus enum) |
| `message`    | string, nullable  | 状态相关的附加信息                                           |
| `progress`   | integer, nullable | 作业进度 (0-100)                                             |
| `start_time` | integer, nullable | 作业开始时间戳 (毫秒)                                        |
| `end_time`   | integer, nullable | 作业结束时间戳 (毫秒)                                        |