## 文档预览

当前仓库用于渲染 markdown 文档为 HTML。

> 基于 python 库 [mkdocs](https://www.mkdocs.org/getting-started/)，另搭配主题 [mkdocs-material](https://github.com/squidfunk/mkdocs-material)。

### 下载代码

1. 如果是从零开始：

```bash
git clone git@github.com:matrixone-cloud/moc-docs.git
```

2. 如果已下载，需要更新到最新代码，可执行：

```
// 更新主项目 渲染文档
git remote update
git rebase upstream/main
```

### 安装依赖

```bash
pip install -r requirements.txt
```

> 提示：MkDocs 需要最新版本的 [Python](https://www.python.org/) 和 Python 包管理器 [pip](https://pip.readthedocs.io/en/stable/installing/) 才能安装在您的系统上。
> 查看是否安装成功，可以通过 `pip list` 看 `mkdocs-material 8.2.8` 是否对应上。

### 启动服务

```bash
mkdocs serve
```

### 预览

打开浏览器访问 `http://127.0.0.1:8000/` 或 `localhost:8000`。
