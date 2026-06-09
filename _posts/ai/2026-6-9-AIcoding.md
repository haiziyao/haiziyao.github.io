---
layout:     post
title:      "AIcoding"
subtitle:   " \"vibe coding\""
date:       2026-6-9 20:00:09
author:     "hzy"
header-img: ""
catalog: true
tags:
    - ai
---





### SDD[P9-规范需求开发SDD]
Specification-Driven Development

#### 需求规范: PRD文档

##### 用户故事格式

``` bash
我作为一个[角色]
我希望 [功能]
以便 [价值/目的]
```

##### 验收标注格式

``` bash
Given(前提条件):
When(操作):
Then(预期结果):
```

#### 技术规范: SPEC文档 

``` bash
系统架构
技术选型
数据模型
API接口
目录结构
```

#### 质量规范

* 编码规范
* 测试规范
* 安全规范


### 彩蛋：土耳其旅游[P11]


### AI编程工具
#### Claude-七个扩展[P17]

* CLAUDE.md :
* Hooks : 会话生命周期钩子
* Skills: 按需加载的专业知识包
* Plugins: 打包一整套Skills+Hooks+MCP
* LSP(语言服务器):
* MCP:
* SubAgents:

#### Codex[P18]
* CLI开源
* 沙箱与审批机制
* AGENTS.md
* 三档自主级别
* 推理强度可控


#### 其他编程工具[P19]

#### CCSwitch[P26]
对于api配置，直接看ccswitch就够了，其他都跳过


### ClaudeCode

#### 模型选择与切换[P28]

``` bash
/model  #列出所有模型
```

**~/.claude/setting.json**   :全局配置
**/.claude/setting.json**   :团队共享
**/.claude/setting.local.json**  :个人(.gitignore)
**/CLAUDE.md**

#### setting.json[P29]
``` json
{
//不太推荐在这个文件中写注释
  // 允许 Claude Code 执行的操作（不再需要每次确认）
  "permissions": {
    "allow": [
      "Read",              // 读取文件
      "Write",             // 写入文件
      "Bash(npm *)",       // 执行 npm 命令
      "Bash(git *)",       // 执行 git 命令
      "Bash(node *)"       // 执行 node 命令
    ],
    "deny": [
      "Bash(rm -rf *)"     // 禁止执行危险的删除命令
    ]
  },

  // 默认使用的模型
  "model": "sonnet",

  // 自动紧凑阈值（上下文使用超过此比例时自动压缩）
  "autoCompactThreshold": 80
}
```


``` json
{
  // 允许 Claude Code 执行的操作（后端开发常用）
  "permissions": {
    "allow": [
      "Read",
      "Write",

      // Git 常用操作
      "Bash(git status)",
      "Bash(git diff *)",
      "Bash(git log *)",
      "Bash(git branch *)",
      "Bash(git checkout *)",
      "Bash(git add *)",
      "Bash(git commit *)",
      "Bash(git pull *)",
      "Bash(git push *)",

      // Node / 前后端项目常用
      "Bash(node *)",
      "Bash(npm *)",
      "Bash(npx *)",
      "Bash(pnpm *)",
      "Bash(yarn *)",

      // Java 后端常用
      "Bash(java *)",
      "Bash(javac *)",
      "Bash(mvn *)",
      "Bash(./mvnw *)",
      "Bash(gradle *)",
      "Bash(./gradlew *)",

      // Python 后端常用
      "Bash(python *)",
      "Bash(python3 *)",
      "Bash(pip *)",
      "Bash(pip3 *)",
      "Bash(pytest *)",

      // Docker 常用
      "Bash(docker ps *)",
      "Bash(docker images *)",
      "Bash(docker logs *)",
      "Bash(docker compose *)",
      "Bash(docker-compose *)",

      // 常用查看命令
      "Bash(ls *)",
      "Bash(cat *)",
      "Bash(pwd)",
      "Bash(find *)",
      "Bash(grep *)",
      "Bash(curl *)"
    ],
    "deny": [
      // 高危删除
      "Bash(rm -rf *)",
      "Bash(rm -fr *)",

      // 高危权限修改
      "Bash(chmod 777 *)",
      "Bash(chown *)",

      // 高危系统操作
      "Bash(sudo *)",
      "Bash(su *)",
      "Bash(reboot *)",
      "Bash(shutdown *)",

      // 避免误删 Git 仓库
      "Bash(git reset --hard *)",
      "Bash(git clean -fd *)",
      "Bash(git clean -fdx *)",

      // 避免 Docker 破坏性操作
      "Bash(docker system prune *)",
      "Bash(docker volume rm *)",
      "Bash(docker rmi *)"
    ]
  },

  // 默认使用的模型
  "model": "sonnet",

  // 自动紧凑阈值
  "autoCompactThreshold": 80
}

```

### 三层记忆[P30-33]
##### CLAUDE.md [P30] 

``` md
// CLAUDE.md
# 项目名称

## 项目概述

## 项目结构

## 编码规范

## 当前开发 状态

## 注意事项
```

这个也有三次层级全局，项目，项目子模块

``` bash
/memory # 可以查看 claude.md
/init
```

##### 卡帕西的md [P32]

[仓库地址](https://github.com/multica-ai/andrej-karpathy-skills)

##### Auto Memory [P33]

这个功能提供了开关，是cc自己的笔记本

* user： 角色，偏好
* feedback: 自己给cc的反馈
* project：项目的进度，决策，技术选型
* reference: 外部资源引用
* **`CRTL`+`O`**

##### 自建参考文档(渐进式披露) [P33]

* 规范：docs/xx.md
* 风格：docs/xxx.md
* 在CLAUDE.md中加上指引

``` bash
## 外部参考文档

- 修改风格，必读 `doc/xxx.md`
```

### claude命令

``` bash
/model 
/context  #查看上下文
/compact  #上下文压缩
/clear

/memory
/status 

/cost # 按照A厂价格算的

/review  # 以git作为标准进行审查

/init  
/plan # 切换到计划模式，不会有任何执行

/rewind # 回滚，不如git
/resume # 恢复上次会话
/btw  # 顺便问一句

/simplify # 调用3个子Agent，快速全面优化已有代码

!pwd  # ！直接进入命令行模式
@文件 # 精准给予上下文

claude 
claude -c
claude --permission-mode plan
claude --dangerously-skip-permissions
```

### Claude Code 实战工作流
 