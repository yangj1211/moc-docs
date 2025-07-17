# 数据处理相关 API

## 工作流

工作流是一套数据处理流程，由一些数据处理节点组成，每个节点是一个处理单元，这些节点组成一个 DAG 图。文档处理过程就是文档的数据按照这个 DAG 图进行处理和流转的过程。

一个工作流包含两部分重要内容：

* 节点：一个文档处理单元，输入是具体的文档，比如一个 pdf 文件，或者 pdf 文件分段后的结果（如以 800 个字符大小进行分段），输出是经过节点处理后的文档或者分段。
* 节点之间的连线：表示数据处理流向，将所有节点构成一个 DAG 图。如果 A 节点有一条指向 B 节点的连线，表示 A 节点的输出是 B 节点的输入。

### 创建工作流

```
POST /byoa/api/v1/workflow_meta
```

**Body 输入参数：**

| 参数名                      | 是否必填 | 类型                         | 含义                           | 默认值 |
| --------------------------- | -------- | ---------------------------- | ------------------------------ | ------ |
| **name**                      | 是       | string                       | 工作流名称                     |        |
| **source_volume_names**       | 是       | array[string]                | 源数据卷名称列表               |        |
| **source_volume_ids**         | 是       | array[String]               | 源数据卷 ID 列表                 |        |
| **file_types**                | 是       | array[integer]               | 文件类型列表，支持：<br>NIL = 0<br>TXT = 1<br>PDF = 2<br>IMAGE = 3<br>PPT = 4<br>WORD = 5<br>MARKDOWN = 6<br>CSV = 7<br>PARQUET = 8<br>SQL_FILES = 9<br>DIR = 10<br>DOCX = 11<br>PPTX = 12<br>WAV = 13<br>MP3 = 14<br>AAC = 15<br>FLAC = 16<br>MP4 = 17<br>MOV = 18<br>MKV = 19<br>PNG = 20<br>JPG = 21<br>JPEG = 22<br>BMP = 23                   |        |
| **process_mode**              | 是       | object (**ProcessModeConfig**) | 处理模式配置                   |        |
| **priority**                  | 否       | integer                      | 优先级                         | 300    |
| **target_volume_id**          | 是       | string                       | 目标数据卷 ID                   |        |
| **target_volume_name**        | 否       | string                       | 目标数据卷名称                 | ""     |
| **create_target_volume_name** | 是       | string                       | 创建目标数据卷时使用的名称     |        |
| **workflow**                  | 是       | object (**WorkflowConfig**)    | 工作流配置  |        |
| **branch_name**               | 否       | string                       | 分支名    | ""     |

* **ProcessModeConfig 结构：**

  | 参数       | 是否必填 | 类型    | 含义                   |
  | ---------- | -------- | ------- | ---------------------- |
  | **interval** | 是       | integer | 处理模式：0 表示一次性处理，-1 表示关联处理，大于 0 表示周期性处理且值为处理间隔（分钟） |
  | **offset**   | 是       | integer | 处理时间偏移量（分钟），一次性载入时默认为 0 |

* **WorkflowConfig 结构：**

  * **components**: 组件配置列表。每个组件对象包含 **name**, **type**, **component_id**, **intro**, **position**, **input_keys**, **output_keys**, **init_parameters**。
  * **connections**: 连接配置列表。每个连接对象包含 **sender** 和 **receiver**。
  * **edges**: 边配置列表。
  * **extra_components**: 额外组件配置列表。

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
    "source_volume_ids": ["1889223879880048640"],
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
                    "ascii_only": False,
                    "keep_id": False,
                    "remove_empty_lines": True,
                    "remove_extra_whitespaces": True,
                    "remove_regex": "([a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+)|https?://[^\\s]+",
                    "remove_repeated_substrings": False
                }
            },
            // ... (其他组件和连接)
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

**返回：**

```json
{
    "code": "ok",
    "msg": "ok",
    "data": {
        "created_at": "2025-05-30T09:45:58",
        "id": "cf68d259-9cd6-4f44-a0a4-5674c79da083",
        "user_id": "01960e07-60ec-7a3c-b45f-415b7e40e8bf",
        "flow_interval": 0,
        "creator": "admin",
        "file_types": "[1, 2, 4, 5, 6, 7, 11, 12]",
        "target_volume_id": "04614636-b858-4b13-99bf-a036d9351289",
        "files": "[]",
        "updated_at": "2025-05-30T09:45:58",
        "version": "1",
        "priority": 300,
        "name": "test",
        "group_id": "",
        "flow_offset": 0,
        "modifier": "admin",
        "source_volume_ids": "[\"1928383194482323456\"]",
        "source_volume_names": "[\"b_vol3\"]",
        "target_volume_name": "b_vol3"
    }
}
```

#### 添加自定义工作流组件

概括来讲，自定义处理节点就是添加一段自定义的 python 代码，对数据流中的文档进行处理。

下面将通过一个具体的例子说明如何自定节点。在目前数据处理工作流中，ImageCaptionToDocument 是对一张图片进行总结描述的节点，假设我们要在图片总结之后，加上我们的一个自定义的说明（如：`自定义 caption 说明`），可以通过下面步骤做到：

1\. **编写自定义 Python 代码**

   自定义 python 代码需要放在一个字符串中，并且使用 documents 作为局部变量，该自定义 python 代码最终会通过 python 的内置函数 exec 通过 `exec(code, {}, {"documents": documents})` 的方式执行。

   示例代码：

   ```python
   custom_caption = '''
   for doc in documents:
       if isinstance(doc.content, str) and len(doc.content) > 0:
           doc.content = doc.content + " add a suffix for each pic caption"
   '''
   ```

   其中 documents 的具体类型是 List[Document]，是一个文档按照特定大小分段后的列表。Document 的具体类型参考 [haystack Document 定义](https://github.com/deepset-ai/haystack/blob/f025501792a5870c062d1d0ecfb2bf2c27d1cfc1/haystack/dataclasses/document.py#L46)。

2\. **添加自定义组件配置**

   在创建工作流的 request 中添加自定义组件，配置路径为 `data -> workflow -> components`。components 是一个列表，自定义组件可以添加在列表的任何位置，与顺序无关。假设自定义组件的名称为 CustomCaptionComponent，并且引用第一步中的 custom_caption 代码。

   配置示例：

   ```json
   {
       "name": "CustomCaptionComponent",
       "type": "byoa.integrations.components.python_executor.PythonExecutor",
       "component_id": "CustomCaptionComponent_1748241281755",
       "intro": "CustomCaptionComponent",
       "position": {
           "x": 0,
           "y": 0
       },
       "input_keys": {},
       "output_keys": {},
       "init_parameters": {
           // 这里配置自定义 python 代码
           "python_code": custom_caption
       }
   }
   ```

   配置参数说明：

   * **name**: 自定义组件的名称，不可以与现有组件重名
   * **type**: 固定配置为 **byoa.integrations.components.python_executor.PythonExecutor**
   * **component_id**：唯一 id，格式与现有组件保持一致，如 **<name_id>**
   * **intro**: 对组件的说明，自定义
   * **position**: 目前配置为 **{"x": 0, "y": 0}** 即可
   * **input_keys**/**output_keys**: 保持为 **{}**
   * **init_parameters.python_code**: 配置第一步中编写的自定义 Python 代码

3\. **配置组件连线**

   将自定义组件添加到工作流中，需要修改 request 配置，在 connections 中添加连线。配置路径为 `data -> workflow -> connections`。connections 是一个列表，可添加在列表的任意位置，与顺序无关。

   例如，在原 workflow 中，如果 ImageCaptionToDocument 指向 DocumentSplitter-ImageOCR 节点（即按照特定字符长度对文档进行分割的节点），现在需要将 CustomCaptionComponent 添加到这两个节点之间。

   修改前：

   ```json
   {
       "receiver": "DocumentSplitter-ImageOCR.documents",
       "sender": "ImageCaptionToDocument.documents"
   }
   ```

   修改后：

   ```json
   {
       "receiver": "DocumentSplitter-ImageOCR.documents",
       "sender": "CustomCaptionComponent.documents"
   },
   {
       "receiver": "CustomCaptionComponent.documents",
       "sender": "ImageCaptionToDocument.documents"
   }
   ```

   连线配置说明：

   * **sender**: 连线的起始节点。以 **CustomCaptionComponent.documents** 为例：

     - CustomCaptionComponent 是组件名称

     - documents 是节点的输出，对于自定义组件，输出固定为 documents，具体类型是 List[Document]

   * **receiver**: 连线的目标节点。documents 是节点的输入，即将上游的 documents 输出作为下游的 documents 输入。

4\. **完成工作流创建**

   通过创建工作流请求 `byoa/api/v1/workflow_meta` 创建工作流。创建之后，用户可通过中间节点处理结果 api 进行查看和验证自定义节点的处理结果。

#### 工作流组件介绍

本节详细介绍工作流中可用的内置组件，包括它们的功能、初始化参数和运行方法规范。

<!-- 下面是数据处理过程的流程图：

![数据处理流程图](../images/data_processing_workflow.png) -->

**AudioToDocument**

**功能描述**：自定义的 Whisper 转录器，支持获取时间戳。

**参数结构示例**：

```json
{
    "name": "AudioToDocument",
    "type": "byoa.integrations.components.converters.audio_to_document.AudioToDocument",
    "component_id": "AudioToDocument_1749126721750",
    "intro": "AudioToDocument",
    "position": {
        "x": 0,
        "y": 0
    },
    "input_keys": {},
    "output_keys": {},
    "init_parameters": {
        "asr_model": "sensevoice-v1",
        "enable_noise_reduction": false,
        "enable_speaker_diarization": false,
        "max_segment_duration": 30,
        "min_silence_duration": 0.5
    },
    "extra_node_info": {
        "name": "音频解析节点",
        "description": ""
    }
}
```

**初始化参数**：

- **asr_model**: str（可选，默认值：'sensevoice-v1'）- ASR 模型名称
- **enable_noise_reduction**: bool（可选，默认值：False）- 是否启用噪音消除
- **enable_speaker_diarization**: bool（可选，默认值：False）- 是否启用说话人分离
- **max_segment_duration**: int（可选，默认值：30）- 最大分段时长（秒）
- **min_silence_duration**: float（可选，默认值：0.5）- 最小静音时长（秒）

**运行方法**

- 输入：
  - **sources**: List[Union[str, Path, ByteStream]]
  - **meta**: Optional[Union[Dict[str, Any], List[Dict[str, Any]]]]（可选）
- 输出：
  - **documents**: list[Document]

**EnhancedDOCXToDocument**

**功能描述**：增强版 DOCX 转 Document 组件。该组件扩展了 Haystack 的 DOCXToDocument 功能，增加了对文档中图片的处理能力，支持图片标注和 OCR 文本提取等功能。

**参数结构示例**：

```json
{
    "name": "DOCXToDocument",
    "type": "byoa.integrations.components.converters.enhanced_docx_to_document.EnhancedDOCXToDocument",
    "component_id": "DOCXToDocument_1749126721750",
    "intro": "DOCXToDocument",
    "position": {
        "x": 0,
        "y": 0
    },
    "input_keys": {},
    "output_keys": {},
    "init_parameters": {
        "image_process_types": ["caption", "ocr"]
    }
}
```

**初始化参数**：

- **image_process_types**: list[str]（可选，默认值：None）- 图片处理类型列表，支持 ["caption", "ocr"]

**运行方法**

- 输入：
  - **sources**: List[Union[str, Path, ByteStream]]
  - **meta**: Optional[Union[Dict[str, Any], List[Dict[str, Any]]]]（可选）
- 输出：
  - **documents**: List[Document]

**EnhancedPPTXToDocument**

**功能描述**：增强版 PPTX 转 Document 组件。该组件扩展了 Haystack 的 PPTXToDocument 功能，增加了对 PPT 中图片的处理能力，支持图片标注和 OCR 文本提取等功能。

**参数结构示例**：

```json
{
    "name": "PPTXToDocument",
    "type": "byoa.integrations.components.converters.enhanced_pptx_to_document.EnhancedPPTXToDocument",
    "component_id": "PPTXToDocument_1749126721750",
    "intro": "PPTXToDocument",
    "position": {
        "x": 0,
        "y": 0
    },
    "input_keys": {},
    "output_keys": {},
    "init_parameters": {
        "image_process_types": ["caption", "ocr"]
    }
}
```

**初始化参数**：

- **image_process_types**: list[str]（可选，默认值：None）- 图片处理类型列表，支持 ["caption", "ocr"]

**运行方法**

- 输入：
  - **sources**: List[Union[str, Path, ByteStream]]
  - **meta**: Optional[Union[Dict[str, Any], List[Dict[str, Any]]]]（可选）
- 输出：
  - **documents**: List[Document]

**EnhancedPlainToDocument**

**功能描述**：增强的纯文本 [txt, md] 转换为文档组件，支持将原文本上传至 OSS，不做格式转换。

**参数结构示例**：

```json
{
    "name": "PlainToDocument",
    "type": "byoa.integrations.components.converters.enhanced_plain_to_document.EnhancedPlainToDocument",
    "component_id": "PlainToDocument_1749126721750",
    "intro": "PlainToDocument",
    "position": {
        "x": 0,
        "y": 0
    },
    "input_keys": {},
    "output_keys": {},
    "init_parameters": {},
    "extra_node_info": {
        "name": "文档解析节点",
        "description": ""
    }
}
```

**初始化参数**：无

**运行方法**

- 输入：
  - **sources**: Variadic[List[Union[str, Path, ByteStream]]]
  - **meta**: Optional[Union[Dict[str, Any], List[Dict[str, Any]]]]（可选）
- 输出：
  - **documents**: List[Document]

**MagicPDFToDocument**

**功能描述**：将 PDF 转换为 Documents。

**参数结构示例**：

```json
{
    "name": "PDFToDocument",
    "type": "byoa.integrations.components.converters.magic_pdf_to_document.MagicPDFToDocument",
    "component_id": "PDFToDocument_1749126721750",
    "intro": "PDFToDocument",
    "position": {
        "x": 0,
        "y": 0
    },
    "input_keys": {},
    "output_keys": {},
    "init_parameters": {
        "image_process_types": ["caption", "ocr"]
    }
}
```

**初始化参数**：

- **image_process_types**: list[str]（可选，默认值：None）- 图片处理类型列表，支持 ["caption", "ocr"]

**运行方法**

- 输入：
  - **sources**: list[Union[str, Path, ByteStream]]
  - **meta**: Optional[Union[dict[str, Any], list[dict[str, Any]]]]（可选）
- 输出：
  - **documents**: list[Document]

- 使用示例：

```python
image_path = "/Users/lhq/Downloads/NVIDIA-2024-Annual-Report_Maximum.pdf-
3457698c0ee4273ea686d71475cac0fe191375e0edc447c39b9f4d9de5c4e155.jpg"
i2d = ImageToDocument()
result = i2d.run([image_path])
print(result)
# 'This is a text from the image file.'
```

**ImageCaptionToDocument**

**功能描述**：将图像文档转换为 Document 对象。使用多模态转换器从图像中获取标题。

**参数结构示例**：

```json
{
    "name": "ImageCaptionToDocument",
    "type": "byoa.integrations.components.converters.image_caption_to_document.ImageCaptionToDocument",
    "component_id": "ImageCaptionToDocument_1749126721751",
    "intro": "ImageCaptionToDocument",
    "position": {
        "x": 0,
        "y": 0
    },
    "input_keys": {},
    "output_keys": {},
    "init_parameters": {}
}
```

**初始化参数**：无

**运行方法**

- 输入：
  - **documents**: list[Document]
- 输出：
  - **documents**: list[Document]

- 使用示例：

```python
image_path = "/Users/lhq/Downloads/NVIDIA-2024-Annual-Report_Maximum.pdf-
3457698c0ee4273ea686d71475cac0fe191375e0edc447c39b9f4d9de5c4e155.jpg"
i2d = ImageToDocument()
result = i2d.run([image_path])
print(result)
# 'This is a text from the image file.
```

**ImageOCRToDocument**

**功能描述**：将图像文档转换为 Document 对象。使用多模态转换器从图像中获取文本 (OCR)。

**参数结构示例**：

```json
{
    "name": "ImageOCRToDocument",
    "type": "byoa.integrations.components.converters.image_ocr_to_document.ImageOCRToDocument",
    "component_id": "ImageOCRToDocument_1749126721751",
    "intro": "ImageOCRToDocument",
    "position": {
        "x": 0,
        "y": 0
    },
    "input_keys": {},
    "output_keys": {},
    "init_parameters": {
        "model": "stepfun-ai/GOT-OCR2_0",
        "tokenizer": "stepfun-ai/GOT-OCR2_0"
    }
}
```

**初始化参数**：

- **model**: str（可选，默认值：'stepfun-ai/GOT-OCR2_0'）- OCR 模型名称
- **tokenizer**: str（可选，默认值：'stepfun-ai/GOT-OCR2_0'）- 分词器名称

**运行方法**

- 输入：
  - **documents**: list[Document]
- 输出：
  - **documents**: list[Document]

- 使用示例：

```python
image_path = "/Users/lhq/Downloads/NVIDIA-2024-Annual-Report_Maximum.pdf-
3457698c0ee4273ea686d71475cac0fe191375e0edc447c39b9f4d9de5c4e155.jpg"
i2d = ImageToDocument()
result = i2d.run([image_path])
print(result)
# 'This is a text from the image file.'
```

**ImageToDocument**

**功能描述**：将图像文档转换为 Document 对象。使用多模态转换器从图像中获取标题。

**参数结构示例**：

```json
{
    "name": "ImageToDocument",
    "type": "byoa.integrations.components.converters.image_to_document.ImageToDocument",
    "component_id": "ImageToDocument_1749126721750",
    "intro": "ImageToDocument",
    "position": {
        "x": 0,
        "y": 0
    },
    "input_keys": {},
    "output_keys": {},
    "init_parameters": {
        "image_process_types": ["ocr", "caption"]
    },
    "extra_node_info": {
        "name": "图片解析节点",
        "description": ""
    }
}
```

**初始化参数**：

- **image_process_types**: list[str]（可选，默认值：['caption', 'ocr']）- 图片处理类型列表，支持 ["caption", "ocr"]

**运行方法**

- 输入：
  - **sources**: list[Union[str, Path, ByteStream]]
  - **meta**: Optional[Union[dict[str, Any], list[dict[str, Any]]]]（可选）
- 输出：
  - **documents**: list[Document]

- 使用示例：

```python
image_path = "/Users/lhq/Downloads/NVIDIA-2024-Annual-Report_Maximum.pdf-
3457698c0ee4273ea686d71475cac0fe191375e0edc447c39b9f4d9de5c4e155.jpg"
i2d = ImageToDocument()
result = i2d.run([image_path])
print(result)
# 'This is a text from the image file.'
```

**ImageGenerateQA**

**功能描述**：虚假的图片生成 QA 组件，实际使用匹配中的病历文字，依据几个样例 qa 对话，再次生成新的生成。

**初始化参数**：

- **api_key**: Optional[str]（可选）
- **model**: Optional[str]（可选）
- **api_base_url**: Optional[str]（可选）
- **system_prompt**: Optional[str]（可选）
- **user_prompt**: Optional[str]（可选）
- **generation_kwargs**: Optional[Dict[str, Any]]（可选）

**运行方法**

- 输入：
  - **documents**: List[Document]
  - **system_prompt**: Optional[str]（可选）
  - **user_prompt**: Optional[str]（可选）
  - **generation_kwargs**: Optional[Dict[str, Any]]（可选）
- 输出：
  - **documents**: List[Document]

- 使用示例：

```python
image_path = "/Users/lhq/Downloads/NVIDIA-2024-Annual-Report_Maximum.pdf-
3457698c0ee4273ea686d71475cac0fe191375e0edc447c39b9f4d9de5c4e155.jpg"
i2d = ImageGenerateQA()
result = i2d.run([image_path])
print(result)
# 'This is a text from the image file.'
```

**GenerateImageContentByLLM**

**功能描述**：使用视觉模型从图像生成结构化内容的组件。

**初始化参数**：

- **api_key**: Optional[str]（可选）
- **model**: Optional[str]（可选）
- **api_base_url**: Optional[str]（可选）
- **system_prompt**: Optional[str]（可选）
- **user_prompt**: Optional[str]（可选）
- **generation_kwargs**: Optional[Dict[str, Any]]（可选）

**运行方法**

- 输入：
  - **documents**: List[Document]
  - **system_prompt**: Optional[str]（可选）
  - **user_prompt**: Optional[str]（可选）
  - **generation_kwargs**: Optional[Dict[str, Any]]（可选）
- 输出：
  - **documents**: List[Document]

**ImageStructureOutput**

**功能描述**：将图像文档转换为 Document 对象。使用多模态转换器从图像中获取标题。

**初始化参数**：**image_process_types**: list[str]（可选，默认值：['caption', 'ocr']）

**运行方法**

- 输入：
  - **sources**: list[Union[str, Path, ByteStream]]
  - **meta**: Optional[Union[dict[str, Any], list[dict[str, Any]]]]（可选）
- 输出：
  - **documents**: list[Document]

- 使用示例：

```python
image_path = "/Users/lhq/Downloads/NVIDIA-2024-Annual-Report_Maximum.pdf-
3457698c0ee4273ea686d71475cac0fe191375e0edc447c39b9f4d9de5c4e155.jpg"
i2d = ImageStructureOutput()
result = i2d.run([image_path])
print(result)
# 'This is a text from the image file.'
```

**DocumentContentImageFiller**

**功能描述**：处理文档集合中的文本和图片关系，完成以下功能：

1. 识别文本中的图片引用

2. 将图片的 **md_page_number** 和 **split_id** 与引用它的文本保持一致

3. 为文档和图片分配统一的排序 ID

**参数结构示例**：

```json
{
    "name": "DocumentContentImageFiller",
    "type": "byoa.integrations.components.converters.document_content_image_filler.DocumentContentImageFiller",
    "component_id": "DocumentContentImageFiller_1749126721751",
    "intro": "DocumentContentImageFiller",
    "position": {
        "x": 0,
        "y": 0
    },
    "input_keys": {},
    "output_keys": {},
    "init_parameters": {}
}
```

**初始化参数**：无

**运行方法**

- 输入：
  - **documents**: List[Document]
- 输出：
  - **documents**: List[Document]

**EnhancedDocumentSplitter**

**功能描述**：拆分文档。

**参数结构示例**：

```json
{
    "name": "DocumentSplitter",
    "type": "byoa.integrations.components.enhance_document_splitter.EnhancedDocumentSplitter",
    "component_id": "DocumentSplitter_1749126721750",
    "intro": "DocumentSplitter",
    "position": {
        "x": 0,
        "y": 0
    },
    "input_keys": {},
    "output_keys": {},
    "init_parameters": {
        "split_unit": "char",
        "split_length": 800,
        "split_overlap": 0
    }
}
```

**初始化参数**：

- **split_length**: int（可选，默认值：800）- 分割长度
- **split_overlap**: int（可选，默认值：0）- 分割重叠长度
- **split_unit**: Literal ['word', 'char']（可选，默认值：'char'）- 分割单位，支持按词或字符

**运行方法**

- 输入：
  - **documents**: List[Document]
- 输出：
  - **documents**: List[Document]

**MoiDocumentCleaner**

**功能描述**：文档清理器。

**参数结构示例**：

```json
{
    "name": "DocumentCleaner",
    "type": "byoa.integrations.components.cleaner.moi_document_cleaner.MoiDocumentCleaner",
    "component_id": "DocumentCleaner_1749126721750",
    "intro": "DocumentCleaner",
    "position": {
        "x": 0,
        "y": 0
    },
    "input_keys": {},
    "output_keys": {},
    "init_parameters": {
        "switch_deduplication": false,
        "switch_special_char_filter": false,
        "switch_special_char_remove": false,
        "switch_text_standardization": false,
        "deduplication_by_md5": false,
        "deduplication_by_similarity": false,
        "deduplication_ngram_ratio": 0.5,
        "filter_special_char_ratio": 0.5,
        "remove_html_labels": false,
        "remove_invisible_char": false,
        "remove_persional_message": false,
        "remove_sensitive_words": false,
        "remove_url": false,
        "traditional_chinese_to_simple": false,
        "unicode_normalization": false
    },
    "extra_node_info": {
        "name": "数据清洗节点",
        "description": ""
    }
}
```

**初始化参数**：

- **unicode_normalization**: bool - 是否进行 Unicode 标准化
- **traditional_chinese_to_simple**: bool - 是否将繁体中文转换为简体中文
- **remove_url**: bool - 是否移除 URL
- **remove_invisible_char**: bool - 是否移除不可见字符
- **remove_html_labels**: bool - 是否移除 HTML 标签
- **deduplication_ngram_ratio**: float - N-gram 去重比率
- **deduplication_by_md5**: bool - 是否通过 MD5 去重
- **filter_special_char_ratio**: float - 特殊字符过滤比率
- **deduplication_by_similarity**: bool（可选，默认值：True）- 是否通过相似度去重
- **remove_persional_message**: bool（可选，默认值：True）- 是否移除个人信息
- **remove_sensitive_words**: bool（可选，默认值：True）- 是否移除敏感词
- **remove_poison_word**: bool（可选，默认值：True）- 是否移除有害词汇

**运行方法**

- 输入：
  - **documents**: List[Document]
- 输出：
  - **documents**: List[Document]

**DataAugmentation**

**功能描述**：根据指定参数增强数据。

**参数结构示例**：

```json
{
    "name": "DataAugmentation",
    "type": "byoa.integrations.components.data_augmentation.DataAugmentation",
    "component_id": "DataAugmentation_1749126721750",
    "intro": "DataAugmentation",
    "position": {
        "x": 0,
        "y": 0
    },
    "input_keys": {},
    "output_keys": {},
    "init_parameters": {
        "categories": null,
        "json_num_per_block": 10,
        "json_schema_str": {
            "instruction": "翻译成法语",
            "input": "Hello",
            "output": "Bonjour"
        },
        "keyword_count": 5,
        "type": "general",
        "use_document_count": 30
    },
    "extra_node_info": {
        "name": "数据增强节点",
        "description": ""
    }
}
```

**初始化参数**：

- **type**: str - 数据增强类型
- **json_schema_str**: str - JSON 模式字符串，定义增强数据的结构
- **json_num_per_block**: int（可选，默认值：10）- 每个块的 JSON 数量
- **use_document_count**: int（可选，默认值：30）- 使用的文档数量
- **categories**: list[str]（可选，默认值：None）- 类别列表
- **keyword_count**: int（可选，默认值：5）- 关键词数量

**运行方法**

- 输入：
  - **documents**: List[Document]
- 输出：
  - **documents**: List[Document]

**PythonExecutor**

**功能描述**：一个 Haystack 组件，用提供的参数执行 Python 代码。

**参数结构示例**：

```json
{
    "name": "PythonExecutor",
    "type": "byoa.integrations.components.python_executor.PythonExecutor",
    "component_id": "PythonExecutor_1749126721751",
    "intro": "PythonExecutor",
    "position": {
        "x": 0,
        "y": 0
    },
    "input_keys": {},
    "output_keys": {},
    "init_parameters": {
        "python_code": ""
    }
}
```

**初始化参数**：

- **python_code**: Optional[str]（可选）- 要执行的 Python 代码
- **timeout**: int（可选，默认值：15）- 执行超时时间（秒）
- **return_error**: bool（可选，默认值：True）- 是否返回错误信息

**运行方法**

- 输入：
  - **python_code**: Optional[str]（可选）
  - **timeout**: Optional[int]（可选）
  - **documents**: Optional[List[Document]]（可选）
- 输出：
  - **documents**: List[Document]
  - **python_output**: str
  - **python_error_output**: str

**CustomLangfuseConnector**

**功能描述**：LangfuseConnector 将 Haystack LLM 框架与 Langfuse 连接起来，以便能够追踪管道内各种组件的操作和数据流。只需将此组件添加到您的管道中，但不要将其连接到任何其他组件。LangfuseConnector 将自动追踪管道内的操作和数据流。

**初始化参数**：

- **name**: str
- **public**: bool（可选，默认值：False）

**运行方法**

- 输入：
  - **invocation_context**: Optional[Dict[str, Any]]（可选）
- 输出：
  - **name**: str
  - **trace_url**: str

- 使用示例：

```python
import os
 os.environ["HAYSTACK_CONTENT_TRACING_ENABLED"] = "true"
 from haystack import Pipeline
 from haystack.components.builders import ChatPromptBuilder
 from haystack.components.generators.chat import OpenAIChatGenerator
 from haystack.dataclasses import ChatMessage
 from haystack_integrations.components.connectors.langfuse import (
 LangfuseConnector,
 )
 if __name__ == "__main__":
 pipe = Pipeline()
 pipe.add_component("tracer", LangfuseConnector("Chat example"))
 pipe.add_component("prompt_builder", ChatPromptBuilder())
 pipe.add_component("llm", OpenAIChatGenerator(model="gpt-3.5-
turbo"))
 pipe.connect("prompt_builder.prompt", "llm.messages")
 messages = [
 ChatMessage.from_system(
 "Always respond in German even if some input data is in 
other languages."
 ),
 ChatMessage.from_user("Tell me about {{location}}"),
 ]
 response = pipe.run(
 data={
 "prompt_builder": {
 "template_variables": {"location": "Berlin"},
 "template": messages,
 }
 }
 )
 print(response["llm"]["replies"][0])
 print(response["tracer"]["trace_url"])
```

**MOCRetriever**

**功能描述**：仅用于 MOC 向量搜索。它是一个特殊的检索器组件，因为我们没有文档存储。

**初始化参数**：

- **mo_knowledge_url**: str
- **user_id**: str（可选，默认值：""）
- **filters**: Optional[Dict[str, Any]]（可选）
- **top_k**: int（可选，默认值：5）
- **scale_score**: bool（可选，默认值：False）
- **return_embedding**: bool（可选，默认值：False）

**运行方法**

- 输入：
  - **query_text**: str
  - **mo_knowledge_url**: Optional[str]（可选）
  - **filters**: Optional[Dict[str, Any]]（可选）
  - **top_k**: Optional[int]（可选）
  - **scale_score**: Optional[bool]（可选）
  - **return_embedding**: Optional[bool]（可选）
  - **user_id**: Optional[str]（可选）
- 输出：
  - **system_chat_query**: List[Document]
  - **user_chat_query**: str

**OutputGenerator**

**功能描述**：一个使用 OpenAI 的聊天完成 API 生成输出的组件。在工作流结束时用于处理流式和非流式响应。

**初始化参数**：

- **llm_endpoint**: str（可选，默认值：'<https://xxxxx.com/model/api/v1'）>
- **api_key**: Secret（可选，默认值：Secret.from_env_var ('OPENAI_API_KEY')）
- **model**: str（可选，默认值：""）
- **streaming**: bool（可选，默认值：False）
- **max_retries**: int（可选，默认值：3）
- **generation_kwargs**: Optional[Dict[str, Any]]（可选）

**运行方法**

- 输入：
  - **messages**: List[ChatMessage]
  - **generation_kwargs**: Optional[Dict[str, Any]]（可选）
- 输出：
  - **replies**: List[str]
  - **stream**: Generator[str, None, None] (仅当流式传输为 True 时)

**StartComponent**

**功能描述**：一个 Haystack 组件，用于启动工作流。仅用于 UI。输入等于输出。

**初始化参数**：

- **variables**: Optional[List[str]]（可选）

**运行方法**

- 输入：
  - **start_query**: Optional[str]（可选）
- 输出：
  - **user_chat_query**: str

### 查看工作流列表

```
GET /byoa/api/v1/workflow_meta
```

**Query 参数：**

| 参数名          | 类型                                  | 是否必填 | 描述                          | 默认值       |
| --------------- | ------------------------------------- | -------- | ----------------------------- | ------------ |
| **name_search**   | string, nullable                      | 否       | 名称搜索 (工作流名)           |              |
| **start_time**    | integer, nullable                     | 否       | 开始时间戳 (毫秒)             |              |
| **end_time**      | integer, nullable                     | 否       | 结束时间戳 (毫秒)             |              |
| **process_modes** | array[integer], nullable              | 否       | 处理模式 (通常指 interval 值) |              |
| **status**        | array[integer], nullable              | 否       | 状态 (例如：1-运行中，2-完成) |              |
| **file_types**    | array[integer], nullable              | 否       | 文件类型                      |              |
| **priority**      | array[integer], nullable              | 否       | 优先级                        |              |
| **creator**       | string, nullable                      | 否       | 创建者                        |              |
| **offset**        | integer, >=0                          | 否       | 当页偏移量                    | 0            |
| **limit**         | integer, >=1                          | 否       | 每页大小                      | 20           |
| **sort_field**    | string, nullable                      | 否       | 排序字段                      | "created_at" |
| **sort_order**    | string, nullable ("ascend"/"descend") | 否       | 排序方式                      | "descend"    |

**示例 (Python)：**

```python
import requests
import json

url = "https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/workflow_meta"
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

**返回：**

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

**输出参数：**

| 参数        | 类型                                    | 描述                                           |
| ----------- | --------------------------------------- | ---------------------------------------------- |
| **total**     | integer                                 | 符合条件的工作流总数                           |
| **workflows** | array[object] | 工作流列表，每个对象包含工作流及其主要分支信息 |

* **`WorkflowListItem` 对象结构:**
    * id (string): 工作流 ID
    * name (string): 工作流名称
    * created_at (integer): 创建时间戳 (毫秒)
    * creator (string): 创建者
    * updated_at (integer): 更新时间戳 (毫秒)
    * modifier (string, nullable): 更新者
    * source_volume_ids (array[string]): 源数据卷 ID 列表
    * source_volume_names (array[string]): 源数据卷名称列表
    * file_types (array[integer]): 文件类型列表
    * target_volume_id (string): 目标数据卷 ID
    * target_volume_name (string): 目标数据卷名称
    * process_mode (object `ProcessModeConfig`): 处理模式配置
    * priority (integer): 优先级
    * status (integer): 状态
    * version (string, nullable): 版本号
    * branch_total (integer, nullable): 该工作流下的分支总数
    * branch_id (string, nullable): (通常是) 主分支或最新活动分支的 ID
    * branch_name (string, nullable): (通常是) 主分支或最新活动分支的名称
    * branch_status (integer, nullable): (通常是) 主分支或最新活动分支的状态
    * branch_volume_id (string, nullable): (通常是) 主分支或最新活动分支的目标数据卷 ID

### 查看工作流详情

```
GET /byoa/api/v1/workflow_meta/{workflow_id}
```

**路径参数：**

| 参数名        | 类型   | 是否必填 | 描述     |
| ------------- | ------ | -------- | -------- |
| **workflow_id** | string | 是       | 工作流 ID |

**示例 (Python)：**

```python
import requests
import json

workflow_to_get = "YOUR_WORKFLOW_ID"
url = f"https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/workflow_meta/{workflow_to_get}"
headers = {
    "moi-key": "xxxxx"
}
response = requests.get(url, headers=headers)

print(response.status_code)
print(json.dumps(response.json(), indent=4, ensure_ascii=False))
```

**返回 (\1)：**

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

**输出参数：**
主要包含工作流的基础信息、主工作流的 Haystack 配置 (**workflow**)、主/默认分支的相关信息 (**branch_id**, **branch_name**, **branch_status**, **branch_volume_id**)，以及一个 **branches** 数组，其中每一项是 **WorkflowBranchItem**。

* **`WorkflowBranchItem` 结构:**
    * branch_id (string): 分支 ID
    * created_at (integer): 创建时间戳
    * creator (string): 创建者
    * updated_at (integer): 更新时间戳
    * modifier (string): 更新者
    * status (integer): 此分支应用的工作流部分的状态
    * workflow (object `WorkflowConfig`): 此分支特定的 Haystack 配置
    * branch_name (string): 分支名
    * branch_status (integer): 分支自身的状态
    * branch_volume_id (string): 分支的目标数据卷 ID

### 修改工作流

```
PUT /byoa/api/v1/workflow_meta/{workflow_id}
```

**描述：**更新指定工作流的配置。这通常会更新工作流的 "main" 或默认分支。

**路径参数：**

| 参数名        | 类型   | 是否必填 | 描述     |
| ------------- | ------ | -------- | -------- |
| **workflow_id** | string | 是       | 工作流 ID |

**Body 输入参数：**
与 "创建工作流" 的 Body 结构相同。所有字段都可以更新。

**示例 (Python)：**

```python
import requests
import json

workflow_to_update = "YOUR_WORKFLOW_ID"
url = f"https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/workflow_meta/{workflow_to_update}"
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
    "file_types": [2, 6],
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
                    "remove_empty_lines": False,
                    "remove_extra_whitespaces": True
                }
            }
            // ... 其他组件和连接
        ],
        "connections": [ /* ... */ ],
        "edges": [],
        "extra_components": []
    }
}

response = requests.put(url, json=body, headers=headers)
print(response.status_code)
print(response.json())
```

**返回：**

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
| **workflow_id** | string | 是       | 工作流 ID |

**Query 参数：**

| 参数名        | 类型    | 是否必填 | 描述                           | 默认值 |
| ------------- | ------- | -------- | ------------------------------ | ------ |
| **delete_data** | boolean | 否       | 是否删除该工作流产生的所有数据 | false  |

**示例 (Python)：**

```python
import requests
import json

workflow_to_delete = "YOUR_WORKFLOW_ID_TO_DELETE" # 替换为实际的 workflow_id
url = f"https://freetier-01.cn-hangzhou.cluster.matrixonecloud.cn/byoa/api/v1/workflow_meta/{workflow_to_delete}"

headers = {
    "moi-key": "xxxxx"
}
params = {
    "delete_data": True
}

response = requests.delete(url, headers=headers, params=params)

print(response.status_code)
if response.content: 
    try:
        print(json.dumps(response.json(), indent=4, ensure_ascii=False))
    except json.JSONDecodeError:
        print("Response text:", response.text)
else:
    print("Request successful, no content returned.")

```

**返回：**
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
| **workflow_id** | string | 是       | 工作流 ID |

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
```

**返回：**
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
| **workflow_id** | string | 是       | 工作流 ID |

**Body 输入参数：**

| 参数名        | 是否必填 | 类型                      | 含义       | 默认值 |
| ------------- | -------- | ------------------------- | ---------- | ------ |
| **branch_name** | 否       | string, nullable          | 新的分支名     | ""     |
| **workflow**    | 是       | object | 新的工作流配置 |        |

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

**返回：**

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
| **workflow_id** | string | 是       | 工作流 ID |

**Query 参数：**

| 参数名          | 类型                     | 是否必填 | 描述                                    |
| --------------- | ------------------------ | -------- | --------------------------------------- |
| **status_in**     | array[integer], nullable | 否       | 工作流状态 (分支应用的工作流部分的状态) |
| **branch_status** | array[integer], nullable | 否       | 分支自身的状态                          |

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

**返回：**
返回结构与 "查看工作流列表" (**GET /byoa/api/v1/workflow_meta**) 类似，其中 **data.workflows** 数组的每一项是 **WorkflowListItem**，但此处代表的是该工作流下的各个分支的信息。请参考 **WorkflowListItem** 结构。

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

**输出参数：**
(具体字段参考 `GET /byoa/api/v1/workflow_meta` 的 `WorkflowListItem` 定义，此处 id 是父工作流 ID, `branch_id`, `branch_name`, `branch_status` 等描述分支特有属性)

#### 获取工作流分支详情

```
GET /byoa/api/v1/workflow_meta/branch/{branch_id}
```

**描述：**获取特定工作流分支的详细信息。

**路径参数：**

| 参数名      | 类型   | 是否必填 | 描述         |
| ----------- | ------ | -------- | ------------ |
| **branch_id** | string | 是       | 工作流分支 ID |

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

**返回：**
返回结构与 "查看工作流详情" (**GET /byoa/api/v1/workflow_meta/{workflow_id}**) 类似，但 **data** 部分描述的是该分支的详情。

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

**输出参数：**
(参考 `GET /byoa/api/v1/workflow_meta/{workflow_id}` 的 `WorkflowDetailResponse` 定义，其中 id 为父工作流 ID，`workflow` 为此分支的配置，`branch_id`, `branch_name` 等为当前分支信息)

#### 更新工作流分支

```
PUT /byoa/api/v1/workflow_meta/branch/{branch_id}
```

**描述：**更新指定工作流分支的配置。

**路径参数：**

| 参数名      | 类型   | 是否必填 | 描述         |
| ----------- | ------ | -------- | ------------ |
| **branch_id** | string | 是       | 工作流分支 ID |

**Body 输入参数：**

| 参数名        | 是否必填 | 类型                      | 含义           | 默认值 |
| ------------- | -------- | ------------------------- | -------------- | ------ |
| **branch_name** | 否       | string, nullable          | 新的分支名     | ""     |
| **workflow**    | 是       | object | 新的工作流配置 |        |

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

**返回：**

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
| **branch_id** | string | 是       | 工作流分支 ID |

**Query 参数：**

| 参数名        | 类型    | 是否必填 | 描述                         | 默认值 |
| ------------- | ------- | -------- | ---------------------------- | ------ |
| **delete_data** | boolean | 否       | 是否删除该分支产生的所有数据 | false  |

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

**返回：**

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
| **branch_id** | string | 是       | 工作流分支 ID |

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

**返回：**
成功启用后，通常返回该分支所属的父工作流的详细信息 (\1)，其中该分支的状态会更新，并可能成为主分支。

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
| **branch_id** | string | 是       | 工作流分支 ID |

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

**返回：**
成功禁用后，通常返回该分支所属的父工作流的详细信息 (\1)，其中该分支的状态会更新。

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

**Body 输入参数：**

| 参数               | 是否必填 | 类型                       | 含义                                                         | 默认值 |
| ------------------ | -------- | -------------------------- | ------------------------------------------------------------ | ------ |
| name               | 是       | string                     | 作业名称                                                     |        |
| workflow_meta_id   | 是       | string                     | 工作流元数据 ID                               |        |
| workflow_branch_id | 是       | string                     | 工作流分支 ID |        |
| target_volume_id   | 是       | string                     | 目标数据卷 ID                    |        |
| files              | 否       | array[object (\1)] | 要处理的文件列表。如果为空，则按工作流配置处理               | []     |

* **`FileItem` 对象结构：**

  | 参数             | 是否必填 | 类型                      | 含义            |
  | ---------------- | -------- | ------------------------- | --------------- |
  | file_name        | 是       | string                    | 文件名          |
  | file_type        | 是       | integer (**FileType** enum) | 文件类型        |
  | file_size        | 是       | integer                   | 文件大小 (bytes) |
  | file_path        | 是       | string                    | 文件路径        |
  | source_volume_id | 是       | integer                   | 源数据卷 ID      |
  | source_file_id   | 是       | integer                   | 源文件 ID        |

**Body 示例：**

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

**返回：**

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

**Query 参数：**

| 参数名        | 类型                                  | 是否必填 | 描述                          | 默认值       |
| ------------- | ------------------------------------- | -------- | ----------------------------- | ------------ |
| **name_search** | string, nullable                      | 否       | 名称搜索 (作业名)             |              |
| **start_time**  | integer, nullable                     | 否       | 开始时间戳 (毫秒)             |              |
| **end_time**    | integer, nullable                     | 否       | 结束时间戳 (毫秒)             |              |
| **status**      | array[integer], nullable              | 否       | 状态 (例如：1-运行中，2-完成) |              |
| **file_types**  | array[integer], nullable              | 否       | 文件类型                      |              |
| **priority**    | array[integer], nullable              | 否       | 优先级                        |              |
| **creator**     | string, nullable                      | 否       | 创建者                        |              |
| **offset**      | integer, >=0                          | 否       | 当页偏移量                    | 0            |
| **limit**       | integer, >=1                          | 否       | 每页大小                      | 20           |
| **sort_field**  | string, nullable                      | 否       | 排序字段                      | "created_at" |
| **sort_order**  | string, nullable ("ascend"/"descend") | 否       | 排序方式                      | "descend"    |

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

**返回 (\1)：**

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

**输出参数：**

| 参数    | 类型                               | 描述                                       |
| ------- | ---------------------------------- | ------------------------------------------ |
| **total** | integer                            | 符合条件的工作流作业总数                   |
| **jobs**  | array[object] | 作业列表，每个对象包含作业及其主要分支信息 |

* **`JobListItem` 对象结构:**
    * id (string): 作业 ID
    * name (string): 作业名称
    * created_at (integer): 创建时间戳 (毫秒)
    * creator (string): 创建者
    * updated_at (integer): 更新时间戳 (毫秒)
    * modifier (string, nullable): 更新者
    * status (integer): 状态
    * version (string, nullable): 版本号
    * workflow_meta_id (string): 工作流元数据 ID
    * workflow_branch_id (string): 工作流分支 ID

### 查看作业详情

```
GET /byoa/api/v1/workflow_job/{job_id}
```

**描述：**获取指定作业的详细信息。

**路径参数：**

| 参数名   | 类型   | 是否必填 | 描述   |
| -------- | ------ | -------- | ------ |
| **job_id** | string | 是       | 作业 ID |

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

**返回：**

```json
{
    "code": "ok",
    "msg": "ok",
    "data": {
        "created_at": "2025-05-30T09:45:58",
        "id": "cf68d259-9cd6-4f44-a0a4-5674c79da083",
        "user_id": "01960e07-60ec-7a3c-b45f-415b7e40e8bf",
        "flow_interval": 0,
        "creator": "admin",
        "file_types": "[1, 2, 4, 5, 6, 7, 11, 12]",
        "target_volume_id": "04614636-b858-4b13-99bf-a036d9351289",
        "files": "[]",
        "updated_at": "2025-05-30T09:45:58",
        "version": "1",
        "priority": 300,
        "name": "test",
        "group_id": "",
        "flow_offset": 0,
        "modifier": "admin",
        "source_volume_ids": "[\"1928383194482323456\"]",
        "source_volume_names": "[\"b_vol3\"]",
        "target_volume_name": "b_vol3"
    }
}
```

**输出参数：**

```json
{
    "code": "ok",
    "msg": "ok",
    "data": {
        "created_at": "2025-05-30T09:45:58",
        "id": "cf68d259-9cd6-4f44-a0a4-5674c79da083",
        "user_id": "01960e07-60ec-7a3c-b45f-415b7e40e8bf",
        "flow_interval": 0,
        "creator": "admin",
        "file_types": "[1, 2, 4, 5, 6, 7, 11, 12]",
        "target_volume_id": "04614636-b858-4b13-99bf-a036d9351289",
        "files": "[]",
        "updated_at": "2025-05-30T09:45:58",
        "version": "1",
        "priority": 300,
        "name": "test",
        "group_id": "",
        "flow_offset": 0,
        "modifier": "admin",
        "source_volume_ids": "[\"1928383194482323456\"]",
        "source_volume_names": "[\"b_vol3\"]",
        "target_volume_name": "b_vol3"
    }
}
```

### 查看作业文件列表

```
GET /byoa/api/v1/workflow_job/{job_id}/files
```

**路径参数：**

| 参数名   | 类型   | 是否必填 | 描述   |
| -------- | ------ | -------- | ------ |
| **job_id** | string | 是       | 作业 ID |

**Query 参数：**

| 参数名             | 类型                                  | 是否必填 | 描述                          | 默认值       |
| ------------------ | ------------------------------------- | -------- | ----------------------------- | ------------ |
| **file_name_search** | string, nullable                      | 否       | 文件名搜索                    |              |
| **file_types**       | array[integer], nullable              | 否       | 文件类型 (见 **FileType** 枚举) |              |
| **status**           | array[integer], nullable              | 否       | 文件处理状态                  |              |
| **sort_field**       | string, nullable                      | 否       | 排序字段                      | "created_at" |
| **sort_order**       | string, nullable ("ascend"/"descend") | 否       | 排序方式                      | "descend"    |
| **offset**           | integer, >=0                          | 否       | 当页偏移量                    | 0            |
| **limit**            | integer, >=1                          | 否       | 每页大小                      | 20           |

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

**返回：**

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

**输出参数：**

| 参数    | 类型                               | 描述               |
| ------- | ---------------------------------- | ------------------ |
| **total** | integer                            | 符合条件的文件总数 |
| **files** | array[object] | 作业相关的文件列表 |

* **`JobFileItem` 对象结构:**
    * id (string): 文件项 ID
    * name (string): 文件名
    * type (integer): 文件类型 (**FileType** 枚举)
    * size (integer): 文件大小 (bytes)
    * status (integer): 文件处理状态
    * created_at (integer): 创建时间戳 (毫秒)
    * updated_at (integer): 更新时间戳 (毫秒)
    * path (string, nullable): 文件在目标数据卷中的路径
    * volume_id (string, nullable): 文件所在的目标数据卷 ID
    * job_id (string): 关联的作业 ID
    * meta_id (string, nullable): 关联的工作流元数据 ID
    * branch_id (string, nullable): 关联的工作流分支 ID

### 重试处理作业文件

```
POST /byoa/api/v1/workflow_job/{job_id}/files
```

**描述：**删除指定作业关联的特定文件记录。

**路径参数：**

| 参数名   | 类型   | 是否必填 | 描述   |
| -------- | ------ | -------- | ------ |
| **job_id** | string | 是       | 作业 ID |

**Query 参数：**

| 参数名     | 类型          | 是否必填 | 描述                                     | 默认值 |
| ---------- | ------------- | -------- | ---------------------------------------- | ------ |
| **file_ids** | array[string] | 是       | 要重试的文件 ID 列表 (指 `JobFileItem.id`) |        |

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

**返回：**

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
| **job_id** | string | 是       | 作业 ID |

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

**返回：**

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

**输出参数：**

| 参数         | 类型              | 描述                                                         |
| ------------ | ----------------- | ------------------------------------------------------------ |
| **job_id**     | string            | 作业 ID                                                       |
| **status**     | integer           | 作业的当前状态 |
| **message**    | string, nullable  | 状态相关的附加信息                                           |
| **progress**   | integer, nullable | 作业进度 (0-100)                                             |
| **start_time** | integer, nullable | 作业开始时间戳 (毫秒)                                        |
| **end_time**   | integer, nullable | 作业结束时间戳 (毫秒)                                        |

**DocumentEmbedder**

**功能描述**：使用 OpenAI 的聊天完成 API 生成输出的组件。在工作流结束时用于处理流式和非流式响应。

**参数结构示例**：

```json
{
    "name": "DocumentEmbedder",
    "type": "haystack.components.embedders.openai_document_embedder.OpenAIDocumentEmbedder",
    "component_id": "DocumentEmbedder_1749126721751",
    "intro": "DocumentEmbedder",
    "position": {
        "x": 0,
        "y": 0
    },
    "input_keys": {},
    "output_keys": {},
    "init_parameters": {
        "api_base_url": "",
        "api_key": {
            "env_vars": ["OPENAI_API_KEY"],
            "strict": true,
            "type": "env_var"
        },
        "batch_size": 32,
        "dimensions": null,
        "embedding_separator": "\n",
        "meta_fields_to_embed": [],
        "model": "",
        "organization": null,
        "prefix": "",
        "progress_bar": true,
        "suffix": ""
    }
}
```

**初始化参数**：

- **api_base_url**: str（可选，默认值：'<https://xxxxx.com/model/api/v1'）-> API 基础 URL
- **api_key**: Secret（可选，默认值：Secret.from_env_var ('OPENAI_API_KEY')）- API 密钥
- **model**: str（可选，默认值：""）- 模型名称
- **batch_size**: int（可选，默认值：32）- 批处理大小
- **dimensions**: Optional[int]（可选，默认值：None）- 嵌入维度
- **embedding_separator**: str（可选，默认值："\n"）- 嵌入分隔符
- **meta_fields_to_embed**: list（可选，默认值：[]）- 要嵌入的元字段列表
- **organization**: Optional[str]（可选，默认值：None）- 组织 ID
- **prefix**: str（可选，默认值：""）- 前缀
- **progress_bar**: bool（可选，默认值：True）- 是否显示进度条
- **suffix**: str（可选，默认值：""）- 后缀

**运行方法**

- 输入：
  - **documents**: List[Document]
  - **meta**: Optional[Union[Dict[str, Any], List[Dict[str, Any]]]]（可选）
- 输出：
  - **documents**: List[Document]

**DocumentWriter**

**功能描述**：文档写入器组件。

**参数结构示例**：

```json
{
    "name": "DocumentWriter",
    "type": "haystack.components.writers.document_writer.DocumentWriter",
    "component_id": "DocumentWriter_1749126721751",
    "intro": "DocumentWriter",
    "position": {
        "x": 0,
        "y": 0
    },
    "input_keys": {},
    "output_keys": {},
    "init_parameters": {
        "document_store": {
            "init_parameters": {
                "connection_string": {
                    "env_vars": ["DATABASE_SYNC_URI"],
                    "strict": true,
                    "type": "env_var"
                },
                "embedding_dimension": 1024,
                "keyword_index_name": "haystack_keyword_index",
                "recreate_table": true,
                "table_name": "embedding_results",
                "vector_function": "cosine_similarity"
            },
            "type": "byoa.integrations.document_stores.mo_document_store.MOIDocumentStore"
        },
        "policy": "NONE"
    }
}
```

**初始化参数**：

- **document_store**: 文档存储配置对象
  - **init_parameters**: 初始化参数
    - **connection_string**: Dict[str, Any] - 数据库连接字符串配置
      - **env_vars**: List[str] - 环境变量列表
      - **strict**: bool - 是否严格模式
      - **type**: str - 类型
    - **embedding_dimension**: int - 嵌入维度
    - **keyword_index_name**: str - 关键词索引名称
    - **recreate_table**: bool - 是否重新创建表
    - **table_name**: str - 表名
    - **vector_function**: str - 向量相似度函数
  - **type**: str - 文档存储类型
- **policy**: str - 写入策略

**运行方法**

- 输入：
  - **documents**: List[Document]
  - **meta**: Optional[Union[Dict[str, Any], List[Dict[str, Any]]]]（可选）
- 输出：
  - **documents**: List[Document]
