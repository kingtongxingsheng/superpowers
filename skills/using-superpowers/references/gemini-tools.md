# Gemini CLI 工具映射

技能使用动作来描述操作（“创建待办”“读取文件”）。在 Gemini CLI 中，这些动作对应以下工具。

| 技能请求的动作 | Gemini CLI 等价操作 |
|---|---|
| 读取文件 | `read_file` |
| 一次读取多个文件 | `read_many_files` |
| 创建新文件 | `write_file` |
| 编辑文件 | `replace` |
| 运行 shell 命令 | `run_shell_command` |
| 搜索文件内容 | `grep_search` |
| 按名称查找文件 | `glob` |
| 列出文件和子目录 | `list_directory` |
| 获取 URL | `web_fetch` |
| 搜索网页 | `google_web_search` |
| 调用技能 | `activate_skill` |
| 任务跟踪（“创建待办”“标记完成”） | `write_todos`（状态：pending、in_progress、completed、cancelled、blocked） |

## 指令文件

当技能提到“你的指令文件”时，在 Gemini CLI 中指 `GEMINI.md`。Gemini CLI 会按层级加载 `GEMINI.md`：全局文件位于 `~/.gemini/GEMINI.md`，工作区目录及其祖先目录中可以有项目级文件；工具访问子目录时，也会加载该目录中的 `GEMINI.md`。

## 个人技能目录

用户级技能位于 **`~/.gemini/skills/`**，`~/.agents/skills/` 是跨运行时别名（与 Codex 和 Copilot CLI 共享）。如果同一作用域同时存在两个目录，优先使用 `.agents/skills/`。每个技能都是包含 `SKILL.md` 的子目录，文件 frontmatter 包含 `name` 和 `description`。

## Gemini CLI 的其他工具

| 工具 | 用途 |
|---|---|
| `save_memory`（旧版） | 当 `experimental.memoryV2 = false` 时持久化跨会话事实 |
| `get_internal_docs` | 查询 Gemini CLI 内置文档 |
| `ask_user` | 向用户提出结构化问题（文本、单选、多选） |
| `enter_plan_mode` / `exit_plan_mode` | 进入或退出只读计划模式 |
| `update_topic` | 更新当前对话的主题和战略意图元数据 |
| `complete_task` | 表示 Gemini 子代理已完成，并将结果返回给父 agent |
| `tracker_create_task`、`tracker_update_task`、`tracker_get_task`、`tracker_list_tasks`、`tracker_add_dependency`、`tracker_visualize` | 提供依赖关系和可视化的任务跟踪器 |
| `read_mcp_resource`、`list_mcp_resources` | 访问 MCP 资源 |
