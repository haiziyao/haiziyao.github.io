---
layout:     post
title:      "SW-cache-issue"
subtitle:   " \"github.io 静态博客 Service Worker 缓存刷新问题\""
date:       2026-6-11 05:57:01
author:     "haiziyao"
header-img: ""
catalog: true
tags:
    - ai
---

## 问题描述

本博客部署在 GitHub Pages，使用 Jekyll 构建。每次更新内容后访问网站，页面不会自动展示最新内容，左下角会弹出 "Content updated. [refresh]" 的提示条，必须手动点击 refresh 才会执行 `location.reload()` 刷新页面。

更烦的是，**每个页面都要单独刷新**——比如改了导航栏或 footer 这种公共组件，几十篇文章页面都需要逐个手动点 refresh，体验很差。

## 根因定位

问题出在项目中的 **Service Worker（SW）**，这是一个手写的离线缓存方案（非 Workbox），位于仓库根目录的 `sw.js`，入口注册在 `js/sw-registration.js`。

### 整体架构

```
sw.js (Service Worker 脚本)
  ├── Install: 预缓存静态资源（App Shell），立即 skipWaiting()
  ├── Activate: clients.claim() 接管所有页面
  └── Fetch: stale-while-revalidate 策略
       └── 比较 Last-Modified → 发送 UPDATE_FOUND → 弹 snackbar
```

### 缓存策略：stale-while-revalidate

`sw.js` 对 HTML 导航请求采用的是 **stale-while-revalidate** 策略（`sw.js:185-217`）：

```javascript
const cached = caches.match(event.request);
const fetched = fetch(getCacheBustingUrl(event.request), { cache: "no-store" });

event.respondWith(
  Promise.race([fetched.catch(_ => cached), cached])
    .then(resp => resp || fetched)
    .catch(_ => caches.match('offline.html'))
);
```

关键逻辑：
1. 用 `Promise.race` 竞速：网络响应和缓存响应谁先返回就用谁
2. 同时发起网络请求（带 `?cache-bust=<timestamp>` 绕过 GitHub Pages 的 `Cache-Control: max-age=600`）
3. 响应后再用网络版本更新缓存

### 刷新提示触发链路

完整链路如下（`sw.js:253-268` → `sw-registration.js:44-56`）：

```
用户访问页面
  → SW 拦截 fetch 请求
  → SW 返回缓存版本（通常更快）或网络版本
  → SW 比较缓存和网络响应的 Last-Modified 头
  → 如果不同 → postMessage({ command: 'UPDATE_FOUND' }) 到所有客户端
  → sw-registration.js 收到消息
  → snackbar.js 弹出左下角提示："Content updated. [refresh]"
  → 用户点击 refresh → location.reload()
```

核心检测代码在 `sw.js`：

```javascript
function revalidateContent(cachedResp, fetchedResp) {
  return Promise.all([cachedResp, fetchedResp])
    .then(([cached, fetched]) => {
      const cachedVer = cached.headers.get('last-modified')
      const fetchedVer = fetched.headers.get('last-modified')
      if (cachedVer !== fetchedVer) {
        sendMessageToClientsAsync({
          'command': 'UPDATE_FOUND',
          'url': fetched.url
        })
      }
    })
}
```

客户端接收在 `sw-registration.js`：

```javascript
navigator.serviceWorker.onmessage = (e) => {
  const data = e.data
  if(data.command == "UPDATE_FOUND"){
    createSnackbar({
      message: "Content updated.",
      actionText: "refresh",
      action: function(e){ location.reload() }
    })
  }
}
```

## 问题本质

1. **不自动刷新**：收到 `UPDATE_FOUND` 后只提示，不自动 reload。如果直接把 `action` 改成自动调用 `location.reload()`，用户就无感了。

2. **逐页缓存**：每个 HTML 页面独立缓存。SW 的 `revalidateContent` 只在用户**主动导航到某个页面**时才会触发该页面的对比。所以改了公共组件后，只有实际访问到的页面才会提示刷新，没访问的页面依然停留在旧缓存。

3. **SW 更新和内容更新是两回事**：`skipWaiting()` + `clients.claim()` 能让 SW 脚本本身立即生效，但**已缓存的页面内容不会因此自动更新**。SW 脚本更新 ≠ 已缓存页面内容更新。

## 可选方案

### 方案一：自动刷新（最小改动）

修改 `sw-registration.js`，收到 `UPDATE_FOUND` 后自动 reload，不再等用户点击：

```javascript
navigator.serviceWorker.onmessage = (e) => {
  if(e.data.command == "UPDATE_FOUND"){
    location.reload()  // 直接自动刷新
  }
}
```

**优点**：改动最小
**缺点**：用户正在阅读时突然刷新，体验不一定好

### 方案二：SW 更新时清理所有缓存

在 `sw.js` 的 `activate` 事件中，删除所有旧缓存，强制下次导航走网络：

```javascript
self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(cacheNames => Promise.all(
      cacheNames.map(cacheName => caches.delete(cacheName))
    )).then(() => self.clients.claim())
  )
})
```

**优点**：用户下次导航自然看到最新内容，无需手动刷新
**缺点**：首次加载会变慢（无缓存）

### 方案三：直接关闭 Service Worker（最彻底）

在 `_config.yml` 中将 `service-worker` 设为 `false`：

```yaml
service-worker: false
```

**优点**：彻底解决缓存问题，GitHub Pages 自身的 10 分钟缓存通常够用
**缺点**：失去离线访问能力

## 总结

这是一个典型的**过于保守的缓存更新策略**问题。SW 检测到了内容更新，但选择提示用户手动操作而非自动处理。对于内容更新频繁的博客来说，这个设计弊大于利——每次 push 后读者都要手动逐页刷新才能看到新内容。

后续根据需求选择合适的方案修复即可。
