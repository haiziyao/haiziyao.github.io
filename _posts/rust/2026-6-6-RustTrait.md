---
layout:     post
title:      "每天学习n个rust库"
subtitle:   " \"我要成为rust信徒\""
date:       2026-6-6 12:00:00
author:     "HZY"
header-img: ""
catalog: true
tags:
    - Rust
---

## Rust, 启动!!!

###  rust-embed
* rust本身不提供这种把文件写入程序的库
* 用法十分简单

``` rust
use rust_embed::Embed;

#[derive(Embed)]
//#[derive(RustEmbed)] //和上面那个属于同一种东西
#[folder = "examples/public/"]
#[include = "*.html"]
#[include = "images/*"]
#[exclude = "*.txt"]
struct Asset;
```