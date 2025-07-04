# 告警相关 API

## 通知接收者管理

### 创建通知接收者

```
POST /alerting/receiver
```

**输入参数：**

| 参数             | 是否必填 | 含义                                                      |
| --------------- | ------- | --------------------------------------------------------- |
| group_id        | 是      | 组 ID，应该为 org_id 或 workspace_id                        |
| name            | 是      | 接收者名称                                                 |
| notify_type     | 是      | 通知类型：0-邮件，1-短信，2-电话，3-企业微信                   |
| status          | 是      | 状态：0-禁用，1-启用                                        |
| email           | 否      | 邮箱地址（notify_type 为 0 时必填）                         |
| phone           | 否      | 电话号码（notify_type 为 1 或 2 时必填）                     |
| wecom_key       | 否      | 企业微信机器人密钥（notify_type 为 3 时必填）                 |
| comment         | 否      | 备注                                                      |

**输出参数：**

| 参数       | 含义        |
| ---------- | ----------- |
| id         | 接收者 ID     |

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/alerting/receiver"
headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "moi-key": "YOUR_MOI_KEY"
}

body = {
    "group_id": "YOUR_WORKSPACE_ID",
    "name": "邮件接收者",
    "notify_type": 0,
    "status": 1,
    "email": "user@example.com",
    "comment": "用于接收告警邮件"
}

response = requests.post(url, headers=headers, json=body)
print("Response:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

返回：

```json
{
    "code": "OK",
    "msg": "OK",
    "data": {
        "id": "receiver_id_12345"
    },
    "request_id": "req_12345"
}
```

### 获取接收者列表

```
POST /alerting/receiver/list
```

**输入参数：**

| 参数             | 是否必填 | 含义                                                      |
| --------------- | ------- | --------------------------------------------------------- |
| page            | 是      | 页码，从 1 开始                                            |
| page_size       | 是      | 每页大小                                                   |
| receiver_filter | 否      | 过滤条件                                                   |

**receiver_filter 参数：**

| 参数               | 是否必填 | 含义                                                      |
| ----------------- | ------- | --------------------------------------------------------- |
| group_ids         | 否      | 组 ID 列表                                                   |
| name_keyword      | 否      | 名称关键词                                                 |
| notify_types      | 否      | 通知类型列表                                               |
| statuses          | 否      | 状态列表                                                   |
| search_keyword    | 否      | 搜索关键词                                                 |

**输出参数：**

| 参数       | 含义           |
| ---------- | -------------- |
| receivers  | 接收者列表      |
| total      | 总数           |

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/alerting/receiver/list"
headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "moi-key": "YOUR_MOI_KEY"
}

body = {
    "page": 1,
    "page_size": 10,
    "receiver_filter": {
        "group_ids": ["YOUR_WORKSPACE_ID"],
        "statuses": [1]
    }
}

response = requests.post(url, headers=headers, json=body)
print("Response:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

### 获取单个接收者详情

```
GET /alerting/receiver?id={receiver_id}
```

**输入参数：**

| 参数 | 是否必填 | 含义     |
| ---- | ------- | -------- |
| id   | 是      | 接收者 ID  |

**输出参数：**

| 参数         | 含义           |
| ------------ | -------------- |
| id           | 接收者 ID       |
| name         | 接收者名称     |
| notify_type  | 通知类型       |
| status       | 状态           |
| email        | 邮箱地址       |
| phone        | 电话号码       |
| wecom_key    | 企业微信密钥   |
| comment      | 备注           |
| created_at   | 创建时间       |
| updated_at   | 更新时间       |

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/alerting/receiver"
headers = {
    "Accept": "application/json",
    "moi-key": "YOUR_MOI_KEY"
}

params = {
    "id": "receiver_id_12345"
}

response = requests.get(url, headers=headers, params=params)
print("Response:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

### 更新通知接收者

```
PUT /alerting/receiver
```

**输入参数：**

| 参数         | 是否必填 | 含义                                                      |
| ------------ | ------- | --------------------------------------------------------- |
| id           | 是      | 接收者 ID                                                   |
| name         | 否      | 接收者名称                                                 |
| notify_type  | 否      | 通知类型：0-邮件，1-短信，2-电话，3-企业微信                   |
| status       | 否      | 状态：0-禁用，1-启用                                        |
| email        | 否      | 邮箱地址                                                   |
| phone        | 否      | 电话号码                                                   |
| wecom_key    | 否      | 企业微信机器人密钥                                         |
| comment      | 否      | 备注                                                      |

**输出参数：**

| 参数 | 含义     |
| ---- | -------- |
| id   | 接收者 ID |

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/alerting/receiver"
headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "moi-key": "YOUR_MOI_KEY"
}

body = {
    "id": "receiver_id_12345",
    "name": "更新后的接收者名称",
    "status": 1,
    "comment": "更新后的备注"
}

response = requests.put(url, headers=headers, json=body)
print("Response:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

### 删除通知接收者

```
DELETE /alerting/receiver
```

**输入参数：**

| 参数 | 是否必填 | 含义     |
| ---- | ------- | -------- |
| id   | 是      | 接收者 ID |

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/alerting/receiver"
headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "moi-key": "YOUR_MOI_KEY"
}

body = {
    "id": "receiver_id_12345"
}

response = requests.delete(url, headers=headers, json=body)
print("Response:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

### 获取默认通知类型

```
POST /alerting/receiver/default_notify_types/list
```

**输出参数：**

| 参数          | 含义                                                      |
| ------------- | --------------------------------------------------------- |
| notify_types  | 支持的通知类型列表：0-邮件，1-短信，2-电话，3-企业微信       |

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/alerting/receiver/default_notify_types/list"
headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "moi-key": "YOUR_MOI_KEY"
}

response = requests.post(url, headers=headers)
print("Response:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

### 发送企业微信通知

```
POST /alerting/receiver/wecom/notify
```

**输入参数：**

| 参数            | 是否必填 | 含义                   |
| --------------- | ------- | ---------------------- |
| bottoken        | 是      | 企业微信机器人 Token    |
| notify_content  | 是      | 通知内容               |

**输出参数：**

| 参数           | 含义       |
| -------------- | ---------- |
| notify_result  | 通知结果   |

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/alerting/receiver/wecom/notify"
headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "moi-key": "YOUR_MOI_KEY"
}

body = {
    "bottoken": "YOUR_WECOM_BOT_TOKEN",
    "notify_content": "告警通知：系统出现异常，请及时处理。"
}

response = requests.post(url, headers=headers, json=body)
print("Response:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

## 告警规则管理

### 获取告警默认信息列表

```
POST /alerting/workspace/alert/default_info/list
```

**Header 参数：**

| 参数名         | 类型   | 是否必填 | 描述                        |
| -------------- | ------ | -------- | --------------------------- |
| `moi-key`      | string | 是       | MOI API 密钥                |

**输出参数：**

| 参数                | 含义                   |
| ------------------- | --------------------- |
| alert_default_infos | 告警默认信息列表       |

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/alerting/workspace/alert/default_info/list"
headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "moi-key": "YOUR_MOI_KEY"
}

response = requests.post(url, headers=headers, json={})
print("Response:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

### 创建告警规则

```
POST /alerting/workspace/alert/rule/create
```

**Header 参数：**

| 参数名         | 类型   | 是否必填 | 描述                        |
| -------------- | ------ | -------- | --------------------------- |
| `moi-key`      | string | 是       | MOI API 密钥                |

**输入参数：**

| 参数             | 是否必填 | 含义                                                      |
| --------------- | ------- | --------------------------------------------------------- |
| workspace_id    | 是      | 工作区 ID（工作区模式下必填）                                 |
| expression_id   | 是      | 表达式 ID                                                   |
| category        | 是      | 类别：metric 或 event                                       |
| level           | 是      | 告警级别                                                   |
| args            | 否      | 参数列表                                                   |
| receivers       | 否      | 接收者 ID 列表                                               |
| repeat_interval | 否      | 重复间隔                                                   |
| silence_rule    | 否      | 静默规则                                                   |

**输出参数：**

| 参数     | 含义     |
| -------- | -------- |
| alert_id | 告警 ID   |

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/alerting/workspace/alert/rule/create"
headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "moi-key": "YOUR_MOI_KEY"
}

body = {
    "workspace_id": "YOUR_WORKSPACE_ID",
    "expression_id": "expr_12345",
    "category": 1,
    "level": "critical",
    "args": [
        {
            "key": "threshold",
            "value": "80"
        }
    ],
    "receivers": ["receiver_id_12345"],
    "repeat_interval": 300,
    "silence_rule": {
        "enabled": false
    }
}

response = requests.post(url, headers=headers, json=body)
print("Response:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

### 获取告警规则列表

```
POST /alerting/workspace/alert/rule/list
```

**Header 参数：**

| 参数名         | 类型   | 是否必填 | 描述                        |
| -------------- | ------ | -------- | --------------------------- |
| `moi-key`      | string | 是       | MOI API 密钥                |

**输入参数：**

| 参数     | 是否必填 | 含义       |
| -------- | ------- | ---------- |
| filters  | 否      | 过滤条件   |
| limit    | 否      | 限制数量   |
| offset   | 否      | 偏移量     |
| sorter   | 否      | 排序条件   |

**输出参数：**

| 参数   | 含义       |
| ------ | ---------- |
| alerts | 告警列表   |
| total  | 总数       |

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/alerting/workspace/alert/rule/list"
headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "moi-key": "YOUR_MOI_KEY"
}

body = {
    "filters": {
        "workspace_id": "YOUR_WORKSPACE_ID"
    },
    "limit": 10,
    "offset": 0,
    "sorter": {
        "sort_by": "created_at",
        "is_desc": true
    }
}

response = requests.post(url, headers=headers, json=body)
print("Response:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

### 更新告警规则

```
POST /alerting/workspace/alert/rule/update
```

**Header 参数：**

| 参数名         | 类型   | 是否必填 | 描述                        |
| -------------- | ------ | -------- | --------------------------- |
| `moi-key`      | string | 是       | MOI API 密钥                |

**输入参数：**

| 参数             | 是否必填 | 含义                                                      |
| --------------- | ------- | --------------------------------------------------------- |
| alert_id        | 是      | 告警 ID                                                     |
| level           | 否      | 告警级别                                                   |
| args            | 否      | 参数列表                                                   |
| receivers       | 否      | 接收者 ID 列表                                               |
| repeat_interval | 否      | 重复间隔                                                   |
| silence_rule    | 否      | 静默规则                                                   |

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/alerting/workspace/alert/rule/update"
headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "moi-key": "YOUR_MOI_KEY"
}

body = {
    "alert_id": "alert_12345",
    "level": "warning",
    "args": [
        {
            "key": "threshold",
            "value": "90"
        }
    ],
    "receivers": ["receiver_id_12345", "receiver_id_67890"],
    "repeat_interval": 600
}

response = requests.post(url, headers=headers, json=body)
print("Response:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

### 删除告警规则

```
POST /alerting/workspace/alert/rule/delete
```

**Header 参数：**

| 参数名         | 类型   | 是否必填 | 描述                        |
| -------------- | ------ | -------- | --------------------------- |
| `moi-key`      | string | 是       | MOI API 密钥                |

**输入参数：**

| 参数     | 是否必填 | 含义   |
| -------- | ------- | ------ |
| alert_id | 是      | 告警 ID |

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/alerting/workspace/alert/rule/delete"
headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "moi-key": "YOUR_MOI_KEY"
}

body = {
    "alert_id": "alert_12345"
}

response = requests.post(url, headers=headers, json=body)
print("Response:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

## 错误码说明

| 错误码 | 描述           |
| ------ | -------------- |
| OK     | 成功           |
| 400    | 参数错误       |
| 401    | 认证失败       |
| 403    | 权限不足       |
| 404    | 资源不存在     |
| 409    | 资源冲突       |
| 500    | 服务器内部错误 |
