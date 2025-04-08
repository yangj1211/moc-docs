# 数据接入相关 API

## 连接器

### 创建连接器

```
POST /conectors
```
  
**输入参数：**
  
|  参数             | 是否必填 |含义|
|  --------------- | ------- |----  |
| name             | 是      | 连接器名称|
| source_type      | 是      | 连接器类型，4 为 OSS，5 为标准 S3 |
| config           | 是      | 配置 oss 和 s3 的连接信息，如果是 oss 需填写 endpoint、access_key_id、access_key_secret、bucket_name，如果是 s3 除了 oss 中的参数还需填写 region 和 path_style（路径风格）信息。|

body：

```
{
    "name": "new_connector_name",
    "source_type": 4,
    "config": {
        "oss": { // 如果source_type为4，填此字段
            "endpoint": "example_oss_endpoint",
            "access_key_id": "example_access_key_id",
            "access_key_secret": "example_access_key_secret",
            "bucket_name": "example_bucket_name"
        },
        "s3": { // 如果source_type为5，填此字段
            "endpoint": "example_s3_endpoint",
            "access_key_id": "example_access_key_id",
            "access_key_secret": "example_access_key_secret",
            "bucket_name": "example_bucket_name",
            "region": "example_region",
            "path_style": true //路径风格，true为path style，false为virtual hoste
        }
    }
}
```

**示例：**

```python
import requests

url = "https://freetier-01.cn-hangzhou.cluster.cn-dev.matrixone.tech/connectors"  # 请替换为实际 API 地址
headers = {
    "user-id":"0194dfaa-3eda-7ea5-b47c-b4f4f594xxxx",
    "Access-Token": "xxxx",
    "uid": "91a2234e-0a06-4d84-815e-840e379d9e1c-0194dfaa-3eda-7ea5-b47c-b4f4f594xxxx:admin:accountadmin"
}

body = {
    "name": "oss-test2",  
    "source_type": 4, 
    "config": {
        "oss": {  
            "endpoint": "xxxx",
            "access_key_id": "xxxx",
            "access_key_secret": "xxxx",
            "bucket_name": "xxxx"
        }
    }
}

response = requests.post(url, json=body, headers=headers)

if response.status_code == 200:
    print(response.json()) 
else:
    print(f"请求失败，状态码：{response.status_code}, 错误信息：{response.text}")
```

返回：

```
{'code': 'OK', 'msg': 'OK'}
```

### 验证连接器

```
POST /connectors/validate
```

**输入参数：**
  
|  参数             | 是否必填 |含义|
|  --------------- | ------- |----  |
| source_type      | 是      | 连接器类型，4 为 OSS，5 为标准 S3 |
| connector_id     | 否      | 填写 connector_id 则无需填写 config 信息。|
| config           | 否      | 填写 config 则无需填写 connector_id 信息配置 oss 和 s3 的连接信息，如果是 oss 需填写 endpoint、access_key_id、access_key_secret、bucket_name，如果是 s3 除了 oss 中的参数还需填写 region 和 path_style 信息。 |

**示例：**

```python
import requests

url = "https://freetier-01.cn-hangzhou.cluster.cn-dev.matrixone.tech/connectors/validate"  
headers = {
    "user-id":"0194dfaa-3eda-7ea5-b47c-b4f4f594xxxx",
    "Access-Token": "xxxx",
    "uid": "2c5a7dc4-032a-42ac-b5ad-4db47f11772b-0194dfaa-3eda-7ea5-b47c-b4f4f594xxxx:admin:accountadmin"
}

body = {
    "source_type": 4,
    "config": {
        "oss": {
            "endpoint": "xxxx",
            "access_key_id": "xxxx",
            "access_key_secret": "xxxx",
            "bucket_name": "xxxx"
        }
    }
}

response = requests.post(url, json=body, headers=headers)

if response.status_code == 200:
    print(response.json())  
else:
    print(f"请求失败，状态码：{response.status_code}, 错误信息：{response.text}")
```

返回示例：

```
{'code': 'OK', 'msg': 'OK', 'data': {'valid': True}}
```

### 查询连接器

```
GET /connectors/list
```

**输出参数：**
  
|  参数             | 含义 |
|  --------------- | ----  |
| id               |connector-id       |
| source_type      | 连接器类型，4 为 OSS，5 为标准 S3     |
| name             | 连接器名称    |
| status           | 连接状态    |
| created_at       | 创建时间    |
| updated_at       | 更新时间    |
| username         | 创建人    |
| updated_at       | 更新时间    |
| username         | 创建人    |
| related_task_ids | 关联的 TaskID   |
| config           | 连接器配置信息    |
| total            | 返回数目    |

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.cn-dev.matrixone.tech/connectors/list" 
headers = {
    "user-id":"xxxx",
    "uid": "f42d1006-b48f-4b1d-bd44-3a18dd7bb8ec-0194dfaa-3eda-7ea5-b47c-b4f4f594xxxx:admin:accountadmin"
}


response = requests.get(url, headers=headers)

print("Response Body:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

返回：

```bash
Response Body: {
    "code": "OK",
    "msg": "OK",
    "data": {
        "connectors": [
            {
                "id": 100004,
                "source_type": 4,
                "name": "oss-test1",
                "status": "active",
                "created_at": 1738919558,
                "updated_at": 1738919558,
                "username": "admin",
                "related_task_ids": [
                    1889223922712281088
                ],
                "config": {
                    "oss": {
                        "endpoint": "xxxx",
                        "access_key_id": "xxxx",
                        "access_key_secret": "xxxx",
                        "bucket_name": "xxxx"
                    }
                }
            },
            {
                "id": 100005,
                "source_type": 5,
                "name": "s3-test",
                "status": "active",
                "created_at": 1738919761,
                "updated_at": 1738919761,
                "username": "admin",
                "related_task_ids": null,
                "config": {
                    "s3": {
                        "endpoint": "xxxx",
                        "access_key_id": "xxxx",
                        "access_key_secret": "xxxx",
                        "bucket_name": "xxxx",
                        "region": "xxxx"
                    }
                }
            }
        ],
        "total": 2
    }
}
```

### 更新连接器

```
PUT /connectors/{id}
```

**输入参数：**
  
|  参数             | 是否必填 |含义|
|  --------------- | ------- |----  |
| name             | 是      | 连接器名称 |
| config           | 是      | 连接器配置信息 |

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.cn-dev.matrixone.tech/connectors/100005"

headers = {
    "user-id":"0194dfaa-3eda-7ea5-b47c-b4f4f594xxxx",
    "Access-Token": "xxxx",
    "uid": "f42d1006-b48f-4b1d-bd44-3a18dd7bb8ec-0194dfaa-3eda-7ea5-b47c-b4f4f594xxxx:admin:accountadmin"
}

body = {
    "name": "s3-test1",  
    "config": {
                    "s3": {
                        "endpoint": "xxxx",
                        "access_key_id": "xxxx",
                        "access_key_secret": "xxxx",
                        "bucket_name": "xxxx",
                        "region": "xxxx"
                    }

}
}

response = requests.put(url, json=body, headers=headers)

if response.status_code == 200:
    print(response.json()) 
else:
    print(f"请求失败，状态码：{response.status_code}, 错误信息：{response.text}")
```

### 查询连接器源文件

```
GET /connectors/files/list
```

**输入参数：**
  
|  参数             | 是否必填 |含义|
|  --------------- | ------- |----  |
| connector_id     | 是      | 连接器 id |
| file_types       | 否      | 文件类型，0：空文件类型（可能作为默认或无效值）；1：TXT 文本文件类型；2：PDF 文档文件类型 3：图片文件类型；4：PPT 演示文稿文件类型；5：Word 文档文件类型；6：Markdown 标记语言文件类型；7：CSV 逗号分隔值文件类型；8：Parquet 列式存储文件类型；9：SQL 文件类型；10：目录类型|

**输出参数：**
  
|  参数             | 含义 |
|  --------------- | ----  |
| uri              |表示源连接器中的唯一资源定位符。      |
| filename         | 文件名称    |
| size             | 文件大小    |
| type             | 文件类型，0：空文件类型（可能作为默认或无效值）；1：TXT 文本文件类型；2：PDF 文档文件类型 3：图片文件类型；4：PPT 演示文稿文件类型；5：Word 文档文件类型；6：Markdown 标记语言文件类型；7：CSV 逗号分隔值文件类型；8：Parquet 列式存储文件类型；9：SQL 文件类型；10：目录类型。    |

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.cn-dev.matrixone.tech/connectors/files/list"

headers = {
    "user-id": "<your_workspace_id>",
    "Access-Token": "<your_access_token>",
    "uid": "<your_uid>",
}

params = {
    "connector_id": 100004,
    "file_types": 2
}

response = requests.get(url, headers=headers, params=params)

try:
    response_json = response.json()
    print("Response Body:", json.dumps(response_json, indent=4, ensure_ascii=False))
except json.JSONDecodeError:
    print("Response is not in JSON format:", response.text)
```

返回：

```bash
Response Body: {
    "code": "OK",
    "msg": "OK",
    "data": {
        "files": [
            {
                "uri": "红楼梦(通行本)简体横排.pdf",
                "filename": "红楼梦(通行本)简体横排.pdf",
                "size": 6787457,
                "type": 2
            },
            {
                "uri": "file1",
                "filename": "file1",
                "size": 0,
                "type": 10
            }
        ]
    }
}
```
  
## 数据载入

### 创建载入任务

```
POST /task
```

**输入参数：**
  
|  参数                    | 是否必填 |含义|
|  -----------------------| ------- |----  |
| source_connector_id     | 是      | 连接器名称 |
| volume_id               | 是      | 要载入的原始卷的的 id |
| source_config           | 是      | 为载入任务源配置 |
| common_file_task_config | 是      | 为通用文件配置 |
| load_mode_config        | 是      | 载入模式设置，interval 为载入周期，load_interval_type 表示载入周期单位和类型，0：未知的加载间隔类型，可作为默认的无效值）；1：按天进行加载，可能表示每天固定时间加载；2：按小时进行加载，可能表示每小时的某个固定时间加载 3：按分钟进行加载，可能表示每分钟的某个固定时刻加载；4：默认类型，仅加载一次。|
| uris                    | 是      | 要载入的文件 |
| config_type             | 是      | 表示通用文件载入配置类型，默认为 1 |

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.cn-dev.matrixone.tech/task" 
headers = {
    "user-id":"xxxx",
    "Access-Token": "xxxx",
    "uid": "f42d1006-b48f-4b1d-bd44-3a18dd7bb8ec-0194dfaa-3eda-7ea5-b47c-b4f4f594xxxx:admin:accountadmin"
}

body = {
    "source_connector_id":100004,
    "volume_id":"1889578498228068352",
    "source_config":
        {
            "common_file_task_config":
             {
                 "load_mode_config":
                  {
                      "load_interval_type":4
                   },
              "uris":["红楼梦 (通行本) 简体横排.pdf"]
             }
        },
    "config_type":1
}

response = requests.post(url, json=body, headers=headers)
print(response.json())  
```

返回：

```
{'code': 'OK', 'msg': 'OK'}
```

### 载入任务列表

```
GET /task/list
```

**输入参数：**
  
|  参数                    | 是否必填 |含义|
|  -----------------------| ------- |----  |
| is_desc               | 否      | 排序 |
| load_interval_types   | 否      | 载入间隔，0：未知间隔类型；1：按天；2：按小时；3：按分钟；4：仅执行一次 |
| order_by              | 否      | 为载入任务源配置 |
| page                  | 否      | 页码 |
| page_size             | 否      | 当页条数 |
| status                | 否     | 表示通用文件载入配置类型，默认为 1 |

**输出参数：**
  
|  参数                  | 含义 |
|  -------------------- | ----  |
| id                    |载入 id      |
| source_connector_id   | 连接器 id    |
| source_connector_type | 连接器类型    |
| volume_id             | 原始卷 id    |
| volume_name            |原始卷名称      |
| status                 | 载入任务状态，0：未知状态；1：正常执行中或可执行状态；2：正在暂停状态；3：已暂停状态；4：已完成状态。   |
| creator                | 创建人    |
| source_config          | 载入配置    |
| start_at               | 载入时间    |
| end_at                 | 结束时间    |
| created_at             | 创建时间    |
| updated_at             | 更新时间    |
| total                  | 返回数量    |

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.cn-dev.matrixone.tech/task/list" 

headers = {
    "user-id": "0194dfaa-3eda-7ea5-b47c-b4f4f594xxxx",
    "Access-Token": "xxxx",
    "uid": "cef0d7a2-1505-4384-a89d-5ee5b8246f95-0194dfaa-3eda-7ea5-b47c-b4f4f594xxxx:admin:accountadmin",
}

response = requests.get(url, headers=headers)

print("Response Body:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

返回：

```bash
Response Body: {
    "code": "OK",
    "msg": "OK",
    "data": {
        "tasks": [
            {
                "id": "1889223922712281088",
                "source_connector_id": 100004,
                "source_connector_type": 4,
                "volume_id": "1889223879880048640",
                "volume_name": "b-vol1",
                "name": "",
                "status": 4,
                "creator": "admin",
                "source_config": {
                    "common_file_task_config": {
                        "uris": [
                            "红楼梦(通行本)简体横排.pdf"
                        ],
                        "load_mode_config": {
                            "load_interval_type": 4,
                            "interval": 0
                        }
                    }
                },
                "start_at": 1739261063,
                "end_at": 1739261640,
                "created_at": 1739261057,
                "updated_at": 1739261640
            }
        ],
        "total": 1
    }
}
```

### 载入任务更新

```
POST /task/update
```

**输入参数：**
  
|  参数                    | 是否必填 |含义|
|  -----------------------| ------- |----  |
| task_id                 | 是      | 任务 id |
| load_mode_config        | 否      | 载入模式设置，interval 为载入周期，load_interval_type 表示载入周期单位和类型，0：未知的加载间隔类型，可作为默认的无效值）；1：按天进行加载，可能表示每天固定时间加载；2：按小时进行加载，可能表示每小时的某个固定时间加载 3：按分钟进行加载，可能表示每分钟的某个固定时刻加载；4：默认类型，仅加载一次。|
| uris                    | 否      | 载入文件 |

**示例：**

```python
import requests
import json
# API URL
url = "https://freetier-01.cn-hangzhou.cluster.cn-dev.matrixone.tech/task/update"  

headers = {
    "user-id":"0194dfaa-3eda-7ea5-b47c-b4f4f594xxxx",
    "Access-Token": "xxxx",
    "uid": "f42d1006-b48f-4b1d-bd44-3a18dd7bb8ec-0194dfaa-3eda-7ea5-b47c-b4f4f594xxxx:admin:accountadmin"
}

body = {
    "task_id":"1889698919578107904",
    "load_mode_config":{
                      "load_interval_type":4
                   },
              "uris":["红楼梦 (通行本) 简体横排.pdf"]
}

response = requests.post(url, json=body, headers=headers)
print(response.json()) 
```

返回：

```bash
{'code': 'OK', 'msg': 'OK'}
```

### 载入任务删除

```
POST /task/delete
```

**输入参数：**
  
|  参数         | 是否必填 |含义       |
| ------------ | ------- |---------  |
|  task_id     | 是       | 任务 id  |

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.cn-dev.matrixone.tech/task/delete/" 

headers = {
    "user-id": "0194dfaa-3eda-7ea5-b47c-b4f4f594xxxx",
    "Access-Token": "xxxx",
    "uid": "cef0d7a2-1505-4384-a89d-5ee5b8246f95-0194dfaa-3eda-7ea5-b47c-b4f4f594xxxx:admin:accountadmin",
}

body = {
    "task_id": "1234567890"
}

response = requests.post(url, headers=headers, json=body)

if response.status_code == 200:
    print(response.json()) 
else:
    print(f"请求失败，状态码：{response.status_code}, 错误信息：{response.text}")
```

返回：

```
{'code': 'OK', 'msg': 'OK'}
```

### 载入任务暂停

```
POST /task/pause
```

**输入参数：**
  
|  参数         | 是否必填 |含义       |
| ------------ | ------- |---------  |
|  task_id     | 是       | 任务 id  |

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.cn-dev.matrixone.tech/task/pause" 

headers = {
    "user-id": "0194dfaa-3eda-7ea5-b47c-b4f4f594xxxx",
    "Access-Token": "xxxx",
    "uid": "cef0d7a2-1505-4384-a89d-5ee5b8246f95-0194dfaa-3eda-7ea5-b47c-b4f4f594xxxx:admin:accountadmin",
}

body= {
    "task_id": "1889613340219121664"
}

response = requests.post(url, headers=headers, json=body)

if response.status_code == 200:
    print(response.json())  # 打印返回的 JSON 数据
else:
    print(f"请求失败，状态码：{response.status_code}, 错误信息：{response.text}")
```

返回：

```
{'code': 'OK', 'msg': 'OK'}
```

### 载入任务恢复

```
POST /task/resume
```

**输入参数：**
  
|  参数         | 是否必填 |含义       |
| ------------ | ------- |---------  |
|  task_id     | 是       | 任务 id  |

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.cn-dev.matrixone.tech/task/resume"  

headers = {
    "user-id": "0194dfaa-3eda-7ea5-b47c-b4f4f594xxxx",
    "Access-Token": "xxxx",
    "uid": "cef0d7a2-1505-4384-a89d-5ee5b8246f95-0194dfaa-3eda-7ea5-b47c-b4f4f594xxxx:admin:accountadmin",
}

data = {
    "task_id": "1889613340219121664"
}

response = requests.post(url, headers=headers, json=data)

if response.status_code == 200:
    print(response.json())  
else:
    print(f"请求失败，状态码：{response.status_code}, 错误信息：{response.text}")
```

返回：

```bash
{'code': 'OK', 'msg': 'OK'}
```

### 载入任务重试

```
POST /task/retry
```

**输入参数：**
  
|  参数         | 是否必填 |含义       |
| ------------ | ------- |---------  |
|  task_id     | 是       | 任务 id  |
|  ids         | 是       | 失败文件 id  |

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.cn-dev.matrixone.tech/task/retry"
headers = {
    "user-id":"0194e0c2-7e81-7040-ba44-f1d4f51axxxx",
    "Access-Token": "",
    "uid": "0401ffeb-592c-4472-bed4-fb4631c72688-0194e0c2-7e81-7040-ba44-f1d4f51axxxx:admin:accountadmin"
}

body = {
    "task_id": "1889074091616481280",
    "ids": ["1889074111245824000"]
}

response = requests.post(url, headers=headers,json=body)
print("Response Body:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

返回：

```bash
Response Body: {
    "code": "OK",
    "msg": "OK"
}
```

### 载入任务获取

```
GET /task/get
```

**输入参数：**
  
|  参数         | 是否必填 |含义       |
| ------------ | ------- |---------  |
|  task_id     | 是       | 任务 id  |

**输出参数：**
  
|  参数                  | 含义 |
|  -------------------- | ----  |
| id                     |载入 id      |
| source_connector_id    | 连接器 id    |
| source_connector_type  | 连接器类型    |
| volume_id              | 原始卷 id    |
| volume_name            |原始卷名称      |
| status                 | 载入任务状态，0：未知状态；1：正常执行中或可执行状态；2：正在暂停状态；3：已暂停状态；4：已完成状态。   |
| creator                | 创建人    |
| source_config          | 载入配置    |
| start_at               | 载入时间    |
| end_at                 | 结束时间    |
| created_at             | 创建时间    |
| updated_at             | 更新时间    |
| total                  | 返回数量    |

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.cn-dev.matrixone.tech/task/get?task_id=1889613340219121664"

headers = {
    "user-id": "0194dfaa-3eda-7ea5-b47c-b4f4f594xxxx",
    "Access-Token": "xxxx",
    "uid": "cef0d7a2-1505-4384-a89d-5ee5b8246f95-0194dfaa-3eda-7ea5-b47c-b4f4f594xxxx:admin:accountadmin",
}

response = requests.get(url, headers=headers)
print("Response Body:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

返回：

```bash
Response Body: {
    "code": "OK",
    "msg": "OK",
    "data": {
        "task": {
            "id": "1889613340219121664",
            "source_connector_id": 100004,
            "source_connector_type": 4,
            "volume_id": "1889578498228068352",
            "volume_name": "b-vol2",
            "name": "",
            "status": 4,
            "creator": "admin",
            "source_config": {
                "common_file_task_config": {
                    "uris": [
                        "红楼梦(通行本)简体横排.pdf"
                    ],
                    "load_mode_config": {
                        "load_interval_type": 4,
                        "interval": 0
                    }
                }
            },
            "start_at": 1739355480,
            "end_at": 1739355480,
            "created_at": 1739353902,
            "updated_at": 1739355480
        }
    }
}
```

### 获取载入任务下的文件

```
GET /task/files
```

**输入参数：**

|  参数         | 是否必填 |含义       |
| ------------ | ------- |---------  |
|  task_id     | 是       | 任务 id  |
|  status      | 否       | 文件载入状态，0：状态未知或未定义；1：等待中；2：正在上传；3：已暂停；4：失败；5：成功；6：正在重试。|
|  page        | 否       | 页码 |
|  page_size   | 否      | 当页展示最大文件数量 |

**输出参数：**
  
|  参数                  | 含义 |
|  -------------------- | ----  |
| id                     |载入 id      |
| name                  | 文件名称   |
| type                  | 文件类型    |
| status                | 文件载入状态    |
| size                  |文件大小      |
| update_time           | 更新时间   |
|user                   | 创建人    |
| start_at              | 载入时间    |
| end_at                | 结束时间    |

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.cn-dev.matrixone.tech/task/files?task_id=1889613340219121664"

headers = {
    "user-id": "0194dfaa-3eda-7ea5-b47c-b4f4f594xxxx",
    "Access-Token": "xxxx",
    "uid": "cef0d7a2-1505-4384-a89d-5ee5b8246f95-0194dfaa-3eda-7ea5-b47c-b4f4f594xxxx:admin:accountadmin",
}

params = {
    "task_id": 1889613340219121664
}

response = requests.get(url, headers=headers, params=params)

print("Response Body:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

返回：

```bash
Response Body: {
    "code": "OK",
    "msg": "OK",
    "data": {
        "total": 1,
        "total_success": 1,
        "total_failed": 0,
        "files": [
            {
                "id": "1889613341347389440",
                "name": "红楼梦(通行本)简体横排.pdf",
                "type": 2,
                "status": 5,
                "size": 6787457,
                "update_time": 1739353902,
                "other_metadata": "",
                "reason": "",
                "user": "admin",
                "start_time": 1739353902,
                "end_time": 0,
                "path": "/b-vol2/红楼梦(通行本)简体横排.pdf"
            }
        ]
    }
}
```
