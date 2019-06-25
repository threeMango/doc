# gitbook

* 初始化

```bash
# 在当前目录下初始化gitbook ,没有README.md SUMMARY.md 文件自动生成
#  如果有了,根据SUMMARY.md 里面的目录生成文件
gitbook init

info: create other/gitbook.md
info: create SUMMARY.md
info: initialization is finished
```

* 安装插件

```bash
# 根据book.json 安装插件
gitbook install
```

* 启动服务

```bash
gitbook serve
```

## 附录

### book.json

```json
{
  "title": "cjn - 笔记",
  "description": " study",
  "language": "zh",
  "plugins": [
    "anchor-navigation-ex",
    "insert-logo",
    "atoc",
    "prism",
    "copy-code-button",
    "chapter-fold",
    "tbfed-pagefooter"
  ],
  "pluginsConfig": {
    "anchor-navigation-ex": {
      "isShowTocTitleIcon": true,
      "tocLevel1Icon": "fa fa-hand-o-right",
      "tocLevel2Icon": "fa fa-hand-o-right",
      "tocLevel3Icon": "fa fa-hand-o-right"
    },
    "insert-logo": {
      "url": "/img/logo.png",
      "style": "background: none; max-height: 80px; min-height: 80px"
    },
    "atoc": {
      "addClass": true,
      "className": "atoc"
    },
    "prism": {
      "css": [
        "prismjs/themes/prism-tomorrow.css"
      ]
    },
    "tbfed-pagefooter": {
      "copyright": "Copyright &copy dsx2016.com 2019",
      "modify_label": "该文章修订时间：",
      "modify_format": "YYYY-MM-DD HH:mm:ss"
    }
  }
}

```



