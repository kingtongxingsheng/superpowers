# Visual Companion 指南

用于展示 mockup、图表和选项的基于浏览器的视觉头脑风暴伴侣。

## 何时使用

按问题决定，而不是按会话决定。判断标准：**用户通过看到它，是否会比阅读文字理解得更好？**

**当内容本身是视觉内容时使用浏览器：**

- **UI mockup**——wireframe、布局、导航结构、组件设计
- **架构图**——系统组件、数据流、关系图
- **并排视觉对比**——比较两种布局、两套配色或两种设计方向
- **设计润色**——问题涉及外观感受、间距或视觉层次时
- **空间关系**——渲染为图表的状态机、流程图、实体关系

**当内容是文本或表格时使用终端：**

- **需求和范围问题**——“X 是什么意思？”、“哪些功能属于范围？”
- **概念性的 A/B/C 选择**——在用文字描述的方案之间选择
- **权衡列表**——优缺点、对比表
- **技术决策**——API 设计、数据建模、架构方案选择
- **澄清问题**——答案是文字而不是视觉偏好的任何问题

关于 UI 主题的问题不自动等于视觉问题。“你想要哪种向导？”是概念问题，应使用终端；“这些向导布局中哪个感觉更合适？”是视觉问题，应使用浏览器。

## 工作方式

服务器监视一个目录中的 HTML 文件，并将最新文件提供给浏览器。你将 HTML 内容写入 `screen_dir`，用户在浏览器中查看并点击选择选项。选择会记录到 `state_dir/events`，你在下一轮读取这些事件。

**内容片段与完整文档：**如果 HTML 文件以 `<!DOCTYPE` 或 `<html` 开头，服务器会按原样提供（只注入 helper script）。否则服务器会自动用 frame template 包装内容——添加标题、CSS 主题、连接状态和全部交互基础设施。**默认写内容片段。**只有需要完全控制页面时才写完整文档。

## 启动会话

```bash
# 用户批准 companion 后再启动。--open 会在第一个界面出现时自动打开浏览器；
# --project-dir 持久化 mockup，并支持使用相同端口重启。
scripts/start-server.sh --project-dir /path/to/project --open

# 返回：{"type":"server-started","port":52341,
#           "url":"http://localhost:52341/?key=ab12…",
#           "screen_dir":"/path/to/project/.superpowers/brainstorm/12345-1706000000/content",
#           "state_dir":"/path/to/project/.superpowers/brainstorm/12345-1706000000/state"}
```

保存响应中的 `screen_dir` 和 `state_dir`。使用 `--open` 时，推送第一个界面后浏览器会自动打开——无需要求用户打开，但仍要分享 URL 作为备用（无头/远程环境不会自动打开）。

**URL 包含会话 key（`?key=…`）。**服务器会拒绝不带 key 的请求，所以始终把 `url` 字段中的完整 URL 提供给用户——绝不能删掉查询字符串，也绝不能提供裸的 `http://host:port`。这个 key 控制 HTTP 和 WebSocket 访问，避免网络中的其他浏览器标签页或机器读取界面、注入事件。首次加载后，浏览器会通过 cookie 记住 key，重新加载和 `/files/*` 资源访问无需重复提供。

**查找连接信息：**服务器将启动 JSON 写入 `$STATE_DIR/server-info`。如果在后台启动服务器时没有捕获 stdout，从该文件读取 URL 和端口。使用 `--project-dir` 时，检查 `<project>/.superpowers/brainstorm/` 中的会话目录。

**注意：**传入项目根目录作为 `--project-dir`，让 mockup 持久化在 `.superpowers/brainstorm/` 中并能在服务器重启后保留。如果不传，文件会写入 `/tmp` 并被清理。如果 `.gitignore` 中尚未包含 `.superpowers/`，提醒用户添加。

**按平台启动服务器：**

**Claude Code：**
```bash
# 默认模式即可——脚本会自行将服务器放到后台。
scripts/start-server.sh --project-dir /path/to/project --open
```

在 Windows 上，脚本会自动检测并切换到前台模式（这会阻塞工具调用）。在 Bash 工具调用中使用 `run_in_background: true`，让服务器跨会话轮次继续运行；下一轮读取 `$STATE_DIR/server-info` 获取 URL 和端口。

**Codex：**
```bash
# Codex 会回收后台进程。脚本自动检测 CODEX_CI 并切换到前台模式。
# 正常运行即可——不需要额外 flag。
scripts/start-server.sh --project-dir /path/to/project --open
```

**Gemini CLI：**
```bash
# 使用 --foreground，并在 shell 工具调用中设置 is_background: true，
# 让进程跨会话轮次继续运行。
scripts/start-server.sh --project-dir /path/to/project --open --foreground
```

**Copilot CLI：**
```bash
# 使用 Copilot CLI 的非阻塞/后台 shell 机制启动，保证服务器跨轮次运行。
# 保留 --foreground，让 harness 而不是脚本负责后台化。启动器是 .sh，
# 因此通过 bash 调用（Windows 上从 PowerShell 工具调用 Git Bash 的 bash.exe）。
bash scripts/start-server.sh --project-dir /path/to/project --open --foreground
```

**其他环境：**服务器必须在会话轮次之间持续后台运行。如果环境会回收脱离的进程，请使用 `--foreground`，并用平台提供的后台执行机制启动命令。

如果浏览器无法访问 URL（远程/容器环境很常见），绑定非 loopback 主机：

```bash
scripts/start-server.sh \
  --project-dir /path/to/project \
  --host 0.0.0.0 \
  --url-host localhost
```

使用 `--url-host` 控制返回 URL JSON 中打印的 hostname。

## 循环

1. **检查服务器仍在运行**，然后将 HTML **写入** `screen_dir` 中的新文件：
   - **在引用 URL 或推送界面前，必须确认服务器仍在运行。**确认 `$STATE_DIR/server-info` 存在且 `$STATE_DIR/server-stopped` 不存在。如果服务器已停止，使用相同的 `--project-dir` 通过 `start-server.sh` 重启——它会复用相同端口，因此用户打开的标签页会自动重新连接（服务器停止时会显示“已暂停”覆盖层），无需发送新 URL。服务器空闲 4 小时后自动退出（可用 `--idle-timeout-minutes` 配置）。
   - 使用语义化文件名：`platform.html`、`visual-style.html`、`layout.html`
   - **绝不要复用文件名**——每个界面都要创建新文件
   - 使用文件创建工具——**绝不要使用 cat/heredoc**（会向终端倾倒噪声）
   - 服务器会自动提供最新文件

2. **告诉用户预期内容并结束本轮：**
   - 每一步都提醒 URL，而不只是在第一次提醒
   - 简短总结界面内容（例如“正在展示主页的 3 种布局选项”）
   - 要求用户在终端回复：“看一下并告诉我你的想法。如果愿意，可以点击选择一个选项。”

3. **下一轮**——用户在终端回复后：
   - 如果 `$STATE_DIR/events` 存在，读取它——其中每行是一个用户浏览器交互 JSON
   - 将其与用户的终端文字合并，得到完整信息
   - 终端消息是主要反馈；`state_dir/events` 提供结构化交互数据

4. **迭代或前进**——如果反馈改变当前界面，写新文件（例如 `layout-v2.html`）。只有当前步骤确认后才能进入下一个问题。

5. **回到终端时卸载浏览器内容**——下一步不需要浏览器时（例如澄清问题或讨论权衡），推送等待界面清除过时内容：

   ```html
   <!-- filename: waiting.html（或 waiting-2.html 等） -->
   <div style="display:flex;align-items:center;justify-content:center;min-height:60vh">
     <p class="subtitle">正在终端中继续……</p>
   </div>
   ```

   这样可以避免用户在对话已经转移后仍盯着已解决的选择。出现下一个视觉问题时，照常推送新的内容文件。

6. 重复以上步骤直到完成。

## 编写内容片段

只写页面内部的内容。服务器会自动用 frame template 包装它（标题、主题 CSS、连接状态和全部交互基础设施）。

**最小示例：**

```html
<h2>哪种布局更合适？</h2>
<p class="subtitle">请考虑可读性和视觉层次</p>

<div class="options">
  <div class="option" data-choice="a" onclick="toggleSelect(this)">
    <div class="letter">A</div>
    <div class="content">
      <h3>单栏</h3>
      <p>清晰、聚焦的阅读体验</p>
    </div>
  </div>
  <div class="option" data-choice="b" onclick="toggleSelect(this)">
    <div class="letter">B</div>
    <div class="content">
      <h3>双栏</h3>
      <p>侧边栏导航配合主内容</p>
    </div>
  </div>
</div>
```

就是这样。不需要 `<html>`、CSS 或 `<script>` 标签，服务器会提供全部内容。

## 可用 CSS 类

frame template 为你的内容提供以下 CSS 类：

### 选项（A/B/C 选择）

```html
<div class="options">
  <div class="option" data-choice="a" onclick="toggleSelect(this)">
    <div class="letter">A</div>
    <div class="content">
      <h3>标题</h3>
      <p>描述</p>
    </div>
  </div>
</div>
```

**多选：**为容器添加 `data-multiselect`，允许用户选择多个选项。每次点击都会切换该项目的选中样式。

```html
<div class="options" data-multiselect>
  <!-- 相同的选项标记——用户可以选择/取消选择多个选项 -->
</div>
```

### 卡片（视觉设计）

```html
<div class="cards">
  <div class="card" data-choice="design1" onclick="toggleSelect(this)">
    <div class="card-image"><!-- mockup 内容 --></div>
    <div class="card-body">
      <h3>名称</h3>
      <p>描述</p>
    </div>
  </div>
</div>
```

### Mockup 容器

```html
<div class="mockup">
  <div class="mockup-header">预览：Dashboard 布局</div>
  <div class="mockup-body"><!-- 你的 mockup HTML --></div>
</div>
```

### 分栏视图（并排）

```html
<div class="split">
  <div class="mockup"><!-- 左侧 --></div>
  <div class="mockup"><!-- 右侧 --></div>
</div>
```

### 优点/缺点

```html
<div class="pros-cons">
  <div class="pros"><h4>优点</h4><ul><li>收益</li></ul></div>
  <div class="cons"><h4>缺点</h4><ul><li>代价</li></ul></div>
</div>
```

### Mock 元素（wireframe 构建块）

```html
<div class="mock-nav">Logo | 首页 | 关于 | 联系</div>
<div style="display: flex;">
  <div class="mock-sidebar">导航</div>
  <div class="mock-content">主内容区域</div>
</div>
<button class="mock-button">操作按钮</button>
<input class="mock-input" placeholder="输入字段">
<div class="placeholder">占位区域</div>
```

### 排版和章节

- `h2`——页面标题
- `h3`——章节标题
- `.subtitle`——标题下的辅助文字
- `.section`——带底部边距的内容块
- `.label`——小号大写标签文字

## 浏览器事件格式

用户在浏览器中点击选项时，交互会记录到 `$STATE_DIR/events`（每行一个 JSON 对象）。推送新界面时，文件会自动清空。

```jsonl
{"type":"click","choice":"a","text":"选项 A - 简单布局","timestamp":1706000101}
{"type":"click","choice":"c","text":"选项 C - 复杂网格","timestamp":1706000108}
{"type":"click","choice":"b","text":"选项 B - 混合布局","timestamp":1706000115}
```

完整事件流展示用户的探索路径——他们可能在最终确定前点击多个选项。最后一个 `choice` 事件通常是最终选择，但点击模式也能揭示值得进一步询问的犹豫或偏好。

如果 `$STATE_DIR/events` 不存在，说明用户没有与浏览器交互——只使用他们的终端文字。

## 设计提示

- **让保真度匹配问题**——布局问题使用 wireframe，润色问题使用精致视觉
- **每页都说明问题**——“哪种布局感觉更专业？”而不只是“选一个”
- **前进前先迭代**——如果反馈改变当前界面，写新版本
- **每个界面最多 2-4 个选项**
- **重要时使用真实内容**——摄影作品集应使用真实图片（Unsplash）。占位内容会掩盖设计问题
- **保持 mockup 简单**——聚焦布局和结构，而不是像素级设计

## 文件命名

- 使用语义化名称：`platform.html`、`visual-style.html`、`layout.html`
- 绝不复用文件名——每个界面必须是新文件
- 迭代时追加版本后缀，如 `layout-v2.html`、`layout-v3.html`
- 服务器按修改时间提供最新文件

## 清理

```bash
scripts/stop-server.sh $SESSION_DIR
```

如果会话使用了 `--project-dir`，mockup 文件会保留在 `.superpowers/brainstorm/` 供后续参考。只有 `/tmp` 会话会在停止时被删除。

## 参考

- Frame template（CSS 参考）：`scripts/frame-template.html`
- Helper script（客户端）：`scripts/helper.js`
