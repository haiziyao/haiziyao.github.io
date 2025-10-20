---
layout:     post
title:      "Hello Ubuntu"
subtitle:   " \"necessity for Ubuntu\""
date:       2025-09-03 12:00:00
author:     "HZY"
header-img: ""
catalog: true
tags:
    - Ubuntu
---

### 以下是装机必备
* 换源

* Flameshot
在自定义快捷键设置 /usr/bin/flameshot/gui
* 搜狗输入法
* vscode 
每次下载vscode，都要做许多工作：
    1. fontsize设置
    2. autosave设置
    3. One Dark Pro 背景更改
    4. C/C++ Cmake Clangd
* Clangd 下载
  这个clangd的配置真是难到我很久了，这里给出最终解决办法，就是在settings.pr
  "clangd.arguments": [
        "--compile-commands-dir=${workspaceFolder}/build",
        "--query-driver=/usr/bin/g++"
    ]
    上面这个自行解决，我不敢说能不能用，反正现在好像是还有一点小问题。
* 