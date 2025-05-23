# 鉴权相关 API

## 获取 token

```
POST /auth/login
```

**输入参数：**
  
|  参数             | 是否必填 |含义|
|  --------------- | ------- |----  |
| account_name     | 是      | 工作区 ID |
| username         | 是      | 管理员名称 |
| password         | 是      | 管理员密码 |

**输出参数：**
  
|  参数             | 含义 |
|  --------------- | ----  |
| uid              | user uuid      |
| Access-Token     | 鉴权码，有效期 15 分钟     |
| Refresh-Token    | 用于 Access-Token 过期后刷新    |

**示例：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/auth/login"
# 设置请求头
headers = {
    "Accept": "application/json, text/plain, */*",
    "Content-Type": "application/json"
}
body = {
    "account_name": "0194dfaa-3eda-7ea5-b47c-b4f4f594xxxx",
    "username": "xxxx",
    "password": "xxxx"
}

# 发送请求
response = requests.post(url, headers=headers, json=body)

# 打印响应头和内容（格式化 JSON）
print("Response Headers:", json.dumps(dict(response.headers), indent=4))
print("Response Body:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

返回：

```bash
Response Headers: {
    "Date": "Wed, 12 Feb 2025 03:38:36 GMT",
    "Content-Type": "application/json; charset=utf-8",
    "Content-Length": "178",
    "Connection": "keep-alive",
    "Access-Token": "xxxx",
    "Refresh-Token": "xxxx",
    "X-Request-Id": "e7d53eb7-80a2-4dc4-813f-8593aef9d9e1",
    "Set-Cookie": "SERVERID=d576c819bbc92dbf22dc5fdfd690d8a6|1739331516|1739331516;Path=/"
}
Response Body: {
    "code": "OK",
    "msg": "OK",
    "data": {
        "uid": "fa6467a6-bfcb-4df0-ac36-0e8dc56a124a-0194dfaa-3eda-7ea5-b47c-b4f4f594xxxx:admin:accountadmin",
        "login_at": "2025-02-12T03:38:36.566638078Z"
    }
}
```

在 Response Header 中获取 access-token 和 refresh-token，从返回结构体中获取 uid。Access-Token 有效期 15min，过期之前，需要调用下面 Refresh 接口，获取新的 Access-Token。后续请求中，Header 中带上 **Access-Token** 和 **uid**。

## 刷新 token

在 Access-Token 过期之前，请求中带上 Access-Token，Refresh-Token 和 Uid，新的 Access-Token，Refresh-Token 会在 Response Header 中返回

```
POST auth/refresh
```

**示例：**

其中，accsee-token、refresh-token 和 uid 在**获取 token** 步骤返回。

```python
import requests
import json
# API URL
url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/auth/refresh"

# 请求头
headers = {
    "Accept": "application/json, text/plain, */*",
    "Content-Type": "application/json",
    "Access-Token": "xxxx",
    "Refresh-Token": "xxxx",
    "uid": "fa6467a6-bfcb-4df0-ac36-0e8dc56a124a-0194dfaa-3eda-7ea5-b47c-b4f4f594xxxx:admin:accountadmin"
}

# 请求体（Body JSON）
body = {
    "type": "user"
}

# 发送请求
response = requests.post(url, headers=headers, json=body)

# 打印响应头和内容（格式化 JSON）
print("Response Headers:", json.dumps(dict(response.headers), indent=4))
print("Response Body:", json.dumps(response.json(), indent=4, ensure_ascii=False))
```

返回：

```bash
Response Headers: {
    "Date": "Wed, 12 Feb 2025 03:40:45 GMT",
    "Content-Type": "application/json; charset=utf-8",
    "Content-Length": "24",
    "Connection": "keep-alive",
    "Access-Token": "xxxx",
    "X-Request-Id": "82897e92-d37d-48fe-8b05-581705987651",
    "Set-Cookie": "SERVERID=39529de3c161baaf8e06ec55d8dc5e95|1739331644|1739331644;Path=/"
}
Response Body: {
    "code": "OK",
    "msg": "OK"
}
```
