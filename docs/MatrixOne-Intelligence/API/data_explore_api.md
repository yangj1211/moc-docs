# 数据探索相关 API

## 原始数据卷

### 创建原始数据卷

```
POST /CreateOriginVolume
```

**输入参数：**
  
|  参数             | 是否必填 |含义|
|  --------------- | ----   | ----  |
| name             |是       | 原始数据卷名 |

**示例：**

```python
url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/CreateOriginVolume"

headers = {
    "user-id":"0194dfaa-3eda-7ea5-b47c-b4f4f5940e97",
    "Access-Token": "",
    "uid": "2de56399-0fda-4982-a26e-580fd666914d-0194dfaa-3eda-7ea5-b47c-b4f4f5940e97:admin:accountadmin"
}

body = {
    "name": "b_vol3"

}
response = requests.post(url, json=body, headers=headers)
# 检查响应状态
print(response.json())  # 打印返回的 JSON 数据
```

返回：

```bash
{'code': 'OK', 'msg': 'OK'}
```

### 查看原始数据卷列表

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
    "user-id":"0194dfaa-3eda-7ea5-b47c-b4f4f5940e97",
    "Access-Token": "xxxx",
    "uid": "ac8fd715-b39c-4edb-837b-e1ea1dae5f80-0194dfaa-3eda-7ea5-b47c-b4f4f5940e97:admin:accountadmin"
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
        "total": 5,
        "volumes": [
            {
                "id": "1889223879880048640",
                "name": "b-vol1",
                "size": 6787457,
                "file_num": 1,
                "owner": "admin",
                "created_at": 1739261047,
                "updated_at": 1739261047
            },
            {
                "id": "1889578498228068352",
                "name": "b-vol2",
                "size": 40724742,
                "file_num": 6,
                "owner": "admin",
                "created_at": 1739345595,
                "updated_at": 1739345595
            },
            {
                "id": "1889868565396619264",
                "name": "b_vol3",
                "size": 0,
                "file_num": 0,
                "owner": "admin",
                "created_at": 1739414752,
                "updated_at": 1739414752
            },
            {
                "id": "1889881472272465920",
                "name": "b_vol6",
                "size": 0,
                "file_num": 0,
                "owner": "admin",
                "created_at": 1739417829,
                "updated_at": 1739417829
            }
        ]
    }
}
```

### 查看某个原始数据卷（文件列表）

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
    "user-id":"0194dfaa-3eda-7ea5-b47c-b4f4f5940e97",
    "Access-Token": "xxxx",
    "uid": "badb5c26-e335-453d-85ad-7e996bcebff4-0194dfaa-3eda-7ea5-b47c-b4f4f5940e97:admin:accountadmin",
}

body={
        "id": "1889223879880048640"
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
                "id": "1889223944229060608",
                "name": "红楼梦(通行本)简体横排.pdf",
                "type": 2,
                "status": 5,
                "size": 6787457,
                "update_time": 1739261640,
                "other_metadata": "",
                "reason": "",
                "user": "admin",
                "start_time": 1739261063,
                "end_time": 1739261640,
                "path": "/b-vol1/红楼梦(通行本)简体横排.pdf"
            }
        ]
    }
}
```

### 下载某个原始数据卷中的文件

```
POST /GetOriginVolumeFileLink
```

**输入参数：**
  
|  参数             | 是否必填 |含义|
|  --------------- | ----   | ----  |
| volume_id        |是       | 原始数据卷 id|
| file_id          |是       | 文件 id|

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/GetOriginVolumeFileLink"
headers = {
    "user-id":"0194dfaa-3eda-7ea5-b47c-b4f4f5940e97",
    "Access-Token": "xxxx",
    "uid": "ac8fd715-b39c-4edb-837b-e1ea1dae5f80-0194dfaa-3eda-7ea5-b47c-b4f4f5940e97:admin:accountadmin"
}

body = {
    "volume_id": 1889223879880048640,
    "file_id": "1889578498228068352"

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
        "link": "https://moi-dev-test.oss-cn-hangzhou.aliyuncs.com/connector_path%2F0194dfaa-3eda-7ea5-b47c-b4f4f594xxxx%2Fb-vol2?Expires=173944xxxx&OSSAccessKeyId=LTAI5t6RX4TpSC8Z2v4nGG4Y&Signature=bCy60Or%2B%2Fr8Na1OcfMn%2Fy2jso6Y%3D"
    }
}
```

### 删除某个原始数据卷中的某个文件

```
POST /DeleteOriginVolumeFiles
```

**输入参数：**
  
|  参数             | 是否必填 |含义|
|  --------------- | ----   | ----  |
| volume_id        |是       | 原始数据卷 id|
| file_ids          |是       | 文件 id|

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/DeleteOriginVolumeFiles"

headers = {
    "user-id":"0194dfaa-3eda-7ea5-b47c-b4f4f5940e97",
    "Access-Token": "xxxx",
    "uid": "badb5c26-e335-453d-85ad-7e996bcebff4-0194dfaa-3eda-7ea5-b47c-b4f4f5940e97:admin:accountadmin",
}


body={
    "volume_id": "1889578498228068352",
    "file_ids": ["1889698920437940224"]
}


response = requests.post(url, headers=headers,json=body)

if response.status_code == 200:
    print(response.json())  
else:
    print(f"请求失败，状态码：{response.status_code}, 错误信息：{response.text}")
```

返回：

```
{'code': 'OK', 'msg': 'OK', 'data': {}}
```

## 处理数据卷

### 创建处理数据卷

```
POST /byoa/api/v1/explore/volumes
```

**输入参数：**
  
|  参数             | 是否必填 |含义|
|  --------------- | ----   | ----  |
| name            |是       | 处理数据卷名称 |

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/explore/volumes"

headers = {
    "user-id":"0194dfaa-3eda-7ea5-b47c-b4f4f5940e97",
    "Access-Token": "xxxx",
    "uid": "ac8fd715-b39c-4edb-837b-e1ea1dae5f80-0194dfaa-3eda-7ea5-b47c-b4f4f5940e97:admin:accountadmin"
}

body = {
    "name": "a_vol4"

}
response = requests.post(url, json=body, headers=headers)
print(response.json())
```

返回：

```bash
{'code': 'ok', 'msg': 'ok', 'data': {'id': 'fb93a6c1-6d1e-4d68-bb7c-4d84facda670', 'name': 'a_vol4', 'created_at': '2025-02-13T11:44:36', 'updated_at': '2025-02-13T11:44:36'}}
```

### 查看处理数据卷列表

```
GET /byoa/api/v1/explore/volumes
```

**输出参数：**
  
|  参数             | 含义 |
|  --------------- | ----  |
| name             | 卷名    |
| id               | 卷 id  |

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/explore/volumes"
headers = {
    "user-id":"0194dfaa-3eda-7ea5-b47c-b4f4f5940e97",
    "Access-Token": "xxxx",
    "uid": "badb5c26-e335-453d-85ad-7e996bcebff4-0194dfaa-3eda-7ea5-b47c-b4f4f5940e97:admin:accountadmin",
}

response = requests.get(url, headers=headers)
print("Response Body:", json.dumps(response.json(), indent=4, ensure_ascii=False))

```

返回：

```bash
Response Body: {
    "code": "ok",
    "msg": "ok",
    "data": {
        "total": 4,
        "volumes": [
            {
                "name": "a-vol1",
                "created_at": "2025-02-11T16:06:55",
                "updated_at": "2025-02-11T16:06:55",
                "user_id": "0194dfaa-3eda-7ea5-b47c-b4f4f5940e97",
                "id": "eb42f0a1-ab18-4010-b95c-cd1716dd5e95"
            },
            {
                "name": "a_vol4",
                "created_at": "2025-02-13T11:44:36",
                "updated_at": "2025-02-13T11:44:36",
                "user_id": "0194dfaa-3eda-7ea5-b47c-b4f4f5940e97",
                "id": "fb93a6c1-6d1e-4d68-bb7c-4d84facda670"
            }
        ]
    }
}
```

### 查看某个处理数据卷（文件列表）

```
POST /byoa/api/v1/explore/volumes/{volume_id}/files
```

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/explore/volumes/dbcc0d71-31f9-4799-b404-096f9e8e57f9/files"
headers = {
    "user-id":"0194dfaa-3eda-7ea5-b47c-b4f4f594xxxx",
    "Access-Token": "xxxx",
    "uid": "2868847d-660d-4ace-a7ca-b75c3be575ce-0194dfaa-3eda-7ea5-b47c-b4f4f594xxxx:admin:accountadmin",
}

response = requests.post(url, headers=headers)
print("Response Body:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

返回：

```
Response Body: {
    "code": "ok",
    "msg": "ok",
    "data": {
        "total": 3,
        "items": [
            {
                "id": "0194fb44-c44b-7713-b064-bff178ba30c3",
                "created_at": "2025-02-12T17:46:16.000000+0000",
                "updated_at": "2025-02-12T17:51:21.000000+0000",
                "user_id": "0194dfaa-3eda-7ea5-b47c-b4f4f5940e97",
                "source_volume_id": "1889223879880048640",
                "source_file_id": "1889223944229060608",
                "target_volume_id": "dbcc0d71-31f9-4799-b404-096f9e8e57f9",
                "file_name": "红楼梦(通行本)简体横排.pdf",
                "file_type": 2,
                "file_size": 6787457,
                "file_path": "0194dfaa-3eda-7ea5-b47c-b4f4f5940e97/b-vol1/1889223922712281088/红楼梦(通行本)简体横排.pdf",
                "file_status": 2,
                "workflow_id": "5775ecd6-5918-42a1-a92f-7245fe96b2bf",
                "job_id": "0194fb44-c44b-7708-aab6-c67e094d0352",
                "error_message": "",
                "duration": 300,
                "start_time": "2025-02-12T17:46:20.000000+0000",
                "end_time": "2025-02-12T17:51:21.000000+0000"
            },
            {
                "id": "0194fb23-cd65-7688-9f0e-b24de1947f9c",
                "created_at": "2025-02-12T17:10:15.000000+0000",
                "updated_at": "2025-02-12T17:15:21.000000+0000",
                "user_id": "0194dfaa-3eda-7ea5-b47c-b4f4f5940e97",
                "source_volume_id": "1889223879880048640",
                "source_file_id": "1889223944229060608",
                "target_volume_id": "dbcc0d71-31f9-4799-b404-096f9e8e57f9",
                "file_name": "红楼梦(通行本)简体横排.pdf",
                "file_type": 2,
                "file_size": 6787457,
                "file_path": "0194dfaa-3eda-7ea5-b47c-b4f4f5940e97/b-vol1/1889223922712281088/红楼梦(通行本)简体横排.pdf",
                "file_status": 2,
                "workflow_id": "729e7a03-652d-46e0-bdad-b05ec5b80cea",
                "job_id": "0194fb23-cd65-767c-b58f-db7c4456b896",
                "error_message": "",
                "duration": 300,
                "start_time": "2025-02-12T17:10:20.000000+0000",
                "end_time": "2025-02-12T17:15:21.000000+0000"
            },
            {
                "id": "0194fb28-61ae-7ab3-8446-a50669b8df87",
                "created_at": "2025-02-12T17:15:15.000000+0000",
                "updated_at": "2025-02-12T17:20:21.000000+0000",
                "user_id": "0194dfaa-3eda-7ea5-b47c-b4f4f5940e97",
                "source_volume_id": "1889223879880048640",
                "source_file_id": "1889223944229060608",
                "target_volume_id": "dbcc0d71-31f9-4799-b404-096f9e8e57f9",
                "file_name": "红楼梦(通行本)简体横排.pdf",
                "file_type": 2,
                "file_size": 6787457,
                "file_path": "0194dfaa-3eda-7ea5-b47c-b4f4f5940e97/b-vol1/1889223922712281088/红楼梦(通行本)简体横排.pdf",
                "file_status": 2,
                "workflow_id": "c6dcbad5-f85d-42b7-942c-2e8d3445a4e6",
                "job_id": "0194fb28-61ae-7aac-8500-a4c924a68211",
                "error_message": "",
                "duration": 300,
                "start_time": "2025-02-12T17:15:20.000000+0000",
                "end_time": "2025-02-12T17:20:21.000000+0000"
            }
        ]
    }
}
```

### 下载某个处理数据卷中的某个文件

```
GET /byoa/api/v1/explore/volumes/{volume_id}/files/{file_id}/raws
```

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/explore/volumes/eb42f0a1-ab18-4010-b95c-cd1716dd5e95/files/0194f41d-59d3-78ae-953d-7db134c83cab/raws"
headers = {
    "user-id":"0194dfaa-3eda-7ea5-b47c-b4f4f594xxxx",
    "Access-Token": "xxxx",
    "uid": "a8b83860-da1a-46cb-96a7-dd668fadc163-0194dfaa-3eda-7ea5-b47c-b4f4f594xxxx:admin:accountadmin"
}

response = requests.get(url, headers=headers)
print("Response Body:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

返回：

```
Response Body: {
    "total": 0,
    "items": []
}
```

### 查看某个处理数据卷中文件的解析内容

```
POST /byoa/api/v1/explore/volumes/{volume_id}/files/{filed_id}/blocks
```

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/explore/volumes/7399732a-3e43-4469-8abb-7a53b99efc22/files/0194fd65-e671-7e67-ba34-66967ba0fbf0/blocks"
headers = {
    "user-id":"0194e0c2-7e81-7040-ba44-f1d4f51axxxx",
    "Access-Token": "xxxx",
    "uid": "0401ffeb-592c-4472-bed4-fb4631c72688-0194e0c2-7e81-7040-ba44-f1d4f51axxxx:admin:accountadmin"
}

body = {
    "limit": 2
}

response = requests.post(url, headers=headers,json=body)
print("Response Body:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

返回：

```
Response Body: {
    "code": "ok",
    "msg": "ok",
    "data": {
        "total": 318,
        "items": [
            {
                "id": "000a9605-733f-4335-bc72-ac9aa8351e66",
                "content": "1. 数据接入与整合 a. Matrix Search 从后台管理系统接入产品图片和库存数据，并通过自动更新和API 接口实现数据的同步和实时更新。 b. 图片数据统一按单面类型进行管理，无型号字样，确保搜索结果的清晰准确性。 2. 搜索索引构建与优化 a. Matrix Search 利用Efficient Net 模型对上传的图片进行特征提取，生成高精度图像嵌入向量，构建图像检索索引。 b. 支持混合检索，通过结合语义检索（以文搜图）和向量检索（以图搜图），提升搜索准确性和结果的相关性。 3. 智能搜索功能实现 a. 用户通过小程序入口上传图片或输入文字进行产品搜索。 b. 系统调用Matrix Search 的搜索API 快速返回匹配的产品结果，同时支持按分类筛选和系列查询，帮助用户快速找到目标产品。 4. 库存查询与展示 a. 对搜索结果进行后台过滤分类后，小程序展示匹配的产品信息，包括名称、规格、图片、库存等。 b. 用户可直接查询产品库存情况，并进一步查看同系列其他产品，优化搜索体验。 # 客户收益  通过基于Matrix Search 的智能搜索平台，金意陶在产品检索和客户体验方面实现了显著提升：搜索效率提升 $90\\%$ ，销售能够快速找到符合需求的瓷砖产品。 $\\bullet$ 系统化的库存查询功能帮助销售团队优化库存管理，减少人工操作时间。 $\\bullet$ 基于图片特征的智能搜索功能显著提升了用户对产品选择的满意度，增强了品牌黏性。 $\\bullet$ 灵活的小程序入口简化了用户交互流程，为客户提供了随时随地的高效服务。 # 素问 TechAgent # 客户背景",
                "content_type": "text",
                "file_id": "0194fd65-e671-7e67-ba34-66967ba0fbf0",
                "created_at": "2025-02-13T03:45:02",
                "updated_at": "2025-02-13T03:45:02"
            },
            {
                "id": "08aaf135-f8ad-446c-9951-03e94777f608",
                "content": "![](/aaf889600825973f8e7e118d8b5e0c805d774aac8e2d96c2f005e0b9ee77bbad.jpg) 接下来我们会逐个分析其中每个关键环节的场景，数据加工的技术要求，以及MatrixOne Intelligence 解决方案中的产品能力如何匹配该环节的需求。 # 数据接入与整合 # 环节概述 前文已经详细描述过企业客户在面向GenAI 应用场景时，企业客户普遍面临新一轮的数据孤岛问题。各类数据源可能分布于不同的数据库（如关系型数据库、NoSQL 数据库）、文件系统（本地或云存储）、第三方SaaS 应用（如网盘、IM 工具）以及边缘设备等环境中。这些数据不仅物理位置分散，格式上也高度异构，涵盖结构化数据（如数据库表）、半结构化数据（如JSON、XML）以及非结构化数据（如PDF 文档、图像、视频、音频等）。 这种分散和多样化的数据形态带来了以下关键问题和需求： 1. 数据获取与整合复杂：数据分布在多个系统和位置，缺乏统一的接入和管理方式，导致数据整合工作量大且效率低下。 2. 非结构化数据处理压力：非结构化数据体量巨大（如视频和音频文件），完全采用中心化的接入方式会带来带宽瓶颈、高延迟和高成本问题。 3. 多模态数据标准化：数据格式不一致，解析和标准化过程繁琐，难以直接为AI 建模和应用提供支持。 4. 安全性与权限管理：跨部门或跨系统的数据访问需要精细化的权限控制，确保数据在接入和管理过程中的安全性和合规性。 因此，本环节的核心目标是解决数据的分散和异构性问题，构建一个支持多数据源统一接入、云边协同处理和分布式管理的架构。通过高效整合结构化、半结构化和非结构化数据，并提供灵活的权限控制和标准化处理能力，为后续的AI 建模和智能化应用奠定坚实的数据基础。",
                "content_type": "text",
                "file_id": "0194fd65-e671-7e67-ba34-66967ba0fbf0",
                "created_at": "2025-02-13T03:45:02",
                "updated_at": "2025-02-13T03:45:02"
            }
        ]
    }
}
```

### 删除某个处理数据卷中的某个文件的分段

```
DELETE /explore/volumes/{volume_id}/files/{filed_id}/blocks
```

**NOTE:** 此接口请求成功的状态码为 204。

**输出参数：**
  
|  参数             | 含义 |
| --------------- | ----  |
| ids             | block 的 id    |

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/explore/volumes/7399732a-3e43-4469-8abb-7a53b99efc22/files/0194fd65-e671-7e67-ba34-66967ba0fbf0/blocks"
headers = {
    "user-id": "0194e0c2-7e81-7040-ba44-f1d4f51axxxx",
    "Access-Token": "xxxx",
    "uid": "8fe335b4-2883-41b4-82eb-a17362504243-0194e0c2-7e81-7040-ba44-f1d4f51axxxx:admin:accountadmin",
}

body = {
    "ids": ["03e927d3-edbe-426c-835a-0f1e4fcc39b6"]
}

response = requests.delete(url, headers=headers, json=body)

if response.status_code == 204:
    print("请求成功，资源已删除")
else:
    print(f"请求失败，状态码：{response.status_code}, 错误信息：{response.text}")
```

返回：

```
请求成功，资源已删除
```
